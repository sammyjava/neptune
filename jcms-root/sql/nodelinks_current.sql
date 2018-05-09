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
-- Name: nodelinks_current; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodelinks_current AS
	SELECT nodelinks.*
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
-- PostgreSQL database dump complete
--

