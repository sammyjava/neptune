--
-- Forms update: CAPTCHA toggle, error alert toggle
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20130620');

ALTER TABLE forms ADD COLUMN usecaptcha boolean NOT NULL DEFAULT true;

ALTER TABLE forms ADD COLUMN alertonerror boolean NOT NULL DEFAULT false;
