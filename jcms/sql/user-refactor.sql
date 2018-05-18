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


INSERT INTO extras VALUES (11, NULL, 'CP Users', 'jcmsusers.jsp', 'doc-jcmsusers.jsp');

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
