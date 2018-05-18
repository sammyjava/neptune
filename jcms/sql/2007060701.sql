--
-- make dhtmlcache.dhtml nullable
-- 2007060701
--

\connect - jcms

UPDATE appinfo SET appinfo_value='2007060701' WHERE appinfo_name='db_version';

ALTER TABLE dhtmlcache ALTER COLUMN dhtml DROP NOT NULL;


