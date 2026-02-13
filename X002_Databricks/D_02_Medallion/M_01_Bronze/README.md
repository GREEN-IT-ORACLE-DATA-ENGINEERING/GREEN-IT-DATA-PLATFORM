# M_01_Bronze - Raw Data Layer

## Purpose
Storage for raw, unprocessed data from source systems.

## Characteristics
- Format: Parquet
- Compression: Snappy
- Schema: As-is from source (no modifications)
- Updates: Append-only

## Files
- green_workload_bronze.parquet: Main dataset from Oracle/Workspace

## Data Lineage
Source -> Bronze
- Oracle Database (stg_green_workload)
- Workspace Parquet file
