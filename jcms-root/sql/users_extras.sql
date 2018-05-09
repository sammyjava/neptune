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
-- Name: users_extras; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_extras (
    uid integer NOT NULL,
    extra_id integer NOT NULL
);


ALTER TABLE public.users_extras OWNER TO jcms;

--
-- Data for Name: users_extras; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users_extras (uid, extra_id) FROM stdin;
1	5
1	6
1	7
1	4
1	3
1	2
1	1
15	1
15	2
15	3
15	4
1	8
1	9
1	10
\.


--
-- Name: users_extras_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extras
    ADD CONSTRAINT users_extras_extra_id_fkey FOREIGN KEY (extra_id) REFERENCES extras(extra_id);


--
-- Name: users_extras_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extras
    ADD CONSTRAINT users_extras_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: users_extras; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users_extras FROM PUBLIC;
REVOKE ALL ON TABLE users_extras FROM jcms;
GRANT ALL ON TABLE users_extras TO jcms;
GRANT ALL ON TABLE users_extras TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

