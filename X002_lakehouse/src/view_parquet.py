import pandas as pd
from pathlib import Path

file_path = Path(
    r"C:\DataCenter_Project\GREEN-IT-DATA-PLATFORM\X002_lakehouse\Medallion\Silver\stg_green_workload_clean.parquet"
)

df = pd.read_parquet(file_path)

print("Nombre de lignes :", len(df))
print("\n Colonnes :")
print(df.columns)

print("\n Aperçu des données :")
print(df.head(10))
