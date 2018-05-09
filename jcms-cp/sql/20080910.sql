--
-- update nodes_current to include all nodes, not just nodes with non-null pid
--

-- fix updatelog ownership
ALTER TABLE updatelog OWNER TO jcms;
ALTER TABLE comments OWNER TO jcms;

\connect - jcms

ALTER TABLE updatelog ALTER COLUMN updated SET DEFAULT now();
INSERT INTO updatelog (name,value) VALUES ('db_version','20080910');

DROP VIEW nodelinks_current;
DROP VIEW nodes_current;

CREATE VIEW nodes_current AS
	SELECT nodelinks.nid, max(nodelinks.starttime) AS starttime
	FROM nodelinks
	WHERE nodelinks.starttime < now()
	GROUP BY nodelinks.nid
	ORDER BY nodelinks.nid;


CREATE VIEW nodelinks_current AS
	SELECT nodelinks.nlid, nodelinks.nid, nodelinks.pid, nodelinks.mid, nodelinks.url, nodelinks.starttime, nodelinks.refid, nodelinks.redirectnid
	FROM nodelinks, nodes_current
	WHERE nodelinks.nid = nodes_current.nid AND nodelinks.starttime = nodes_current.starttime;

GRANT ALL ON nodes_current TO jcmsadmin;
GRANT ALL ON nodelinks_current TO jcmsadmin;

GRANT SELECT ON nodes_current TO jcmsuser;
GRANT SELECT ON nodelinks_current TO jcmsuser;
