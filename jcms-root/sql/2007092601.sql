--
-- update, insert stylesheet classes; add a site setting for centering the site
--

UPDATE appinfo SET appinfo_value='2007092601' WHERE appinfo_name='db_version';

INSERT INTO settings VALUES (3, 'site_centered', 'false');

INSERT INTO settings VALUES (60, 'footer_dateshown', 'false');
INSERT INTO settings VALUES (61, 'footer_dateformat', 'EEE, MMM d, yyyy');


UPDATE stylesheet SET required=true WHERE class_name LIKE '%navpri%' AND level_num = 0;

INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('td.footer-date','',7,true,0,0,6);
INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('td.footer-date','',7,true,1,-1,6);

INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('a.footer-ims:link','',30,true,0,0,6);
INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('a.footer-ims:visited','',31,true,0,0,6);
INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('a.footer-ims:hover','',32,true,0,0,6);
INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('a.footer-ims:active','',33,true,0,0,6);

INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('td.main-left','padding: 0;',41,true,0,0,0);
INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('td.main-right','padding: 0;',42,true,0,0,0);
INSERT INTO stylesheet (class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES ('td.main-right','padding: 0;',42,true,1,-1,0);
