--
-- add comments.location field
--

UPDATE appinfo SET appinfo_value='20080617' WHERE appinfo_name='db_version';

ALTER TABLE comments ADD COLUMN location varchar;

UPDATE stylesheet SET class_name='div.comment' WHERE class_name='td.comment';
UPDATE stylesheet SET class_name='.commentlocation' WHERE class_name='table.comment';
UPDATE stylesheet SET class_name='.commentname' WHERE class_name='td.commentheading';
UPDATE stylesheet SET class_name='.commenttime' WHERE class_name='td.commenttime';


