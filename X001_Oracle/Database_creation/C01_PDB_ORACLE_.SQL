-- 1. Create the PDB from the seed
-- We use FILE_NAME_CONVERT to define where the physical datafiles will live
CREATE PLUGGABLE DATABASE green_it_pdb 
ADMIN USER pdb_admin IDENTIFIED BY "PdbAdmin_2024"
FILE_NAME_CONVERT = ('/opt/oracle/oradata/ORCLCDB/pdbseed/', '/opt/oracle/oradata/ORCLCDB/green_it_pdb/');
-- 2. Open the PDB
-- A new PDB starts in MOUNTED mode; we must open it for use
ALTER PLUGGABLE DATABASE green_it_pdb OPEN;
-- 3. Set the PDB to open automatically when the CDB restarts
-- This is a Best Practice to avoid manual intervention after a server reboot
ALTER PLUGGABLE DATABASE green_it_pdb SAVE STATE;
-- 4. Switch the session context to the new PDB
ALTER SESSION SET CONTAINER = green_it_pdb;
show con_name;
COMMIT;


