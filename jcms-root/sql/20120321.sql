--
-- Replace site_rootfolder with '' for slash consistency
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120321');

UPDATE settings SET setting_value='' WHERE setting_name='site_rootfolder' AND setting_value='/';
