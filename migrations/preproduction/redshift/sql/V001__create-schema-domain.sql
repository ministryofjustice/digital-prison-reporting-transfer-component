CREATE EXTERNAL SCHEMA IF NOT EXISTS domain from data catalog
database 'domain'
iam_role 'arn:aws:iam::972272129531:role/dpr-redshift-spectrum-role'
create external database if not exists;
