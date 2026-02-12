import pandas as pd
from pathlib import Path

# -----------------------------
# 1. Paths
# -----------------------------
silver_path = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\L_02_Medallion\M_02_Silver\stg_green_workload_clean.parquet"
)

gold_path = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\L_02_Medallion\M_03_Gold"
)

gold_path.mkdir(parents=True, exist_ok=True)

# -----------------------------
# 2. Load Silver
# -----------------------------
df = pd.read_parquet(silver_path)

print("Silver rows:", len(df))

# =====================================================
# 🔹 DIM_WORKLOAD
# =====================================================
dim_workload = (
    df[["RECORD_ID", "WORKLOAD_TYPE"]]
    .drop_duplicates()
    .reset_index(drop=True)
)

dim_workload["workload_id"] = dim_workload.index + 1

# =====================================================
# 🔹 DIM_ENERGY
# =====================================================
dim_energy = (
    df[["ENERGY_SOURCE", "RENEWABLE_SHARE"]]
    .drop_duplicates()
    .reset_index(drop=True)
)

dim_energy["energy_id"] = dim_energy.index + 1

# =====================================================
# 🔹 DIM_SECURITY
# =====================================================
dim_security = (
    df[["SECURITY_LEVEL", "PQC_ENABLED"]]
    .drop_duplicates()
    .reset_index(drop=True)
)

dim_security["security_id"] = dim_security.index + 1

# =====================================================
# 🔹 DIM_SCENARIO
# =====================================================
dim_scenario = (
    df[["WORKLOAD_SCENARIO", "SCENARIO_STRATEGY"]]
    .drop_duplicates()
    .reset_index(drop=True)
)

dim_scenario["scenario_id"] = dim_scenario.index + 1

# =====================================================
# 🔹 FACT TABLE
# =====================================================

fact = df.merge(dim_workload, on=["RECORD_ID", "WORKLOAD_TYPE"])
fact = fact.merge(dim_energy, on=["ENERGY_SOURCE", "RENEWABLE_SHARE"])
fact = fact.merge(dim_security, on=["SECURITY_LEVEL", "PQC_ENABLED"])
fact = fact.merge(dim_scenario, on=["WORKLOAD_SCENARIO", "SCENARIO_STRATEGY"])

fact_green = fact[
    [
        "workload_id",
        "energy_id",
        "security_id",
        "scenario_id",
        "COMPUTE_DEMAND",
        "STORAGE_DEMAND",
        "NETWORK_DEMAND",
        "ENERGY_CONSUMPTION",
        "CARBON_EMISSIONS",
        "OPERATIONAL_COST",
        "ENERGY_EFFICIENCY",
        "SERVICE_QUALITY",
        "SECURE_OPS_SCORE",
        "QSO_OPTIMIZATION",
        "PERFORMANCE_METRIC",
        "UNCERTAINTY_FACTOR",
    ]
]

# =====================================================
# 🔹 SAVE GOLD
# =====================================================

dim_workload.to_parquet(gold_path / "DIM_WORKLOAD.parquet", index=False)
dim_energy.to_parquet(gold_path / "DIM_ENERGY.parquet", index=False)
dim_security.to_parquet(gold_path / "DIM_SECURITY.parquet", index=False)
dim_scenario.to_parquet(gold_path / "DIM_SCENARIO.parquet", index=False)
fact_green.to_parquet(gold_path / "FACT_GREEN_WORKLOAD.parquet", index=False)

print("OLD STAR SCHEMA CREATED ")
