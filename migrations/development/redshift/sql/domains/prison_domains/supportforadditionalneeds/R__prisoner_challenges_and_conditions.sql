/* 13/01/2025 Version 2 replace 1/0 and include N/A instead of NULLS for has_need, has_aln_need, has_ldd_need columns.
 * cell location and ethnicity description
 */
CREATE OR REPLACE VIEW prison_domains.supportforadditionalneeds_prisoner_challenges_and_conditions AS
WITH base AS (SELECT cp.prisoner_number AS prison_number,
                     cp.prison_id       AS current_location,
                     cp.gender_code     as sex_code,
                     cp.age,
                     cp.cell_location,
                     cp.ethnicity_code,
                     cp.ethnicity,
                     ov.has_need,
                     ov.has_aln_need,
                     ov.has_ldd_need
              FROM datamart.prison_domains."supportforadditionalneeds_prisoner_overview" ov
                       LEFT JOIN datamart.person.prisoner cp ON ov.prison_number = cp.prisoner_number
              WHERE cp.prison_id NOT in ('OUT', 'ZZGHI')),
     ref AS (SELECT r.id   AS condition_id,
                    r.code AS condition_code
             FROM "prisons"."supportforadditionalneeds_reference_data" r
             WHERE r.domain = 'CONDITION'),
     challenge_ref AS (SELECT r.id            AS challenge_type_id,
                              r.category_code AS challenge_group
                       FROM "prisons"."supportforadditionalneeds_reference_data" r
                       WHERE r.domain = 'CHALLENGE'
                         AND r.category_code IN (
                                                 'PHYSICAL_SKILLS',
                                                 'ATTENTION_ORGANISING_TIME',
                                                 'PROCESSING_SPEED',
                                                 'NUMERACY_SKILLS',
                                                 'SENSORY',
                                                 'LANGUAGE_COMM_SKILLS',
                                                 'EMOTIONS_FEELINGS',
                                                 'LITERACY_SKILLS',
                                                 'MEMORY'
                           )),
     cond AS (SELECT c.prison_number,
                     c.condition_type_id
              FROM "prisons"."supportforadditionalneeds_condition" c
              WHERE c.active = TRUE
--      AND c.__current = TRUE
     ),
     challenge AS (SELECT ch.prison_number,
                          ch.challenge_type_id
                   FROM "prisons"."supportforadditionalneeds_challenge" ch
                   WHERE ch.active = TRUE
--      AND ch.__current = TRUE
     ),
     conditions_pivot AS (SELECT c.prison_number,
                                 -- max updated to work with booleans
                                 BOOL_OR(CASE WHEN r.condition_code = 'PHYSICAL_OTHER' THEN TRUE END)   AS conditions_restricting_mobility_dexterity,
                                 BOOL_OR(CASE WHEN r.condition_code = 'DLD_OTHER' THEN TRUE END)        AS other_language_speech_communication_disorder,
                                 BOOL_OR(CASE WHEN r.condition_code = 'DYSPRAXIA' THEN TRUE END)        AS dyspraxia_developmental_coordination_disorder,
                                 BOOL_OR(CASE WHEN r.condition_code = 'ABI' THEN TRUE END)              AS acquired_brain_injury,
                                 BOOL_OR(CASE WHEN r.condition_code = 'DYSLEXIA' THEN TRUE END)         AS dyslexia,
                                 BOOL_OR(CASE WHEN r.condition_code = 'ASC' THEN TRUE END)              AS autism_spectrum_condition,
                                 BOOL_OR(CASE WHEN r.condition_code = 'ADHD' THEN TRUE END)             AS attention_deficit_hyperactivity_disorder_adhd_add,
                                 BOOL_OR(CASE WHEN r.condition_code = 'DYSCALCULIA' THEN TRUE END)      AS dyscalculia,
                                 BOOL_OR(CASE WHEN r.condition_code = 'LD_OTHER' THEN TRUE END)         AS other_learning_disability,
                                 BOOL_OR(CASE WHEN r.condition_code = 'MENTAL_HEALTH' THEN TRUE END)    AS mental_health,
                                 BOOL_OR(CASE WHEN r.condition_code = 'VISUAL_IMPAIR' THEN TRUE END)    AS visual_impairment,
                                 BOOL_OR(CASE WHEN r.condition_code = 'OTHER' THEN TRUE END)            AS other_disability_or_health_condition_not_listed_above,
                                 BOOL_OR(CASE WHEN r.condition_code = 'LEARN_DIFF_OTHER' THEN TRUE END) AS other,
                                 BOOL_OR(CASE WHEN r.condition_code = 'LD_DOWN' THEN TRUE END)          AS downs_syndrome,
                                 BOOL_OR(CASE WHEN r.condition_code = 'DLD_LANG' THEN TRUE END)         AS developmental_language_disorder,
                                 BOOL_OR(CASE WHEN r.condition_code = 'NEURODEGEN' THEN TRUE END)       AS neurodegenerative_condition,
                                 BOOL_OR(CASE WHEN r.condition_code = 'FASD' THEN TRUE END)             AS foetal_alcohol_spectrum_disorder,
                                 BOOL_OR(CASE WHEN r.condition_code = 'DLD_HEAR' THEN TRUE END)         AS hearing_impairment,
                                 BOOL_OR(CASE WHEN r.condition_code = 'TOURETTES' THEN TRUE END)        AS tourettes_syndrome_tic_disorder,
                                 BOOL_OR(CASE WHEN r.condition_code = 'LONG_TERM_OTHER' THEN TRUE END)  AS other_long_term_medical_condition,
                                 BOOL_OR(CASE WHEN r.condition_code = 'NEURO_OTHER' THEN TRUE END)      AS other_neurological_condition
                          FROM cond c
                                   JOIN ref r
                                        ON c.condition_type_id = r.condition_id
                          GROUP BY c.prison_number),
     challenges_pivot AS (SELECT ch.prison_number,
                                 -- max updated to work with integer
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'PHYSICAL_SKILLS' THEN TRUE END)           AS challenge_physical_skills,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'ATTENTION_ORGANISING_TIME' THEN TRUE END) AS challenge_attention_organising_time,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'PROCESSING_SPEED' THEN TRUE END)          AS challenge_processing_speed,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'NUMERACY_SKILLS' THEN TRUE END)           AS challenge_numeracy_skills,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'SENSORY' THEN TRUE END)                   AS challenge_sensory,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'LANGUAGE_COMM_SKILLS' THEN TRUE END)      AS challenge_language_comm_skills,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'EMOTIONS_FEELINGS' THEN TRUE END)         AS challenge_emotions_feelings,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'LITERACY_SKILLS' THEN TRUE END)           AS challenge_literacy_skills,
                                 BOOL_OR(CASE WHEN cr.challenge_group = 'MEMORY' THEN TRUE END)                    AS challenge_memory
                          FROM challenge ch
                                   JOIN challenge_ref cr
                                        ON ch.challenge_type_id = cr.challenge_type_id
                          GROUP BY ch.prison_number)
SELECT b.prison_number,
       b.age,
       b.sex_code,
       b.current_location,
       b.cell_location,
       b.ethnicity_code,
       b.ethnicity,
       b.has_need,
       CASE
           WHEN b.has_aln_need IS NULL THEN 'N/A'
           WHEN b.has_aln_need THEN 'true'
           ELSE 'false'
           END                                                                    AS has_aln_need,
       CASE
           WHEN b.has_ldd_need IS NULL THEN 'N/A'
           WHEN b.has_ldd_need THEN 'true'
           ELSE 'false'
           END                                                                    AS has_ldd_need,
       -- Conditions
       COALESCE(c.conditions_restricting_mobility_dexterity, 'false')             AS conditions_restricting_mobility_dexterity,
       COALESCE(c.other_language_speech_communication_disorder, 'false')          AS other_language_speech_communication_disorder,
       COALESCE(c.dyspraxia_developmental_coordination_disorder, 'false')         AS dyspraxia_developmental_coordination_disorder,
       COALESCE(c.acquired_brain_injury, 'false')                                 AS acquired_brain_injury,
       COALESCE(c.dyslexia, 'false')                                              AS dyslexia,
       COALESCE(c.autism_spectrum_condition, 'false')                             AS autism_spectrum_condition,
       COALESCE(c.attention_deficit_hyperactivity_disorder_adhd_add,
                'false')                                                          AS attention_deficit_hyperactivity_disorder_adhd_add,
       COALESCE(c.dyscalculia, 'false')                                           AS dyscalculia,
       COALESCE(c.other_learning_disability, 'false')                             AS other_learning_disability,
       COALESCE(c.mental_health, 'false')                                         AS mental_health,
       COALESCE(c.visual_impairment, 'false')                                     AS visual_impairment,
       COALESCE(c.other_disability_or_health_condition_not_listed_above,
                'false')                                                          AS other_disability_or_health_condition_not_listed_above,
       COALESCE(c.other, 'false')                                                 AS other,
       COALESCE(c.downs_syndrome, 'false')                                        AS downs_syndrome,
       COALESCE(c.developmental_language_disorder, 'false')                       AS developmental_language_disorder,
       COALESCE(c.neurodegenerative_condition, 'false')                           AS neurodegenerative_condition,
       COALESCE(c.foetal_alcohol_spectrum_disorder, 'false')                      AS foetal_alcohol_spectrum_disorder,
       COALESCE(c.hearing_impairment, 'false')                                    AS hearing_impairment,
       COALESCE(c.tourettes_syndrome_tic_disorder, 'false')                       AS tourettes_syndrome_tic_disorder,
       COALESCE(c.other_long_term_medical_condition, 'false')                     AS other_long_term_medical_condition,
       COALESCE(c.other_neurological_condition, 'false')                          AS other_neurological_condition,
       COALESCE(ch.challenge_physical_skills, 'false')                            AS challenge_physical_skills,
       COALESCE(ch.challenge_attention_organising_time, 'false')                  AS challenge_attention_organising_time,
       COALESCE(ch.challenge_processing_speed, 'false')                           AS challenge_processing_speed,
       COALESCE(ch.challenge_numeracy_skills, 'false')                            AS challenge_numeracy_skills,
       COALESCE(ch.challenge_sensory, 'false')                                    AS challenge_sensory,
       COALESCE(ch.challenge_language_comm_skills, 'false')                       AS challenge_language_comm_skills,
       COALESCE(ch.challenge_emotions_feelings, 'false')                          AS challenge_emotions_feelings,
       COALESCE(ch.challenge_literacy_skills, 'false')                            AS challenge_literacy_skills,
       COALESCE(ch.challenge_memory, 'false')                                     AS challenge_memory
FROM base b
         LEFT JOIN conditions_pivot c
                   ON b.prison_number = c.prison_number
         LEFT JOIN challenges_pivot ch
                   ON ch.prison_number = b.prison_number
ORDER BY b.current_location, b.prison_number
WITH NO SCHEMA BINDING;
