--
-- add fields to comments setting to support max limit on comments and "view more" link text
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20101104');

INSERT INTO settings VALUES (546, 'comments_numshown', 0, 'Number of most recent comments to show by default; 0 to show all.', false, false);
INSERT INTO settings VALUES (547, 'comments_viewall', 'View all comments', 'Text for view-all-comments link, shown when there are more than numshown comments.', false, false);

INSERT INTO stylesheet VALUES (257, 'div#comments-viewall', '', 13, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (266, 'a.comments-viewall:link', '', 14, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (267, 'a.comments-viewall:visited', '', 15, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (268, 'a.comments-viewall:hover', '', 16, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (269, 'a.comments-viewall:active', '', 17, true, 0, 0, 16);

