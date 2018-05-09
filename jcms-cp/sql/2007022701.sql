--
-- 2007022701
--
-- Replace cache table in favor of dhtmlcache table, which is specifically devoted to
-- storing DHTML for each access user.
--

DROP TABLE cache;

CREATE TABLE dhtmlcache (
	accessuser_id	int	PRIMARY KEY REFERENCES accessusers,
	dhtml		varchar	NOT NULL,
	updated		timestamp(0) with time zone	NOT NULL DEFAULT now()
);

GRANT ALL ON dhtmlcache TO jcmsadmin;
GRANT SELECT ON dhtmlcache TO jcmsuser;

INSERT INTO dhtmlcache SELECT accessuser_id, '' FROM accessusers;


	
