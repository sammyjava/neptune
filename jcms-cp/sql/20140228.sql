--
-- add forms.confirmationsubject to override default
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20140228');

ALTER TABLE forms ADD COLUMN confirmationsubject varchar;


