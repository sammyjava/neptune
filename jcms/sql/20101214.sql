--
-- Insert some stylesheet classes for the new Fetch extra, etc.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20101214');


-- shift some classes around

UPDATE stylesheet SET class_id=2020 where class_id=17 AND class_name='table#footer';
UPDATE stylesheet SET class_id=2025 where class_id=18 AND class_name='td.footer';

UPDATE stylesheet SET class_id=17 WHERE class_id=19 AND class_name='table';
UPDATE stylesheet SET class_id=18 WHERE class_id=20 AND class_name = 'td';

UPDATE stylesheet SET class_id=20 WHERE class_id=2020;
UPDATE stylesheet SET class_id=25 WHERE class_id=2025;

-- some new required classes

INSERT INTO stylesheet VALUES (19, 'img', '', 20, true, 0, 0, 0);

INSERT INTO stylesheet VALUES (534, 'div.imagerotator', '', 1, true, 0, 0, 1);
INSERT INTO stylesheet VALUES (535, 'div.fetch', '', 1, true, 0, 0, 1);

-- this isn't a required element in the "other" stylesheet any more, but may be in use

UPDATE stylesheet SET required=false WHERE class_name='table.form';

