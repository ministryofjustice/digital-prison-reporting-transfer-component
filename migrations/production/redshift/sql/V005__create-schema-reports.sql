CREATE EXTERNAL SCHEMA IF NOT EXISTS reports from data catalog
database 'reports'
iam_role 'arn:aws:iam::004723187462:role/dpr-redshift-spectrum-role'
create external database if not exists;
