--
-- Settings for access control text
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20081009');

INSERT INTO settings VALUES (40, 'access_denied_title', 'Access Denied', 'Title shown on Access Denied page.', false);
INSERT INTO settings VALUES (41, 'access_denied_instructions', 'If you are a registered site member, log in below to gain access to restricted content.', 'Instructions shown on Access Denied page.', false);
INSERT INTO settings VALUES (42, 'access_login_title', 'Restricted Access Authorization', 'Title shown on Access login page.', false);

