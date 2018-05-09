--
-- add new settings to support utility content rewrite
--

\connect - jcms

DELETE FROM settings WHERE setting_id=2;
INSERT INTO settings VALUES (2, 'site_dateformat', 'HH:mm yyyy-MM-dd', 'Date format used by currentdate.jsp and lastupdate.jsp', false, false);

DELETE FROM settings WHERE setting_id=504;
INSERT INTO settings VALUES (504, 'printable_linktext', 'printer-friendly', 'Text shown on printer-friendly link in printablelink.jsp', false, false);

DELETE FROM settings WHERE setting_id=45;
INSERT INTO settings VALUES (45, 'access_login_linktext', 'log in', 'Text shown on access login link in accesslink.jsp', false, false);

DELETE FROM settings WHERE setting_id=46;
INSERT INTO settings VALUES (46, 'access_logout_linktext', 'log out', 'Text shown on access logout link in accesslink.jsp', false, false);

UPDATE settings SET setting_name='site_copyrighttext', description='Text shown after the copyright year in copyright.jsp' WHERE setting_name='footer_copyrighttext';
