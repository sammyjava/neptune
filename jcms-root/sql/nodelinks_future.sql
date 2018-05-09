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

