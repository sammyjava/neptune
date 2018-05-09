--
-- Extras tables to separate extras from extensions
--

\connect - jcms

-- INSERT INTO updatelog (name,value) VALUES ('db_version','20081101');

DROP TABLE users_extras;
DROP TABLE extras;

CREATE TABLE extras (
	extra_id	serial	PRIMARY KEY,
	parent_extra_id	int	REFERENCES extras,
	name		varchar	UNIQUE NOT NULL,
	cpurl		varchar	NOT NULL,
	docurl		varchar
);

GRANT SELECT ON extras TO jcmsadmin;


CREATE TABLE users_extras (
	uid		int	NOT NULL REFERENCES users,
	extra_id	int	NOT NULL REFERENCES extras
);

GRANT ALL ON users_extras TO jcmsadmin;


INSERT INTO extras VALUES (DEFAULT, NULL, 'Comments', 'comments.jsp', 'doc-comments.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'Contact Forms', 'forms.jsp', 'doc-forms.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'Image Rotator', 'imagerotator.jsp', 'doc-imagerotator.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'Photo Sets', 'photosets.jsp', 'doc-photosets.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'SearchBlox', 'searchblox.jsp', 'doc-searchblox.jsp');
INSERT INTO extras VALUES (DEFAULT, 5, 'CSS Editor', 'searchblox-css.jsp', NULL);
INSERT INTO extras VALUES (DEFAULT, 5, 'XSL Editor', 'searchblox-xsl.jsp', NULL);

DELETE FROM users_extensions WHERE extid IN (SELECT extid FROM extensions WHERE cpurl IN (SELECT cpurl FROM extras));
DELETE FROM extensions WHERE cpurl IN (SELECT cpurl FROM extras);


	
	
