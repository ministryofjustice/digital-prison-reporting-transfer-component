CREATE OR REPLACE VIEW prison_domains.supportforadditionalneeds_prisoner_challenges_and_conditions AS
WITH base AS (SELECT cp.prisoner_number AS prison_number,
                     cp.prison_id       AS current_location,
                     cp.sex_code,
                     cp.first_name,
                     cp.last_name,
                     cp.date_of_birth   as birth_date,
                     ov.has_need,
                     ov.has_aln_need,
                     ov.has_ldd_need
              FROM datamart.prisoner.profile AS cp
                       LEFT JOIN datamart.prison_domains."supportforadditionalneeds_prisoner_overview" ov
                                 ON cp.prisoner_number = ov.prison_number
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
                                 -- max updated to work with integer
                                 MAX(CASE WHEN r.condition_code = 'PHYSICAL_OTHER' THEN TRUE::INTEGER END) AS conditions_restricting_mobility_dexterity,
                                 MAX(CASE WHEN r.condition_code = 'DLD_OTHER' THEN 1 END)                  AS other_language_speech_communication_disorder,
                                 MAX(CASE WHEN r.condition_code = 'DYSPRAXIA' THEN 1 END)                  AS dyspraxia_developmental_coordination_disorder,
                                 MAX(CASE WHEN r.condition_code = 'ABI' THEN 1 END)                        AS acquired_brain_injury,
                                 MAX(CASE WHEN r.condition_code = 'DYSLEXIA' THEN 1 END)                   AS dyslexia,
                                 MAX(CASE WHEN r.condition_code = 'ASC' THEN 1 END)                        AS autism_spectrum_condition,
                                 MAX(CASE WHEN r.condition_code = 'ADHD' THEN 1 END)                       AS attention_deficit_hyperactivity_disorder_adhd_add,
                                 MAX(CASE WHEN r.condition_code = 'DYSCALCULIA' THEN 1 END)                AS dyscalculia,
                                 MAX(CASE WHEN r.condition_code = 'LD_OTHER' THEN 1 END)                   AS other_learning_disability,
                                 MAX(CASE WHEN r.condition_code = 'MENTAL_HEALTH' THEN 1 END)              AS mental_health,
                                 MAX(CASE WHEN r.condition_code = 'VISUAL_IMPAIR' THEN 1 END)              AS visual_impairment,
                                 MAX(CASE WHEN r.condition_code = 'OTHER' THEN 1 END)                      AS other_disability_or_health_condition_not_listed_above,
                                 MAX(CASE WHEN r.condition_code = 'LEARN_DIFF_OTHER' THEN 1 END)           AS other,
                                 MAX(CASE WHEN r.condition_code = 'LD_DOWN' THEN 1 END)                    AS downs_syndrome,
                                 MAX(CASE WHEN r.condition_code = 'DLD_LANG' THEN 1 END)                   AS developmental_language_disorder,
                                 MAX(CASE WHEN r.condition_code = 'NEURODEGEN' THEN 1 END)                 AS neurodegenerative_condition,
                                 MAX(CASE WHEN r.condition_code = 'FASD' THEN 1 END)                       AS foetal_alcohol_spectrum_disorder,
                                 MAX(CASE WHEN r.condition_code = 'DLD_HEAR' THEN 1 END)                   AS hearing_impairment,
                                 MAX(CASE WHEN r.condition_code = 'TOURETTES' THEN 1 END)                  AS tourettes_syndrome_tic_disorder,
                                 MAX(CASE WHEN r.condition_code = 'LONG_TERM_OTHER' THEN 1 END)            AS other_long_term_medical_condition,
                                 MAX(CASE WHEN r.condition_code = 'NEURO_OTHER' THEN 1 END)                AS other_neurological_condition
                          FROM cond c
                                   JOIN ref r
                                        ON c.condition_type_id = r.condition_id
                          GROUP BY c.prison_number),
     challenges_pivot AS (SELECT ch.prison_number,
                                 -- max updated to work with integer
                                 MAX(CASE WHEN cr.challenge_group = 'PHYSICAL_SKILLS' THEN 1 END)           AS challenge_physical_skills,
                                 MAX(CASE WHEN cr.challenge_group = 'ATTENTION_ORGANISING_TIME' THEN 1 END) AS challenge_attention_organising_time,
                                 MAX(CASE WHEN cr.challenge_group = 'PROCESSING_SPEED' THEN 1 END)          AS challenge_processing_speed,
                                 MAX(CASE WHEN cr.challenge_group = 'NUMERACY_SKILLS' THEN 1 END)           AS challenge_numeracy_skills,
                                 MAX(CASE WHEN cr.challenge_group = 'SENSORY' THEN 1 END)                   AS challenge_sensory,
                                 MAX(CASE WHEN cr.challenge_group = 'LANGUAGE_COMM_SKILLS' THEN 1 END)      AS challenge_language_comm_skills,
                                 MAX(CASE WHEN cr.challenge_group = 'EMOTIONS_FEELINGS' THEN 1 END)         AS challenge_emotions_feelings,
                                 MAX(CASE WHEN cr.challenge_group = 'LITERACY_SKILLS' THEN 1 END)           AS challenge_literacy_skills,
                                 MAX(CASE WHEN cr.challenge_group = 'MEMORY' THEN 1 END)                    AS challenge_memory
                          FROM challenge ch
                                   JOIN challenge_ref cr
                                        ON ch.challenge_type_id = cr.challenge_type_id
                          GROUP BY ch.prison_number)
SELECT b.prison_number,
       b.first_name,
       b.last_name,
       b.birth_date,
       b.sex_code,
       b.current_location,
       b.has_need,
       b.has_aln_need,
       b.has_ldd_need,
       -- Conditions
       c.conditions_restricting_mobility_dexterity,
       c.other_language_speech_communication_disorder,
       c.dyspraxia_developmental_coordination_disorder,
       c.acquired_brain_injury,
       c.dyslexia,
       c.autism_spectrum_condition,
       c.attention_deficit_hyperactivity_disorder_adhd_add,
       c.dyscalculia,
       c.other_learning_disability,
       c.mental_health,
       c.visual_impairment,
       c.other_disability_or_health_condition_not_listed_above,
       c.other,
       c.downs_syndrome,
       c.developmental_language_disorder,
       c.neurodegenerative_condition,
       c.foetal_alcohol_spectrum_disorder,
       c.hearing_impairment,
       c.tourettes_syndrome_tic_disorder,
       c.other_long_term_medical_condition,
       c.other_neurological_condition,
       -- Challenges
       ch.challenge_physical_skills,
       ch.challenge_attention_organising_time,
       ch.challenge_processing_speed,
       ch.challenge_numeracy_skills,
       ch.challenge_sensory,
       ch.challenge_language_comm_skills,
       ch.challenge_emotions_feelings,
       ch.challenge_literacy_skills,
       ch.challenge_memory
FROM base b
         LEFT JOIN conditions_pivot c
                   ON b.prison_number = c.prison_number
         LEFT JOIN challenges_pivot ch
                   ON b.prison_number = ch.prison_number
ORDER BY b.current_location, b.prison_number
WITH NO SCHEMA BINDING;
