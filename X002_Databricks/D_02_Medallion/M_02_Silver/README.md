# M_02_Silver - Cleaned Data Layer

## Purpose
Cleaned, validated, and enriched data ready for analytics.

## Transformations Applied
1. Data Cleaning
   - Text standardization (lowercase, trim)
   - Data type conversions
   - NULL handling

2. Data Enrichment
   - Carbon intensity calculation
   - Efficiency categorization
   - Renewable energy flags

3. Quality Checks
   - Duplicate removal
   - Validation rules
   - Metadata addition

## Files
- green_workload_silver.parquet: Cleaned and enriched dataset

## Data Lineage
Bronze -> Silver
- Cleaning + Validation + Enrichment
