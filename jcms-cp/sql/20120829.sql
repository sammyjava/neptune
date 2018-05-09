--
-- add settings used by lastmodified.jsp
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120829');

INSERT INTO settings VALUES (170, 'lastmodified_prefix', 'Last modified', 'Text before lastmodified.jsp date/time output', false, false);
INSERT INTO settings VALUES (171, 'lastmodified_dateformat', 'HH:mm yyyy-MM-dd', 'Date format used by lastmodified.jsp', false, false);

UPDATE settings SET description='Date format used by currentdate.jsp' WHERE setting_id=2;

INSERT INTO stylesheet VALUES (180, 'div.content-lastmodified', '', 2, true, 0, 0, 1);
INSERT INTO stylesheet VALUES (181, 'div.page-lastmodified', '', 2, true, 0, 0, 1);

