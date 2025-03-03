-- Create a role that can be granted to other users/roles
CREATE ROLE fdw_access_domain_read_only;
-- Allow connection to the database
GRANT CONNECT ON DATABASE operational_db TO fdw_access_domain_read_only;
-- Allow seeing objects in the domain schema
GRANT USAGE ON SCHEMA domain TO fdw_access_domain_read_only;
-- Allow selecting from all existing tables, views and materialised views in the domain schema
GRANT SELECT ON ALL TABLES IN SCHEMA domain TO fdw_access_read_only;
-- Ensure that the role can select from all new tables and views in the domain schema
ALTER DEFAULT PRIVILEGES IN SCHEMA domain
    GRANT SELECT ON TABLES TO fdw_access_read_only;

-- You can create users and grant this role to them with SQL such as this:
-- CREATE USER my_user WITH PASSWORD '...';
-- GRANT fdw_access_domain_read_only TO my_user;
