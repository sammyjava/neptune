--
-- Add two Lyris settings for RSS feed
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090311');

--
-- LDAP is now an implementation of User and AccessUser with its own parameters in web.xml
--
DELETE FROM settings WHERE setting_name LIKE 'ldap%';

--
-- new Lyris set starts at 60
--
INSERT INTO settings VALUES (60, 'lyris_host', '', 'Host name of Lyris ListManager server.', false, false);
INSERT INTO settings VALUES (61, 'lyris_list', '', 'Lyris ListManager list for RSS feed.', false, false);

