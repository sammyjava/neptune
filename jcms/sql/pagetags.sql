CREATE TABLE pagetags (
	pid	int	REFERENCES pages,
	tag	varchar	NOT NULL
);

CREATE UNIQUE INDEX pagetags_unique ON pagetags(pid,tag);

GRANT ALL ON pagetags TO jcmsadmin;
GRANT SELECT ON pagetags TO jcmsuser;
