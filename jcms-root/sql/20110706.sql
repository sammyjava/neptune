--
-- Add forms.submitvalue for customizing button
-- Add polls.label for selector, keep question separate since can be very long
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110706');

ALTER TABLE forms ADD COLUMN submitvalue varchar NOT NULL DEFAULT 'SEND';

ALTER TABLE polls ADD COLUMN label varchar;
