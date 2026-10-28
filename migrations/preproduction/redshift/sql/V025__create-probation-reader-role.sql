-- =================================================================
-- Probation data, and the LAO tables the library reads to leave out
-- limited access offenders.
-- =================================================================
CREATE ROLE probation_reader;

GRANT USAGE ON SCHEMA probation TO ROLE probation_reader;

GRANT USAGE ON SCHEMA product_ TO ROLE probation_reader;
GRANT SELECT ON product_.lao_exclusions TO ROLE probation_reader;
GRANT SELECT ON product_.lao_restrictions TO ROLE probation_reader;
