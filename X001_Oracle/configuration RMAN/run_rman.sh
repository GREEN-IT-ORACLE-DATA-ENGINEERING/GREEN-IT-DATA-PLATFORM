#!/bin/bash
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$PATH:$ORACLE_HOME/bin

rman target / <<EOF
BACKUP INCREMENTAL LEVEL 0 PLUGGABLE DATABASE green_it_pdb TAG 'WEEKLY_L0';
EXIT;
EOF