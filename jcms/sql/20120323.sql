--
-- Remove WYSIWG toggle from settings
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120323');

DELETE FROM settings WHERE setting_name='cp_defaulteditmode';


