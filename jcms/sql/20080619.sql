--
-- add stylesheet classes for email extra
-- also: create updatelog table for keeping track of db and other updates, replaces appinfo table
--

DROP TABLE appinfo;

CREATE TABLE updatelog (
	updated	timestamp(0)	NOT NULL DEFAULT now(),
	name varchar		NOT NULL,
	value varchar		NOT NULL
);

GRANT SELECT ON updatelog TO jcmsadmin;

INSERT INTO updatelog (name,value) VALUES ('db_version','20080619');



INSERT INTO stylesheetcategories VALUES (18, 'email', 18);

INSERT INTO stylesheet VALUES (300, 'body#emailform', '', 1, true, 0, 0, 18);
INSERT INTO stylesheet VALUES (301, 'form#emailform', '', 2, true, 0, 0, 18);
INSERT INTO stylesheet VALUES (302, 'table#emailform', '', 3, true, 0, 0, 18);
INSERT INTO stylesheet VALUES (303, 'td.emailform', '', 4, true, 0, 0, 18);
INSERT INTO stylesheet VALUES (304, 'input.emailfield', '', 5, true, 0, 0, 18);
INSERT INTO stylesheet VALUES (305, 'textarea.emailfield', '', 6, true, 0, 0, 18);
INSERT INTO stylesheet VALUES (306, 'input.emailbutton', '', 7, true, 0, 0, 18);
