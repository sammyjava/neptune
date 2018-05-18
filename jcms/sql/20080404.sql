--
-- add BloggerClient settings, stylesheet classes, and semi-related tweak to settings table
--
-- NOTE: switching to yyyymmdd format for db_version.
--

UPDATE appinfo SET appinfo_value='20080404' WHERE appinfo_name='db_version';

--
-- also add privacy toggle for settings
--

ALTER TABLE settings ADD COLUMN password boolean NOT NULL DEFAULT false;


INSERT INTO settings VALUES (70, 'blogger_metafeed_url', 'http://www.blogger.com/feeds/default/blogs', 'Blogger metafeed URL', false);
INSERT INTO settings VALUES (71, 'blogger_feed_uri_base', 'http://www.blogger.com/feeds', 'base portion of Blogger feed URI', false);
INSERT INTO settings VALUES (72, 'blogger_posts_feed_uri_suffix', '/posts/default', 'URI suffix for Blogger posts', false);
INSERT INTO settings VALUES (73, 'blogger_comments_feed_uri_suffix', '/comments/default', 'URI suffix for Blogger comments', false);
INSERT INTO settings VALUES (74, 'blogger_username', '', 'Blogger username', false);
INSERT INTO settings VALUES (75, 'blogger_password', '', 'Blogger password', true);
INSERT INTO settings VALUES (76, 'blogger_service_name', 'blogger', 'Google Service name', false);
INSERT INTO settings VALUES (77, 'blogger_application_name', 'exampleCo-exampleApp-1', 'Google Service application name', false);
INSERT INTO settings VALUES (78, 'blogger_dateformat', 'yyyy-MM-dd HH:mm', 'java.text.SimpleDateFormat for the blog dates', false);
INSERT INTO settings VALUES (79, 'blogger_comment_post_uri', 'https://www.blogger.com/comment.g', 'The URI used for posting comments', false);

--
-- stylesheet classes
--

INSERT INTO stylesheetcategories VALUES (17, 'blog', 17);

INSERT INTO stylesheet VALUES (270, 'div.blogpost', '', 1, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (271, 'div.blogposttitle', '', 2, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (272, 'div.blogpostauthor', '', 3, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (273, 'div.blogpostdate', '', 4, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (274, 'div.blogpostcontent', '', 5, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (275, 'div.blogcomment', '', 6, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (277, 'div.blogcommentauthor', '', 7, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (278, 'div.blogcommentdate', '', 8, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (279, 'div.blogcommentcontent', '', 9, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (280, 'a.blogcommentpost:link', '', 10, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (281, 'a.blogcommentpost:visited', '', 10, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (282, 'a.blogcommentpost:hover', '', 10, true, 0, 0, 17);
INSERT INTO stylesheet VALUES (283, 'a.blogcommentpost:active', '', 10, true, 0, 0, 17);

