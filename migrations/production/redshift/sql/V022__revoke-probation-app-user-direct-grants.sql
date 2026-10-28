-- =================================================================
-- Remove all of probation_mi_app's direct grants, some of which went
-- wider than it needs. Nothing uses this user yet, so nothing loses
-- access. It will get its access from roles instead.
-- =================================================================
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM probation_mi_app;
REVOKE ALL ON SCHEMA public FROM probation_mi_app;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA public
    REVOKE ALL ON TABLES FROM probation_mi_app;

REVOKE ALL ON ALL TABLES IN SCHEMA reports FROM probation_mi_app;
REVOKE ALL ON SCHEMA reports FROM probation_mi_app;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA reports
    REVOKE ALL ON TABLES FROM probation_mi_app;

REVOKE ALL ON ALL TABLES IN SCHEMA admin FROM probation_mi_app;
REVOKE ALL ON SCHEMA admin FROM probation_mi_app;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA admin
    REVOKE ALL ON TABLES FROM probation_mi_app;

REVOKE ALL ON ALL TABLES IN SCHEMA product_ FROM probation_mi_app;
REVOKE ALL ON SCHEMA product_ FROM probation_mi_app;
ALTER DEFAULT PRIVILEGES FOR USER dpruser IN SCHEMA product_
    REVOKE ALL ON TABLES FROM probation_mi_app;

REVOKE ALL ON SCHEMA hmpps_curated_tables FROM probation_mi_app;
REVOKE ALL ON SCHEMA probation FROM probation_mi_app;
