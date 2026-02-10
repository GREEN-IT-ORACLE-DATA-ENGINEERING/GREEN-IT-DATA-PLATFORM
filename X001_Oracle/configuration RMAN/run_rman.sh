#!/bin/bash

# 1. Configuration de l'environnement Oracle
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$PATH:$ORACLE_HOME/bin

# 2. Vérification du jour du mois pour différencier la sauvegarde mensuelle et hebdomadaire
# Si le jour est entre 1 et 7, on effectue un Level 0 (une fois par mois)
# Sinon, on effectue un Level 1 (le reste des semaines)
DAY_OF_MONTH=$(date +%e)

if [ $DAY_OF_MONTH -le 7 ]; then
    LVL=0
    TAG="MONTHLY_FULL_L0"
else
    LVL=1
    TAG="WEEKLY_INCR_L1"
fi

# 3. Exécution de RMAN
rman target / <<EOF
RUN {
    # Allocation du canal de sauvegarde sur disque
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    
    # Exécution de la sauvegarde incrémentale (Level 0 ou 1)
    BACKUP INCREMENTAL LEVEL $LVL 
    PLUGGABLE DATABASE green_it_pdb 
    TAG '$TAG';
    
    # Nettoyage des anciennes sauvegardes pour libérer l'espace disque
    CROSSCHECK BACKUP;
    DELETE NOPROMPT OBSOLETE;
    DELETE NOPROMPT ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-7';
    
    # Libération du canal
    RELEASE CHANNEL ch1;
}
EXIT;
EOF