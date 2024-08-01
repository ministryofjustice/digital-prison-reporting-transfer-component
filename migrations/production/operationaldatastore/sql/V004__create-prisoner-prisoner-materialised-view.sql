-- =================================================================
-- prisoner_prisoner
-- =================================================================

CREATE SCHEMA IF NOT EXISTS domain;

DROP MATERIALIZED VIEW IF EXISTS domain.prisoner_prisoner;

CREATE MATERIALIZED VIEW domain.prisoner_prisoner AS
WITH ofrel AS (SELECT row_number() over (partition by prisons.nomis_offender_profile_details.offender_book_id) as rn,
                      prisons.nomis_offender_profile_details.offender_book_id,
                      prisons.nomis_offender_profile_details.profile_code,
                      prisons.nomis_profile_codes.description
               FROM prisons.nomis_offender_profile_details
                        LEFT JOIN prisons.nomis_profile_codes ON prisons.nomis_profile_codes.profile_code =
                                                         prisons.nomis_offender_profile_details.profile_code
               where prisons.nomis_offender_profile_details.profile_type = 'RELF'),
     pnc AS (SELECT *, row_number() over (partition by offender_id order by offender_id_seq) as rn
             FROM prisons.nomis_offender_identifiers
             where prisons.nomis_offender_identifiers.identifier_type = 'PNC'),
     prim_lang AS (SELECT * FROM prisons.nomis_offender_languages WHERE language_type = 'PRIM'),
     sec_lang AS (SELECT *, row_number() over (partition by offender_book_id) as rn
                  FROM prisons.nomis_offender_languages
                  WHERE language_type = 'SEC'),
     latest_sentence AS (SELECT *, row_number() over (partition by offender_book_id order by end_date desc) as rn
                         from prisons.nomis_offender_sentence_terms),
     ethnicity_domain AS (SELECT code, domain, description
                          from prisons.nomis_reference_codes
                          where domain = 'ETHNICITY'),
     nationality_info AS (select row_number() over (partition by offender_book_id) as rn,
                                 offender_book_id,
                                 prisons.nomis_profile_codes.profile_code                  as code,
                                 prisons.nomis_profile_codes.description
                          from prisons.nomis_offender_profile_details
                                   left join prisons.nomis_profile_codes
                                             on prisons.nomis_offender_profile_details.profile_code =
                                                prisons.nomis_profile_codes.profile_code
                          where prisons.nomis_offender_profile_details.profile_type = 'NAT'),
     gender_domain AS (SELECT code, domain, description from prisons.nomis_reference_codes where domain = 'SEX'),
     diet_info AS (select row_number() over (partition by offender_book_id) as rn,
                          offender_book_id,
                          prisons.nomis_profile_codes.profile_code                  as code,
                          prisons.nomis_profile_codes.description
                   from prisons.nomis_offender_profile_details
                            left join prisons.nomis_profile_codes
                                      on prisons.nomis_offender_profile_details.profile_code =
                                         prisons.nomis_profile_codes.profile_code
                   where prisons.nomis_offender_profile_details.profile_type = 'DIET'),
     latest_category AS (SELECT *, row_number() over (partition by offender_book_id order by assessment_date desc) as rn
                         from prisons.nomis_offender_assessments),
     sexo_info
         AS (select row_number() over (partition by prisons.nomis_offender_profile_details.offender_book_id) as rn,
                    offender_book_id,
                    prisons.nomis_profile_codes.profile_code                                                 as code,
                    prisons.nomis_profile_codes.description
             from prisons.nomis_offender_profile_details
                      left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code =
                                                       prisons.nomis_profile_codes.profile_code
             where prisons.nomis_offender_profile_details.profile_type = 'SEXO')
SELECT o.offender_id_display                                  AS number,
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
       EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birth_date))  AS age,
       o.birth_place                                          AS birth_place,
       o.sex_code                                             AS gender_code,
       gender_domain.description                              AS gender,
       CASE
           WHEN o.race_code = 'W8' then 'W3'
           WHEN o.race_code = 'O1' then 'A4'
           ELSE o.race_code END                               AS ethnicity_code,
       ethnicity_domain.description                           AS ethnicity,
       prim_lang.language_code                                AS primary_language,
       sec_lang.language_code                                 AS secondary_language,
       pnc.identifier                                         AS pnc,
       CASE
           WHEN latest_sentence.life_sentence_flag = 'Y' THEN 'LIFE'
           ELSE (latest_sentence.years || '/' || latest_sentence.months || '/' ||
                 latest_sentence.days) END                    AS sentence_length,
       CASE
           WHEN latest_sentence.life_sentence_flag = 'Y' THEN 'Life'
           ELSE (latest_sentence.years || ' years ' || latest_sentence.months || ' months ' || latest_sentence.days ||
                 ' days') END                                 AS sentence_length_description,
       nationality_info.code                                  AS nationality_code,
       nationality_info.description                           AS nationality,
       ofrel.profile_code                                     AS religion_code,
       ofrel.description                                      AS religion,
       latest_category.score                                  AS category,
       diet_info.code                                         AS diet_code,
       diet_info.description                                  AS diet,
       sexo_info.code                                         AS sex_orientation_code,
       sexo_info.description                                  AS sex_orientation
FROM prisons.nomis_offenders o
         JOIN prisons.nomis_offender_bookings ob ON o.offender_id = ob.offender_id
         LEFT JOIN ofrel ON ofrel.offender_book_id = ob.offender_book_id AND ofrel.rn = 1
         LEFT JOIN pnc ON pnc.offender_id = o.offender_id AND pnc.rn = 1
         LEFT JOIN prim_lang ON prim_lang.offender_book_id = ob.offender_book_id
         LEFT JOIN sec_lang ON sec_lang.offender_book_id = ob.offender_book_id AND sec_lang.rn = 1
         LEFT JOIN latest_sentence ON latest_sentence.offender_book_id = ob.offender_book_id AND latest_sentence.rn = 1
         LEFT JOIN ethnicity_domain ON o.race_code = ethnicity_domain.code
         LEFT JOIN nationality_info
                   ON ob.offender_book_id = nationality_info.offender_book_id AND nationality_info.rn = 1
         LEFT JOIN gender_domain ON o.sex_code = gender_domain.code
         LEFT JOIN diet_info ON ob.offender_book_id = diet_info.offender_book_id AND diet_info.rn = 1
         LEFT JOIN latest_category ON latest_category.offender_book_id = ob.offender_book_id AND latest_category.rn = 1
         LEFT JOIN sexo_info ON ob.offender_book_id = sexo_info.offender_book_id AND sexo_info.rn = 1;
