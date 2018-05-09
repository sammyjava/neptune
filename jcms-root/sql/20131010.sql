--
-- create table to relate forms to mailchimp lists
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20131010');


DROP TABLE formmailchimplists;

CREATE TABLE formmailchimplists (
	form_id	int		NOT NULL REFERENCES forms,
	listid	varchar		NOT NULL,
	listname varchar	NOT NULL
);

GRANT ALL ON formmailchimplists TO jcmsadmin;
GRANT SELECT ON formmailchimplists TO jcmsuser;




