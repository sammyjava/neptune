--
-- Update of access tables to handle arbitrary authentication methods.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090212');

ALTER TABLE accessroles_media ADD COLUMN rolename varchar;
ALTER TABLE accessroles_nodes ADD COLUMN rolename varchar;

UPDATE accessroles_media SET rolename=(SELECT accessrole FROM accessroles WHERE accessrole_id=accessroles_media.accessrole_id);
UPDATE accessroles_nodes SET rolename=(SELECT accessrole FROM accessroles WHERE accessrole_id=accessroles_nodes.accessrole_id);

ALTER TABLE accessroles_media DROP COLUMN accessrole_id;
ALTER TABLE accessroles_nodes DROP COLUMN accessrole_id;

ALTER TABLE accessroles_media ALTER COLUMN rolename SET NOT NULL;
ALTER TABLE accessroles_nodes ALTER COLUMN rolename SET NOT NULL;

CREATE INDEX accessroles_media_idx ON accessroles_media(rolename);
CREATE INDEX accessroles_nodes_idx ON accessroles_nodes(rolename);


