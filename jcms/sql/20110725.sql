--
-- Add settings for 404 head title, page title and content
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110725');

INSERT INTO settings VALUES (12, 'site_404_headtitle', 'Page Not Found', 'The HEAD title shown on a 404 response.', false, false);
INSERT INTO settings VALUES (13, 'site_404_pagetitle', 'Page Not Found', 'The page title shown on a 404 response.', false, false);
INSERT INTO settings VALUES (14, 'site_404_content', 'The page you have requested does not exist on this site. Please select a page from the navigation.', 'The content shown on a 404 response.', false, false);

