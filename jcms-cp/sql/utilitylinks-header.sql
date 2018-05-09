--
-- add utility links to header, and associated stylesheet classes
--

-- deprecate header_image settings
DELETE FROM settings WHERE setting_id>120 AND setting_id<=126;

-- add home-only toggle for header links
INSERT INTO settings VALUES (120, 'header_links_homeonly', 'false', 'Show header utility links only on home page', false, true);

-- remove div#header-image from stylesheet
DELETE FROM stylesheet WHERE class_id=47;

-- add header-links classes
INSERT INTO stylesheet VALUES (80, 'div#header-links', '', 3, true, 0, 0 2);
INSERT INTO stylesheet VALUES (81, 'table#header-links', '', 4, true, 0, 0 2);
INSERT INTO stylesheet VALUES (82, 'td.header-link', '', 5, true, 0, 0 2);
INSERT INTO stylesheet VALUES (83, 'a.header-link:link', '', 6, true, 0, 0 2);
INSERT INTO stylesheet VALUES (84, 'a.header-link:visited', '', 7, true, 0, 0 2);
INSERT INTO stylesheet VALUES (85, 'a.header-link:hover', '', 8, true, 0, 0 2);
INSERT INTO stylesheet VALUES (86, 'a.header-link:active', '', 9, true, 0, 0 2);
