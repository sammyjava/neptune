--
-- remove unused fields
--

UPDATE appinfo SET appinfo_value='2007121001' WHERE appinfo_name='db_version';

ALTER TABLE pages DROP COLUMN dateactive;
ALTER TABLE pages DROP COLUMN dateexpires;
