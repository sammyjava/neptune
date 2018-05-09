--
-- 2007011701 - add appinfo table containing app-wide info
--

CREATE TABLE appinfo (
	appinfo_id	int	PRIMARY KEY,
	appinfo_name	varchar	NOT NULL,
	appinfo_value	varchar	NOT NULL
);

GRANT SELECT ON appinfo TO jcmsadmin;

INSERT INTO appinfo VALUES (1, 'db_version', '2007011701');



