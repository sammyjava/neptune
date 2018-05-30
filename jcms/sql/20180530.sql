--
-- update reCaptcha settings to match Google doc
--

UPDATE settings SET setting_name='recaptcha_secret_key' WHERE setting_id=110;
UPDATE settings SET setting_name='recaptcha_site_key' WHERE setting_id=111;

UPDATE settings SET description='google recaptcha Secret key' WHERE setting_id=110;
UPDATE settings SET description='google recaptcha Site key' WHERE setting_id=111;
