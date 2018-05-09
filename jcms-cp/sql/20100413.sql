--
-- Some extra settings/functionality that are needed
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100413');

-- toggle to show RSS icon in location bar
INSERT INTO settings VALUES (26, 'site_showrssicon', 'false', 'Show RSS icon in location bar (true/false)', false, true);

-- optional text to show in td.footer-text 
INSERT INTO settings VALUES (403, 'footer_text', '', 'Text to display in footer (optional)', false, false);

-- corresponding style
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (106,'td.footer-text','',5,true,0,0,6);



