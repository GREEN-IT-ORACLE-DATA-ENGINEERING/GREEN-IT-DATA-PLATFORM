import pandas as pd
from pathlib import Path

# -----------------------------
# Bronze directory
# -----------------------------
bronze_dir = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\Medallion\Bronze"
)

csv_path = bronze_dir / "stg_green_workload.csv"
parquet_path = bronze_dir / "stg_green_workload.parquet"

# -----------------------------
# Read CSV
# -----------------------------
df = pd.read_csv(csv_path)
print(f" Rows loaded: {len(df)}")

# -----------------------------
# Write Parquet (same folder)
# -----------------------------
df.to_parquet(
    parquet_path,
    engine="pyarrow",
    compression="snappy",  
    index=False
)

print(f"Parquet created in Bronze: {parquet_path}")
