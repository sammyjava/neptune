--
-- Sidebar and comments updates.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090216');

--
-- add location to put sidebar extensions above/below secondary navigation
--

ALTER TABLE sidebarextensions ADD COLUMN location char NOT NULL DEFAULT 'S';


--
-- add a setting for email notification of comment postings
--

INSERT INTO settings (setting_id,setting_name,setting_value,description) VALUES (545, 'comments_notify', '', 'Email address of person notified of every comment post.  Optional.');
