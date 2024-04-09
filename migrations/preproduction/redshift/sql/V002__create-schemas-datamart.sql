-- =================================================================
-- Create a Spectrum link to the curated layer via the prisons 
-- hive catalogue
--
-- As each new table is deployed, this will
-- be automatically refreshed.
--
-- =================================================================
CREATE EXTERNAL SCHEMA IF NOT EXISTS prisons from data catalog
database 'prisons'
iam_role 'arn:aws:iam::972272129531:role/dpr-redshift-spectrum-role';


-- =================================================================
-- Drop the schema if exists
-- =================================================================
DROP SCHEMA IF EXISTS datamart CASCADE;

-- =================================================================
-- Create a schema space for datamart
-- All datamart views will be deployed here on a domain_table basis
--
-- =================================================================

CREATE SCHEMA IF NOT EXISTS datamart QUOTA UNLIMITED;
GRANT USAGE ON SCHEMA datamart TO dpruser;
