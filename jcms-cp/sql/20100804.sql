--
-- add imagerotator.url
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100804');

ALTER TABLE imagerotator ADD COLUMN url varchar;

