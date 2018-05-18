--
-- reordering of stylesheet categories
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100809');


UPDATE stylesheetcategories SET num=4 WHERE stylesheetcategory_id=14;
UPDATE stylesheetcategories SET num=5 WHERE stylesheetcategory_id=5;

UPDATE stylesheetcategories SET num=7 WHERE stylesheetcategory_id=11;
UPDATE stylesheetcategories SET num=8 WHERE stylesheetcategory_id=4;
