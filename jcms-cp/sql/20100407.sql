--
-- add another setting for headlines, show page title rather than node names
--

\connect - jcms

-- new headline setting to use page titles rather than node name
INSERT INTO settings VALUES (142, 'headlines_showpagetitle', 'false', 'Show page title rather than node names as headlines (true/false).', false, true);


