/*
================================================================================
PROCEDURE: SP_ETL_LOAD_STAR_SCHEMA
OBJECTIF: Charger les données depuis la table de staging (STG_GREEN_WORKLOAD)
          vers le schéma en étoile (dimensions + faits)
================================================================================
*/
create or replace procedure green_it_owner.sp_etl_load_star_schema as
   v_count_stg  number;
   v_count_fact number;
begin
   dbms_output.put_line('--------------------------------------------------------');
   dbms_output.put_line('DEBUT DU PROCESSUS D''EXTRACTION ET CHARGEMENT (ETL)');
   dbms_output.put_line('--------------------------------------------------------');

    ----------------------------------------------------------------------------
    -- 1. REINITIALISATION DES DONNEES
    ----------------------------------------------------------------------------
    -- L''ordre respecte les contraintes d''integrite referentielle
   execute immediate 'TRUNCATE TABLE green_it_owner.fact_green_workload';
   execute immediate 'TRUNCATE TABLE green_it_owner.dim_workload';
   execute immediate 'TRUNCATE TABLE green_it_owner.dim_energy';
   execute immediate 'TRUNCATE TABLE green_it_owner.dim_security';
   execute immediate 'TRUNCATE TABLE green_it_owner.dim_scenario';
   dbms_output.put_line('Phase 1 : Nettoyage des tables effectue.');

    ----------------------------------------------------------------------------
    -- 2. CHARGEMENT DES DIMENSIONS (DISTINCT pour eviter les redondances)
    ----------------------------------------------------------------------------
    
    -- DIM_WORKLOAD
   insert into green_it_owner.dim_workload (
      record_id,
      workload_type
   )
      select distinct record_id,
                      workload_type
        from green_it_owner.stg_green_workload
       where record_id is not null;

    -- DIM_ENERGY
   insert into green_it_owner.dim_energy (
      energy_source,
      renewable_flag
   )
      select distinct energy_source,
                      case
                         when upper(energy_source) in ( 'SOLAR',
                                                        'WIND',
                                                        'HYDRO',
                                                        'RENEWABLE' ) then
                            1
                         else
                            0
                      end
        from green_it_owner.stg_green_workload
       where energy_source is not null;

    -- DIM_SECURITY
   insert into green_it_owner.dim_security (
      security_level,
      pqc_enabled
   )
      select distinct security_level,
                      nvl(
                         pqc_enabled,
                         0
                      )
        from green_it_owner.stg_green_workload
       where security_level is not null;

    -- DIM_SCENARIO
   insert into green_it_owner.dim_scenario (
      workload_scenario,
      scenario_strategy
   )
      select distinct workload_scenario,
                      scenario_strategy
        from green_it_owner.stg_green_workload
       where workload_scenario is not null;

   commit;
   dbms_output.put_line('Phase 2 : Chargement des tables de dimensions termine.');

    ----------------------------------------------------------------------------
    -- 3. CHARGEMENT DE LA TABLE DE FAITS (JOINTURES ET METRIQUES)
    ----------------------------------------------------------------------------
   insert into green_it_owner.fact_green_workload (
      workload_key,
      energy_key,
      security_key,
      scenario_key,
      compute_demand_tflops,
      storage_demand_tb,
      network_demand_gbps,
      energy_consumption_kwh,
      carbon_emissions_kgco2,
      operational_cost_usd,
      performance_metric,
      load_date
   )
      select dw.workload_key,
             de.energy_key,
             ds.security_key,
             dsc.scenario_key,
             stg.compute_demand,
             stg.storage_demand,
             stg.network_demand,
             stg.energy_consumption,
             stg.carbon_emissions,
             stg.operational_cost,
             stg.performance_metric,
             sysdate
        from green_it_owner.stg_green_workload stg
       inner join green_it_owner.dim_workload dw
      on stg.record_id = dw.record_id
       inner join green_it_owner.dim_energy de
      on stg.energy_source = de.energy_source
       inner join green_it_owner.dim_security ds
      on stg.security_level = ds.security_level
         and nvl(
         stg.pqc_enabled,
         0
      ) = ds.pqc_enabled
       inner join green_it_owner.dim_scenario dsc
      on stg.workload_scenario = dsc.workload_scenario
         and stg.scenario_strategy = dsc.scenario_strategy;

   v_count_fact := sql%rowcount;
   commit;

    ----------------------------------------------------------------------------
    -- 4. VALIDATION ET AUDIT
    ----------------------------------------------------------------------------
   select count(*)
     into v_count_stg
     from green_it_owner.stg_green_workload;

   dbms_output.put_line('Phase 3 : Chargement de la table de faits termine.');
   dbms_output.put_line('--------------------------------------------------------');
   dbms_output.put_line('RAPPORT FINAL :');
   dbms_output.put_line('Lignes en Staging : ' || v_count_stg);
   dbms_output.put_line('Lignes en Fait    : ' || v_count_fact);
   if v_count_stg = v_count_fact then
      dbms_output.put_line('INTEGRITE : Conforme');
   else
      dbms_output.put_line('INTEGRITE : Ecart detecte - Verifier les jointures');
   end if;
   dbms_output.put_line('--------------------------------------------------------');
exception
   when others then
      rollback;
      dbms_output.put_line('ERREUR CRITIQUE : ' || sqlerrm);
      raise;
end sp_etl_load_star_schema;
/