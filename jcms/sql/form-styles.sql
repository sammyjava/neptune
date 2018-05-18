--
-- Forms styles
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20081016');


INSERT INTO stylesheetcategories VALUES (19,'forms',19);

INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (320,'div#form','',1,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (321,'div#forminstructions','',2,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (322,'table#form','',3,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (323,'td.formfield','',4,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (324,'.required','',5,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (325,'.optional','',6,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (326,'table.checkboxes','',7,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (327,'td.checkbox','',8,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (328,'table.radios','',9,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (329,'td.radio','',10,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (330,'td.lyris','',11,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (331,'table.submit','',12,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (332,'td.captcha','',13,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (333,'input.captcha','',14,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (334,'input.submit','',15,true,0,0,19);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (335,'div#thankyou','',16,true,0,0,19);


