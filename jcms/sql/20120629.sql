--
-- Update to Comments (show incrementally more comments)
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120629');

UPDATE settings SET setting_name='comments_viewmore', description='Text for view-more-comments link, shown when there are more comments than shown.' WHERE setting_name='comments_viewall';
UPDATE settings SET setting_value='View earlier comments' WHERE setting_value='View all comments';

UPDATE stylesheet SET class_name='div#comments-viewmore' WHERE class_name='div#comments-viewall';



GRANT UPDATE ON users_nodes TO jcmsadmin;
