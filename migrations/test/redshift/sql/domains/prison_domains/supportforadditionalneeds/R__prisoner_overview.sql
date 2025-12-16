CREATE OR REPLACE VIEW prison_domains.supportforadditionalneeds_prisoner_overview AS
WITH all_prisoners AS (SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_aln_assessment
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_ldd_assessment
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_education
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_condition
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_challenge
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_strength
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_plan_creation_schedule
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_review_schedule
                       UNION
                       SELECT prison_number
                       FROM "datamart"."prisons".supportforadditionalneeds_elsp_plan)
SELECT ap.prison_number
     , aln.has_need                                                 has_aln_need
     , ldd.has_need                                                 has_ldd_need
     , COALESCE(edu.in_education, false)                            in_education
     , COALESCE((cond.exists_flag IS NOT NULL), false)              has_condition
     , COALESCE((chal.exists_flag IS NOT NULL), false)              has_non_screener_challenge
     , COALESCE((str.exists_flag IS NOT NULL), false)               has_non_screener_strength
     , pcs.deadline_date                                            plan_creation_deadline_date
     , rsched.deadline_date                                         review_deadline_date
     , COALESCE(rsched.deadline_date, pcs.deadline_date)            deadline_date
     , COALESCE((plan.exists_flag IS NOT NULL), false)              has_plan
     , COALESCE((pcs.status = 'EXEMPT_PRISONER_NOT_COMPLY'), false) plan_declined
     , ((CASE
             WHEN (aln.has_need IS NOT NULL) THEN aln.has_need
             WHEN (ldd.has_need IS NOT NULL) THEN ldd.has_need
             ELSE false END) OR COALESCE((cond.exists_flag IS NOT NULL), false) OR
        COALESCE((chal.exists_flag IS NOT NULL), false))            has_need
FROM all_prisoners ap
         LEFT JOIN (SELECT prison_number
                         , has_need
                    FROM (SELECT prison_number
                               , has_need
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_aln_assessment) t
                    WHERE (rn = 1)) aln ON (aln.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , has_need
                    FROM (SELECT prison_number
                               , has_need
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_ldd_assessment) t
                    WHERE (rn = 1)) ldd ON (ldd.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , in_education
                    FROM (SELECT prison_number
                               , in_education
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_education) t
                    WHERE (rn = 1)) edu ON (edu.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , 1 exists_flag
                    FROM (SELECT prison_number
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_condition
                          WHERE (active = true)) t
                    WHERE (rn = 1)) cond ON (cond.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , 1 exists_flag
                    FROM (SELECT prison_number
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_challenge
                          WHERE ((active = true) AND (aln_screener_id IS NULL))) t
                    WHERE (rn = 1)) chal ON (chal.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , 1 exists_flag
                    FROM (SELECT prison_number
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_strength
                          WHERE ((active = true) AND (aln_screener_id IS NULL))) t
                    WHERE (rn = 1)) str ON (str.prison_number = ap.prison_number)
         LEFT JOIN "datamart"."prisons".supportforadditionalneeds_plan_creation_schedule pcs
                   ON (pcs.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , deadline_date
                    FROM (SELECT prison_number
                               , deadline_date
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY deadline_date DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_review_schedule
                          WHERE (status = 'SCHEDULED')) t
                    WHERE (rn = 1)) rsched ON (rsched.prison_number = ap.prison_number)
         LEFT JOIN (SELECT prison_number
                         , 1 exists_flag
                    FROM (SELECT prison_number
                               , ROW_NUMBER() OVER (PARTITION BY prison_number ORDER BY created_at DESC) rn
                          FROM "datamart"."prisons".supportforadditionalneeds_elsp_plan) t
                    WHERE (rn = 1)) plan ON (plan.prison_number = ap.prison_number)
WITH NO SCHEMA BINDING;
