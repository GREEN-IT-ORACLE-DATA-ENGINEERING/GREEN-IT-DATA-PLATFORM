-- Connexion
CONNECT / AS SYSDBA;
--  Arrêter la base
SHUTDOWN IMMEDIATE;
---Démarrer en mode MOUNT
STARTUP MOUNT;
---Activer le mode ARCHIVELOG
ALTER DATABASE ARCHIVELOG;

ALTER SESSION SET CONTAINER = green_it_pdb;   
SHOW CON_NAME;

ALTER PLUGGABLE DATABASE green_it_pdb OPEN;
-----Sauvegarde complète (Level 0)
rman target /
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    BACKUP INCREMENTAL LEVEL 0
    PLUGGABLE DATABASE green_it_pdb
    TAG 'L0_FULL_BACKUP';
    RELEASE CHANNEL ch1;
}
----sauvegarde incrimentielle (level 1)
RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    BACKUP INCREMENTAL LEVEL 1
    PLUGGABLE DATABASE green_it_pdb
    TAG 'L1_INC_BACKUP';
    RELEASE CHANNEL ch1;
}

---Vérification des sauvegardes
LIST BACKUP SUMMARY;
---Vérification des qrchives logs
ARCHIVE LOG LIST;
---Création du script :
nano /home/oracle/auto_backup.sh
#!/bin/bash
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$PATH:$ORACLE_HOME/bin

rman target / <<EOF
BACKUP INCREMENTAL LEVEL 0 PLUGGABLE DATABASE green_it_pdb TAG 'WEEKLY_L0';
EXIT;
EOF
---Cette tâche exécute le script auto_backup.sh tous les dimanches à minuit pour automatiser la sauvegarde.
crontab -e
00 00 * * 0 /home/oracle/auto_backup.sh

---Activation du Block Change Tracking
---Connexion SQLPlus :
sqlplus / as sysdba
ALTER DATABASE ENABLE BLOCK CHANGE TRACKING
USING FILE '/opt/oracle/product/19c/dbhome_1/dbs/change_tracking.f' ----Cette commande active le suivi des changements par bloc dans une base Oracle (Block Change Trackin
REUSE;
--Vérification :
SELECT status, filename, bytes
FROM v$block_change_tracking;


