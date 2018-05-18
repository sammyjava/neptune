--
-- 2007080601 accessroles_media
--

\connect - jcms

UPDATE appinfo SET appinfo_value='2007080601' WHERE appinfo_name='db_version';


CREATE TABLE accessroles_media (
	accessrole_id	int	NOT NULL REFERENCES accessroles,
	mid		int	NOT NULL REFERENCES media
);

GRANT SELECT ON accessroles_media TO jcmsuser;
GRANT ALL ON accessroles_media TO jcmsadmin;

UPDATE settings SET setting_name='site_imagedir' where setting_name='site_uploaddir';
UPDATE settings SET setting_name='site_imagefolder' where setting_name='site_uploadfolder';

UPDATE settings SET setting_id=1 WHERE setting_id=8;
INSERT INTO settings VALUES (7, 'site_mediafolder', '/media/');
INSERT INTO settings VALUES (8, 'site_mediadir', '');


UPDATE nodes SET alias=substring(alias FROM 2) WHERE alias IS NOT NULL;
