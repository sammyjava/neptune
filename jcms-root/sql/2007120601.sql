--
-- Custom root page option
--

UPDATE appinfo SET appinfo_value='2007120601' WHERE appinfo_name='db_version';

DELETE FROM settings WHERE setting_id=31;
DELETE FROM settings WHERE setting_id=32;
DELETE FROM settings WHERE setting_id=33;

INSERT INTO settings VALUES (30, 'root_header_disable', 'false', 'Disable header on root node: true/false.');
INSERT INTO settings VALUES (31, 'root_nav_primary_disable', 'false', 'Disable primary nav on root node: true/false.');
INSERT INTO settings VALUES (32, 'root_sectionheader_disable', 'false', 'Disable section header on root node: true/false.');
INSERT INTO settings VALUES (33, 'root_subheader_disable', 'false', 'Disable subheader on root node: true/false.');
INSERT INTO settings VALUES (34, 'root_footer_disable', 'false', 'Disable footer on root node: true/false.');



