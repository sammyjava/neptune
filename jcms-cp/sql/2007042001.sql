--
-- 2007042001
--
-- Add site_licensekey to settings
--

INSERT INTO settings VALUES (2, 'site_licensekey', '');

UPDATE appinfo SET appinfo_value='2007042001' WHERE appinfo_name='db_version';

