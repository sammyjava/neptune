--
-- 2007051101 - add extensions table
--

UPDATE appinfo SET appinfo_value='2007051101' WHERE appinfo_name='db_version';

\connect - jcms

CREATE TABLE extensions (
	extid		serial	PRIMARY KEY,
	num		int	NOT NULL,
	name		varchar	NOT NULL,
	cpcontext	varchar NOT NULL,
	cpurl		varchar	NOT NULL,
	parent_extid	int
);

GRANT ALL ON extensions TO jcmsadmin;
GRANT ALL ON extensions_extid_seq TO jcmsadmin;
