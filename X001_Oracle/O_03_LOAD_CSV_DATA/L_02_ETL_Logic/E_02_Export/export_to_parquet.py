import pandas as pd
import cx_Oracle
import os
from datetime import datetime

# --- PART 1: CONFIGURATION DES PARAMETRES DE CONNEXION ---
# On utilise os.getenv pour la securite et la portabilite entre VM et environnements differents.
# Si la variable n'est pas definie dans le systeme, la valeur par defaut est utilisee.
ORACLE_USER = os.getenv("ORA_USER", "GREEN_IT_OWNER")
ORACLE_PASS = os.getenv("ORA_PASS", "Owner_2026_#IT") 
ORACLE_HOST = os.getenv("ORA_HOST", "192.168.197.133")
ORACLE_PORT = int(os.getenv("ORA_PORT", 1521))
ORACLE_SERVICE = os.getenv("ORA_SERVICE", "green_it_pdb")

# --- PART 2: CONSTRUCTION DU DSN (DATA SOURCE NAME) ---
# makedsn permet de generer une chaine de connexion robuste compatible Oracle 19c.
dsn = cx_Oracle.makedsn(ORACLE_HOST, ORACLE_PORT, service_name=ORACLE_SERVICE)

# --- PART 3: DEFINITION DE LA REQUETE SQL (STAR SCHEMA) ---
# On effectue des jointures (JOIN) pour recuperer les labels des dimensions au lieu des simples IDs.
sql_query = """
SELECT 
    f.FACT_KEY,
    w.WORKLOAD_TYPE,
    e.ENERGY_SOURCE,
    s.SECURITY_LEVEL,
    sc.WORKLOAD_SCENARIO,
    f.ENERGY_CONSUMPTION_KWH,
    f.CARBON_EMISSIONS_KGCO2,
    f.OPERATIONAL_COST_USD,
    f.LOAD_DATE
FROM GREEN_IT_OWNER.FACT_GREEN_WORKLOAD f
JOIN GREEN_IT_OWNER.DIM_WORKLOAD w ON f.WORKLOAD_KEY = w.WORKLOAD_KEY
JOIN GREEN_IT_OWNER.DIM_ENERGY e   ON f.ENERGY_KEY   = e.ENERGY_KEY
JOIN GREEN_IT_OWNER.DIM_SECURITY s ON f.SECURITY_KEY = s.SECURITY_KEY
JOIN GREEN_IT_OWNER.DIM_SCENARIO sc ON f.SCENARIO_KEY = sc.SCENARIO_KEY
"""

def main():
    connection = None
    try:
        # --- PART 4: GESTION DES CHEMINS ET DOSSIERS ---
        # On recupere le repertoire de travail actuel (cwd) pour garantir la compatibilite des paths.
        base_path = "/home/oracle/green_it"
        export_directory = os.path.join(base_path, "X001_Oracle/O_03_LOAD_CSV_DATA/L_02_ETL_Logic/E_03_Data_Output")
        
        # Creation du dossier Exports s'il n'existe pas encore.
        if not os.path.exists(export_directory):
            os.makedirs(export_directory, exist_ok=True)
            print(f"Directory created: {export_directory}")

        # --- PART 5: CONNEXION ET EXTRACTION DES DONNEES ---
        print(f"Connecting to Oracle Database at {ORACLE_HOST}...")
        connection = cx_Oracle.connect(user=ORACLE_USER, password=ORACLE_PASS, dsn=dsn)

        # Extraction par 'chunks' (morceaux) pour optimiser l'utilisation de la memoire RAM.
        print("Starting data extraction in chunks...")
        data_chunks = pd.read_sql(sql_query, connection, chunksize=5000)
        df = pd.concat(data_chunks)

        # --- PART 6: EXPORT AU FORMAT PARQUET ---
        # Generation d'un nom de fichier horodate (YYYY-MM-DD).
        timestamp = datetime.now().strftime("%Y-%m-%d")
        file_path = os.path.join(export_directory, f"green_it_metrics_{timestamp}.parquet")

        # Sauvegarde avec compression snappy pour une performance optimale sur Databricks.
        print(f"Saving data to Parquet: {file_path}")
        df.to_parquet(file_path, engine="pyarrow", compression="snappy", index=False)

        print(f"Export successful. Total rows processed: {len(df)}")

    except Exception as error:
        print(f"An error occurred during the ETL process: {error}")

    finally:
        # --- PART 7: FERMETURE DE LA CONNEXION ---
        if connection:
            connection.close()
            print("Oracle connection closed safely.")

if __name__ == "__main__":
    main()