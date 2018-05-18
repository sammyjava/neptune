--
-- image rotator extra
--

UPDATE appinfo SET appinfo_value='2007100301' WHERE appinfo_name='db_version';

CREATE TABLE imagerotator (
	id		serial	PRIMARY KEY,
	filename	varchar	UNIQUE NOT NULL,
	num		int	NOT NULL,
	width		int	NOT NULL,
	height		int	NOT NULL,
	caption		varchar,
	alt		varchar
);

ALTER TABLE imagerotator OWNER TO jcms;

GRANT ALL ON imagerotator TO jcmsadmin;
GRANT SELECT ON imagerotator TO jcmsuser;

GRANT ALL ON imagerotator_id_seq TO public;


