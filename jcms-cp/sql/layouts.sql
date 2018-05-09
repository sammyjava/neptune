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
-- Name: layouts; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE layouts (
    layout_id integer DEFAULT nextval('layouts_layout_id_seq'::regclass) NOT NULL,
    layout character varying NOT NULL,
    cols integer NOT NULL,
    rows integer NOT NULL,
    num integer NOT NULL
);


ALTER TABLE public.layouts OWNER TO jcms;

--
-- Data for Name: layouts; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY layouts (layout_id, layout, cols, rows, num) FROM stdin;
1	single pane	1	1	1
2	two columns	2	1	2
3	two columns above full-width pane	2	2	3
\.


--
-- Name: layouts_num_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layouts
    ADD CONSTRAINT layouts_num_key UNIQUE (num);


--
-- Name: layouts_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layouts
    ADD CONSTRAINT layouts_pkey PRIMARY KEY (layout_id);


--
-- Name: layouts; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE layouts FROM PUBLIC;
REVOKE ALL ON TABLE layouts FROM jcms;
GRANT ALL ON TABLE layouts TO jcms;
GRANT SELECT ON TABLE layouts TO jcmsuser;
GRANT ALL ON TABLE layouts TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

