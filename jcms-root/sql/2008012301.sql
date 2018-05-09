--
-- quaternary navigation settings and stylesheet classes
--

UPDATE appinfo SET appinfo_value='2008012301' WHERE appinfo_name='db_version';

INSERT INTO settings VALUES (330, 'navquat_disable', 'true', 'Disable quaternary navigation: true/false.');


UPDATE stylesheetcategories SET num=13 where stylesheetcategory_id=7;
UPDATE stylesheetcategories SET num=14 where stylesheetcategory_id=12;
UPDATE stylesheetcategories SET num=15 where stylesheetcategory_id=13;
UPDATE stylesheetcategories SET num=16 where stylesheetcategory_id=1;

INSERT INTO stylesheetcategories VALUES (15, 'quaternary nav', 12);

INSERT INTO stylesheet VALUES (210, 'div#navquat-box', '', 1, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (211, 'div#navquat-top', '', 2, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (212, 'div.navquat', '', 3, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (213, 'div.navquat-on', '', 4, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (214, 'div.navquat-off', '', 5, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (215, 'div.navquat-over', '', 6, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (216, 'div#navquat-bottom', '', 7, true, 0, 0, 15);

INSERT INTO stylesheet VALUES (220, 'a.navquat:link', '', 10, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (221, 'a.navquat:visited', '', 11, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (222, 'a.navquat:hover', '', 12, true, 0, 0, 15);
INSERT INTO stylesheet VALUES (223, 'a.navquat:active', '', 13, true, 0, 0, 15);
