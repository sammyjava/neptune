--
-- Rename photos.imagealt to photos.title.  Title is more important!
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090924');

ALTER TABLE photos RENAME COLUMN imagealt TO title;

UPDATE stylesheet SET num=11 WHERE class_id=359;
UPDATE stylesheet SET num=12 WHERE class_id=360;

INSERT INTO stylesheet VALUES (361, 'div.photo-title', 'font-weight: bold;', 10, true, 0, 0, 20);

