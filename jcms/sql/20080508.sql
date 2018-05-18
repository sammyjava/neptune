--
-- add blogger_enable setting and change stylesheet category to "blogger" to be clearer
--

UPDATE appinfo SET appinfo_value='20080508' WHERE appinfo_name='db_version';

INSERT INTO settings VALUES (80, 'blogger_enable', 'false', 'Enable blogger extra: true/false.');

UPDATE stylesheetcategories SET stylesheetcategory='blogger' WHERE stylesheetcategory_id=17;


