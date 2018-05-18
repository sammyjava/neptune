--
-- Reorganize some tables and views, hopefully to improve performance a bit
--
-- Plus, new commentblacklist of words to block comments
--

\connect - jcms

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;


INSERT INTO updatelog (name,value) VALUES ('db_version','20120129');

DROP VIEW nodelinks_current;
DROP VIEW nodelinks_future;
DROP VIEW nodes_current;

--
-- Name: nodes_current; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodes_current AS
    SELECT nodelinks.nid, max(nodelinks.starttime) AS starttime FROM nodelinks WHERE (nodelinks.starttime < now()) GROUP BY nodelinks.nid;


ALTER TABLE public.nodes_current OWNER TO jcms;

--
-- Name: nodes_current; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodes_current FROM PUBLIC;
REVOKE ALL ON TABLE nodes_current FROM jcms;
GRANT ALL ON TABLE nodes_current TO jcms;
GRANT ALL ON TABLE nodes_current TO jcmsadmin;
GRANT SELECT ON TABLE nodes_current TO jcmsuser;


--
-- Name: nodelinks_current; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodelinks_current AS
	SELECT nodelinks.nlid, nodelinks.nid, nodelinks.pid, nodelinks.mid, nodelinks.url, nodelinks.starttime, nodelinks.refid, nodelinks.redirectnid 
	FROM nodelinks, nodes_current
	WHERE ((nodelinks.nid = nodes_current.nid) AND (nodelinks.starttime = nodes_current.starttime));


ALTER TABLE public.nodelinks_current OWNER TO jcms;

--
-- Name: nodelinks_current; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodelinks_current FROM PUBLIC;
REVOKE ALL ON TABLE nodelinks_current FROM jcms;
GRANT ALL ON TABLE nodelinks_current TO jcms;
GRANT ALL ON TABLE nodelinks_current TO jcmsadmin;
GRANT SELECT ON TABLE nodelinks_current TO jcmsuser;


--
-- Name: nodelinks_future; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodelinks_future AS
    	SELECT nodelinks.nlid, nodelinks.nid, nodelinks.pid, nodelinks.mid, nodelinks.url, nodelinks.starttime, nodelinks.refid, nodelinks.redirectnid 
	FROM nodelinks
	WHERE ((nodelinks.pid IS NOT NULL) AND (nodelinks.starttime > now()));


ALTER TABLE public.nodelinks_future OWNER TO jcms;

--
-- Name: nodelinks_future; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodelinks_future FROM PUBLIC;
REVOKE ALL ON TABLE nodelinks_future FROM jcms;
GRANT ALL ON TABLE nodelinks_future TO jcms;
GRANT SELECT ON TABLE nodelinks_future TO jcmsuser;
GRANT SELECT ON TABLE nodelinks_future TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

CREATE TABLE commentblacklist (
	word_id	serial	PRIMARY KEY,
	word	varchar	UNIQUE NOT NULL
);

GRANT ALL ON commentblacklist TO jcmsadmin;
GRANT SELECT ON commentblacklist TO jcmsuser;

GRANT ALL ON commentblacklist_word_id_seq TO jcmsadmin;


INSERT INTO extras VALUES (14, 1, 'Blacklisted Words', 'comment-blacklist.jsp', 'doc-blacklist.jsp');


--
-- Form delete update
--

GRANT ALL ON postedforms TO jcmsadmin;
GRANT ALL ON postedformfields TO jcmsadmin;
