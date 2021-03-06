--
-- create table to relate forms to mailchimp lists
--

\connect - jcms

DROP TABLE formmailchimplists;

CREATE TABLE formmailchimplists (
	form_id	int		NOT NULL REFERENCES forms,
	listid	varchar		NOT NULL,
	listname varchar	NOT NULL
);

GRANT ALL ON formmailchimplists TO jcmsadmin;
GRANT SELECT ON formmailchimplists TO jcmsuser;


