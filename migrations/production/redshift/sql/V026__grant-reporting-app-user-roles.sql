-- =================================================================
-- Give each reporting app's user its roles. Apply
-- redshift-app-users.tf in modernisation-platform-environments
-- first, as it creates the users.
-- =================================================================
GRANT ROLE prisons_reader TO prisons_mi_app;
GRANT ROLE reporting_state_writer TO prisons_mi_app;

GRANT ROLE probation_reader TO probation_mi_app;
GRANT ROLE reporting_state_writer TO probation_mi_app;
