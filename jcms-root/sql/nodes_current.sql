--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

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
-- PostgreSQL database dump complete
--

