--
-- add site_host and site_sslhost for front-end redirects
--

UPDATE appinfo SET appinfo_value='2008030501' WHERE appinfo_name='db_version';


INSERT INTO settings VALUES (23, 'site_host', '', 'Non-SSL host for non-SSL pages on sites with SSL host set');
INSERT INTO settings VALUES (24, 'site_sslhost', '', 'SSL host for pages to be served via SSL');

ALTER TABLE nodes ADD COLUMN ssl boolean NOT NULL DEFAULT false;

-- bug fix

UPDATE settings SET setting_name ='printable_logo_height' WHERE setting_id=503; 

-- and this would have prevented it

CREATE UNIQUE INDEX settings_unique ON settings(setting_name);
