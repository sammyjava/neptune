--
-- add site_center to settings and put explicit align="center" in DHTML container table
--

UPDATE appinfo SET appinfo_value='2008030701' WHERE appinfo_name='db_version';


INSERT INTO settings VALUES (25, 'site_center', 'false', 'Center site in browser: true/false.');

