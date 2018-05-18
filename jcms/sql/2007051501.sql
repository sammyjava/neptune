--
-- remove timezone and license key from settings, set in web.xml now
--

UPDATE appinfo SET appinfo_value='2007051501' WHERE appinfo_name='db_version';

\connect - jcms

DELETE FROM settings WHERE setting_name='site_timezone';
DELETE FROM settings WHERE setting_name='site_licensekey';

