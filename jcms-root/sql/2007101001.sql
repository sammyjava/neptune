--
-- more settings fuckery
--

UPDATE appinfo SET appinfo_value='2007101001' WHERE appinfo_name='db_version';

UPDATE settings SET setting_name='cp_defaulteditmode' WHERE setting_name='content_defaultmode';

--
-- renumber settings to make them better organized; add settings to disable regions
--

UPDATE settings SET setting_id=         71 WHERE setting_name='cp_defaulteditmode';

UPDATE settings SET setting_id=          1 WHERE setting_name='site_name';
UPDATE settings SET setting_id=          3 WHERE setting_name='site_centered';
UPDATE settings SET setting_id=          4 WHERE setting_name='site_maxuploadsize';
UPDATE settings SET setting_id=          5 WHERE setting_name='site_imagefolder';
UPDATE settings SET setting_id=          6 WHERE setting_name='site_imagedir';
UPDATE settings SET setting_id=          7 WHERE setting_name='site_mediafolder';
UPDATE settings SET setting_id=          8 WHERE setting_name='site_mediadir';
UPDATE settings SET setting_id=          9 WHERE setting_name='site_designfolder';
UPDATE settings SET setting_id=         10 WHERE setting_name='site_designdir';
UPDATE settings SET setting_id=         19 WHERE setting_name='site_rootfolder';
UPDATE settings SET setting_id=         20 WHERE setting_name='site_cssdir';
UPDATE settings SET setting_id=         21 WHERE setting_name='site_cssfolder';
UPDATE settings SET setting_id=         22 WHERE setting_name='site_debug';

INSERT INTO settings VALUES (100,'header_disable','false','Disable header: true/false.');
UPDATE settings SET setting_id=        101 WHERE setting_name='header_search';
UPDATE settings SET setting_id=        110 WHERE setting_name='header_flash';
UPDATE settings SET setting_id=        111 WHERE setting_name='header_flash_url';
UPDATE settings SET setting_id=        112 WHERE setting_name='header_flash_homeonly';
UPDATE settings SET setting_id=        113 WHERE setting_name='header_flash_width';
UPDATE settings SET setting_id=        114 WHERE setting_name='header_flash_height';
UPDATE settings SET setting_id=        115 WHERE setting_name='header_flash_bgcolor';

UPDATE settings SET setting_id=        200 WHERE setting_name='subheader_disable';
UPDATE settings SET setting_id=        201 WHERE setting_name='subheader_dateshown';
UPDATE settings SET setting_id=        202 WHERE setting_name='subheader_dateformat';
UPDATE settings SET setting_id=        210 WHERE setting_name='subheader_flash';
UPDATE settings SET setting_id=        211 WHERE setting_name='subheader_flash_url';
UPDATE settings SET setting_id=        212 WHERE setting_name='subheader_flash_homeonly';
UPDATE settings SET setting_id=        213 WHERE setting_name='subheader_flash_width';
UPDATE settings SET setting_id=        214 WHERE setting_name='subheader_flash_height';
UPDATE settings SET setting_id=        215 WHERE setting_name='subheader_flash_bgcolor';

UPDATE settings SET setting_id=        301 WHERE setting_name='navpri_dhtml';
UPDATE settings SET setting_id=        302 WHERE setting_name='navpri_images';

INSERT INTO settings VALUES (350,'pagetitle_disable','false','Disable page title: true/false.');
UPDATE settings SET setting_id=        351 WHERE setting_name='pagetitle_level1';

INSERT INTO settings VALUES (360,'sidebar_disable','false','Disable sidebar: true/false.');

INSERT INTO settings VALUES (400,'footer_disable','false','Disable footer: true/false.');
UPDATE settings SET setting_id=        401 WHERE setting_name='footer_copyrightshown';
UPDATE settings SET setting_id=        402 WHERE setting_name='footer_copyrighttext';
UPDATE settings SET setting_id=        410 WHERE setting_name='footer_dateshown';
UPDATE settings SET setting_id=        411 WHERE setting_name='footer_dateformat';
UPDATE settings SET setting_id=        420 WHERE setting_name='footer_imscredit';
UPDATE settings SET setting_id=        430 WHERE setting_name='footer_lastupdate';

UPDATE settings SET setting_id=        501 WHERE setting_name='printable_logo';
UPDATE settings SET setting_id=        502 WHERE setting_name='printable_logo_width';
UPDATE settings SET setting_id=        503 WHERE setting_name='printable_logo_height';

UPDATE settings SET setting_id=        520 WHERE setting_name='sitemap_pagetitle';
UPDATE settings SET setting_id=        521 WHERE setting_name='sitemap_headtitle';

UPDATE settings SET setting_id=        530 WHERE setting_name='search_size';
UPDATE settings SET setting_id=        531 WHERE setting_name='search_image';
UPDATE settings SET setting_id=        532 WHERE setting_name='search_imagewidth';
UPDATE settings SET setting_id=        533 WHERE setting_name='search_imageheight';
UPDATE settings SET setting_id=        534 WHERE setting_name='searchblox_cssdir';
UPDATE settings SET setting_id=        535 WHERE setting_name='searchblox_xsldir';
