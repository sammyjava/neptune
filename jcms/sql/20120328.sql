--
-- New setting cp_enable_wysiwyg (default true)
--

\connect - jcms

DELETE FROM settings WHERE setting_id=50;
INSERT INTO settings VALUES (50, 'cp_enable_wysiwyg', 'true', 'Enable WYSIWYG content editor (true/false).', false, true);

INSERT INTO updatelog (name,value) VALUES ('db_version','20120328');

