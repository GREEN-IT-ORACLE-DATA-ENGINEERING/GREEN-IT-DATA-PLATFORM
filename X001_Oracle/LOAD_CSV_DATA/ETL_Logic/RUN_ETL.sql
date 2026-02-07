---- 1. Activation de l'affichage pour visualiser les logs de la procedure
   SET SERVEROUTPUT ON;
---- 2. Lancement du processus ETL (Nettoyage, Transformation et Chargement)
-- Cette commande remplit les dimensions et la table de faits a partir du Staging
EXEC green_it_owner.SP_ETL_LOAD_STAR_SCHEMA;

--Verification de la volumetrie pour audit de qualite
-- Le nombre de lignes dans DIM_WORKLOAD doit correspondre au nombre de faits si RECORD_ID est unique
select count(*)  
  from green_it_owner.dim_workload;
select count(*)
  from green_it_owner.dim_energy;
select count(*)
  from green_it_owner.dim_security;
select count(*)
  from green_it_owner.dim_scenario;
select count(*)
  from green_it_owner.fact_green_workload;