CREATE EXTERNAL SCHEMA IF NOT EXISTS reports from data catalog
database 'reports'
iam_role 'arn:aws:iam::771283872747:role/dpr-redshift-spectrum-role'
create external database if not exists;
