-- =================================================================
-- Prisons data and the views over it. Spectrum can only grant a
-- whole external schema, so this can read every table in prisons.
-- The default privileges cover views using prisons data added by
-- later migrations.
-- =================================================================
CREATE ROLE prisons_reader;

GRANT USAGE ON SCHEMA prisons TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA datamart TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA datamart TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA datamart
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA establishment TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA establishment TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA establishment
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA staff TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA staff TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA staff
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA person TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA person TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA person
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA regional TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA regional TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA regional
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA external TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA external TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA external
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA prisoner TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA prisoner TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA prisoner
    GRANT SELECT ON TABLES TO ROLE prisons_reader;

GRANT USAGE ON SCHEMA prison_domains TO ROLE prisons_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA prison_domains TO ROLE prisons_reader;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA prison_domains
    GRANT SELECT ON TABLES TO ROLE prisons_reader;
