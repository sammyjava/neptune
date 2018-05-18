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
-- Name: users_extensions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_extensions (
    uid integer NOT NULL,
    extid integer NOT NULL
);


ALTER TABLE public.users_extensions OWNER TO jcms;

--
-- Data for Name: users_extensions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users_extensions (uid, extid) FROM stdin;
1	15
\.


--
-- Name: users_extensions_extid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extensions
    ADD CONSTRAINT users_extensions_extid_fkey FOREIGN KEY (extid) REFERENCES extensions(extid);


--
-- Name: users_extensions_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extensions
    ADD CONSTRAINT users_extensions_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: users_extensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users_extensions FROM PUBLIC;
REVOKE ALL ON TABLE users_extensions FROM jcms;
GRANT ALL ON TABLE users_extensions TO jcms;
GRANT ALL ON TABLE users_extensions TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

