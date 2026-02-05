alter session set container = green_it_pdb;
show con_name;
--1.Detailed Security Profiles
-- Profile for PDB_ADMIN (Maximum Authority)
create profile prof_green_pdba limit
   sessions_per_user 5
   cpu_per_session unlimited
   idle_time unlimited
   failed_login_attempts 3
   password_life_time 90
   password_reuse_time 365
   password_grace_time 7;

-- Profile for GREEN_IT_OWNER (Developer/DBA)
create profile prof_green_owner limit
   sessions_per_user 5
   cpu_per_session unlimited
   idle_time 30          -- 30 mins idle timeout
   failed_login_attempts 5
   password_life_time 60          -- Change every 2 months
   password_reuse_time 180
   password_reuse_max 3           -- Cannot reuse last 3 passwords
   password_grace_time 7;

-- Profile for GREEN_IT_DB_READER (End User)
create profile prof_green_reader limit
   sessions_per_user 2
   cpu_per_session 10000       -- Limit CPU usage for safety
   idle_time 15          -- 15 mins idle timeout
   failed_login_attempts 5
   password_life_time 30
   password_grace_time 3;

--2. Role-Based Access Control (RBAC)
-- Role for the PDB Admin
create role role_green_pdba;
grant all privileges to role_green_pdba;

-- Role for the Owner (As requested: Session, Index, CRUD, View)
create role role_green_owner;
grant create session,
   create table,
   create view,
   create any index,
   insert any table,
   update any table,
   delete any table,
   create sequence,
   create procedure
to role_green_owner;

-- Role for the Reader
create role role_green_reader;
grant create session to role_green_reader;

--3. User Creation with GREEN_IT Prefix
-- 1. The PDB Admin
create user green_it_pdb_admin identified by "PdbAdmin_2026_#"
   default tablespace ts_fact_green
   profile prof_green_pdba;
grant role_green_pdba to green_it_pdb_admin;

-- 2. The Owner (Schema Creator)
create user green_it_owner identified by "Owner_2026_#IT"
   default tablespace ts_fact_green
   profile prof_green_owner;
grant role_green_owner to green_it_owner;

-- 3. The Reader
create user green_it_db_reader identified by "Reader_2026_#IT"
   default tablespace ts_fact_green
   profile prof_green_reader;
grant role_green_reader to green_it_db_reader;

-- Essential: Give Owner space to work
alter user green_it_owner
   quota unlimited on ts_green_staging;
alter user green_it_owner
   quota unlimited on ts_dim_workload;
alter user green_it_owner
   quota unlimited on ts_dim_energy;
alter user green_it_owner
   quota unlimited on ts_dim_security;
alter user green_it_owner
   quota unlimited on ts_dim_scenario;
alter user green_it_owner
   quota unlimited on ts_fact_green;
alter user green_it_owner
   quota unlimited on ts_green_archive;

commit;