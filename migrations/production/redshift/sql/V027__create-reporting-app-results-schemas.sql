-- =================================================================
-- Each reporting app writes its async results to a schema of its
-- own. Only an external schema's owner can create tables in it, so
-- each app's user owns its schema, and the other app's user gets no
-- access.
-- =================================================================
CREATE EXTERNAL SCHEMA IF NOT EXISTS reports_prisons FROM DATA CATALOG
DATABASE 'reports_prisons'
IAM_ROLE 'arn:aws:iam::004723187462:role/dpr-redshift-spectrum-role'
CREATE EXTERNAL DATABASE IF NOT EXISTS;
ALTER SCHEMA reports_prisons OWNER TO prisons_mi_app;

CREATE EXTERNAL SCHEMA IF NOT EXISTS reports_probation FROM DATA CATALOG
DATABASE 'reports_probation'
IAM_ROLE 'arn:aws:iam::004723187462:role/dpr-redshift-spectrum-role'
CREATE EXTERNAL DATABASE IF NOT EXISTS;
ALTER SCHEMA reports_probation OWNER TO probation_mi_app;
