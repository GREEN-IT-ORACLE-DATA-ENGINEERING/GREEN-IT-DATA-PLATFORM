#!/bin/bash
# --- Final Working Configuration ---
DB_USER="GREEN_IT_OWNER"
DB_PASS="Owner_2026_#IT"
DB_CONN="//192.168.197.133:1521/green_it_pdb" # <--- Verified Service Name
CTL_FILE="green_it_load.ctl"
LOG_FILE="green_it_load.log"
BAD_FILE="green_it_errors.bad"

echo "--------------------------------------------------------"
echo "Starting Data Ingestion: Green IT Project"
echo "Target Service: green_it_pdb"
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
