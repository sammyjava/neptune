--
-- Softslate extras records
--

\connect - jcms

INSERT INTO extras (extra_id,name,cpurl) VALUES (12, 'SoftSlate', 'softslate.jsp');
INSERT INTO extras (extra_id,parent_extra_id,name,cpurl) VALUES (13, 12, 'Softslate CSS', 'softslate-css.jsp');

INSERT INTO settings VALUES (560, 'softslate_cssdir', '', 'Full path to SoftSlate custom.css', false, false);

INSERT INTO updatelog (name,value) VALUES ('db_version','20091026');
