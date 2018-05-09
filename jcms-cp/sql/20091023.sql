--
-- add header_image_rotator toggle setting
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20091023');

INSERT INTO settings VALUES (102, 'header_image_rotator', 'false', 'Use Image Rotator extra for header background image: true/false.', false, true);

