--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accessroles_accessusers; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessroles_accessusers (
    accessrole_id integer NOT NULL,
    accessuser_id integer NOT NULL
);


ALTER TABLE public.accessroles_accessusers OWNER TO jcms;

--
-- Name: accessroles_accessusers_accessrole_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_accessusers
    ADD CONSTRAINT accessroles_accessusers_accessrole_id_fkey FOREIGN KEY (accessrole_id) REFERENCES accessroles(accessrole_id);


--
-- Name: accessroles_accessusers_accessuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_accessusers
    ADD CONSTRAINT accessroles_accessusers_accessuser_id_fkey FOREIGN KEY (accessuser_id) REFERENCES accessusers(accessuser_id);


--
-- Name: accessroles_accessusers; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessroles_accessusers FROM PUBLIC;
REVOKE ALL ON TABLE accessroles_accessusers FROM jcms;
GRANT ALL ON TABLE accessroles_accessusers TO jcms;
GRANT ALL ON TABLE accessroles_accessusers TO jcmsadmin;
GRANT SELECT ON TABLE accessroles_accessusers TO jcmsuser;


--
-- PostgreSQL database dump complete
--

