"""
Medallion Architecture Configuration
Project: GREEN-IT-DATA-PLATFORM
Environment: Databricks
Generated: 2026-02-13 16:31:02.848295
"""

# BASE PATHS
BASE_PATH = "/Workspace/Users/yahyasanbati.mail@gmail.com/GREEN-IT-DATA-PLATFORM/X002_Databricks"
NOTEBOOKS_PATH = f"{BASE_PATH}/L_02_notebooks"
MEDALLION_PATH = f"{BASE_PATH}/L_02_Medallion"

# DATA LAYER PATHS
BRONZE_PATH = f"{MEDALLION_PATH}/M_01_Bronze"
SILVER_PATH = f"{MEDALLION_PATH}/M_02_Silver"
GOLD_PATH = f"{MEDALLION_PATH}/M_03_Gold"

# FILE PATHS

# Bronze
BRONZE_FILE = f"{BRONZE_PATH}/green_workload_bronze.parquet"

# Silver
SILVER_FILE = f"{SILVER_PATH}/green_workload_silver.parquet"

# Gold - Dimensions
DIM_WORKLOAD_FILE = f"{GOLD_PATH}/DIM_WORKLOAD.parquet"
DIM_ENERGY_FILE = f"{GOLD_PATH}/DIM_ENERGY.parquet"
DIM_SECURITY_FILE = f"{GOLD_PATH}/DIM_SECURITY.parquet"
DIM_SCENARIO_FILE = f"{GOLD_PATH}/DIM_SCENARIO.parquet"

# Gold - Fact
FACT_GREEN_WORKLOAD_FILE = f"{GOLD_PATH}/FACT_GREEN_WORKLOAD.parquet"

# SOURCE DATA
SOURCE_FILE = "/Workspace/Users/yahyasanbati.mail@gmail.com/GREEN-IT-DATA-PLATFORM/X001_Oracle/O_03_LOAD_CSV_DATA/L_02_ETL_Logic/E_03_Data_Output/green_it_metrics_2026-02-09 (1).parquet"

# GOLD FILES DICTIONARY
GOLD_FILES = {
    "dim_workload": DIM_WORKLOAD_FILE,
    "dim_energy": DIM_ENERGY_FILE,
    "dim_security": DIM_SECURITY_FILE,
    "dim_scenario": DIM_SCENARIO_FILE,
    "fact_green_workload": FACT_GREEN_WORKLOAD_FILE
}

# METADATA
PROJECT_NAME = "GREEN-IT-DATA-PLATFORM"
ENVIRONMENT = "Databricks"
OWNER = "yahyasanbati.mail@gmail.com"
VERSION = "1.0"
