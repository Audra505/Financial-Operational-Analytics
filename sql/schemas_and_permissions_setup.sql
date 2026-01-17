-- 1. Create ETL role
CREATE ROLE adaoradata2025
LOGIN
PASSWORD 'DataClass2025';

-- 2. Allow connection to database
GRANT CONNECT ON DATABASE postgres TO adaoradata2025;

-- 3. Create project schemas
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS ref;
CREATE SCHEMA IF NOT EXISTS mart;

-- 4. Grant schema-level access
GRANT USAGE, CREATE ON SCHEMA staging TO adaoradata2025;
GRANT USAGE, CREATE ON SCHEMA ref TO adaoradata2025;
GRANT USAGE, CREATE ON SCHEMA mart TO adaoradata2025;

-- 5. Grant access to existing tables
GRANT ALL ON ALL TABLES IN SCHEMA staging TO adaoradata2025;
GRANT ALL ON ALL TABLES IN SCHEMA ref TO adaoradata2025;
GRANT ALL ON ALL TABLES IN SCHEMA mart TO adaoradata2025;

-- 6. Ensure future tables are accessible
ALTER DEFAULT PRIVILEGES IN SCHEMA staging
GRANT ALL ON TABLES TO adaoradata2025;

ALTER DEFAULT PRIVILEGES IN SCHEMA ref
GRANT ALL ON TABLES TO adaoradata2025;

ALTER DEFAULT PRIVILEGES IN SCHEMA mart
GRANT ALL ON TABLES TO adaoradata2025;
