CREATE OR REPLACE VIEW prisoner.profile AS
SELECT o.offender_id_display as prisoner_number,
       o.first_name,
       o.last_name,
       o.birth_date          as date_of_birth,
       o.sex_code,
       ob.offender_book_id   as latest_booking_id,
       ob.booking_no         as latest_book_number,
       ob.agy_loc_id         as prison_id
FROM prisons.nomis_offender_bookings ob
         INNER JOIN datamart.prisons."nomis_offenders" o ON ob.offender_id = o.offender_id
    AND ob.booking_seq = 1
WITH NO SCHEMA BINDING;
