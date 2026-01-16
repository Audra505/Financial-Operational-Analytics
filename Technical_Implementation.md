# Technical Implementation
_End-to-End Financial & Operational Analytics Pipeline_

# Purpose
This document details the **technical design and implementation of the end-to-end analytics pipeline,** covering ETL processing, PostgreSQL data modeling, and architectural decisions. It is intended to demonstrate real-world analytics engineering practices, including data quality handling, layered architecture, and BI-ready modeling.

The implementation intentionally mirrors analytics environments by separating data ingestion, cleansing, modeling, and reporting into clearly defined layers.

**End-to-End Flow:**

```text
Raw CSV Files
→ KNIME ETL (Cleaning & Validation)
→ PostgreSQL Staging Layer
→ PostgreSQL Star Schema (Mart)
→ Power BI Analytics
```

- Raw transactional CSV files are ingested via KNIME
- Data is cleaned, validated, and standardized
- Cleaned data is written to PostgreSQL staging tables
- A star schema is built in the mart layer
- Power BI consumes the star schema for analytics

**Technology Stack**

- **ETL:** KNIME Analytics Platform
- **Database:** PostgreSQL
- **Schemas:** staging, ref, mart
- **Analytics:** Power BI

---

# ETL Design & Workflow
(image)

## Raw Data Ingestion
_CSV Reader_

- Raw transactional data and reference product data are ingested from CSV files
- No transformations are applied at ingestion
- Raw values are preserved to support traceability and auditing

--

## Preprocessing & Field Standardization
_Expression node + String Manipulation node_

- Cleaned fields are derived using controlled transformations
- Raw columns are not overwritten
- Reference product data is normalized independently to ensure stable matching baseline

This approach separates **raw ingestion from cleaned representations,** supporting auditability.



