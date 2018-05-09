--
-- Add formfields.hidden to handle hidden input fields (which may be GET parameters on first load)
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110323');

ALTER TABLE formfields ADD COLUMN hidden boolean NOT NULL DEFAULT false;

