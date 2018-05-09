--
-- add thumbnail index option to photosets
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100729');

ALTER TABLE photosets ADD COLUMN thumbnailindex boolean NOT NULL DEFAULT false;
ALTER TABLE photosets ADD COLUMN thumbnailcolumns int NOT NULL DEFAULT 4;

INSERT INTO stylesheet VALUES (362, 'table.thumbnails', '', 7, true, 0, 0, 20);
INSERT INTO stylesheet VALUES (363, 'div.photoset-indexlink', '', 13, true, 0, 0, 20);
INSERT INTO stylesheet VALUES (364, 'a.photoset-indexlink:link', '', 14, true, 0, 0, 20);
INSERT INTO stylesheet VALUES (365, 'a.photoset-indexlink:visited', '', 15, true, 0, 0, 20);
INSERT INTO stylesheet VALUES (366, 'a.photoset-indexlink:hover', '', 16, true, 0, 0, 20);
INSERT INTO stylesheet VALUES (367, 'a.photoset-indexlink:active', '', 17, true, 0, 0, 20);

INSERT INTO settings VALUES (558, 'photos_index_label', 'back to index', 'Label shown on link to photo index (thumbnails) on a given photo page, if photoset thumbnail index is toggled on.', false, false);


