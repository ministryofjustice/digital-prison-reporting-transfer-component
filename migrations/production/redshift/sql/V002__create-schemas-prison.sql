-- =================================================================
-- Create a Spectrum link to the curated layer via the prisons 
-- hive catalogue
--
-- As each new table is deployed, this will
-- be automatically refreshed.
--
-- =================================================================
CREATE EXTERNAL SCHEMA prisons from data catalog
database 'prisons'
iam_role 'arn:aws:iam::004723187462:role/dpr-redshift-spectrum-role';


-- =================================================================
-- Drop the schema if exists
-- =================================================================
DROP SCHEMA IF EXISTS domain;

-- =================================================================
-- Create a schema space for domain
-- All domain views will be deployed here on a domain_table basis
--
-- =================================================================

CREATE SCHEMA IF NOT EXISTS domain QUOTA UNLIMITED;
GRANT USAGE ON SCHEMA domain TO dpruser;