-- Create unique indexes (required to refresh materialised views concurrently) and a pg cron refresh schedule for each materialised view

CREATE UNIQUE INDEX establishment_establishment_id_key ON establishment.establishment(id);
SELECT cron.schedule ('refresh establishment.establishment','15 2 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY establishment.establishment');

CREATE UNIQUE INDEX establishment_prison_prison_id_key ON establishment.prison(prison_id);
SELECT cron.schedule ('refresh establishment.prison','30 2 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY establishment.prison');

CREATE UNIQUE INDEX staff_staff_staff_id_key ON staff.staff(staff_id);
SELECT cron.schedule ('refresh staff.staff','45 2 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY staff.staff');

CREATE UNIQUE INDEX person_prisoner_offender_id_display_key ON person.prisoner(prisoner_number);
SELECT cron.schedule ('refresh person.prisoner','0 3 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY person.prisoner');

CREATE UNIQUE INDEX regional_area_area_code_key ON regional.area(area_code);
SELECT cron.schedule ('refresh regional.area','15 3 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY regional.area');

CREATE UNIQUE INDEX external_location_id_key ON external.location(id);
SELECT cron.schedule ('refresh external.location','30 3 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY external.location');
