--
-- forms update, added redirecturl
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100701');

ALTER TABLE forms ADD COLUMN redirecturl varchar;


