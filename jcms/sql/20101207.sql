--
-- Utility Content update - big changes to settings and stylesheet.  Many settings are removed by UtilityContent.convert(), not here.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20101207');

--
-- add new settings
--

DELETE FROM settings WHERE setting_id=2;
INSERT INTO settings VALUES (2, 'site_dateformat', 'HH:mm yyyy-MM-dd', 'Date format used by currentdate.jsp and lastupdate.jsp', false, false);

DELETE FROM settings WHERE setting_id=504;
INSERT INTO settings VALUES (504, 'printable_linktext', 'printer-friendly', 'Text shown on printer-friendly link in printablelink.jsp', false, false);

DELETE FROM settings WHERE setting_id=45;
INSERT INTO settings VALUES (45, 'access_login_linktext', 'log in', 'Text shown on access login link in accesslink.jsp', false, false);

DELETE FROM settings WHERE setting_id=46;
INSERT INTO settings VALUES (46, 'access_logout_linktext', 'log out', 'Text shown on access logout link in accesslink.jsp', false, false);

UPDATE settings SET setting_name='site_copyrighttext', description='Text shown after the copyright year in copyright.jsp' WHERE setting_name='footer_copyrighttext';

--
-- update stylesheet
--

-- move some layout classes up, were stuck in low numbers from setup site

UPDATE stylesheet SET class_id=455 WHERE class_id=51;
UPDATE stylesheet SET class_id=456 WHERE class_id=52;
UPDATE stylesheet SET class_id=457 WHERE class_id=87 AND class_name LIKE 'td#l%';
UPDATE stylesheet SET class_id=458 WHERE class_id=89 AND class_name LIKE 'td#l%';
UPDATE stylesheet SET class_id=459 WHERE class_id=91 AND class_name LIKE 'td#l%';

-- header

DELETE FROM stylesheet WHERE class_name='div#header-links';
DELETE FROM stylesheet WHERE class_name='div#header';

UPDATE stylesheet SET class_name='table#header', num=1 WHERE class_name='table#header-links';
UPDATE stylesheet SET class_name='td.header', num=3 WHERE class_name='td.header-link';
UPDATE stylesheet SET class_name='a.header:link', num=6 WHERE class_name='a.header-link:link';
UPDATE stylesheet SET class_name='a.header:visited', num=7 WHERE class_name='a.header-link:visited';
UPDATE stylesheet SET class_name='a.header:hover', num=8 WHERE class_name='a.header-link:hover';
UPDATE stylesheet SET class_name='a.header:active', num=9 WHERE class_name='a.header-link:active';
UPDATE stylesheet SET class_name='a.header', num=4 WHERE class_name='a.header-link';

UPDATE stylesheet SET required=false, num=99 WHERE class_name='div#header-logo';
UPDATE stylesheet SET required=false, num=99 WHERE class_name='div#header-flash';

INSERT INTO stylesheet VALUES (80, 'td.header-left', 'padding:0;', 2, true, 0, 0, 2);
INSERT INTO stylesheet VALUES (87, 'td.header-right', 'padding:0;', 4, true, 0, 0, 2);
INSERT INTO stylesheet VALUES (88, 'table#header', '', 1, true, 1, -1, 2);
INSERT INTO stylesheet VALUES (89, 'td.header-left', 'padding:0;', 2, true, 1, -1, 2);
INSERT INTO stylesheet VALUES (90, 'td.header', '', 3, true, 1, -1, 2);
INSERT INTO stylesheet VALUES (91, 'td.header-right', 'padding:0;', 4, true, 1, -1, 2);

-- section header

DELETE FROM stylesheet WHERE class_name='td.sectionheader-middle';
INSERT INTO stylesheet VALUES (202, 'td.sectionheader', '', 3, true, 0, 0, 14);

INSERT INTO stylesheet VALUES (204, 'table#sectionheader', '', 1, true, 1, -1, 14);
INSERT INTO stylesheet VALUES (205, 'td.sectionheader-left', 'padding:0;', 2, true, 1, -1, 14);
INSERT INTO stylesheet VALUES (206, 'td.sectionheader', '', 3, true, 1, -1, 14);
INSERT INTO stylesheet VALUES (207, 'td.sectionheader-right', 'padding:0;', 4, true, 1, -1, 14);

-- subheader

DELETE FROM stylesheet WHERE class_name='td.subheader-middle';
DELETE FROM stylesheet WHERE class_name='td.subheader-date';
DELETE FROM stylesheet WHERE class_name LIKE 'a.subheader%' AND level_num=-1;

UPDATE stylesheet SET num=1 WHERE class_name='table#subheader';
UPDATE stylesheet SET num=2 WHERE class_name='td.subheader-left';
UPDATE stylesheet SET num=3 WHERE class_name='td.subheader';
UPDATE stylesheet SET num=4 WHERE class_name='td.subheader-right';
UPDATE stylesheet SET num=5 WHERE class_name='a.subheader:link';
UPDATE stylesheet SET num=6 WHERE class_name='a.subheader:visited';
UPDATE stylesheet SET num=7 WHERE class_name='a.subheader:hover';
UPDATE stylesheet SET num=8 WHERE class_name='a.subheader:active';

-- sidebar

DELETE FROM stylesheet WHERE class_name='div#sidebar-box';

-- footer

DELETE FROM stylesheet WHERE class_name='td.footer-text';
DELETE FROM stylesheet WHERE class_name='td.footer-copyright';
DELETE FROM stylesheet WHERE class_name='td.footer-date';
DELETE FROM stylesheet WHERE class_name='td.footer-ims';
DELETE FROM stylesheet WHERE class_name LIKE 'a.footer%' AND level_num=-1;

UPDATE stylesheet SET required=false, num=99  WHERE class_name LIKE 'a.footer-ims%';

UPDATE stylesheet SET num=1 WHERE class_name='table#footer';
UPDATE stylesheet SET num=2 WHERE class_name='td.footer-left';
UPDATE stylesheet SET num=3 WHERE class_name='td.footer';
UPDATE stylesheet SET num=4 WHERE class_name='td.footer-right';
UPDATE stylesheet SET num=5 WHERE class_name='a.footer:link';
UPDATE stylesheet SET num=6 WHERE class_name='a.footer:visited';
UPDATE stylesheet SET num=7 WHERE class_name='a.footer:hover';
UPDATE stylesheet SET num=8 WHERE class_name='a.footer:active';


-- search - blow away entire category

DELETE FROM stylesheet WHERE stylesheetcategory_id=12;
DELETE FROM stylesheetcategories WHERE stylesheetcategory_id=12;

--
-- replaces utilitylinks and sidebarextensions
--

CREATE TABLE utilitycontent (
	utilitycontent_id	serial		PRIMARY KEY,
	location		character(1)	NOT NULL,
	num			int		NOT NULL DEFAULT 1,
	copy			varchar,
	created	timestamp(0) with time zone	NOT NULL DEFAULT now(),
	updated	timestamp(0) with time zone,
	modulecontext		varchar,
	moduleurl		varchar,
	moduleabove		boolean		NOT NULL DEFAULT false,
	showhome		boolean		NOT NULL DEFAULT false,
	showinside		boolean		NOT NULL DEFAULT false
);

CREATE UNIQUE INDEX utilitycontent_unique ON utilitycontent(location,num);

GRANT ALL ON utilitycontent TO jcmsadmin;
GRANT ALL ON utilitycontent_utilitycontent_id_seq TO jcmsadmin;

GRANT SELECT ON utilitycontent TO jcmsuser;
	

