--
-- Section header addition
--

-- fix
UPDATE stylesheet SET class_name='a.subheader:active' WHERE class_name='a.subheader.active';

UPDATE appinfo SET appinfo_value='2007112001' WHERE appinfo_name='db_version';

INSERT INTO settings VALUES (321, 'sectionheader_disable', 'true', 'Disable section header: true/false.');

UPDATE stylesheetcategories SET num=num+1 WHERE num>4;
INSERT INTO stylesheetcategories VALUES (14, 'sectionheader', 5);

INSERT INTO stylesheet VALUES (200, 'table#sectionheader', '', 1, true, 0, 0, 14);
INSERT INTO stylesheet VALUES (201, 'td.sectionheader-left', '', 2, true, 0, 0, 14);
INSERT INTO stylesheet VALUES (202, 'td.sectionheader-middle', '', 3, true, 0, 0, 14);
INSERT INTO stylesheet VALUES (203, 'td.sectionheader-right', '', 4, true, 0, 0, 14);
