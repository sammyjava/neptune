--
-- Atom extra
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100720');

INSERT INTO settings VALUES (85,'atom_uri','http://wordpress.org/news/feed/atom','URI of Atom feed',false,false);

INSERT INTO settings VALUES (86,'atom_dateformat','yyyy-MM-dd HH:mm','java.text.SimpleDateFormat for the atom feed dates',false,false);

INSERT INTO settings VALUES (87,'atom_maxlisted','0','maximum number of atom feed entries shown; 0 for no limit',false,false);
