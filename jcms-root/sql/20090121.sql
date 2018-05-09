--
-- Add footer_imslogo for logo instead of text
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090121');

INSERT INTO settings (setting_id,setting_name,setting_value,description) VALUES (421, 'footer_imslogo', '', 'Location of IMS footer logo, blank if none');
INSERT INTO settings (setting_id,setting_name,setting_value,description) VALUES (422, 'footer_imslogo_width', '0', 'Width of IMS footer logo');
INSERT INTO settings (setting_id,setting_name,setting_value,description) VALUES (423, 'footer_imslogo_height', '0', 'Height of IMS footer logo');


