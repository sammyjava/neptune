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
-- Name: users_nodes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_nodes (
    uid integer NOT NULL,
    nid integer NOT NULL
);


ALTER TABLE public.users_nodes OWNER TO jcms;

--
-- Data for Name: users_nodes; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users_nodes (uid, nid) FROM stdin;
4	2
5	0
14	0
15	0
3	0
2	0
1	0
\.


--
-- Name: users_nodes_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX users_nodes_unique ON users_nodes USING btree (uid, nid);


--
-- Name: users_nodes_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_nodes
    ADD CONSTRAINT users_nodes_nid_fkey FOREIGN KEY (nid) REFERENCES nodes(nid);


--
-- Name: users_nodes_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_nodes
    ADD CONSTRAINT users_nodes_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: users_nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users_nodes FROM PUBLIC;
REVOKE ALL ON TABLE users_nodes FROM jcms;
GRANT ALL ON TABLE users_nodes TO jcms;
GRANT SELECT,INSERT,DELETE ON TABLE users_nodes TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

