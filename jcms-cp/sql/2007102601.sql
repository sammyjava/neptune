--
-- Add LDAP settings, as well as new field in users table to support LDAP uid
--

UPDATE appinfo SET appinfo_value='2007102601' WHERE appinfo_name='db_version';

DELETE FROM settings WHERE setting_id=60;
INSERT INTO settings VALUES (60, 'ldap_authentication', 'false', 'Use LDAP authentication for control panel: true/false. Requires ldap.* parameters in web.xml.');

ALTER TABLE users ADD COLUMN ldapuid varchar UNIQUE;

-- password is null for LDAP authentication
ALTER TABLE users ALTER COLUMN password DROP NOT NULL;



