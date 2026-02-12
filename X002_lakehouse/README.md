# X002_lakehouse - Lakehouse Implementation

## 📋 Overview

The **X002_lakehouse** module implements a modern **Medallion Architecture** (Bronze → Silver → Gold) for processing Green IT data. This lakehouse layer acts as the data transformation and analytics preparation component between the Oracle database and Power BI visualization layer.

This implementation follows data lakehouse best practices, combining the flexibility of data lakes with the structure and performance of data warehouses, optimized for Green IT analytics focusing on energy efficiency, carbon emissions, and operational metrics.

---

## 🏗️ Architecture

### Medallion Architecture Layers

```
Oracle Database (X001_Oracle)
        ↓
    BRONZE Layer (Raw Data Ingestion)
        ↓
    SILVER Layer (Cleaned & Transformed)
        ↓
    GOLD Layer (Star Schema - Business Ready)
        ↓
Power BI Dashboards (X003_Powerbi)
```

#### 🟤 **Bronze Layer** - Raw Data Ingestion
- **Purpose**: Ingest raw data from Oracle database without transformation
- **Format**: CSV and Parquet files
- **Characteristics**: 
  - Direct copy from source
  - Immutable data
  - Foundation for all downstream processing
  - Data lineage starting point

#### ⚪ **Silver Layer** - Cleaned & Transformed Data
- **Purpose**: Apply data quality rules, cleansing, and business logic
- **Format**: Parquet files
- **Characteristics**:
  - Standardized data types
  - Normalized text values (lowercase, trimmed)
  - Added calculated fields (e.g., carbon intensity)
  - Technical audit columns (processing timestamps)
  - Ready for analytical queries

#### 🟡 **Gold Layer** - Business-Ready Star Schema
- **Purpose**: Dimensional model optimized for analytics and reporting
- **Format**: Parquet files (Star Schema)
- **Characteristics**:
  - Dimension tables for lookups
  - Fact table for metrics
  - Optimized for Power BI consumption
  - High query performance
  - Business-friendly structure

---

## 📁 Folder Structure

```
X002_lakehouse/
│
├── README.md                          # This documentation file
│
├── Medallion/                         # Data layers following medallion architecture
│   ├── M_01_Bronze/                   # Bronze layer - Raw data
│   │   └── stg_green_workload.csv    # Raw CSV data from Oracle
│   │
│   ├── M_02_Silver/                   # Silver layer - Cleaned data
│   │   └── stg_green_workload_clean.parquet  # Cleaned and transformed data
│   │
│   └── M_03_Gold/                     # Gold layer - Star schema
│       ├── DIM_WORKLOAD.parquet      # Dimension: Workload types
│       ├── DIM_ENERGY.parquet        # Dimension: Energy sources
│       ├── DIM_SECURITY.parquet      # Dimension: Security levels
│       ├── DIM_SCENARIO.parquet      # Dimension: Workload scenarios
│       └── FACT_GREEN_WORKLOAD.parquet  # Fact: Green IT metrics
│
└── src/                               # Python source code
    ├── __init__.py                    # Package initializer
    ├── 02_bronze_ingestion.py        # Extract data from Oracle to Bronze
    ├── 03_silver_transformation.py   # Transform Bronze to Silver
    ├── 04_gold_star_schema.py        # Build Gold star schema
    ├── csv_to_parquet.py             # Utility: Convert CSV to Parquet
    ├── view_parquet.py               # Utility: View Parquet file contents
    └── __pycache__/                  # Python compiled bytecode
```

---

## 📄 File Descriptions

### Source Code (`src/`)

#### `02_bronze_ingestion.py`
**Purpose**: Extract raw data from Oracle database into Bronze layer

**Process**:
1. Connect to Oracle database (`GREEN_IT_PDB`) using `oracledb` driver
2. Extract all columns from `green_it_owner.stg_green_workload` table
3. Load data into Pandas DataFrame
4. Write to Bronze layer as CSV file

**Output**: `Medallion/Bronze/stg_green_workload.csv`

---

#### `03_silver_transformation.py`
**Purpose**: Clean and transform Bronze data into Silver layer

**Transformations**:
- Text standardization (lowercase, trimmed)
- Numeric data type casting with error handling
- Calculate **Carbon Intensity**: `CARBON_EMISSIONS / ENERGY_CONSUMPTION`
- Add processing timestamp: `SILVER_PROCESSED_AT`

**Input**: `Medallion/Bronze/stg_green_workload.parquet`

**Output**: `Medallion/Silver/stg_green_workload_clean.parquet`

---

#### `04_gold_star_schema.py`
**Purpose**: Build dimensional star schema for analytical queries

**Star Schema**:
- **4 Dimensions**: DIM_WORKLOAD, DIM_ENERGY, DIM_SECURITY, DIM_SCENARIO
- **1 Fact Table**: FACT_GREEN_WORKLOAD with all metrics

**Process**: Extract dimensions, generate surrogate keys, join to create fact table

**Input**: `Medallion/Silver/stg_green_workload_clean.parquet`

**Output**:
- `Medallion/Gold/DIM_WORKLOAD.parquet`
- `Medallion/Gold/DIM_ENERGY.parquet`
- `Medallion/Gold/DIM_SECURITY.parquet`
- `Medallion/Gold/DIM_SCENARIO.parquet`
- `Medallion/Gold/FACT_GREEN_WORKLOAD.parquet`

---

#### `csv_to_parquet.py`
**Purpose**: Convert CSV to Parquet format with Snappy compression

#### `view_parquet.py`
**Purpose**: Inspect Parquet files (row count, columns, preview data)

---

## 🔄 Data Flow Pipeline

### Pipeline Execution

```bash
# Step 1: Ingest raw data from Oracle (Bronze)
python src/02_bronze_ingestion.py

# Step 2: Clean and transform (Silver)
python src/03_silver_transformation.py

# Step 3: Build star schema (Gold)
python src/04_gold_star_schema.py
```

### Data Transformation Summary

| Layer  | Format  | Purpose                    | Key Transformations           |
|--------|---------|----------------------------|-------------------------------|
| Bronze | CSV     | Raw ingestion              | None (exact copy from Oracle) |
| Silver | Parquet | Cleaned data               | Type casting, text normalization, calculated fields |
| Gold   | Parquet | Star schema                | Dimensional modeling, joins, surrogate keys |

---

## 🛠️ Technologies

- **Python 3.x** - Core programming language
- **Pandas** - Data manipulation & transformation
- **OracleDB** - Oracle database connectivity
- **PyArrow** - Parquet file handling
- **Parquet** - Columnar storage format

---

## 📊 Data Model

- **Bronze**: Direct copy of Oracle staging table (20+ columns)
- **Silver**: Cleaned data with calculated `CARBON_INTENSITY` field
- **Gold**: Star schema (4 dimensions + 1 fact table) optimized for analytics

---

## 🚀 Getting Started

### Prerequisites
```bash
pip install pandas oracledb pyarrow
```

### Configuration
Update connection parameters in `02_bronze_ingestion.py` with your Oracle credentials.

### Execution
```bash
cd X002_lakehouse/src
python 02_bronze_ingestion.py      # Oracle → Bronze
python 03_silver_transformation.py # Bronze → Silver
python 04_gold_star_schema.py     # Silver → Gold
```

---

## 📈 Use Cases

- **Energy Efficiency Analysis** - Track consumption patterns and optimization opportunities
- **Carbon Footprint Tracking** - Monitor emissions and carbon intensity metrics
- **Cost Optimization** - Analyze operational costs vs. performance
- **Security & Compliance** - Track security levels and PQC adoption
- **Performance Monitoring** - Service quality and workload scenario analysis

---

## 🔍 Key Metrics

**Resources**: Compute, Storage, Network Demand | **Energy**: Consumption, Carbon Emissions, Renewable Share, Carbon Intensity | **Financial**: Operational Cost | **Performance**: Energy Efficiency, Service Quality, Secure Ops Score, QSO Score

---

## 🔗 Integration

**Upstream**: X001_Oracle (`green_it_owner.stg_green_workload` on `GREEN_IT_PDB`)  
**Downstream**: X003_Powerbi (consumes Gold layer Parquet files)

---

## 🎯 Best Practices

- Separation of concerns (Bronze/Silver/Gold)
- Immutable Bronze layer
- Data quality validation in Silver
- Star schema dimensional modeling
- Columnar Parquet storage
- Audit trail with timestamps
- Modular script design

---

## 📝 Future Enhancements

- Delta Lake for incremental processing
- Data quality validation framework
- Pipeline orchestration (Airflow/Prefect)
- Date-based partitioning
- Logging and monitoring
- Unit tests

---

## 🎓 Conclusion

The **X002_lakehouse** implements a Medallion Architecture (Bronze-Silver-Gold) that transforms raw Oracle data into analytics-ready datasets for Power BI visualization.

**Key Benefits**:
- Progressive data quality refinement
- Optimized Parquet storage for analytical queries
- Star schema designed for Green IT KPIs
- Complete data lineage tracking

**Business Impact**:
- Energy consumption and carbon footprint analytics
- Cost optimization insights
- Security and performance monitoring
- Decision support for Green IT initiatives

This lakehouse serves as the **critical data transformation layer** in the GREEN-IT-DATA-PLATFORM, bridging Oracle database and Power BI reporting.

---

**Project**: GREEN-IT-DATA-PLATFORM | **Module**: X002_lakehouse | **Version**: 1.0 | **Updated**: February 2026


