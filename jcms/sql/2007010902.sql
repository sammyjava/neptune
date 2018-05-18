--
-- 2007010902
-- Remove site_rootpage, site_level1pages from settings; deprecated by new redirect functionality
--

DELETE FROM settings WHERE setting_name='site_rootpage';
DELETE FROM settings WHERE setting_name='site_level1pages';


