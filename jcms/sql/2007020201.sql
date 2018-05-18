--
-- 2007020201
--
-- Add site search items
--

INSERT INTO settings VALUES (38, 'header_search', 'false');
INSERT INTO settings VALUES (50, 'search_size', '20');
INSERT INTO settings VALUES (51, 'search_image', 'spacer.gif');
INSERT INTO settings VALUES (52, 'search_imagewidth', '20');
INSERT INTO settings VALUES (53, 'search_imageheight', '20');

INSERT INTO stylesheetcategories VALUES (12, 'search');

INSERT INTO stylesheet VALUES (DEFAULT, 'form.search', '', 1, true, 0, 0, 12);
INSERT INTO stylesheet VALUES (DEFAULT, 'table.search', '', 2, true, 0, 0, 12);
INSERT INTO stylesheet VALUES (DEFAULT, 'td.search', '', 3, true, 0, 0, 12);
INSERT INTO stylesheet VALUES (DEFAULT, 'input.search', '', 4, true, 0, 0, 12);
INSERT INTO stylesheet VALUES (DEFAULT, 'td.search-button', '', 5, true, 0, 0, 12);

UPDATE appinfo SET appinfo_value='2007020201' WHERE appinfo_name='db_version=';


