# M_03_Gold - Analytics-Ready Star Schema

## Purpose
Dimensional model optimized for BI tools and analytics.

## Star Schema Design

### Dimension Tables
- DIM_WORKLOAD.parquet: Workload types and characteristics
- DIM_ENERGY.parquet: Energy sources and renewable share
- DIM_SECURITY.parquet: Security levels and PQC status
- DIM_SCENARIO.parquet: Workload scenarios and strategies

### Fact Table
- FACT_GREEN_WORKLOAD.parquet: Main metrics table with Energy, Carbon, Cost, Performance

## Usage
Connect Power BI / Tableau to Gold layer for reporting and dashboards.

## Data Lineage
Silver -> Gold
- Dimensional modeling (Star Schema)
- Surrogate key generation
- Fact-Dimension relationships
