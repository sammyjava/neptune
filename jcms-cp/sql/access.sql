--
-- Modifications for refactored Access system
--

\connect - jcms

-- INSERT INTO updatelog (name,value) VALUES ('db_version','20081201');

--
-- JcmsAccess is now an extra
--
INSERT INTO extras VALUES (8, NULL, 'Access Users', 'access-users.jsp', 'doc-access.jsp');
INSERT INTO extras VALUES (9, 8, 'Access Roles', 'access-roles.jsp', NULL);

--
-- can't have public user in table now since won't generally be in external stores
--
DELETE FROM accessusers WHERE accessuser_id = 0;

--
-- rewrite of dhtmlcache
--
DROP TABLE dhtmlcache;

CREATE TABLE dhtmlcache (
	accessuser	varchar	UNIQUE,
	dhtml		varchar,
	updated		timestamp(0) with time zone NOT NULL DEFAULT now()
);

GRANT DELETE ON dhtmlcache TO jcmsadmin;
GRANT INSERT,SELECT ON dhtmlcache TO jcmsuser;
