--
-- Add site_head setting for global head tags
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110621');

INSERT INTO settings VALUES (3, 'site_head', '', 'Site-wide content placed in HEAD tag', false, false);
