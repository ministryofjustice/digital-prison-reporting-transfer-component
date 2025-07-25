-- Allow seeing objects in the domain schemas
GRANT USAGE ON SCHEMA establishment, staff, person, regional, external TO fdw_access_domain_read_only;
-- Allow selecting from all existing tables, views and materialised views in the domain schemas
GRANT SELECT ON ALL TABLES IN SCHEMA establishment TO fdw_access_domain_read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA staff TO fdw_access_domain_read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA person TO fdw_access_domain_read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA regional TO fdw_access_domain_read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA external TO fdw_access_domain_read_only;
-- Ensure that the role can select from all new tables and views in the domain schemas
ALTER DEFAULT PRIVILEGES IN SCHEMA establishment GRANT SELECT ON TABLES TO fdw_access_domain_read_only;
ALTER DEFAULT PRIVILEGES IN SCHEMA staff GRANT SELECT ON TABLES TO fdw_access_domain_read_only;
ALTER DEFAULT PRIVILEGES IN SCHEMA person GRANT SELECT ON TABLES TO fdw_access_domain_read_only;
ALTER DEFAULT PRIVILEGES IN SCHEMA regional GRANT SELECT ON TABLES TO fdw_access_domain_read_only;
ALTER DEFAULT PRIVILEGES IN SCHEMA external GRANT SELECT ON TABLES TO fdw_access_domain_read_only;

-- You can create users and grant this role to them with SQL such as this:
-- CREATE USER my_user WITH PASSWORD '...';
-- GRANT fdw_access_domain_read_only TO my_user;
