-- =================================================================
-- Remove hmpps_curated_tables. It read the same Glue database as
-- prisons, so it gave a second route to probation data. Use prisons
-- for prisons data and probation for probation data.
-- =================================================================
DROP SCHEMA IF EXISTS hmpps_curated_tables;

COMMENT ON SCHEMA prisons IS 'Prisons data only.';
