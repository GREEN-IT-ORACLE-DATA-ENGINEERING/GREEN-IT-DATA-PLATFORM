alter session set container = green_it_pdb;

show con_name;

-- 1. STAGING: Raw data landing zone
create tablespace ts_green_staging
   datafile 'green_stg_01.dbf' size 200M
   autoextend on next 10M maxsize 500M;
-- 2. DIM_WORKLOAD: Storage for workload metadata
create tablespace ts_dim_workload
   datafile 'dim_work_01.dbf' size 50M
   autoextend on maxsize 500M;
-- 3. DIM_ENERGY: Storage for energy source details
create tablespace ts_dim_energy
   datafile 'dim_ener_01.dbf' size 50M
   autoextend on maxsize 300M;
-- 4. DIM_SECURITY: Storage for security levels and PQC status
create tablespace ts_dim_security
   datafile 'dim_secu_01.dbf' size 50M
   autoextend on maxsize 300M;
-- 5. DIM_SCENARIO: Storage for scenarios and strategies
create tablespace ts_dim_scenario
   datafile 'dim_scen_01.dbf' size 50M
   autoextend on maxsize 300M;
-- 6. FACT_GREEN_WORKLOAD: The heavy-lifter (Measures & Metrics)
create tablespace ts_fact_green
   datafile 'fact_green_01.dbf' size 200M
   autoextend on next 50M maxsize 500M;
-- 7. ARCHIVE: For historical data or logging
create tablespace ts_green_archive
   datafile 'green_arch_01.dbf' size 500M
   autoextend on maxsize 1G;
-- 8. UNDO: Dedicated undo for this PDB's transactions
-- Professional Note: Locally managed undo in PDBs is a modern Oracle best practice
create undo tablespace ts_green_undo
   datafile 'green_undo_01.dbf' size 100M;

commit;

-- Vérifier le conteneur actuel
select sys_context(
   'USERENV',
   'CON_NAME'
) as container_name
  from dual;

-- Vérifier les tablespaces créés
select tablespace_name,
       status,
       contents
  from dba_tablespaces;