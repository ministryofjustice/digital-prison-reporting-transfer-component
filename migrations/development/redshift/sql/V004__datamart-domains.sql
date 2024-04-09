-- =================================================================
-- adjudication_hearing
-- =================================================================

DROP VIEW IF EXISTS datamart.adjudication_hearing;

CREATE OR REPLACE VIEW datamart.adjudication_hearing AS 
WITH aiparty AS (SELECT * FROM prisons.nomis_agency_incident_parties)
SELECT hrg.oic_hearing_id AS id,
hrg.oic_hearing_type AS type,
hrg.oic_incident_id AS incident_id,
hrg.schedule_time AS scheduled,
TO_CHAR(hrg.hearing_time, 'AM') AS slot,
hrg.hearing_time AS date,
hrg.hearing_time AS time,
aiparty.offender_book_id AS prisoner_id
FROM prisons.nomis_oic_hearings hrg
LEFT JOIN aiparty ON aiparty.oic_incident_id=hrg.oic_incident_id
WITH NO SCHEMA BINDING;


-- =================================================================
-- establishment_establishment
-- =================================================================

DROP VIEW IF EXISTS datamart.establishment_establishment;

CREATE OR REPLACE VIEW datamart.establishment_establishment AS 

SELECT al.agy_loc_id AS id,
al.description AS name
FROM prisons.nomis_agency_locations al

WITH NO SCHEMA BINDING;


-- =================================================================
-- establishment_living_unit
-- =================================================================

DROP VIEW IF EXISTS datamart.establishment_living_unit;

CREATE OR REPLACE VIEW datamart.establishment_living_unit AS 

SELECT ail.internal_location_id AS id,
ail.internal_location_code AS code,
ail.agy_loc_id AS establishment_id,
ail.description AS name,
ail.unit_type AS unit_type,
ail.internal_location_type AS location_type
FROM prisons.nomis_agency_internal_locations ail

WITH NO SCHEMA BINDING;


-- =================================================================
-- movement_movement
-- =================================================================

DROP VIEW IF EXISTS datamart.movement_movement;

CREATE OR REPLACE VIEW datamart.movement_movement AS 
WITH origin_location AS (SELECT * from prisons.nomis_agency_locations),
destination_location AS (SELECT * from prisons.nomis_agency_locations),
mvr AS (SELECT * from prisons.nomis_movement_reasons)
SELECT (mov.offender_book_id || '.' || mov.movement_seq) AS id,
mov.offender_book_id AS prisoner,
mov.movement_date AS date,
mov.movement_time AS time,
mov.direction_code AS direction,
mov.movement_type AS type,
mov.from_agy_loc_id AS origin_code,
origin_location.description AS origin,
mov.to_agy_loc_id AS destination_code,
destination_location.description AS destination,
mov.movement_reason_code AS reason_code,
mvr.description AS reason,
mov.escort_code AS escort,
mov.comment_text AS comment
FROM prisons.nomis_offender_external_movements mov
LEFT JOIN origin_location ON mov.from_agy_loc_id=origin_location.agy_loc_id
LEFT JOIN destination_location ON mov.to_agy_loc_id=destination_location.agy_loc_id
LEFT JOIN mvr ON mvr.movement_type=mov.movement_type AND mvr.movement_reason_code=mov.movement_reason_code
WITH NO SCHEMA BINDING;


-- =================================================================
-- movement_schedule
-- =================================================================

DROP VIEW IF EXISTS datamart.movement_schedule;

CREATE OR REPLACE VIEW datamart.movement_schedule AS 
WITH origin_location AS (SELECT * from prisons.nomis_agency_locations),
destination_location AS (SELECT * from prisons.nomis_agency_locations),
mov_status AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='EVENT_STS'),
mov_type AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='EVENT_TYPE'),
mov_subtype AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='INT_SCH_RSN')
SELECT mov.event_id AS id,
mov.offender_book_id AS prisoner_id,
mov.event_date AS date,
mov.event_date AS time,
TO_CHAR(mov.start_time,'AM') AS slot,
mov.start_time AS start_time,
mov.end_time AS end_time,
mov.return_time AS return_time,
mov.direction_code AS direction,
mov.agy_loc_id AS origin_code,
origin_location.description AS origin,
mov.to_agy_loc_id AS destination_code,
destination_location.description AS destination,
mov.escort_code AS escorted,
mov.event_class AS class,
mov_type.code AS type_code,
mov_type.description AS type,
mov_subtype.description AS subtype,
mov_status.description AS status,
swl.approved_flag AS transfer_approved,
swl.wait_list_status AS wait_list_status
FROM prisons.nomis_offender_ind_schedules mov
LEFT JOIN prisons.nomis_offender_ind_sch_wait_lists swl ON mov.event_id=swl.event_id
LEFT JOIN origin_location ON mov.agy_loc_id=origin_location.agy_loc_id
LEFT JOIN destination_location ON mov.to_agy_loc_id=destination_location.agy_loc_id
LEFT JOIN mov_status ON mov.event_status=mov_status.code
LEFT JOIN mov_type ON mov.event_type=mov_type.code
LEFT JOIN mov_subtype ON mov.event_sub_type=mov_subtype.code AND mov_subtype.datamart=CASE 
WHEN mov.event_class='INT_MOV' THEN
    'INT_SCH_RSN'
WHEN mov.event_class='EXT_MOV' THEN
    'MOVE_RSN'
WHEN mov.event_class='COMM' THEN
    'EVENTS'
END
WITH NO SCHEMA BINDING;


-- =================================================================
-- movement_release
-- =================================================================

DROP VIEW IF EXISTS datamart.movement_release;

CREATE OR REPLACE VIEW datamart.movement_release AS 
WITH mov_status AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='EVENT_STS'),
mov_type AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='MOVE_TYPE'),
mov_subtype AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='MOVE_RSN')
SELECT mov.event_id AS id,
mov.offender_book_id AS prisoner_id,
mov.release_date AS date,
mov.release_date AS time,
NULL AS slot,
NULL AS start_time,
NULL AS end_time,
NULL AS return_time,
NULL AS direction,
NULL AS origin_code,
NULL AS origin,
NULL AS destination_code,
NULL AS destination,
NULL AS escorted,
'EXTERNAL' AS class,
mov_type.code AS type_code,
mov_type.description AS type,
mov_subtype.description AS subtype,
mov_status.description AS status,
NULL AS transfer_approved,
NULL AS wait_list_status
FROM prisons.nomis_offender_release_details mov
LEFT JOIN mov_status ON mov.event_status=mov_status.code
LEFT JOIN mov_type ON mov.movement_type=mov_type.code
LEFT JOIN mov_subtype ON mov.movement_reason_code=mov_subtype.code
WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_prisoner
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_prisoner;

CREATE OR REPLACE VIEW datamart.prisoner_prisoner AS 
WITH ofrel AS (SELECT row_number() over (partition by prisons.nomis_offender_profile_details.offender_book_id) as rn, prisons.nomis_offender_profile_details.offender_book_id, prisons.nomis_offender_profile_details.profile_code, prisons.nomis_profile_codes.description FROM prisons.nomis_offender_profile_details LEFT JOIN prisons.nomis_profile_codes ON prisons.nomis_profile_codes.profile_code=prisons.nomis_offender_profile_details.profile_code where prisons.nomis_offender_profile_details.profile_type='RELF'),
pnc AS (SELECT *, row_number() over (partition by offender_id order by offender_id_seq) as rn FROM prisons.nomis_offender_identifiers where prisons.nomis_offender_identifiers.identifier_type='PNC'),
prim_lang AS (SELECT * FROM prisons.nomis_offender_languages WHERE language_type='PRIM'),
sec_lang AS (SELECT *, row_number() over (partition by offender_book_id) as rn  FROM prisons.nomis_offender_languages WHERE language_type='SEC'),
latest_sentence AS (SELECT *, row_number() over (partition by offender_book_id order by end_date desc) as rn from prisons.nomis_offender_sentence_terms),
ethnicity_datamart AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='ETHNICITY'),
nationality_info AS (select row_number() over (partition by offender_book_id) as rn, offender_book_id, prisons.nomis_profile_codes.profile_code as code, prisons.nomis_profile_codes.description
from prisons.nomis_offender_profile_details
left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code=prisons.nomis_profile_codes.profile_code
where prisons.nomis_offender_profile_details.profile_type='NAT'),
gender_datamart AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='SEX'),
diet_info AS (select row_number() over (partition by offender_book_id) as rn, offender_book_id, prisons.nomis_profile_codes.profile_code as code, prisons.nomis_profile_codes.description
from prisons.nomis_offender_profile_details
left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code=prisons.nomis_profile_codes.profile_code
where prisons.nomis_offender_profile_details.profile_type='DIET'),
latest_category AS (SELECT *, row_number() over (partition by offender_book_id order by assessment_date desc) as rn from prisons.nomis_offender_assessments),
sexo_info AS (select row_number() over (partition by prisons.nomis_offender_profile_details.offender_book_id) as rn, offender_book_id, prisons.nomis_profile_codes.profile_code as code, prisons.nomis_profile_codes.description
from prisons.nomis_offender_profile_details
left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code=prisons.nomis_profile_codes.profile_code
where prisons.nomis_offender_profile_details.profile_type='SEXO')
SELECT o.offender_id_display AS number,
ob.offender_book_id AS id,
o.offender_id AS offender_id,
o.root_offender_id AS offender_root_id,
ob.agy_loc_id AS establishment_id,
ob.living_unit_id AS living_unit_id,
o.first_name AS first_name,
o.middle_name AS middle_name,
o.middle_name_2 AS middle_name_2,
o.last_name AS last_name,
o.suffix AS suffix,
(o.last_name || ', ' || substring(o.first_name,1,1)) AS name,
ob.request_name AS requested_name,
o.birth_date AS date_of_birth,
DATEDIFF(hour,o.birth_date,CURRENT_DATE)/8766 AS age,
o.birth_place AS birth_place,
o.sex_code AS gender_code,
gender_datamart.description AS gender,
CASE WHEN o.race_code='W8' then 'W3'
WHEN o.race_code='O1' then 'A4'
ELSE o.race_code END AS ethnicity_code,
ethnicity_datamart.description AS ethnicity,
prim_lang.language_code AS primary_language,
sec_lang.language_code AS secondary_language,
pnc.identifier AS pnc,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'LIFE' ELSE (latest_sentence.years || '/' || latest_sentence.months || '/' || latest_sentence.days ) END AS sentence_length,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'Life' ELSE (latest_sentence.years || ' years ' || latest_sentence.months || ' months ' || latest_sentence.days  || ' days') END AS sentence_length_description,
nationality_info.code AS nationality_code,
nationality_info.description AS nationality,
ofrel.profile_code AS religion_code,
ofrel.description AS religion,
latest_category.score AS category,
diet_info.code AS diet_code,
diet_info.description AS diet,
sexo_info.code AS sex_orientation_code,
sexo_info.description AS sex_orientation
FROM prisons.nomis_offenders o
JOIN prisons.nomis_offender_bookings ob ON o.offender_id=ob.offender_id
LEFT JOIN ofrel ON ofrel.offender_book_id=ob.offender_book_id AND ofrel.rn=1
LEFT JOIN pnc ON pnc.offender_id = o.offender_id AND pnc.rn=1
LEFT JOIN prim_lang ON prim_lang.offender_book_id=ob.offender_book_id
LEFT JOIN sec_lang ON sec_lang.offender_book_id=ob.offender_book_id AND sec_lang.rn=1
LEFT JOIN latest_sentence ON latest_sentence.offender_book_id=ob.offender_book_id AND latest_sentence.rn=1
LEFT JOIN ethnicity_datamart ON o.race_code=ethnicity_datamart.code
LEFT JOIN nationality_info ON ob.offender_book_id=nationality_info.offender_book_id AND nationality_info.rn=1
LEFT JOIN gender_datamart ON o.sex_code=gender_datamart.code
LEFT JOIN diet_info ON ob.offender_book_id=diet_info.offender_book_id AND diet_info.rn=1
LEFT JOIN latest_category ON latest_category.offender_book_id=ob.offender_book_id AND latest_category.rn=1
LEFT JOIN sexo_info ON ob.offender_book_id=sexo_info.offender_book_id AND sexo_info.rn=1
WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_profile
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_profile;

CREATE OR REPLACE VIEW datamart.prisoner_profile AS 
WITH ofrel AS (SELECT row_number() over (partition by prisons.nomis_offender_profile_details.offender_book_id) as rn, prisons.nomis_offender_profile_details.offender_book_id, prisons.nomis_offender_profile_details.profile_code, prisons.nomis_profile_codes.description FROM prisons.nomis_offender_profile_details LEFT JOIN prisons.nomis_profile_codes ON prisons.nomis_profile_codes.profile_code=prisons.nomis_offender_profile_details.profile_code where prisons.nomis_offender_profile_details.profile_type='RELF'),
pnc AS (SELECT * FROM prisons.nomis_offender_identifiers),
cro AS (SELECT * FROM prisons.nomis_offender_identifiers),
cid AS (SELECT * FROM prisons.nomis_offender_identifiers),
portref AS (SELECT * FROM prisons.nomis_offender_identifiers),
horef AS (SELECT * FROM prisons.nomis_offender_identifiers),
prim_lang AS (SELECT * FROM prisons.nomis_offender_languages WHERE language_type='PRIM'),
sec_lang AS (SELECT * FROM prisons.nomis_offender_languages WHERE language_type='SEC'),
latest_sentence AS (SELECT *, row_number() over (partition by offender_book_id order by end_date desc) as rn from prisons.nomis_offender_sentence_terms),
ethnicity_datamart AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='ETHNICITY'),
nationality_info AS (select offender_book_id, prisons.nomis_profile_codes.profile_code as code, prisons.nomis_profile_codes.description
from prisons.nomis_offender_profile_details
left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code=prisons.nomis_profile_codes.profile_code
where prisons.nomis_offender_profile_details.profile_type='NAT'),
gender_datamart AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='SEX'),
diet_info AS (select offender_book_id, prisons.nomis_profile_codes.profile_code as code, prisons.nomis_profile_codes.description
from prisons.nomis_offender_profile_details
left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code=prisons.nomis_profile_codes.profile_code
where prisons.nomis_offender_profile_details.profile_type='DIET'),
latest_category AS (SELECT *, row_number() over (partition by offender_book_id order by assessment_date desc) as rn from prisons.nomis_offender_assessments),
sexo_info AS (select offender_book_id, prisons.nomis_profile_codes.profile_code as code, prisons.nomis_profile_codes.description
from prisons.nomis_offender_profile_details
left join prisons.nomis_profile_codes on prisons.nomis_offender_profile_details.profile_code=prisons.nomis_profile_codes.profile_code
where prisons.nomis_offender_profile_details.profile_type='SEXO'),
living_unit AS (SELECT * FROM prisons.nomis_agency_internal_locations),
establishment AS (SELECT * FROM prisons.nomis_agency_locations),
ofims AS (SELECT offender_book_id, description, latest_status FROM prisons.nomis_offender_imprison_statuses JOIN prisons.nomis_imprisonment_statuses ON prisons.nomis_offender_imprison_statuses.imprisonment_status=prisons.nomis_imprisonment_statuses.imprisonment_status WHERE latest_status='Y')
SELECT o.offender_id_display AS number,
ob.offender_book_id AS id,
o.offender_id AS offender_id,
o.root_offender_id AS offender_root_id,
ob.agy_loc_id AS establishment_id,
ob.living_unit_id AS living_unit_id,
o.first_name AS first_name,
o.middle_name AS middle_name,
o.middle_name_2 AS middle_name_2,
o.last_name AS last_name,
o.suffix AS suffix,
(o.last_name || ', ' || substring(o.first_name,1,1)) AS name,
ob.request_name AS requested_name,
o.birth_date AS date_of_birth,
DATEDIFF(hour,o.birth_date,CURRENT_DATE)/8766 AS age,
o.birth_place AS birth_place,
o.sex_code AS gender_code,
gender_datamart.description AS gender,
CASE WHEN o.race_code='W8' then 'W3'
WHEN o.race_code='O1' then 'A4'
ELSE o.race_code END AS ethnicity_code,
ethnicity_datamart.description AS ethnicity,
prim_lang.language_code AS primary_language,
sec_lang.language_code AS secondary_language,
pnc.identifier AS pnc,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'LIFE' ELSE (latest_sentence.years || '/' || latest_sentence.months || '/' || latest_sentence.days ) END AS sentence_length,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'Life' ELSE (latest_sentence.years || ' years ' || latest_sentence.months || ' months ' || latest_sentence.days  || ' days') END AS sentence_length_description,
nationality_info.code AS nationality_code,
nationality_info.description AS nationality,
ofrel.profile_code AS religion_code,
ofrel.description AS religion,
latest_category.score AS category,
diet_info.code AS diet_code,
diet_info.description AS diet,
sexo_info.code AS sex_orientation_code,
sexo_info.description AS sex_orientation,
living_unit.description AS living_unit_name,
establishment.description AS establishment,
ofims.description AS legal_status,
ob.in_out_status AS in_out_status,
ob.booking_status AS booking_status,
ob.booking_begin_date AS booking_begin,
ob.active_flag AS active,
'$TBC' AS main_offence_code,
'$TBC' AS main_offence,
cro.identifier AS cro,
cid.identifier AS cid,
portref.identifier AS portref,
horef.identifier AS horef,
'$TBC' AS latest_cell_sharing_risk_assessment,
'$TBC' AS incentive_level
FROM prisons.nomis_offenders o
LEFT JOIN prisons.nomis_offender_bookings ob ON ob.offender_id=o.offender_id
LEFT JOIN ofrel ON ofrel.offender_book_id=ob.offender_book_id AND ofrel.rn=1
LEFT JOIN pnc ON pnc.offender_id = ob.offender_id AND pnc.identifier_type='PNC'
LEFT JOIN cro ON cro.offender_id = ob.offender_id AND cro.identifier_type='CRO'
LEFT JOIN cid ON cid.offender_id = ob.offender_id AND cid.identifier_type='CID'
LEFT JOIN portref ON portref.offender_id = ob.offender_id AND portref.identifier_type='PORTREF'
LEFT JOIN horef ON horef.offender_id = ob.offender_id AND horef.identifier_type='HOREF'
LEFT JOIN prim_lang ON prim_lang.offender_book_id=ob.offender_book_id
LEFT JOIN sec_lang ON sec_lang.offender_book_id=ob.offender_book_id
LEFT JOIN latest_sentence ON latest_sentence.offender_book_id=ob.offender_book_id AND latest_sentence.rn=1
LEFT JOIN ethnicity_datamart ON o.race_code=ethnicity_datamart.code
LEFT JOIN nationality_info ON ob.offender_book_id=nationality_info.offender_book_id
LEFT JOIN gender_datamart ON o.sex_code=gender_datamart.code
LEFT JOIN diet_info ON ob.offender_book_id=diet_info.offender_book_id
LEFT JOIN latest_category ON latest_category.offender_book_id=ob.offender_book_id AND latest_category.rn=1
LEFT JOIN sexo_info ON ob.offender_book_id=sexo_info.offender_book_id
LEFT JOIN living_unit ON living_unit.internal_location_id=ob.living_unit_id
LEFT JOIN establishment ON establishment.agy_loc_id=ob.agy_loc_id
LEFT JOIN ofims ON ob.offender_book_id = ofims.offender_book_id
WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_status
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_status;

CREATE OR REPLACE VIEW datamart.prisoner_status AS 
WITH ofims AS (SELECT offender_book_id, description, latest_status FROM prisons.nomis_offender_imprison_statuses JOIN prisons.nomis_imprisonment_statuses ON prisons.nomis_offender_imprison_statuses.imprisonment_status=prisons.nomis_imprisonment_statuses.imprisonment_status WHERE latest_status='Y')
SELECT o.offender_id_display AS number,
ob.offender_book_id AS id,
ofims.description AS legal_status,
ob.in_out_status AS in_out_status,
ob.booking_status AS booking_status,
ob.booking_begin_date AS booking_begin,
ob.active_flag AS active,
'TBD' AS status
FROM prisons.nomis_offender_bookings ob
JOIN prisons.nomis_offenders o ON ob.offender_id=o.offender_id
LEFT JOIN ofims ON ofims.offender_book_id = ob.offender_book_id
WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_property
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_property;

CREATE OR REPLACE VIEW datamart.prisoner_property AS 

SELECT opc.property_container_id AS id,
opc.offender_book_id AS prisoner_id,
opc.active_flag AS active,
opc.seal_mark AS seal_mark,
opc.agy_loc_id AS establishment_id,
opc.expiry_date AS expiry_date,
opc.internal_location_id AS living_unit_id,
opc.proposed_disposal_date AS proposed_disposal_date,
opc.container_code AS container_code,
opc.property_only_flag AS property_only,
opc.comment_text AS description
FROM prisons.nomis_offender_ppty_containers opc

WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_alert
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_alert;

CREATE OR REPLACE VIEW datamart.prisoner_alert AS 
WITH acode AS (SELECT * from prisons.nomis_reference_codes WHERE datamart='ALERT_CODE'),
acat AS (SELECT * FROM prisons.nomis_reference_codes WHERE datamart='ALERT')
SELECT (alert.offender_book_id || '.' || alert.alert_seq) AS id,
alert.offender_book_id AS prisoner_id,
alert.alert_date AS date,
alert.alert_type AS type,
alert.alert_code AS code,
acode.description AS description,
alert.alert_status AS status,
alert.expiry_date AS expiry_date,
acat.description AS category,
alert.comment_text AS comment
FROM prisons.nomis_offender_alerts alert
LEFT JOIN acode ON alert.alert_code=acode.code
LEFT JOIN acat ON alert.alert_type=acat.code
WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_offence
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_offence;

CREATE OR REPLACE VIEW datamart.prisoner_offence AS 
WITH acode AS (SELECT * from prisons.nomis_reference_codes WHERE datamart='ALERT_CODE'),
acat AS (SELECT * FROM prisons.nomis_reference_codes WHERE datamart='ALERT')
SELECT (alert.offender_book_id || '.' || alert.alert_seq) AS id,
alert.alert_date AS date,
alert.alert_type AS type,
alert.alert_code AS code,
acode.description AS description,
alert.alert_status AS status,
alert.expiry_date AS expiry_date,
acat.description AS category,
alert.comment_text AS comment
FROM prisons.nomis_offender_alerts alert
LEFT JOIN acode ON alert.alert_code=acode.code
LEFT JOIN acat ON alert.alert_type=acat.code
WITH NO SCHEMA BINDING;


-- =================================================================
-- prisoner_sentence
-- =================================================================

DROP VIEW IF EXISTS datamart.prisoner_sentence;

CREATE OR REPLACE VIEW datamart.prisoner_sentence AS 
WITH latest_sentence AS (SELECT *, row_number() over (partition by offender_book_id order by end_date desc) as rn from prisons.nomis_offender_sentence_terms)
SELECT sent.offender_sent_calculation_id AS id,
sent.offender_book_id AS prisoner_id,
NVL(sent.hdced_overrided_date,sent.hdced_calculated_date) AS hdced,
NVL(sent.apd_overrided_date,sent.apd_calculated_date) AS apd,
NVL(sent.prrd_overrided_date,sent.prrd_calculated_date) AS prrd,
NVL(sent.ard_overrided_date,sent.ard_calculated_date) AS ard,
NVL(sent.crd_overrided_date,sent.crd_calculated_date) AS crd,
NVL(sent.npd_overrided_date,sent.npd_calculated_date) AS npd,
NVL(sent.mtd_overrided_date,sent.mtd_calculated_date) AS mtd,
NVL(sent.ltd_overrided_date,sent.ltd_calculated_date) AS ltd,
NVL(sent.etd_overrided_date,sent.etd_calculated_date) AS etd,
NVL(sent.hdcad_overrided_date,sent.hdcad_calculated_date) AS hdcad,
sent.ersed_overrided_date AS ersed,
NVL(sent.sed_overrided_date,sent.sed_calculated_date) AS sed,
NVL(sent.led_overrided_date,sent.led_calculated_date) AS led,
NVL(ord.release_date,sent.hdcad_overrided_date, sent.apd_overrided_date, sent.prrd_overrided_date, sent.ard_overrided_date,sent.ard_calculated_date, sent.crd_overrided_date, sent.crd_calculated_date, sent.npd_overrided_date, sent.npd_calculated_date, sent.mtd_overrided_date, sent.mtd_calculated_date, NULL) AS current_release_date,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'LIFE' ELSE (latest_sentence.years || '/' || latest_sentence.months || '/' || latest_sentence.days ) END AS effective_sentence_length,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'Life' ELSE TO_CHAR(latest_sentence.years, '9999') END AS sentence_length_years,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'Life' ELSE TO_CHAR(latest_sentence.months, '9999') END AS sentence_length_months,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'Life' ELSE TO_CHAR(latest_sentence.weeks, '9999') END AS sentence_length_weeks,
CASE WHEN latest_sentence.life_sentence_flag='Y' THEN 'Life' ELSE TO_CHAR(latest_sentence.days, '9999') END AS sentence_length_days,
latest_sentence.life_sentence_flag='Y' AS life_sentence
FROM prisons.nomis_offender_sent_calculations sent
JOIN prisons.nomis_offender_release_details ord ON sent.offender_book_id=ord.offender_book_id
LEFT JOIN latest_sentence ON latest_sentence.offender_book_id=sent.offender_book_id
WITH NO SCHEMA BINDING;


-- =================================================================
-- reference_address
-- =================================================================

DROP VIEW IF EXISTS datamart.reference_address;

CREATE OR REPLACE VIEW datamart.reference_address AS 

SELECT addr.address_id AS id,
addr.address_type AS type,
addr.flat AS flat,
addr.premise AS premise,
addr.street AS street,
addr.locality AS locality,
addr.city_code AS city_code,
addr.city_name AS city,
addr.county_code AS county,
addr.country_code AS country,
addr.postal_code AS postcode,
addr.start_date AS start_date,
addr.end_date AS end_date
FROM prisons.nomis_addresses addr

WITH NO SCHEMA BINDING;


-- =================================================================
-- activity_wait_list
-- =================================================================

DROP VIEW IF EXISTS datamart.activity_wait_list;

CREATE OR REPLACE VIEW datamart.activity_wait_list AS 

SELECT waitlist.event_id AS id,
waitlist.approved_flag AS approved,
waitlist.wait_list_status AS status
FROM prisons.nomis_offender_ind_sch_wait_lists waitlist

WITH NO SCHEMA BINDING;


-- =================================================================
-- visit_visit
-- =================================================================

DROP VIEW IF EXISTS datamart.visit_visit;

CREATE OR REPLACE VIEW datamart.visit_visit AS 

SELECT visits.offender_visit_id AS id,
visits.offender_book_id AS prisoner_id,
TO_CHAR(visits.start_time,'AM') AS slot,
visits.start_time AS start_time,
visits.end_time AS end_time,
visits.visit_status AS status,
visits.visit_date AS date
FROM prisons.nomis_offender_visits visits

WITH NO SCHEMA BINDING;


-- =================================================================
-- court_event
-- =================================================================

DROP VIEW IF EXISTS datamart.court_event;

CREATE OR REPLACE VIEW datamart.court_event AS 
WITH destination_location AS (SELECT * from prisons.nomis_agency_locations),
evt_subtype AS (SELECT code, datamart, description from prisons.nomis_reference_codes where datamart='MOVE_RSN')
SELECT events.event_id AS id,
events.case_id AS case_id,
events.offender_book_id AS prisoner_id,
events.event_date AS date,
TO_CHAR(events.start_time,'AM') AS slot,
events.start_time AS start_time,
events.end_time AS end_time,
events.court_event_type AS subtype_code,
evt_subtype.description AS subtype,
events.event_status AS status,
events.agy_loc_id AS destination_code,
destination_location.description AS destination,
events.direction_code AS direction
FROM prisons.nomis_court_events events
LEFT JOIN destination_location ON events.agy_loc_id=destination_location.agy_loc_id
LEFT JOIN evt_subtype ON events.court_event_type=evt_subtype.code
WITH NO SCHEMA BINDING;
