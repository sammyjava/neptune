--
-- headlines stylesheet category and classes
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100219');

-- STYLESHEET - rename email to headlines since email now deprecated
UPDATE stylesheetcategories SET stylesheetcategory='headlines' WHERE stylesheetcategory_id=18;
DELETE FROM stylesheet WHERE stylesheetcategory_id=18;

-- headlines classes
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (300,'div.headlines','',1,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (301,'div.headline','',2,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (302,'a.headline:link','',3,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (303,'a.headline:visited','',4,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (304,'a.headline:hover','',5,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (305,'a.headline:active','',6,true,0,0,18);
