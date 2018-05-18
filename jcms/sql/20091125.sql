--
-- Add a Setting for SoftSlate context; replacing softslate stylesheet path, no longer needed; also remove stylesheet editor.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20091125');

UPDATE settings SET setting_name='softslate_context', setting_value='/softslate', description='SoftSlate web app context', password=false, toggle=false WHERE setting_id=560;
INSERT INTO settings VALUES (562, 'softslate_sitemap', 'false', 'Show SoftSlate categories on site map; true/false.', false, true);

DELETE FROM users_extras WHERE extra_id=13;
DELETE FROM extras WHERE extra_id=13;
UPDATE extras SET cpurl='/administrator' WHERE extra_id=12;


