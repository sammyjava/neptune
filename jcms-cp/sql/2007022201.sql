--
-- 2007022201
-- Access Control tables
--

\connect - jcms

CREATE TABLE accessroles (
	accessrole_id	serial	PRIMARY KEY,
	accessrole	varchar	UNIQUE NOT NULL,
	created		timestamp(0) with time zone	NOT NULL DEFAULT now(),
	updated		timestamp(0) with time zone
);

GRANT ALL ON accessroles TO jcmsadmin;
GRANT SELECT ON accessroles TO jcmsuser;
GRANT ALL ON accessroles_accessrole_id_seq TO jcmsadmin;

CREATE TABLE accessusers (
	accessuser_id	serial	PRIMARY KEY,
	email		varchar	UNIQUE NOT NULL,
	password	varchar	NOT NULL,
	created		timestamp(0) with time zone	NOT NULL DEFAULT now(),
	updated		timestamp(0) with time zone
);

GRANT ALL ON accessusers TO jcmsadmin;
GRANT SELECT ON accessusers TO jcmsuser;
GRANT ALL ON accessusers_accessuser_id_seq TO jcmsadmin;

CREATE TABLE accessroles_accessusers (
	accessrole_id	int	NOT NULL REFERENCES accessroles,
	accessuser_id	int	NOT NULL REFERENCES accessusers
);

GRANT ALL ON accessroles_accessusers TO jcmsadmin;
GRANT SELECT ON accessroles_accessusers TO jcmsuser;

CREATE TABLE accessroles_nodes (
	accessrole_id	int	NOT NULL REFERENCES accessroles,
	nid		int	NOT NULL REFERENCES nodes
);

GRANT ALL ON accessroles_nodes TO jcmsadmin;
GRANT SELECT ON accessroles_nodes TO jcmsuser;

---
--- insert public user
---

INSERT INTO accessusers VALUES (0, 'public', '', default, null);

--
-- new stylesheet category: access, with form/table classes
--

INSERT INTO stylesheetcategories VALUES (13, 'access');

INSERT INTO stylesheet (stylesheetcategory_id, level, level_num, required, num, class_name, class_value) VALUES (13, 0, 0, true, 1, 'div.access', ''); 
INSERT INTO stylesheet (stylesheetcategory_id, level, level_num, required, num, class_name, class_value) VALUES (13, 0, 0, true, 10, 'form.access', ''); 
INSERT INTO stylesheet (stylesheetcategory_id, level, level_num, required, num, class_name, class_value) VALUES (13, 0, 0, true, 11, 'input.access-text', ''); 
INSERT INTO stylesheet (stylesheetcategory_id, level, level_num, required, num, class_name, class_value) VALUES (13, 0, 0, true, 12, 'input.access-submit', ''); 
INSERT INTO stylesheet (stylesheetcategory_id, level, level_num, required, num, class_name, class_value) VALUES (13, 0, 0, true, 20, 'table.access', '');
INSERT INTO stylesheet (stylesheetcategory_id, level, level_num, required, num, class_name, class_value) VALUES (13, 0, 0, true, 21, 'td.access', '');



