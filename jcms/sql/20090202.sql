--
-- User refactor into abstract User class and JcmsUser (default, extra) and LdapUser (no cp tool) instances
-- New "toggle" boolean for settings, goes with UI update
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090202');

--
-- Refactor User classes to support arbitrary authentication schemes.
--

DROP INDEX audit_email_idx;
ALTER TABLE audit RENAME COLUMN "key" TO record_id;
ALTER TABLE audit RENAME COLUMN email TO username;
CREATE INDEX audit_username_idx ON audit(username);

ALTER TABLE users DROP COLUMN ldapuid;

ALTER TABLE users_nodes ADD COLUMN username varchar;
ALTER TABLE users_extras ADD COLUMN username varchar;
ALTER TABLE users_extensions ADD COLUMN username varchar;

UPDATE users_nodes SET username=(SELECT email FROM users WHERE users.uid=users_nodes.uid);
UPDATE users_extras SET username=(SELECT email FROM users WHERE users.uid=users_extras.uid);
UPDATE users_extensions SET username=(SELECT email FROM users WHERE users.uid=users_extensions.uid);

ALTER TABLE users_nodes DROP COLUMN uid;
ALTER TABLE users_extras DROP COLUMN uid;
ALTER TABLE users_extensions DROP COLUMN uid;

ALTER TABLE users_nodes ALTER COLUMN username SET NOT NULL;
ALTER TABLE users_extras ALTER COLUMN username SET NOT NULL;
ALTER TABLE users_extensions ALTER COLUMN username SET NOT NULL;

CREATE INDEX users_nodes_idx ON users_nodes(username);
CREATE INDEX users_extras_idx ON users_extras(username);
CREATE INDEX users_extensions_idx ON users_extensions(username);

CREATE UNIQUE INDEX users_nodes_unique ON users_nodes(username,nid);
CREATE UNIQUE INDEX users_extras_unique ON users_extras(username,extra_id);
CREATE UNIQUE INDEX users_extensions_unique ON users_extensions(username,extid);

GRANT DELETE ON users TO jcmsadmin;

CREATE TABLE cproles (
	username	varchar	UNIQUE NOT NULL,
	editor		boolean	NOT NULL DEFAULT false,
	designer	boolean NOT NULL DEFAULT false,
	admin		boolean NOT NULL DEFAULT false
);
GRANT ALL ON cproles TO jcmsadmin;

--
-- initialize cproles with data from users, then drop fields from users
--
INSERT INTO cproles SELECT email,editor,designer,admin FROM users;

ALTER TABLE users DROP COLUMN editor;
ALTER TABLE users DROP COLUMN designer;
ALTER TABLE users DROP COLUMN admin;


--
-- JcmsUsers control panel extra, add for all admins
--
INSERT INTO extras VALUES (11, NULL, 'CP Users', 'jcmsusers.jsp', 'doc-jcmsusers.jsp');
INSERT INTO users_extras (extra_id,username) SELECT 11,username FROM cproles WHERE admin=true;


--
-- Update Settings to handle toggles (booleans) and display checkboxes rather than typing in true/false, with associated methods.
--

ALTER TABLE settings ADD COLUMN toggle boolean NOT NULL DEFAULT false;

UPDATE settings SET toggle=true WHERE setting_value='true' OR setting_value='false';

--
-- fix bad descriptions from switch to disable to enable logic way back
--

UPDATE settings SET description='Enable DHTML primary nav dropdowns.'                            WHERE setting_id=        301;
UPDATE settings SET description='Enable primary nav level 1 links (requires navpri_dhtml=true).' WHERE setting_id=        303;
UPDATE settings SET description='Enable quaternary navigation.'                                  WHERE setting_id=        330;
UPDATE settings SET description='Enable page title.'                                             WHERE setting_id=        350;
UPDATE settings SET description='Enable footer on root node.'                                    WHERE setting_id=         34;
UPDATE settings SET description='Enable header on root node.'                                    WHERE setting_id=         30;
UPDATE settings SET description='Enable primary nav on root node.'                               WHERE setting_id=         31;
UPDATE settings SET description='Enable section header on root node.'                            WHERE setting_id=         32;
UPDATE settings SET description='Enable subheader on root node.'                                 WHERE setting_id=         33;
UPDATE settings SET description='Enable section header.'                                         WHERE setting_id=        321;
UPDATE settings SET description='Enable sidebar.'                                                WHERE setting_id=        360;
UPDATE settings SET description='Enable header.'                                                 WHERE setting_id=        100;
UPDATE settings SET description='Enable subheader.'                                              WHERE setting_id=        200;
UPDATE settings SET description='Enable footer.'                                                 WHERE setting_id=        400;


