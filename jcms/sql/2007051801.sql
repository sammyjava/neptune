--
-- users_extensions for controlling admin access to extensions
--

UPDATE appinfo SET appinfo_value='2007051801' WHERE appinfo_name='db_version';

\connect - jcms

CREATE TABLE users_extensions (
	uid	int 	NOT NULL REFERENCES users,
	extid	int	NOT NULL REFERENCES extensions
);

GRANT ALL ON users_extensions TO jcmsadmin;


