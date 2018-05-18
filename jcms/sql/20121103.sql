--
-- Revert to SimpleCaptcha, ReCaptcha is totally broken by spammers! Keep ReCaptcha available, though.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20121103');

INSERT INTO settings VALUES (112, 'simplecaptcha_instructions', 'Please enter the word shown below (reduces spam).', 'Instructions shown above SimpleCaptcha.', false, false);
INSERT INTO settings VALUES (113, 'simplecaptcha_regenerate', 'Click the image to generate a new one.', 'Instructions to regenerate SimpleCaptcha.', false, false);
INSERT INTO settings VALUES (114, 'simplecaptcha_inputsize', '5', 'Size of text input for SimpleCaptcha.', false, false);

