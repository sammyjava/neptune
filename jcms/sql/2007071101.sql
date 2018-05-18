--
-- 2007071101.sql - add pages.othermeta, and views for page link reporting
--

\connect - jcms

UPDATE appinfo SET appinfo_value='2007071101' WHERE appinfo_name='db_version';

ALTER TABLE pages ADD COLUMN othermeta varchar;


CREATE VIEW nodes_current AS
  SELECT nodelinks.nid, max(nodelinks.starttime) AS starttime
  FROM nodelinks
  WHERE nodelinks.pid IS NOT NULL AND nodelinks.starttime < now()
  GROUP BY nodelinks.nid
  ORDER BY nodelinks.nid;

CREATE VIEW nodelinks_current AS
  SELECT nodelinks.*
  FROM nodelinks, nodes_current
  WHERE nodelinks.nid = nodes_current.nid AND nodelinks.starttime = nodes_current.starttime;

CREATE VIEW nodelinks_future AS
  SELECT nodelinks.*
  FROM nodelinks
  WHERE nodelinks.pid IS NOT NULL AND nodelinks.starttime > now();

GRANT SELECT ON nodes_current TO jcmsuser, jcmsadmin;
GRANT SELECT ON nodelinks_current TO jcmsuser, jcmsadmin;
GRANT SELECT ON nodelinks_future TO jcmsuser, jcmsadmin;
