--
-- add settings and stylesheet classes for page meta descriptions under headings
--

-- new headlines settings
INSERT INTO settings VALUES (140, 'headlines_showdescription', 'false', 'Show page meta description under headline (true/false)', false, true);
INSERT INTO settings VALUES (141, 'headlines_readmore', 'Read more.', 'Text for the "Read more" link at the end of the description.', false, false);

-- new headline setting to use page titles rather than node name
INSERT INTO settings VALUES (142, 'headlines_pagetitles', 'false', 'Show page titles rather than node names as headlines (true/false).', false, true);

-- new headlines classes
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (310,'div.headline-description','',7,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (312,'a.headline-readmore:link','',8,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (313,'a.headline-readmore:visited','',9,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (314,'a.headline-readmore:hover','',10,true,0,0,18);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (315,'a.headline-readmore:active','',11,true,0,0,18);



