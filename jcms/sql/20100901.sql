--
-- new settings for iContact account and client folder, and other DB updates
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100901');


INSERT INTO settings VALUES (150, 'icontact_accountid', '', 'iContact accountId (int)', false, false);
INSERT INTO settings VALUES (151, 'icontact_clientfolderid', '', 'iContact clientFolderId (int)', false, false);


CREATE TABLE formicontactlists (
	form_id		int	NOT NULL REFERENCES forms,
	listid		int	NOT NULL,
	name		varchar	NOT NULL,
	description 	varchar	NOT NULL
);

GRANT SELECT ON formicontactlists TO jcmsuser;
GRANT ALL ON formicontactlists TO jcmsadmin;
