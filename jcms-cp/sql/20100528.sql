--
-- Added optional file upload to forms, with two new fields
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100528');

ALTER TABLE forms ADD COLUMN filetitle varchar;
ALTER TABLE forms ADD COLUMN fileinstructions varchar;
ALTER TABLE forms ADD COLUMN filerequired boolean NOT NULL DEFAULT false;
ALTER TABLE forms ADD COLUMN filefieldsize int NOT NULL DEFAULT 30;

INSERT INTO settings VALUES (11, 'site_formuploadsdir', '/home/java/jcms/uploads/forms/', 'Contact Forms file uploads directory, with trailing slash.', false, false);
