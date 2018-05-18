--
-- Change AddThis settings for new AddThis code
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100301');


UPDATE settings SET setting_name='addthis_services', description='Comma-separated list of services to show on AddThis menu' WHERE setting_id=91;

UPDATE settings SET setting_name='addthis_username', description='AddThis account username' WHERE setting_id=92;
