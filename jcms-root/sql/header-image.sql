--
-- new feature: optional linked header image that you can float (doesn't have to fit inside the header)
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090429');

--
-- settings
--

INSERT INTO settings VALUES (120, 'header_image_enable', 'false', 'Enable a linked image in the header', false, true);
INSERT INTO settings VALUES (121, 'header_image_file', '', 'Header image file', false, false);
INSERT INTO settings VALUES (122, 'header_image_width', '', 'Width of header image', false, false);
INSERT INTO settings VALUES (123, 'header_image_height', '', 'Height of header image', false, false);
INSERT INTO settings VALUES (124, 'header_image_url', '', 'URL which header image links', false, false);
INSERT INTO settings VALUES (125, 'header_image_homeonly', 'false', 'Show linked header image only on home page', false, true);
INSERT INTO settings VALUES (126, 'header_image_alt', '', 'Alt text for header image', false, false);

--
-- stylesheet
--

INSERT INTO stylesheet VALUES (47,'div#header-image','',3,true,0,0,2);


