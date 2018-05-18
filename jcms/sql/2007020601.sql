--
-- 2007020601
-- add SearchBlox xsl file locations and stuff
--

INSERT INTO settings VALUES (58, 'searchblox_cssdir', '/home/java/jcms/searchblox');
INSERT INTO settings VALUES (59, 'searchblox_xsldir', '/home/java/jcms/searchblox/stylesheets');

UPDATE appinfo SET appinfo_value='2007020601' WHERE appinfo_name='db_version';
