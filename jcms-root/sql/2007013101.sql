--
-- 2007013101
--
-- Create audit table
--

\connect - jcms

CREATE TABLE audit (
	audit_id	serial		PRIMARY KEY,
	timestamp	timestamp(0) with time zone	NOT NULL DEFAULT now(),
	tablename	varchar		NOT NULL,
	key		int		NOT NULL,
	action		char(1)		NOT NULL,
	email		varchar		NOT NULL,
	description	varchar
);

GRANT SELECT,INSERT ON audit TO jcmsadmin;
GRANT ALL ON audit_audit_id_seq TO jcmsadmin;

CREATE INDEX audit_tablename_idx ON audit(tablename);
CREATE INDEX audit_email_idx ON audit(email);

UPDATE appinfo SET appinfo_value='2007013101' WHERE appinfo_name='db_version';
