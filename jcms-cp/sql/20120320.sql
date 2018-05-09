--
-- Change UNIQUE constraints on photos so we can have same name in different sets
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120320');

ALTER TABLE photos DROP CONSTRAINT photos_imagefile_key;

ALTER TABLE photos ADD CONSTRAINT photos_imagefile_key UNIQUE (photoset_id,imagefile);

