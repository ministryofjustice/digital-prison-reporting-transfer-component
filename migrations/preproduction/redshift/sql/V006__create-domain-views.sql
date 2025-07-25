-- =================================================================
-- Drop the schemas if they exist
-- =================================================================

DROP SCHEMA IF EXISTS establishment CASCADE;
DROP SCHEMA IF EXISTS staff CASCADE;
DROP SCHEMA IF EXISTS person CASCADE;
DROP SCHEMA IF EXISTS regional CASCADE;
DROP SCHEMA IF EXISTS external CASCADE;

-- =================================================================
-- Create schemas
-- =================================================================

CREATE SCHEMA IF NOT EXISTS establishment QUOTA UNLIMITED;
CREATE SCHEMA IF NOT EXISTS staff QUOTA UNLIMITED;
CREATE SCHEMA IF NOT EXISTS person QUOTA UNLIMITED;
CREATE SCHEMA IF NOT EXISTS regional QUOTA UNLIMITED;
CREATE SCHEMA IF NOT EXISTS external QUOTA UNLIMITED;

-- =================================================================
-- Grant usage
-- =================================================================

GRANT USAGE ON SCHEMA establishment TO dpruser;
GRANT USAGE ON SCHEMA staff TO dpruser;
GRANT USAGE ON SCHEMA person TO dpruser;
GRANT USAGE ON SCHEMA regional TO dpruser;
GRANT USAGE ON SCHEMA external TO dpruser;

-- =================================================================
-- Grant select on all future tables/views in those schemas.
-- Views in Redshift are considered tables for privilege purposes.
-- =================================================================

ALTER DEFAULT PRIVILEGES IN SCHEMA establishment
    GRANT SELECT ON TABLES TO dpruser;

ALTER DEFAULT PRIVILEGES IN SCHEMA staff
    GRANT SELECT ON TABLES TO dpruser;

ALTER DEFAULT PRIVILEGES IN SCHEMA person
    GRANT SELECT ON TABLES TO dpruser;

ALTER DEFAULT PRIVILEGES IN SCHEMA regional
    GRANT SELECT ON TABLES TO dpruser;

ALTER DEFAULT PRIVILEGES IN SCHEMA external
    GRANT SELECT ON TABLES TO dpruser;

-- =================================================================
-- Create views
-- =================================================================

CREATE OR REPLACE VIEW establishment.establishment AS
SELECT agy_loc_id           as id,
       description          as name,
       agency_location_type as agency_type,
       area_code,
       noms_region_code,
       active_flag          as active
FROM prisons.nomis_agency_locations
WITH NO SCHEMA BINDING;


CREATE OR REPLACE VIEW establishment.prison AS
SELECT p.prison_id,
       p.name,
       p.active,
       p.male,
       p.female,
       p.inactive_date,
       p.contracted                        as contracted_out,
       p.lthse                             as long_term_high_security_estate,
       (SELECT LISTAGG(type, ', ') WITHIN GROUP (ORDER BY type)
        FROM prisons.prisonregister_prison_type pt
        WHERE pt.prison_id = p.prison_id)  as types,
       (SELECT LISTAGG(category, ', ') WITHIN GROUP (ORDER BY category)
        FROM prisons.prisonregister_prison_category cat
        WHERE cat.prison_id = p.prison_id) as categories,
       (SELECT LISTAGG(o.name, ', ') WITHIN GROUP (ORDER BY o.name)
        FROM prisons.prisonregister_prison_operator op
                 JOIN "prisons"."prisonregister_operator" o
                      ON o.id = op.operator_id
        WHERE op.prison_id = p.prison_id) as operators
FROM prisons.prisonregister_prison p
        WITH NO SCHEMA BINDING;


CREATE OR REPLACE VIEW staff.staff AS
SELECT sm.staff_id,
       aua.username,
       sm.first_name,
       sm.last_name,
       aua.working_caseload_id as active_caseload_id,
       sm.status                  account_status
FROM prisons.nomis_STAFF_MEMBERS SM
JOIN prisons.nomis_staff_user_accounts aua
    ON sm.staff_id = aua.staff_id
WITH NO SCHEMA BINDING;


CREATE OR REPLACE VIEW person.prisoner AS
SELECT o.offender_id_display as prisoner_number,
       o.first_name,
       o.last_name,
       o.birth_date          as date_of_birth,
       ob.offender_book_id   as latest_booking_id,
       ob.booking_no         as latest_book_number,
       ob.agy_loc_id         as prison_id,
       i.description         as cell_location,
       l.id                  as location_uuid
FROM prisons.nomis_offender_bookings ob
INNER JOIN datamart.prisons."nomis_offenders" o
    ON ob.offender_id = o.offender_id
    AND ob.booking_seq = 1
LEFT JOIN prisons.nomis_agency_internal_locations I
    ON ob.living_unit_id = i.internal_location_id
LEFT JOIN prisons.locationsinsideprison_location l
    ON l.prison_id = ob.agy_loc_id and concat(l.prison_id, concat('-', l.path_hierarchy)) = i.description
WITH NO SCHEMA BINDING;


CREATE OR REPLACE VIEW regional.area AS
SELECT area_class,
       area_code,
       description,
       parent_area_code,
       active_flag
FROM prisons.nomis_areas
WITH NO SCHEMA BINDING;


CREATE OR REPLACE VIEW external.locations AS
SELECT agy_loc_id           as id,
       description          as name,
       agency_location_type as agency_type,
       area_code,
       noms_region_code,
       active_flag          as active
FROM prisons.nomis_agency_locations
WITH NO SCHEMA BINDING;
