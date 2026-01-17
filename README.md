# Financial & Operational Analytics
_End-to-End Analytics Project_

## Project Overview

This project simulates an **end-to-end financial and operational analytics workflow** for a large, global organization. It demonstrates how raw, imperfect transactional data can be cleaned, modeled in PostgreSQL using a star schema, and analyzed in Power BI to provide **leadership with visibility into revenue, cost, and margin performance across regions and business units.**

The project demonstrates the ability to:

- Work with imperfect, real-world enterprise data
- Design layered analytics pipelines
- Model data for scalable BI consumption
- Bridge technical implementation with business decision-making

---

## Business Context

The organization operates **across multiple countries and internal departments** (e.g., Sales, Legal, Accounting, Engineering, and Operations). It **tracks internal financial activity using transaction-level records rather than consumer sales data.**

### Business Objective

Enable leadership-level decision-making by providing visibility into revenue, cost, and margin performance, with a focus on identifying:

- What changed
- Why it changed
- Where action may be needed

### Key Business Questions Answered

- How are revenue, cost, and margin performing overall?
- How is performance changing over time (YoY / MoM)?
- Which regions and business units are driving results?
- Where is margin under pressure, and what are the underlying drivers?

This project translates those leadership questions into a structured analytics solution.

---

## Data Overview

The dataset represents **transaction-level financial records,** where each row corresponds to a single operational transaction.

**Core fields include:**

- Transaction ID and date
- Business unit (department)
- Region (country)
- Product 
- Units processed
- Revenue and cost amounts

The data intentionally reflects real-world enterprise challenges, including:

- Inconsistent naming conventions
- Missing cost values
- Transactions with low or negative margins
- Product names without formal SKU codes

These characteristics require careful cleaning and validation before analysis.

---

### End-to-End Architecture

At a high level, the analytics **pipeline follows a layered architecture designed to separate ingestion, transformation, modeling, and reporting:**

```text
Raw CSV Files
→ ETL Cleaning & Validation
→ PostgreSQL Staging Tables
→ Star Schema (Fact & Dimensions)
→ Power BI Dashboard
```

Raw data is cleaned and standardized through an ETL process, stored in PostgreSQL, modeled using a star schema for analytical performance, and consumed by Power BI for reporting and storytelling.

---

## Analytics & Reporting Layer

The Power BI dashboard **connects directly to the PostgreSQL star schema** and is designed for executive-level analysis rather than heavy data transformation.

It enables:

- Revenue, cost, and margin trend analysis
- Department and regional performance comparison
- Product-level contribution and margin pressure analysis
- Time-based analysis, including YoY and MoM comparisons

The dashboard supports both high-level monitoring and deeper investigation through detailed views.

---

## Tools & Technologies

- **PostgreSQL:** Data storage and dimensional modeling
- **SQL:** Data transformation and analytical querying
- **ETL (KNIME):** Data cleaning, validation, and standardization
- **Power BI:** Analytics, visualization, and storytelling

---

## Related Resources

- **Technical Implementation:** Detailed ETL and data modeling documentation
- **Live Dashboard:** Power BI report
- **Loom Walkthrough:** Business-focused dashboard and insights walkthrough
