import pandas as pd
from pathlib import Path
from datetime import datetime

# -----------------------------
# Paths
# -----------------------------
bronze_path = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\L_02_Medallion\M_03_Bronze\green_workload_bronze.csv"
)

silver_path = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\L_02_Medallion\M_04_Silver\stg_green_workload_clean.parquet"
)

silver_path.parent.mkdir(parents=True, exist_ok=True)

# -----------------------------
# Load Bronze
# -----------------------------
df = pd.read_parquet(bronze_path)

print(" Bronze rows:", len(df))

# -----------------------------
# Cleaning
# -----------------------------
text_columns = [
    "WORKLOAD_TYPE",
    "ENERGY_SOURCE",
    "SECURITY_LEVEL",
    "WORKLOAD_SCENARIO",
    "SCENARIO_STRATEGY"
]

for col in text_columns:
    df[col] = df[col].str.lower().str.strip()

# Cast numeric properly
numeric_cols = [
    "COMPUTE_DEMAND",
    "STORAGE_DEMAND",
    "NETWORK_DEMAND",
    "ENERGY_CONSUMPTION",
    "CARBON_EMISSIONS",
    "OPERATIONAL_COST"
]

for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# -----------------------------
# Business rule
# -----------------------------
df["CARBON_INTENSITY"] = df["CARBON_EMISSIONS"] / df["ENERGY_CONSUMPTION"]

# Add technical column
df["SILVER_PROCESSED_AT"] = datetime.now()

# -----------------------------
# Save Silver
# -----------------------------
df.to_parquet(silver_path, index=False)

print("Silver created successfully")
