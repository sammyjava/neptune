--
-- Add td.navpri-first to achieve design asymmetry
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110726');

INSERT INTO stylesheet VALUES (92, 'td.navpri-first', '', 9, true, 0, 0, 3);

UPDATE stylesheet SET num=9 WHERE class_id=92;
