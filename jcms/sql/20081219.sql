--
-- Add google_tracker_id for folks that want Google Analytics
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20081219');

INSERT INTO settings (setting_id,setting_name,setting_value,description) VALUES (90, 'google_tracker_id', '', 'Google Tracker ID, e.g. UA-6716421-1');

