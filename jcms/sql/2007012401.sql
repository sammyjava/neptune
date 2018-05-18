--
-- 2007012401.sql
--
-- Add pages.label
--

ALTER TABLE pages ADD COLUMN label varchar;
UPDATE pages SET label=lower(title);

UPDATE appinfo SET appinfo_value='2007012401' WHERE appinfo_name='db_version';
