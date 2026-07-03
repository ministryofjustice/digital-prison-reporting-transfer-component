-- =================================================================
-- Create a Spectrum link to the curated layer via the prisons
-- hive catalogue
--
-- As each new table is deployed, this will
-- be automatically refreshed.
--
-- This is to provide a more generic name than 'prisons' for
-- curated data that includes both prisons and probation data.
--
-- We should consider migrating the underlying Hive/Glue catalogue
-- name itself as part of a future migration. See PDHD-242 in jira.
-- =================================================================
CREATE EXTERNAL SCHEMA IF NOT EXISTS hmpps_curated_tables from data catalog
database 'prisons'
iam_role 'arn:aws:iam::004723187462:role/dpr-redshift-spectrum-role';

GRANT USAGE ON SCHEMA hmpps_curated_tables TO dpruser;
GRANT USAGE ON SCHEMA hmpps_curated_tables TO probation_mi_app;
