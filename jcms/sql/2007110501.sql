--
-- BIG HTML/stylesheet redesign
-- move things to DIV that don't belong in tables
-- add div#container surrounding div
-- drop site_centered setting since that can be done in div#container
--

UPDATE appinfo SET appinfo_value='2007110701' WHERE appinfo_name='db_version';

DELETE FROM settings WHERE setting_name='site_centered';

INSERT INTO stylesheet VALUES (15, 'div#container', '', 1, true, 0, 0, 0);
INSERT INTO stylesheet VALUES (4, 'div#container', '', 1, true, 0, -1, 0);

UPDATE stylesheet SET class_name='div#header-flash' WHERE class_name='table.header-flash';
DELETE FROM stylesheet WHERE class_name='td.header-flash';
INSERT INTO stylesheet VALUES (46, 'div#header-flash', '', 2, true, 0, 0, 2);

UPDATE stylesheet SET class_name='div#header',num=1 WHERE class_name='table.header';
DELETE FROM stylesheet WHERE class_name='td.header';

UPDATE stylesheet SET class_name='table#navpri' WHERE class_name='table.navpri';
UPDATE stylesheet SET class_name='table#subheader' WHERE class_name='table.subheader';
UPDATE stylesheet SET class_name='table#footer' WHERE class_name='table.footer';

INSERT INTO stylesheet VALUES (486, 'div#search', 'float: right;', 2, true, 0, 0, 12);

UPDATE stylesheet SET class_name='div#subheader-flash' WHERE class_name='table.subheader-flash';
DELETE FROM stylesheet WHERE class_name='td.subheader-flash';

UPDATE stylesheet SET class_name='table#main' WHERE class_name='table.main';
UPDATE stylesheet SET class_name='td#main-left' WHERE class_name='td.main-left';
UPDATE stylesheet SET class_name='td#main-right' WHERE class_name='td.main-right';

DELETE FROM stylesheet WHERE class_name='table.pagetitle';
DELETE FROM stylesheet WHERE class_name='td.pagetitle';
UPDATE stylesheet SET class_name='div#pagetitle' WHERE class_name='div.pagetitle';

UPDATE stylesheet SET class_name='div#navsec-box' WHERE class_name='table.navsec';
UPDATE stylesheet SET class_name='div#navsec-top' WHERE class_name='td.navsec-top';
UPDATE stylesheet SET class_name='div#navsec-bottom' WHERE class_name='td.navsec-bottom';

UPDATE stylesheet SET class_name='div.navsec' WHERE class_name='td.navsec';
UPDATE stylesheet SET class_name='div.navsec-over' WHERE class_name='td.navsec-over';
UPDATE stylesheet SET class_name='div.navsec-on' WHERE class_name='td.navsec-on';
UPDATE stylesheet SET class_name='div.navsec-off' WHERE class_name='td.navsec-off';

UPDATE stylesheet SET class_name='div.navter-box' WHERE class_name='table.navter';

UPDATE stylesheet SET class_name='div.navter' WHERE class_name='td.navter';
UPDATE stylesheet SET class_name='div.navter-over' WHERE class_name='td.navter-over';
UPDATE stylesheet SET class_name='div.navter-on' WHERE class_name='td.navter-on';
UPDATE stylesheet SET class_name='div.navter-off' WHERE class_name='td.navter-off';

UPDATE stylesheet SET class_name='div#sidebar-box' WHERE class_name='table.sidebar';
UPDATE stylesheet SET class_name='div#sidebar-top' WHERE class_name='td.sidebar-top';
UPDATE stylesheet SET class_name='div#sidebar-bottom' WHERE class_name='td.sidebar-bottom';

UPDATE stylesheet SET class_name='div.sidebar' WHERE class_name='td.sidebar';

--
-- extra div in layout cells is redundant, remove
--
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l1_p1' AND level_num=0) WHERE class_name='td.l1_p1';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l2_p1' AND level_num=0) WHERE class_name='td.l2_p1';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l2_p2' AND level_num=0) WHERE class_name='td.l2_p2';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l3_p1' AND level_num=0) WHERE class_name='td.l3_p1';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l3_p2' AND level_num=0) WHERE class_name='td.l3_p2';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l3_p3' AND level_num=0) WHERE class_name='td.l3_p3';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l4_p1' AND level_num=0) WHERE class_name='td.l4_p1';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l4_p2' AND level_num=0) WHERE class_name='td.l4_p2';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l4_p3' AND level_num=0) WHERE class_name='td.l4_p3';
UPDATE stylesheet SET class_value=class_value||E'\n'||(SELECT class_value FROM stylesheet WHERE class_name='div.l4_p4' AND level_num=0) WHERE class_name='td.l4_p4';

DELETE FROM stylesheet WHERE class_name LIKE 'div.l%';

--
-- use id since unique to page
--
UPDATE stylesheet SET class_name='table#l1' WHERE class_name='table.l1';
UPDATE stylesheet SET class_name='table#l2' WHERE class_name='table.l2';
UPDATE stylesheet SET class_name='table#l3' WHERE class_name='table.l3';
UPDATE stylesheet SET class_name='table#l4' WHERE class_name='table.l4';

UPDATE stylesheet SET class_name='td#l1_p1' WHERE class_name='td.l1_p1';
UPDATE stylesheet SET class_name='td#l2_p1' WHERE class_name='td.l2_p1';
UPDATE stylesheet SET class_name='td#l2_p2' WHERE class_name='td.l2_p2';
UPDATE stylesheet SET class_name='td#l3_p1' WHERE class_name='td.l3_p1';
UPDATE stylesheet SET class_name='td#l3_p2' WHERE class_name='td.l3_p2';
UPDATE stylesheet SET class_name='td#l3_p3' WHERE class_name='td.l3_p3';
UPDATE stylesheet SET class_name='td#l4_p1' WHERE class_name='td.l4_p1';
UPDATE stylesheet SET class_name='td#l4_p2' WHERE class_name='td.l4_p2';
UPDATE stylesheet SET class_name='td#l4_p3' WHERE class_name='td.l4_p3';
UPDATE stylesheet SET class_name='td#l4_p4' WHERE class_name='td.l4_p4';

--
-- old deprecated stuff
--
DELETE FROM stylesheet WHERE class_name='table.tight';
DELETE FROM stylesheet WHERE class_name='td.tight';
DELETE FROM stylesheet WHERE class_name='table.border';

--
-- need to number stylesheet categories for selector user friendliness
--
ALTER TABLE stylesheetcategories ADD COLUMN num int;

UPDATE stylesheetcategories SET num=1,stylesheetcategory='body' WHERE stylesheetcategory='core';
UPDATE stylesheetcategories SET num=2 WHERE stylesheetcategory='header';
UPDATE stylesheetcategories SET num=3 WHERE stylesheetcategory='primary nav';
UPDATE stylesheetcategories SET num=4 WHERE stylesheetcategory='subheader';
UPDATE stylesheetcategories SET num=5,stylesheetcategory='main' WHERE stylesheetcategory='page title';
UPDATE stylesheetcategories SET num=6 WHERE stylesheetcategory='secondary nav';
UPDATE stylesheetcategories SET num=7 WHERE stylesheetcategory='sidebar';
UPDATE stylesheetcategories SET num=8,stylesheetcategory='layouts' WHERE stylesheetcategory='content';
UPDATE stylesheetcategories SET num=9 WHERE stylesheetcategory='footer';
UPDATE stylesheetcategories SET num=10 WHERE stylesheetcategory='dhtml';
UPDATE stylesheetcategories SET num=11 WHERE stylesheetcategory='site map';
UPDATE stylesheetcategories SET num=12 WHERE stylesheetcategory='search';
UPDATE stylesheetcategories SET num=13 WHERE stylesheetcategory='access';
UPDATE stylesheetcategories SET num=14 WHERE stylesheetcategory='other';

--
-- move main classes to new main category (8)
--
UPDATE stylesheet SET stylesheetcategory_id=8,num=1 WHERE class_name='table#main';
UPDATE stylesheet SET stylesheetcategory_id=8,num=2 WHERE class_name='td#main-left';
UPDATE stylesheet SET stylesheetcategory_id=8,num=2 WHERE class_name='td#main-right';

--
-- give logo its own space
--
INSERT INTO stylesheet VALUES (403, 'div#header-logo', 'float: left;', 3, true, 0, 0, 2);
