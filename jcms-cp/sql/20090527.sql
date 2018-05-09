--
-- AddThis settings
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20090527');

INSERT INTO settings VALUES (91, 'addthis_options', 'email,linkedin,facebook,favorites,digg,delicious,more', 'List of items to show on AddThis menu', false, false);
INSERT INTO settings VALUES (92, 'addthis_pub', '49f9e4e34d6a2edf', 'The addthis_pub parameter, which is unique to each site', false, false);
