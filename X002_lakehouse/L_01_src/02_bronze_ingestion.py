import oracledb
import pandas as pd
from pathlib import Path

# -----------------------------
# 1. Oracle connection (THIN MODE)
# -----------------------------
connection = oracledb.connect(
    user="GREEN_IT_OWNER",
    password="Owner_2026_#IT",
    host="192.168.68.217",
    port=1521,
    service_name="GREEN_IT_PDB"
)

print(" Connected to Oracle")

# -----------------------------
# 2. SQL Query
# -----------------------------
query = """
SELECT
    record_id,
    workload_type,
    compute_demand,
    storage_demand,
    network_demand,
    energy_source,
    energy_consumption,
    renewable_share,
    carbon_emissions,
    qso_optimization,
    uncertainty_factor,
    security_level,
    pqc_enabled,
    energy_efficiency,
    service_quality,
    secure_ops_score,
    workload_scenario,
    scenario_strategy,
    operational_cost,
    performance_metric
FROM green_it_owner.stg_green_workload
"""

# -----------------------------
# 3. Load into Pandas
# -----------------------------
df = pd.read_sql(query, connection)
print(f" Rows loaded: {len(df)}")

# -----------------------------
# 4. Write BRONZE CSV
# -----------------------------
bronze_path = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\L_02_Medallion\M_03_Bronze\green_workload_bronze.csv"
)

bronze_path.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(bronze_path, index=False)

print(" BRONZE CSV created successfully")

connection.close()
