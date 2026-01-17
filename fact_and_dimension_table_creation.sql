-- Dimension Tables (Star Schema)

-- Create Date Dimension
-- Stores one row per distinct transaction date with derived calendar attributes
CREATE TABLE mart.dim_date (
    date_id SERIAL PRIMARY KEY,
	full_date DATE UNIQUE,
	year INT,
	month INT,
	month_name VARCHAR(20),
	day INT,
	quarter INT
);

-- Populate Date Dimension
INSERT INTO mart.dim_date (full_date, year, month, month_name, day, quarter)
SELECT DISTINCT 
       transaction_date,
	   EXTRACT(YEAR FROM transaction_date),
	   EXTRACT(MONTH FROM transaction_date),
	   TRIM(TO_CHAR(transaction_date, 'Month')),
	   EXTRACT(DAY FROM transaction_date),
	   EXTRACT(QUARTER FROM transaction_date)
FROM staging.transactions_clean
ORDER BY transaction_date;

ALTER TABLE mart.dim_date
ADD COLUMN month_short VARCHAR(3),
ADD COLUMN month_num INT;

-- Update to include short month name and sorting column for easier visualization
UPDATE mart.dim_date
SET month_short = TO_CHAR(full_date, 'Mon'),
    month_num = EXTRACT(MONTH FROM full_date);

-- Create Business Unit Dimension
-- Lookup table for standardized business unit values
CREATE TABLE mart.dim_business_unit (
	business_unit_id SERIAL PRIMARY KEY,
	business_unit VARCHAR(255) UNIQUE
);

-- Populate Business Unit Dimension
INSERT INTO mart.dim_business_unit(business_unit)
SELECT DISTINCT business_unit_clean
FROM staging.transactions_clean
ORDER BY business_unit_clean;


-- Create Region Dimension
-- Lookup table for standardized geographic regions
CREATE TABLE mart.dim_region (
	region_id SERIAL PRIMARY KEY,
	region VARCHAR(255) UNIQUE
);

-- Populate Region Dimension
INSERT INTO mart.dim_region(region)
SELECT DISTINCT region_clean
FROM staging.transactions_clean
ORDER BY region_clean;


-- Create Product Dimension
-- Lookup table for unique products used across transactions
CREATE TABLE mart.dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) UNIQUE
);

-- Populate Product Dimension
INSERT INTO mart.dim_product (product_name)
SELECT DISTINCT product_clean
FROM staging.transactions_clean
ORDER BY product_clean;


-- Fact Table (Star Schema)
-- Stores transaction-level metrics and links to all dimension tables

CREATE TABLE mart.fact_transactions (
    transaction_id INT PRIMARY KEY,
    date_id INT NOT NULL,
    business_unit_id INT NOT NULL,
    region_id INT NOT NULL,
    product_id INT NOT NULL,
    units_processed INT,
    revenue_amount NUMERIC(12,2),
    cost_amount NUMERIC(12,2),
    data_quality_status VARCHAR(50),

FOREIGN KEY (date_id) 
REFERENCES mart.dim_date(date_id),

FOREIGN KEY (business_unit_id) 
REFERENCES mart.dim_business_unit(business_unit_id),

FOREIGN KEY (region_id) 
REFERENCES mart.dim_region(region_id),

FOREIGN KEY (product_id) 
REFERENCES mart.dim_product(product_id)
);

-- Revised Fact Table
-- Update to include a surrogate primary key replacing transaction_id which was set as the primary key
DROP TABLE mart.fact_transactions;

CREATE TABLE mart.fact_transactions (
    fact_id SERIAL PRIMARY KEY,
    transaction_id INT,
    date_id INT NOT NULL,
    business_unit_id INT NOT NULL,
    region_id INT NOT NULL,
    product_id INT NOT NULL,
    units_processed INT,
    revenue_amount NUMERIC(12,2),
    cost_amount NUMERIC(12,2),
    data_quality_status VARCHAR(50),

FOREIGN KEY (date_id) 
REFERENCES mart.dim_date(date_id),

FOREIGN KEY (business_unit_id) 
REFERENCES mart.dim_business_unit(business_unit_id),

FOREIGN KEY (region_id) 
REFERENCES mart.dim_region(region_id),

FOREIGN KEY (product_id) 
REFERENCES mart.dim_product(product_id)
);

-- Populate Fact Table
INSERT INTO mart.fact_transactions (
    transaction_id,
    date_id,
    business_unit_id,
    region_id,
    product_id,
    units_processed,
    revenue_amount,
    cost_amount,
    data_quality_status
)
SELECT
    s.transaction_id,
    d.date_id,
    bu.business_unit_id,
    r.region_id,
    p.product_id,
    s.units_processed,
    s.revenue_amount,
    s.cost_amount,
    s.data_quality_status
FROM staging.transactions_clean s
JOIN mart.dim_date d
    ON s.transaction_date = d.full_date
JOIN mart.dim_business_unit bu
    ON s.business_unit_clean = bu.business_unit
JOIN mart.dim_region r
    ON s.region_clean = r.region
JOIN mart.dim_product p
    ON s.product_clean = p.product_name;

-- Add derived financial metrics to fact table (Profit & Margin)
ALTER TABLE mart.fact_transactions
ADD COLUMN profit NUMERIC(12,2),
ADD COLUMN margin NUMERIC(10,4);

-- Populate metrics
UPDATE mart.fact_transactions
SET
    profit = revenue_amount - cost_amount,
    margin = CASE
        WHEN revenue_amount = 0 OR revenue_amount IS NULL THEN NULL
        ELSE (revenue_amount - cost_amount) / revenue_amount
    END;
