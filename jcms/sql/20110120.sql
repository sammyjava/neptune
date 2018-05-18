--
-- Forms - Constant Contact integration; some other items
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110120');


-- set CAPTCHA blurb in Settings (i18n)

INSERT INTO settings VALUES (110, 'forms_captcha_instructions', 'Enter the security code shown below (reduces spam).', 'Instructions shown above CAPTCHA on forms instructing to fill it in.', false, false);
INSERT INTO settings VALUES (111, 'forms_captcha_generate', '(Click the security code to generate a new image.)', 'Instructions shown below CAPTCHA on forms instructing to click it to get a new image.', false, false);


-- Constant Contact lists
DROP TABLE formconstantcontactlists;
CREATE TABLE formconstantcontactlists (
	form_id		int	NOT NULL REFERENCES forms,
	link		varchar	UNIQUE NOT NULL,
	name		varchar	NOT NULL
);

GRANT SELECT ON formconstantcontactlists TO jcmsuser;
GRANT ALL ON formconstantcontactlists TO jcmsadmin;




