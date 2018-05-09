--
-- Add sidebar extensions capability
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20081208');

CREATE TABLE sidebarextensions (
	sidebarextension_id	serial	PRIMARY KEY,
	num			int	NOT NULL DEFAULT 1,
	extensionurl		varchar	NOT NULL,
	extensioncontext	varchar	NOT NULL
);

GRANT ALL ON sidebarextensions TO jcmsadmin;
GRANT SELECT ON sidebarextensions TO jcmsuser;

GRANT ALL ON sidebarextensions_sidebarextension_id_seq TO jcmsadmin;
