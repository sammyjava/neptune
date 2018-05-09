--
-- add settings descriptions, used on doc
--

UPDATE appinfo SET appinfo_value='2007100201' WHERE appinfo_name='db_version';

ALTER TABLE settings ADD COLUMN description varchar;

UPDATE settings SET description='Default mode of the content editor: HTML/WYSIWYG' WHERE setting_name='content_defaultmode';
UPDATE settings SET description='Show copyright line in the footer: true/false.' WHERE setting_name='footer_copyrightshown';
UPDATE settings SET description='Text shown after the copyright year.' WHERE setting_name='footer_copyrighttext';
UPDATE settings SET description='Format (java.text.SimpleDateFormat) for the current date in the footer.' WHERE setting_name='footer_dateformat';
UPDATE settings SET description='Show current date in the footer: true/false.' WHERE setting_name='footer_dateshown';
UPDATE settings SET description='Show a Flash movie in the header: true/false.' WHERE setting_name='header_flash';
UPDATE settings SET description='Background color of the header Flash movie.' WHERE setting_name='header_flash_bgcolor';
UPDATE settings SET description='Height of the header Flash movie.' WHERE setting_name='header_flash_height';
UPDATE settings SET description='Show the header Flash movie only on the home page: true/false.' WHERE setting_name='header_flash_homeonly';
UPDATE settings SET description='URL of the header Flash movie.' WHERE setting_name='header_flash_url';
UPDATE settings SET description='Width of the header Flash movie.' WHERE setting_name='header_flash_width';
UPDATE settings SET description='Show the Search form in the header: true/false.' WHERE setting_name='header_search';
UPDATE settings SET description='Use DHTML in the primary navigation: true/false.' WHERE setting_name='navpri_dhtml';
UPDATE settings SET description='Use rollover images for the primary navigation: true/false.  Rollover images are named navpri#-off|on|over.gif, where # is the primary node number.' WHERE setting_name='navpri_images';
UPDATE settings SET description='Show the page title on level 1 (primary) pages: true/false.' WHERE setting_name='pagetitle_level1';
UPDATE settings SET description='URL of the printer-friendly page logo image.' WHERE setting_name='printable_logo';
UPDATE settings SET description='Height of the printer-friendly page logo image.' WHERE setting_name='printable_logo_height';
UPDATE settings SET description='Width of the printer-friendly page logo image.' WHERE setting_name='printable_logo_width';
UPDATE settings SET description='SearchBlox css directory path.' WHERE setting_name='searchblox_cssdir';
UPDATE settings SET description='SearchBlox xsl directory path.' WHERE setting_name='searchblox_xsldir';
UPDATE settings SET description='URL for the search button image.' WHERE setting_name='search_image';
UPDATE settings SET description='Height of the search button image.' WHERE setting_name='search_imageheight';
UPDATE settings SET description='Width of the search button image.' WHERE setting_name='search_imagewidth';
UPDATE settings SET description='Size of the search text field.' WHERE setting_name='search_size';
UPDATE settings SET description='Center the site in the browser: true/false. Note: if true, navpri_dhtml must be false!' WHERE setting_name='site_centered';
UPDATE settings SET description='css directory path, including trailing slash.' WHERE setting_name='site_cssdir';
UPDATE settings SET description='css folder, without trailing slash.' WHERE setting_name='site_cssfolder';
UPDATE settings SET description='Debug mode: true/false.' WHERE setting_name='site_debug';
UPDATE settings SET description='Design images directory path, including trailing slash.' WHERE setting_name='site_designdir';
UPDATE settings SET description='Design images folder, without trailing slash.' WHERE setting_name='site_designfolder';
UPDATE settings SET description='Content images directory path, including trailing slash.' WHERE setting_name='site_imagedir';
UPDATE settings SET description='Content images folder, without trailing slash.' WHERE setting_name='site_imagefolder';
UPDATE settings SET description='Title for the HEAD tag on the site map.' WHERE setting_name='sitemap_headtitle';
UPDATE settings SET description='Page title for the site map.' WHERE setting_name='sitemap_pagetitle';
UPDATE settings SET description='Maxiumum size of uploaded files, in bytes.' WHERE setting_name='site_maxuploadsize';
UPDATE settings SET description='Media uploads directory, with trailing slash.' WHERE setting_name='site_mediadir';
UPDATE settings SET description='Media uploads folder, without trailing slash.' WHERE setting_name='site_mediafolder';
UPDATE settings SET description='Site name.' WHERE setting_name='site_name';
UPDATE settings SET description='Context of the site root, typically /.' WHERE setting_name='site_rootfolder';
UPDATE settings SET description='Format (java.text.SimpleDateFormat) for the current date in the subheader.' WHERE setting_name='subheader_dateformat';
UPDATE settings SET description='Show current date in the subheader: true/false.' WHERE setting_name='subheader_dateshown';
UPDATE settings SET description='Show a Flash movie in the subheader: true/false.' WHERE setting_name='subheader_flash';
UPDATE settings SET description='Background color of the subheader Flash movie.' WHERE setting_name='subheader_flash_bgcolor';
UPDATE settings SET description='Height of the subheader Flash movie.' WHERE setting_name='subheader_flash_height';
UPDATE settings SET description='Show the subheader Flash movie only on the home page: true/false.' WHERE setting_name='subheader_flash_homeonly';
UPDATE settings SET description='URL of the subheader Flash movie.' WHERE setting_name='subheader_flash_url';
UPDATE settings SET description='Width of the subheader Flash movie.' WHERE setting_name='subheader_flash_width';

ALTER TABLE settings ALTER COLUMN description SET NOT NULL;
