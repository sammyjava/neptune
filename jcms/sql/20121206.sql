--
-- Ad Scheduler extra
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20121206');

\i sponsors.sql
\i ads.sql
\i adplacement.sql


