-- =================================================================
-- Function age
-- input : $1 date
-- output : age of person
--
-- uses stable so can be re-used for the same statement
-- =================================================================
CREATE OR REPLACE FUNCTION domain.age(date)
    returns bigint
stable
AS $$
    select DATEDIFF(hour,$1,CURRENT_DATE)/8766
$$ language sql;

CREATE OR REPLACE FUNCTION domain.age(TIMESTAMP WITHOUT TIME ZONE)
    returns bigint
    stable
AS $$
    select DATEDIFF(hour,$1,CURRENT_DATE)/8766
$$ language sql;
