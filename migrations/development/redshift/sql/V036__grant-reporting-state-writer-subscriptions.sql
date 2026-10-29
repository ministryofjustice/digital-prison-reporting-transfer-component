GRANT SELECT ON admin.statement_execution_status TO ROLE reporting_state_writer;

GRANT USAGE ON SCHEMA subscription_ TO ROLE reporting_state_writer;
GRANT SELECT, INSERT, UPDATE ON subscription_.user_subscription TO ROLE reporting_state_writer;
