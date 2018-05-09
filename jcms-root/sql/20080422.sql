--
-- reverse negative "disable" logic to positive "enable" logic for settings
--

UPDATE appinfo SET appinfo_value='20080422' WHERE appinfo_name='db_version';

UPDATE settings SET setting_name = 'root_header_enable' WHERE setting_id=                 30;
UPDATE settings SET setting_name = 'root_nav_primary_enable' WHERE setting_id=            31;
UPDATE settings SET setting_name = 'root_sectionheader_enable' WHERE setting_id=          32;
UPDATE settings SET setting_name = 'root_subheader_enable' WHERE setting_id=              33;
UPDATE settings SET setting_name = 'root_footer_enable' WHERE setting_id=                 34;
UPDATE settings SET setting_name = 'header_enable' WHERE setting_id=                     100;
UPDATE settings SET setting_name = 'subheader_enable' WHERE setting_id=                  200;
UPDATE settings SET setting_name = 'navpri_dhtml_enable' WHERE setting_id=               301;
UPDATE settings SET setting_name = 'navpri_level1_enable' WHERE setting_id=              303;
UPDATE settings SET setting_name = 'sectionheader_enable' WHERE setting_id=              321;
UPDATE settings SET setting_name = 'navquat_enable' WHERE setting_id=                    330;
UPDATE settings SET setting_name = 'breadcrumbs_enable' WHERE setting_id=                340;
UPDATE settings SET setting_name = 'pagetitle_enable' WHERE setting_id=                  350;
UPDATE settings SET setting_name = 'sidebar_enable' WHERE setting_id=                    360;
UPDATE settings SET setting_name = 'footer_enable' WHERE setting_id=                     400;

--
-- toggle false values to temp TRUE value
--
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=         30 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=         31 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=         32 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=         33 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=         34 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        100 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        200 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        301 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        303 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        321 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        330 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        340 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        350 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        360 AND setting_value='false';
UPDATE settings SET setting_value = 'TRUE' WHERE setting_id=        400 AND setting_value='false';

--
-- toggle true values to false
--
UPDATE settings SET setting_value = 'false' WHERE setting_id=         30 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=         31 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=         32 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=         33 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=         34 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        100 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        200 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        301 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        303 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        321 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        330 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        340 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        350 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        360 AND setting_value='true';
UPDATE settings SET setting_value = 'false' WHERE setting_id=        400 AND setting_value='true';

--
-- reset temp TRUE values to true
--
UPDATE settings SET setting_value = 'true' WHERE setting_id=         30 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=         31 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=         32 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=         33 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=         34 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        100 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        200 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        301 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        303 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        321 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        330 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        340 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        350 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        360 AND setting_value='TRUE';
UPDATE settings SET setting_value = 'true' WHERE setting_id=        400 AND setting_value='TRUE';
