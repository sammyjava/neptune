--
-- 2007012201.sql
--
-- Copy stylesheet records for printable stylesheet.  Also, move some "other" classes to core.
--

UPDATE stylesheet SET stylesheetcategory_id=0 WHERE stylesheetcategory_id=1 AND (class_name LIKE 'table.%' OR class_name LIKE 'td.%');

INSERT INTO stylesheet (class_name, class_value, num, required, level, level_num, stylesheetcategory_id)
SELECT class_name, class_value, num, required, 1, -1, stylesheetcategory_id
FROM stylesheet
WHERE level=0 AND level_num=0 AND (
   stylesheetcategory_id=0
OR stylesheetcategory_id=2
OR stylesheetcategory_id=5
OR stylesheetcategory_id=6
OR stylesheetcategory_id=7
OR stylesheetcategory_id=8
OR stylesheetcategory_id=9
)
;


UPDATE appinfo SET appinfo_value='2007012201' WHERE appinfo_name='db_version';
