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
    ├── 01_oracle_connection_test.py  # Test Oracle JDBC connectivity (PySpark)
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

#### `01_oracle_connection_test.py`
**Purpose**: Test Oracle database connectivity using PySpark and JDBC driver

**Technology Stack**:
- PySpark Session
- Oracle JDBC driver
- JDBC URL connection

**Key Features**:
- Validates Oracle connection
- Tests JDBC driver configuration
- Simple query execution test (`SELECT 1 FROM dual`)
- Prerequisite for data ingestion

---

#### `02_bronze_ingestion.py`
**Purpose**: Extract raw data from Oracle database into Bronze layer

**Technology Stack**:
- `oracledb` (Python Oracle driver - Thin mode)
- `pandas` for data manipulation
- `pathlib` for file handling

**Process**:
1. **Connect** to Oracle database (`GREEN_IT_PDB`)
2. **Execute SQL Query**: Extract all columns from `stg_green_workload` staging table
3. **Load** data into Pandas DataFrame
4. **Write** to Bronze layer as CSV file
5. **Close** database connection

**Data Source**: `green_it_owner.stg_green_workload` table

**Output**: `Medallion/Bronze/stg_green_workload.csv`

**Key Columns Extracted**:
- `record_id`, `workload_type`, `compute_demand`, `storage_demand`
- `network_demand`, `energy_source`, `energy_consumption`
- `renewable_share`, `carbon_emissions`, `qso_optimization`
- `uncertainty_factor`, `security_level`, `pqc_enabled`
- `energy_efficiency`, `service_quality`, `secure_ops_score`
- `workload_scenario`, `scenario_strategy`, `operational_cost`
- `performance_metric`

---

#### `03_silver_transformation.py`
**Purpose**: Clean and transform Bronze data into Silver layer

**Technology Stack**:
- `pandas` for transformation logic
- `pathlib` for file handling
- `datetime` for audit columns

**Transformation Steps**:

1. **Load Bronze** Parquet file
2. **Text Standardization**:
   - Convert to lowercase
   - Trim whitespace
   - Columns: `WORKLOAD_TYPE`, `ENERGY_SOURCE`, `SECURITY_LEVEL`, `WORKLOAD_SCENARIO`, `SCENARIO_STRATEGY`

3. **Data Type Casting**:
   - Convert numeric columns with error handling (`coerce`)
   - Columns: `COMPUTE_DEMAND`, `STORAGE_DEMAND`, `NETWORK_DEMAND`, `ENERGY_CONSUMPTION`, `CARBON_EMISSIONS`, `OPERATIONAL_COST`

4. **Business Logic**:
   - **Carbon Intensity** calculation: `CARBON_EMISSIONS / ENERGY_CONSUMPTION`
   - Adds efficiency metric for analysis

5. **Audit Columns**:
   - `SILVER_PROCESSED_AT`: Timestamp of processing

**Input**: `Medallion/Bronze/stg_green_workload.parquet`

**Output**: `Medallion/Silver/stg_green_workload_clean.parquet`

---

#### `04_gold_star_schema.py`
**Purpose**: Build dimensional star schema for analytical queries

**Technology Stack**:
- `pandas` for dimensional modeling
- `pathlib` for file handling

**Star Schema Design**:

##### Dimension Tables

1. **DIM_WORKLOAD**
   - `workload_id` (PK)
   - `RECORD_ID`
   - `WORKLOAD_TYPE`

2. **DIM_ENERGY**
   - `energy_id` (PK)
   - `ENERGY_SOURCE`
   - `RENEWABLE_SHARE`

3. **DIM_SECURITY**
   - `security_id` (PK)
   - `SECURITY_LEVEL`
   - `PQC_ENABLED` (Post-Quantum Cryptography)

4. **DIM_SCENARIO**
   - `scenario_id` (PK)
   - `WORKLOAD_SCENARIO`
   - `SCENARIO_STRATEGY`

##### Fact Table

**FACT_GREEN_WORKLOAD**
- **Foreign Keys**: `workload_id`, `energy_id`, `security_id`, `scenario_id`
- **Measures**:
  - Resource Demand: `COMPUTE_DEMAND`, `STORAGE_DEMAND`, `NETWORK_DEMAND`
  - Energy Metrics: `ENERGY_CONSUMPTION`, `CARBON_EMISSIONS`
  - Cost: `OPERATIONAL_COST`
  - Performance: `ENERGY_EFFICIENCY`, `SERVICE_QUALITY`, `SECURE_OPS_SCORE`
  - Optimization: `QSO_OPTIMIZATION`, `PERFORMANCE_METRIC`, `UNCERTAINTY_FACTOR`

**Process**:
1. Load Silver data
2. Extract and deduplicate dimensions
3. Generate surrogate keys for each dimension
4. Join Silver data with dimensions to create fact table
5. Save dimension and fact tables as Parquet files

**Input**: `Medallion/Silver/stg_green_workload_clean.parquet`

**Output**:
- `Medallion/Gold/DIM_WORKLOAD.parquet`
- `Medallion/Gold/DIM_ENERGY.parquet`
- `Medallion/Gold/DIM_SECURITY.parquet`
- `Medallion/Gold/DIM_SCENARIO.parquet`
- `Medallion/Gold/FACT_GREEN_WORKLOAD.parquet`

---

#### `csv_to_parquet.py`
**Purpose**: Convert CSV files to optimized Parquet format

**Technology Stack**:
- `pandas`
- `pyarrow` engine
- Snappy compression

**Features**:
- Reads CSV from Bronze layer
- Converts to Parquet with Snappy compression
- Reduces file size and improves query performance
- Maintains data integrity

**Usage**: Utility for converting CSV exports to Parquet

---

#### `view_parquet.py`
**Purpose**: Inspect and preview Parquet file contents

**Technology Stack**:
- `pandas`

**Features**:
- Display row count
- List all columns
- Preview first 10 rows of data
- Quick data validation tool

**Usage**: Data quality checks and exploration

---

## 🔄 Data Flow Pipeline

### Complete Pipeline Execution Order

```bash
# Step 1: Test connection (optional)
python src/01_oracle_connection_test.py

# Step 2: Ingest raw data from Oracle (Bronze)
python src/02_bronze_ingestion.py

# Step 3: Clean and transform (Silver)
python src/03_silver_transformation.py

# Step 4: Build star schema (Gold)
python src/04_gold_star_schema.py

# Optional: Convert CSV to Parquet
python src/csv_to_parquet.py

# Optional: View data
python src/view_parquet.py
```

### Data Transformation Summary

| Layer  | Format  | Purpose                    | Key Transformations           |
|--------|---------|----------------------------|-------------------------------|
| Bronze | CSV     | Raw ingestion              | None (exact copy from Oracle) |
| Silver | Parquet | Cleaned data               | Type casting, text normalization, calculated fields |
| Gold   | Parquet | Star schema                | Dimensional modeling, joins, surrogate keys |

---

## 🛠️ Technologies Used

| Technology    | Purpose                          |
|---------------|----------------------------------|
| Python 3.x    | Core programming language        |
| Pandas        | Data manipulation & transformation |
| OracleDB      | Oracle database connectivity     |
| PySpark       | Distributed data processing (testing) |
| PyArrow       | Parquet file handling            |
| Parquet       | Columnar storage format          |
| Pathlib       | Cross-platform file path handling |

---

## 📊 Data Model

### Bronze Layer Schema
Direct copy of Oracle staging table with 20+ columns including workload characteristics, energy metrics, security settings, and performance indicators.

### Silver Layer Enhancements
- Standardized text fields (lowercase, trimmed)
- Validated numeric data types
- **Calculated Field**: `CARBON_INTENSITY` (emissions per unit energy)
- Audit timestamp: `SILVER_PROCESSED_AT`

### Gold Layer Star Schema
- **4 Dimension Tables**: Workload, Energy, Security, Scenario
- **1 Fact Table**: Green workload metrics
- Optimized for:
  - Energy consumption analysis
  - Carbon emissions tracking
  - Cost optimization
  - Performance monitoring
  - Security compliance

---

## 🚀 Getting Started

### Prerequisites

```bash
# Install required Python packages
pip install pandas
pip install oracledb
pip install pyarrow
pip install pyspark  # Optional for connection testing
```

### Configuration Requirements

Update database connection parameters in `02_bronze_ingestion.py`:
```python
connection = oracledb.connect(
    user="GREEN_IT_OWNER",
    password="Your_Password",
    host="your_host_ip",
    port=1521,
    service_name="GREEN_IT_PDB"
)
```

### Execution

Run the pipeline sequentially to process data through all layers:

```bash
cd X002_lakehouse/src
python 02_bronze_ingestion.py    # Oracle → Bronze
python 03_silver_transformation.py  # Bronze → Silver
python 04_gold_star_schema.py      # Silver → Gold
```

---

## 📈 Use Cases

This lakehouse implementation supports various Green IT analytical scenarios:

1. **Energy Efficiency Analysis**
   - Track energy consumption patterns
   - Identify optimization opportunities
   - Monitor renewable energy usage

2. **Carbon Footprint Tracking**
   - Calculate carbon intensity metrics
   - Monitor emissions by workload type
   - Analyze renewable share impact

3. **Cost Optimization**
   - Correlate operational costs with performance
   - Identify cost-effective configurations
   - Resource utilization analysis

4. **Security & Compliance**
   - Track security levels across workloads
   - Monitor PQC (Post-Quantum Cryptography) adoption
   - Security scoring analysis

5. **Performance Monitoring**
   - Service quality metrics
   - Performance vs. energy trade-offs
   - Workload scenario analysis

---

## 🔍 Key Metrics Available in Gold Layer

### Resource Metrics
- Compute Demand
- Storage Demand
- Network Demand

### Energy & Environmental
- Energy Consumption
- Carbon Emissions
- Renewable Share
- Carbon Intensity (calculated)

### Financial
- Operational Cost

### Performance & Quality
- Energy Efficiency
- Service Quality
- Performance Metric
- Secure Operations Score

### Optimization
- QSO (Quality-Security-Optimization) Score
- Uncertainty Factor

---

## 🔗 Integration Points

### Upstream (Input)
- **X001_Oracle**: Oracle Database with `stg_green_workload` staging table
- Source schema: `green_it_owner`
- PDB: `GREEN_IT_PDB`

### Downstream (Output)
- **X003_Powerbi**: Power BI dashboards consume Gold layer Parquet files
- Star schema optimized for DirectQuery or Import mode
- Pre-aggregated dimensions for fast visualization

---

## 🎯 Best Practices Implemented

1. **Separation of Concerns**: Each layer has distinct purpose and transformations
2. **Immutable Bronze**: Raw data preserved without modification
3. **Data Quality**: Type validation and standardization in Silver layer
4. **Dimensional Modeling**: Star schema in Gold for optimal query performance
5. **Columnar Storage**: Parquet format for efficient analytics
6. **Audit Trail**: Timestamps track data processing lineage
7. **Modular Design**: Each script handles one layer transformation
8. **Path Management**: Using `pathlib` for cross-platform compatibility

---

## 📝 Future Enhancements

Potential improvements for this lakehouse implementation:

- [ ] **Incremental Processing**: Delta Lake integration for change data capture
- [ ] **Data Quality Checks**: Great Expectations framework for validation
- [ ] **Orchestration**: Apache Airflow/Prefect for pipeline automation
- [ ] **Partitioning**: Date-based partitioning for large datasets
- [ ] **Metadata Management**: Data catalog integration (Apache Atlas/DataHub)
- [ ] **Monitoring**: Add logging and alerting for pipeline failures
- [ ] **Testing**: Unit tests for transformation logic
- [ ] **Documentation**: Auto-generate data dictionary from Gold schema

---

## 🎓 Conclusion

The **X002_lakehouse** module successfully implements a modern **Medallion Architecture** that bridges the gap between transactional Oracle database storage and analytical Power BI reporting. By implementing the Bronze-Silver-Gold pattern, this solution provides:

###  **Achieved Objectives**

1. **Data Quality**: Progressive refinement from raw to analytics-ready data
2. **Performance**: Columnar Parquet format optimized for analytical queries
3. **Scalability**: Modular architecture supports growing data volumes
4. **Maintainability**: Clear separation between ingestion, transformation, and modeling
5. **Analytics-Ready**: Star schema specifically designed for Green IT KPIs

### 🌟 **Business Value**

- **Energy Insights**: Enables detailed analysis of energy consumption patterns
- **Carbon Intelligence**: Tracks and measures carbon footprint across workloads
- **Cost Optimization**: Identifies opportunities for operational efficiency
- **Security Visibility**: Monitors security posture and PQC adoption
- **Decision Support**: Provides reliable data foundation for strategic planning

### 🔧 **Technical Excellence**

- Follows industry-standard lakehouse patterns
- Implements dimensional modeling best practices
- Uses efficient file formats (Parquet with compression)
- Maintains data lineage across all layers
- Supports both batch processing and analytics workloads

### 🚀 **Impact**

This lakehouse implementation serves as the **critical data transformation layer** in the GREEN-IT-DATA-PLATFORM, ensuring that raw operational data from Oracle is systematically refined into high-quality, performant, and business-friendly datasets ready for visualization and decision-making in Power BI.

The architecture demonstrates a production-ready approach to building a data lakehouse for Green IT analytics, combining the flexibility of data lakes with the structure and governance of data warehouses.

---


