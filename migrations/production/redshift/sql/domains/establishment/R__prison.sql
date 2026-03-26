CREATE OR REPLACE VIEW establishment.prison AS
SELECT p.prison_id,
       p.name,
       p.active,
       p.male,
       p.female,
       p.inactive_date,
       p.contracted                        as contracted_out,
       p.lthse                             as long_term_high_security_estate,
       (SELECT LISTAGG(type, ', ') WITHIN GROUP (
           ORDER BY
           type
           )
        FROM prisons.prisonregister_prison_type pt
        WHERE pt.prison_id = p.prison_id)  as types,
       (SELECT LISTAGG(category, ', ') WITHIN GROUP (
           ORDER BY
           category
           )
        FROM prisons.prisonregister_prison_category cat
        WHERE cat.prison_id = p.prison_id) as categories,
       (SELECT LISTAGG(o.name, ', ') WITHIN GROUP (
           ORDER BY
           o.name
           )
        FROM prisons.prisonregister_prison_operator op
                 JOIN "prisons"."prisonregister_operator" o ON o.id = op.operator_id
        WHERE op.prison_id = p.prison_id)  as operators,
       pe.region                           as region -- include region
FROM prisons.prisonregister_prison p
         LEFT JOIN prisons.prisonestate_prisons pe ON pe.prison_code = p.prison_id
-- join on estate
        WITH NO SCHEMA BINDING;
