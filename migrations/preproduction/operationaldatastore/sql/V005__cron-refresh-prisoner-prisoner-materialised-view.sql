CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 'REFRESH MATERIALIZED VIEW CONCURRENTLY' requires a unique index
CREATE UNIQUE INDEX prisoner_prisoner_id_key ON domain.prisoner_prisoner(id);

-- Refresh daily at 2am. Refreshing concurrently allows queries to continue during the refresh
SELECT cron.schedule ('refresh domain.prisoner_prisoner','0 2 * * *','REFRESH MATERIALIZED VIEW CONCURRENTLY domain.prisoner_prisoner');
