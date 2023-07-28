CREATE EXTERNAL SCHEMA domain from data catalog
database 'domain'
iam_role 'arn:aws:iam::<account>:role/dpr-redshift-spectrum-role'
create external database if not exists;
