--
-- "Related" extra, adds tags to pages
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20111116');

CREATE TABLE pagetags (
	pid	int	REFERENCES pages,
	tag	varchar	NOT NULL
);

CREATE UNIQUE INDEX pagetags_unique ON pagetags(pid,tag);

GRANT ALL ON pagetags TO jcmsadmin;
GRANT SELECT ON pagetags TO jcmsuser;



INSERT INTO stylesheetcategories VALUES (24, 'related', 24);

INSERT INTO stylesheet VALUES (240, 'div.related', '', 1, true, 0, 0, 24);
INSERT INTO stylesheet VALUES (241, 'div.related-link', '', 2, true, 0, 0, 24);
INSERT INTO stylesheet VALUES (243, 'a.related-link:link', '', 3, true, 0, 0, 24);
INSERT INTO stylesheet VALUES (244, 'a.related-link:visited', '', 4, true, 0, 0, 24);
INSERT INTO stylesheet VALUES (245, 'a.related-link:hover', '', 5, true, 0, 0, 24);
INSERT INTO stylesheet VALUES (246, 'a.related-link:active', '', 6, true, 0, 0, 24);





