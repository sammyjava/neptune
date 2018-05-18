--
-- new required stylesheet class
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100709');

INSERT INTO stylesheet VALUES (629,'div.event-ics','',23,true,0,0,23);
