--
-- Add accessusers.resetkey for new password reset extra
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090123');

ALTER TABLE accessusers ADD COLUMN resetkey varchar;
GRANT UPDATE ON accessusers TO jcmsuser;

INSERT INTO settings VALUES (43, 'access_passwordreset_fromaddress', '', 'From: address on password reset email sent to users.');
INSERT INTO settings VALUES (44, 'access_passwordreset_fromname', '', 'From: name on password reset email sent to users.');

