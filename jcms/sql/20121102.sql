--
-- switch from SimpleCaptcha to ReCaptcha - change settings; also update to divs rather than table for contact form, so stylesheet update
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20121102');

UPDATE settings SET setting_name = 'recaptcha_public_key', setting_value = '6Lfxh9gSAAAAAKwOQQ7sCbwKunW76-djvqOx0iyJ' WHERE setting_name = 'forms_captcha_generate';
UPDATE settings SET setting_name = 'recaptcha_private_key', setting_value = '6Lfxh9gSAAAAAA6ppKFhQ5r8vlYNuZiNiqQJ6fCB' WHERE setting_name = 'forms_captcha_instructions';

UPDATE stylesheet SET class_name = 'div.formfield' WHERE class_name = 'td.formfield';
UPDATE stylesheet SET class_name = 'div.captcha' WHERE class_name = 'td.captcha';
UPDATE stylesheet SET class_name = 'div.submit' WHERE class_name = 'table.submit';


DELETE FROM stylesheet WHERE class_name = 'table#form';
DELETE FROM stylesheet WHERE class_name = 'input.captcha';

