CREATE SCHEMA IF NOT EXISTS configuration;

CREATE TABLE configuration.datahub_managed_tables
(
    source     VARCHAR,
    table_name VARCHAR,
    PRIMARY KEY (source, table_name)
);

INSERT INTO configuration.datahub_managed_tables (source, table_name)
VALUES ('nomis', 'offenders'),
       ('nomis', 'offender_bookings'),
       ('nomis', 'offender_profile_details'),
       ('nomis', 'profile_codes'),
       ('nomis', 'offender_identifiers'),
       ('nomis', 'offender_languages'),
       ('nomis', 'offender_sentence_terms'),
       ('nomis', 'reference_codes'),
       ('nomis', 'offender_assessments');
