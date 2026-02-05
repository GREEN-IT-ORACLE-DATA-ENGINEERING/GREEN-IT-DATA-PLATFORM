📜 Oracle Green IT: Complete Ingestion Workflow
1.	Configuration des Permissions et Quotas (SQL*Plus as SYSDBA)
-- Connexion à la PDB
ALTER SESSION SET CONTAINER = green_it_pdb;

-- Enregistrement du service dans le Listener
ALTER SYSTEM REGISTER;

-- Correction des accès au stockage (Tablespace Quota)
-- I did this because I found out that I didn’t give the QUOTA on tablespace (TS_GREEN_STAGING) to user OWNER
ALTER USER GREEN_IT_OWNER QUOTA UNLIMITED ON TS_GREEN_STAGING;
ALTER USER GREEN_IT_OWNER QUOTA UNLIMITED ON TS_FACT_GREEN;
COMMIT;

2.	Assainissement du Fichier Source (Linux Terminal)
--Se placer dans le dossier du projet
cd /home/oracle/green_it

--Supprimer les retours chariot Windows
sed -i 's/\r$//' green_it_data.csv

3.	Le Fichier de Contrôle Final (green_it_load.ctl)
OPTIONS (SKIP=1)   --we use this one to ignore the header 
LOAD DATA
INFILE 'green_it_data.csv'
APPEND
INTO TABLE GREEN_IT_OWNER.STG_GREEN_WORKLOAD
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  RECORD_ID,
  WORKLOAD_TYPE,
  COMPUTE_DEMAND,
  STORAGE_DEMAND,
  NETWORK_DEMAND,
  ENERGY_SOURCE,
  ENERGY_CONSUMPTION,
  RENEWABLE_SHARE,
  CARBON_EMISSIONS,
  QSO_OPTIMIZATION,
  UNCERTAINTY_FACTOR,
  SECURITY_LEVEL,
  PQC_ENABLED,
  ENERGY_EFFICIENCY,
  SERVICE_QUALITY,
  SECURE_OPS_SCORE,
  WORKLOAD_SCENARIO,
  SCENARIO_STRATEGY,
  OPERATIONAL_COST,
  PERFORMANCE_METRIC TERMINATED BY WHITESPACE     -- and this on The TERMINATED BY        WHITESPACE option acts as a final cleanup filter to ensure that only the number is read
)

4.	Script d'Exécution Automatisée (run_ingestion.sh)
#!/bin/bash
DB_USER="GREEN_IT_OWNER"
DB_PASS="Owner2026IT"
DB_CONN="//192.168.209.128:1521/green_it_pdb.local" # <--- Verified Service Name
CTL_FILE="green_it_load.ctl"
LOG_FILE="green_it_load.log"
BAD_FILE="green_it_errors.bad"

echo "--------------------------------------------------------"
echo "Starting Data Ingestion: Green IT Project"
echo "Target Service: green_it_pdb.local"
echo "--------------------------------------------------------"

# Run SQL*Loader with exact connection
sqlldr userid="${DB_USER}/${DB_PASS}@${DB_CONN}" \
       control=$CTL_FILE \
       log=$LOG_FILE \
       bad=$BAD_FILE \
       direct=true

echo "--------------------------------------------------------"
echo "Verification..."
sqlplus -s "${DB_USER}/${DB_PASS}@${DB_CONN}" <<EOF
SET FEEDBACK OFF
SET PAGESIZE 0
SELECT 'Rows Loaded in STG_GREEN_WORKLOAD: ' || COUNT(*) FROM STG_GREEN_WORKLOAD;
EXIT;
EOF

5.	Commande de Lancement
chmod +x run_ingestion.sh      --this command tells oracle that (run_ingestion.sh) this is an executable script not just a simple file
./run_ingestion.sh    --this the command for running the script 
