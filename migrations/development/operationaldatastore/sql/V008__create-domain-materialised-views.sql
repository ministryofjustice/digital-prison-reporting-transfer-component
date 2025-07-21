-- =================================================================
-- establishment.establishment
-- =================================================================

CREATE SCHEMA establishment;

CREATE MATERIALIZED VIEW establishment.establishment AS
SELECT agy_loc_id           as id,
       description          as name,
       agency_location_type as agency_type,
       area_code,
       noms_region_code,
       active_flag          as active
FROM prisons.nomis_agency_locations;


-- =================================================================
-- establishment.prison
-- =================================================================

CREATE MATERIALIZED VIEW establishment.prison AS
SELECT p.prison_id,
       p.name,
       p.active,
       p.male,
       p.female,
       p.inactive_date,
       p.contracted                        as contracted_out,
       p.lthse                             as long_term_high_security_estate,
       (SELECT string_agg(type, ', ' ORDER BY type)
        FROM prisons.prisonregister_prison_type pt
        where pt.prison_id = p.prison_id)  as types,
       (SELECT string_agg(category, ', ' ORDER BY category)
        FROM prisons.prisonregister_prison_category cat
        where cat.prison_id = p.prison_id) as categories,
       (SELECT string_agg(o.name, ', ' ORDER BY o.name)
        FROM prisons.prisonregister_prison_operator op
                 JOIN prisons.prisonregister_operator o on o.id = op.operator_id
        WHERE op.prison_id = p.prison_id)  as operators
FROM prisons.prisonregister_prison p;


-- =================================================================
-- staff.staff
-- =================================================================

CREATE SCHEMA staff;

CREATE MATERIALIZED VIEW staff.staff AS
SELECT sm.staff_id,
       aua.username,
       sm.first_name,
       sm.last_name,
       aua.working_caseload_id as active_caseload_id,
       sm.status                  account_status
FROM prisons.nomis_staff_members sm
         JOIN prisons.nomis_staff_user_accounts aua ON sm.staff_id = aua.staff_id;

-- =================================================================
-- person.prisoner
-- =================================================================

CREATE SCHEMA person;

CREATE MATERIALIZED VIEW person.prisoner AS
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
         INNER JOIN prisons.nomis_offenders o
                    ON ob.offender_id = o.offender_id AND ob.booking_seq = 1
         LEFT JOIN prisons.nomis_agency_internal_locations i
                   ON ob.living_unit_id = i.internal_location_id
         LEFT JOIN prisons.locationsinsideprison_location l
                   ON l.prison_id = ob.agy_loc_id
                       AND concat(l.prison_id, concat('-', l.path_hierarchy)) = i.description;


-- =================================================================
-- regional.area
-- =================================================================

CREATE SCHEMA regional;

CREATE MATERIALIZED VIEW regional.area AS
SELECT area_class, area_code, description, parent_area_code, active_flag
FROM prisons.nomis_areas;

-- =================================================================
-- external.location
-- =================================================================

CREATE SCHEMA external;
CREATE MATERIALIZED VIEW external.location AS
SELECT agy_loc_id           as id,
       description          as name,
       agency_location_type as agency_type,
       area_code,
       noms_region_code,
       active_flag          as active
FROM prisons.nomis_agency_locations;
