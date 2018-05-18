--
-- Remove site_center from settings; no need for DB version update, it's harmless.
--

\connect - jcms

DELETE FROM settings WHERE setting_id=25;


