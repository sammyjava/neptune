--
-- Remove NOT NULL constraint on forms.senderemail and forms.sendername since aren't needed if no confirmation email sent; add setting site_email for default From: address
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20111115');

INSERT INTO settings VALUES (15, 'site_email', 'webmaster@ims.net', 'From: address for notification emails sent from contact forms, e.g. webmaster@yourdomain.com', false, false);

ALTER TABLE forms ALTER COLUMN sendername DROP NOT NULL;
ALTER TABLE forms ALTER COLUMN senderemail DROP NOT NULL;

UPDATE settings SET description='From: address for notification emails sent from contact forms, e.g. webmaster@yourdomain.com' WHERE setting_id=15;
