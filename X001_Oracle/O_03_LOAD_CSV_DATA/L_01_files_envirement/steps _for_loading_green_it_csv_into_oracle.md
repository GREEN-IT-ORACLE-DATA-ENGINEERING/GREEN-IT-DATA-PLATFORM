# ==========================================================
# 1. CONFIGURATION SQL (SQL*Plus as SYSDBA)
# ==========================================================
# Connect to PDB and set Quotas
sqlplus / as sysdba <<EOF
ALTER SESSION SET CONTAINER = green_it_pdb;
ALTER SYSTEM REGISTER;
ALTER USER GREEN_IT_OWNER QUOTA UNLIMITED ON TS_GREEN_STAGING;
ALTER USER GREEN_IT_OWNER QUOTA UNLIMITED ON TS_FACT_GREEN;
COMMIT;
EXIT;
EOF

# ==========================================================
# 2. PRÉPARATION DU FICHIER (Linux Terminal)
# ==========================================================
cd /home/oracle/green_it
# Supprimer les retours chariot Windows (CRLF to LF)
sed -i 's/\r$//' green_it_data.csv

# ==========================================================
# 3. FICHIER DE CONTRÔLE (green_it_load.ctl)
# ==========================================================
# Content of green_it_load.ctl:
# OPTIONS (SKIP=1)
# LOAD DATA
# INFILE 'green_it_data.csv'
# APPEND INTO TABLE GREEN_IT_OWNER.STG_GREEN_WORKLOAD
# FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
# TRAILING NULLCOLS (RECORD_ID, ..., PERFORMANCE_METRIC TERMINATED BY WHITESPACE)

# ==========================================================
# 4. EXÉCUTION DE L'INGESTION (Script Shell)
# ==========================================================
#!/bin/bash
DB_USER="GREEN_IT_OWNER"
DB_PASS="Owner2026IT"
DB_CONN="//192.168.209.128:1521/green_it_pdb.local"

echo "Starting SQL*Loader..."
sqlldr userid="${DB_USER}/${DB_PASS}@${DB_CONN}" \
       control=green_it_load.ctl \
       log=green_it_load.log \
       bad=green_it_errors.bad \
       direct=true

# ==========================================================
# 5. VÉRIFICATION FINALE
# ==========================================================
sqlplus -s "${DB_USER}/${DB_PASS}@${DB_CONN}" <<EOF
SET FEEDBACK OFF
SELECT 'Rows Loaded: ' || COUNT(*) FROM STG_GREEN_WORKLOAD;
EXIT;
EOF