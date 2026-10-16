-- =================================================================
-- Create a Spectrum link to the curated layer via the probation
-- hive catalogue
--
-- As each new table is deployed, this will
-- be automatically refreshed.
--
-- This schema is for probation data only. Prisons data stays in
-- the prisons schema.
-- =================================================================
CREATE EXTERNAL SCHEMA IF NOT EXISTS probation from data catalog
database 'probation'
iam_role 'arn:aws:iam::771283872747:role/dpr-redshift-spectrum-role';

GRANT USAGE ON SCHEMA probation TO dpruser;
GRANT USAGE ON SCHEMA probation TO probation_mi_app;

COMMENT ON SCHEMA probation IS 'Probation data only. Prisons data is in the prisons schema.';
