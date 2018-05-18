--
-- Add accessusers.resetkey for password reset
--

\connect - jcms

ALTER TABLE accessusers ADD COLUMN resetkey varchar;

INSERT INTO settings VALUES (43, 'access_passwordreset_fromaddress', '', 'From: address on password reset email sent to users.');
INSERT INTO settings VALUES (44, 'access_passwordreset_fromname', '', 'From: name on password reset email sent to users.');

