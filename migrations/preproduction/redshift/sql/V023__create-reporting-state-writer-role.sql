-- =================================================================
-- This role gives access to the reporting library's own tables.
-- Every reporting app's user gets this role. These tables aren't
-- split per deployment, so every deployment shares them.
-- =================================================================
CREATE ROLE reporting_state_writer;

GRANT USAGE ON SCHEMA admin TO ROLE reporting_state_writer;
GRANT SELECT, INSERT ON admin.multiphase_query_state TO ROLE reporting_state_writer;

GRANT USAGE ON SCHEMA product_ TO ROLE reporting_state_writer;
GRANT SELECT, INSERT, UPDATE ON product_.product_collection TO ROLE reporting_state_writer;
GRANT SELECT, INSERT, DELETE ON product_.product_collection_attributes TO ROLE reporting_state_writer;
GRANT SELECT, INSERT, DELETE ON product_.product_collection_products TO ROLE reporting_state_writer;
