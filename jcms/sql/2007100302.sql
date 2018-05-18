--
-- more settings
--

UPDATE appinfo SET appinfo_value='2007100302' WHERE appinfo_name='db_version';

INSERT INTO settings VALUES (62, 'footer_imscredit', 'true', 'Show IMS credit and link in footer.');
INSERT INTO settings VALUES (63, 'footer_lastupdate', 'false', 'Show page last update in footer.');


