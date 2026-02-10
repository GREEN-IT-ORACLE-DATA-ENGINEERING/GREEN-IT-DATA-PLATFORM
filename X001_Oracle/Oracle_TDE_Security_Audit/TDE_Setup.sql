-- ==========================================================
-- PROJECT: GREEN IT - DATABASE SECURITY AUDIT
-- DESCRIPTION: Configuration of Transparent Data Encryption
-- ==========================================================

-- [1] DATABASE LEVEL CONFIGURATION (CDB$ROOT)
-- Define the wallet root path for the instance
ALTER SYSTEM SET WALLET_ROOT = '/opt/oracle/admin/ORCLCDB' SCOPE=SPFILE;
-- Note: Instance restart (SHUTDOWN/STARTUP) is required here.

-- Configure the keystore type to FILE
ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" SCOPE=BOTH;

-- [2] KEYSTORE INITIALIZATION (CDB$ROOT)
-- Create the physical software keystore file
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY "GreenIT2026";

-- Open the keystore for encryption operations
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "GreenIT2026";

-- [3] PDB ACTIVATION (green_it_pdb)
ALTER SESSION SET CONTAINER = green_it_pdb;

-- Open keystore explicitly for the PDB
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "GreenIT2026";

-- Generate and set the Master Encryption Key
ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY "GreenIT2026" WITH BACKUP;

-- [4] VALIDATION
-- Create an encrypted tablespace using AES256
CREATE TABLESPACE secure_data_ts 
DATAFILE 'secure_data01.dbf' SIZE 100M 
ENCRYPTION USING 'AES256' DEFAULT STORAGE(ENCRYPT);