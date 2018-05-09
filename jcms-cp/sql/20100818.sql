--
-- updates for vertical primary navigation option
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100818');


INSERT INTO settings VALUES (304, 'navpri_vertical', 'false', 'Display primary navigation vertically along with secondary; automatically disables DHTML navigation. (true/false)', false, true);
