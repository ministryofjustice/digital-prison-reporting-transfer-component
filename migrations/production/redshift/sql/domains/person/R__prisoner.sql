/*
Updated to work off the NOMIS nomis_agency_internal_locations TABLE
TODO
1: To use the internal locations service when available in production -
*/
CREATE OR REPLACE VIEW person.prisoner AS
WITH ofrel AS (SELECT row_number() over (
    partition by prisons.nomis_offender_profile_details.offender_book_id
    ) as rn,
                      prisons.nomis_offender_profile_details.offender_book_id,
                      prisons.nomis_offender_profile_details.profile_code,
                      prisons.nomis_profile_codes.description
               FROM prisons.nomis_offender_profile_details
                        LEFT JOIN prisons.nomis_profile_codes ON prisons.nomis_profile_codes.profile_code =
                                                                 prisons.nomis_offender_profile_details.profile_code
               where prisons.nomis_offender_profile_details.profile_type = 'RELF'),
     ethnicity_domain AS (SELECT code,
                                 domain,
                                 description
                          from prisons.nomis_reference_codes
                          where domain = 'ETHNICITY'),
     nationality_info AS (select row_number() over (partition by offender_book_id) as rn,
                                 offender_book_id,
                                 prisons.nomis_profile_codes.profile_code          as code,
                                 prisons.nomis_profile_codes.description
                          from prisons.nomis_offender_profile_details
                                   left join prisons.nomis_profile_codes
                                             on prisons.nomis_offender_profile_details.profile_code =
                                                prisons.nomis_profile_codes.profile_code
                          where prisons.nomis_offender_profile_details.profile_type = 'NAT'),
     gender_domain AS (SELECT code,
                              domain,
                              description
                       from prisons.nomis_reference_codes
                       where domain = 'SEX')
SELECT o.offender_id_display                             as prisoner_number,
       o.first_name,
       o.last_name,
       INITCAP(o.last_name || ', ' || o.first_name)      AS name,
       o.birth_date                                      as date_of_birth,
       DATEDIFF(hour, o.birth_date, CURRENT_DATE) / 8766 AS age,
       ob.offender_book_id                               as latest_booking_id,
       ob.booking_no                                     as latest_book_number,
       ob.agy_loc_id                                     as prison_id,
       I.description                                     as cell_location,
       I.internal_location_id                            as location_uuid,
       o.sex_code                                        AS gender_code,
       gender_domain.description                         AS gender,
       CASE
           WHEN o.race_code = 'W8' then 'W3'
           WHEN o.race_code = 'O1' then 'A4'
           ELSE o.race_code END                          AS ethnicity_code,
       ethnicity_domain.description                      AS ethnicity,
       nationality_info.code                             AS nationality_code,
       nationality_info.description                      AS nationality,
       ofrel.profile_code                                AS religion_code,
       ofrel.description                                 AS religion
FROM prisons.nomis_offender_bookings ob
         INNER JOIN prisons."nomis_offenders" o ON ob.offender_id = o.offender_id
    AND ob.booking_seq = 1
         LEFT JOIN prisons.nomis_agency_internal_locations I ON ob.living_unit_id = i.internal_location_id
         LEFT JOIN gender_domain ON o.sex_code = gender_domain.code
         LEFT JOIN ethnicity_domain ON o.race_code = ethnicity_domain.code
         LEFT JOIN nationality_info ON ob.offender_book_id = nationality_info.offender_book_id
    AND nationality_info.rn = 1
         LEFT JOIN ofrel ON ofrel.offender_book_id = ob.offender_book_id
    AND ofrel.rn = 1
WITH NO SCHEMA BINDING;
