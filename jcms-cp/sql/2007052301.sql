--
-- 2007052301
-- delete some unused (and confusing) stylesheet classes
--

\connect - jcms

UPDATE appinfo SET appinfo_value='2007052301' WHERE appinfo_name='db_version';

DELETE FROM stylesheet WHERE class_name='td.pagetitle-local';
