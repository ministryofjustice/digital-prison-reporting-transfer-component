
DROP SCHEMA IF EXISTS prisoner CASCADE;

CREATE SCHEMA prisoner QUOTA UNLIMITED;

GRANT USAGE ON SCHEMA prisoner TO dpruser;

ALTER DEFAULT PRIVILEGES IN SCHEMA prisoner
    GRANT SELECT ON TABLES TO dpruser;

create view prisoner.prisoner as
with offender_latest_booking as (
    -- contains the latest booking for this offender so there is a single offender_book_id per offender_id
    select
        offender_book_id,
        agy_loc_id,
        living_unit_id,
        request_name,
        offender_id
    from (
        select *, row_number() over (partition by offender_id order by booking_begin_date DESC, booking_seq ASC) as rn
        from prisons.nomis_offender_bookings
    ) t
    where rn = 1
),
latest_profile_per_booking as (
    -- contains a row for each booking and profile type pair
    select
        p.offender_book_id,
        p.profile_type,
        p.profile_code,
        pc.description
    from (
        -- The combination of offender_book_id, profile_type and profile_seq is unique.
        select *, row_number() over (partition by offender_book_id, profile_type order by profile_seq DESC) as rn
        from prisons.nomis_offender_profile_details
    ) p
    left join prisons.nomis_profile_codes pc
        on p.profile_code = pc.profile_code
        and p.profile_type = pc.profile_type
    -- We assume that the largest profile_seq for each offender_book_id, profile_type pair is the latest
    where rn = 1
),
pnc as (
    -- contains a row for each offender
    select
        offender_id,
        identifier
    from (
        select *, row_number() over (partition by offender_id order by offender_id_seq desc) as rn
        from prisons.nomis_offender_identifiers
        where identifier_type = 'PNC'
    ) p
    -- We assume that the largest offender_id_seq for each offender_id is the latest.
    where rn = 1
),
religion_profile_info as (
    select * from latest_profile_per_booking
    where profile_type = 'RELF'
),
nationality_profile_info as (
    select * from latest_profile_per_booking
    where profile_type = 'NAT'
),
diet_profile_info as (
    select * from latest_profile_per_booking
    where profile_type = 'DIET'
),
sexual_orientation_profile_info as (
    select * from latest_profile_per_booking
    where profile_type = 'SEXO'
),
gender_domain as (
     select
          code,
          domain,
          description
     from prisons.nomis_reference_codes
     where domain = 'SEX'
),
ethnicity_domain as (
     select
          code,
          domain,
          description
     from prisons.nomis_reference_codes
     where domain = 'ETHNICITY'
),
primary_language as (
     select
         offender_book_id,
         language_code
     from prisons.nomis_offender_languages
     where language_type = 'PRIM'
),
secondary_language as (
     -- aggregated into 1 row per offender_book_id
     select
         offender_book_id,
         split_to_array(listagg(distinct language_code, ',') WITHIN GROUP (ORDER BY language_code)) as language_codes
     from prisons.nomis_offender_languages
     where language_type = 'SEC'
     group by offender_book_id

)
select o.offender_id_display                                  AS number,
       ob.offender_book_id                                    AS id,
       o.offender_id                                          AS offender_id,
       o.root_offender_id                                     AS offender_root_id,
       ob.agy_loc_id                                          AS establishment_id,
       ob.living_unit_id                                      AS living_unit_id,
       o.first_name                                           AS first_name,
       o.middle_name                                          AS middle_name,
       o.middle_name_2                                        AS middle_name_2,
       o.last_name                                            AS last_name,
       o.suffix                                               AS suffix,
       (o.last_name || ', ' || substring(o.first_name, 1, 1)) AS name,
       ob.request_name                                        AS requested_name,
       o.birth_date                                           AS date_of_birth,
       o.birth_place                                          AS birth_place,
       o.sex_code                                             AS gender_code,
       gender.description                                     AS gender,
       CASE
           WHEN o.race_code = 'W8' then 'W3'
           WHEN o.race_code = 'O1' then 'A4'
           ELSE o.race_code
           END                                                AS ethnicity_code,
       ethnicity.description                                  AS ethnicity,
       primary_language.language_code                         AS primary_language,
       secondary_language.language_codes                      AS secondary_languages,
       pnc.identifier                                         AS pnc,
       nationality.profile_code                               AS nationality_code,
       nationality.description                                AS nationality,
       religion.profile_code                                  AS religion_code,
       religion.description                                   AS religion,
       diet.profile_code                                      AS diet_code,
       diet.description                                       AS diet,
       orientation.profile_code                               AS sex_orientation_code,
       orientation.description                                AS sex_orientation
from prisons.nomis_offenders o
-- We will have 1 row for each offender
left join offender_latest_booking ob
    on o.offender_id = ob.offender_id
left join nationality_profile_info nationality
    on ob.offender_book_id = nationality.offender_book_id
left join religion_profile_info religion
    on ob.offender_book_id = religion.offender_book_id
left join diet_profile_info diet
    on ob.offender_book_id = diet.offender_book_id
left join sexual_orientation_profile_info orientation
    on ob.offender_book_id = orientation.offender_book_id
left join gender_domain gender
    on o.sex_code = gender.code
left join ethnicity_domain ethnicity
    on o.race_code = ethnicity.code
left join primary_language
    on ob.offender_book_id = primary_language.offender_book_id
left join secondary_language
    on ob.offender_book_id = secondary_language.offender_book_id
left join pnc
    on o.offender_id = pnc.offender_id
with no schema binding;
