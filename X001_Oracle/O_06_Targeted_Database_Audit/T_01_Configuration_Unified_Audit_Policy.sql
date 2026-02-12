ALTER SESSION SET CONTAINER = green_it_pdb;

-- 1. Create the Unified Audit Policy for DML operations
-- This policy monitors INSERT, UPDATE, and DELETE actions on the specific fact table
-- to ensure the integrity of Green IT metrics.
CREATE AUDIT POLICY data_green_audit
ACTIONS INSERT, UPDATE, DELETE ON GREEN_IT_OWNER.FACT_GREEN_WORKLOAD;

-- 2. Enable the audit policy for all users
-- Once enabled, Oracle starts tracking the specified actions.
AUDIT POLICY data_green_audit;

-- 3. Verify that the policy is active (Enabled)
-- Note: We use '*' or 'ENABLED_OPTION' as columns vary by Oracle version.
SELECT * FROM AUDIT_UNIFIED_ENABLED_POLICIES 
WHERE POLICY_NAME = 'DATA_GREEN_AUDIT';

-- 4. Insert test data to trigger the audit
-- Ensure column names match the schema (FACT_KEY, ENERGY_CONSUMPTION_KWH).
INSERT INTO GREEN_IT_OWNER.FACT_GREEN_WORKLOAD (FACT_KEY, ENERGY_CONSUMPTION_KWH) 
VALUES (1001, 15.5);
COMMIT;

-- 5. Consult the Audit Trail (The Logs)
-- We use 'UNIFIED_AUDIT_POLICIES' column to filter logs for our specific policy.
-- Note: If empty, wait a few minutes for Oracle to flush memory buffers to disk.
SELECT EVENT_TIMESTAMP, 
       DBUSERNAME, 
       ACTION_NAME, 
       OBJECT_NAME, 
       SQL_TEXT
FROM UNIFIED_AUDIT_TRAIL 
WHERE UNIFIED_AUDIT_POLICIES LIKE '%DATA_GREEN_AUDIT%'
ORDER BY EVENT_TIMESTAMP DESC;