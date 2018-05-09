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
-- Name: layoutpanes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE layoutpanes (
    layoutpane_id integer NOT NULL,
    layout_id integer NOT NULL,
    pane integer DEFAULT 1 NOT NULL,
    vposition integer DEFAULT 1 NOT NULL,
    hposition integer DEFAULT 1 NOT NULL,
    colspan integer DEFAULT 1 NOT NULL,
    rowspan integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.layoutpanes OWNER TO jcms;

--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE layoutpanes_layoutpane_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.layoutpanes_layoutpane_id_seq OWNER TO jcms;

--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE layoutpanes_layoutpane_id_seq OWNED BY layoutpanes.layoutpane_id;


--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('layoutpanes_layoutpane_id_seq', 6, true);


--
-- Name: layoutpane_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE layoutpanes ALTER COLUMN layoutpane_id SET DEFAULT nextval('layoutpanes_layoutpane_id_seq'::regclass);


--
-- Data for Name: layoutpanes; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY layoutpanes (layoutpane_id, layout_id, pane, vposition, hposition, colspan, rowspan) FROM stdin;
1	1	1	1	1	1	1
2	2	1	1	1	1	1
3	2	2	1	2	1	1
4	3	1	1	1	1	1
5	3	2	1	2	1	1
6	3	3	2	1	2	1
\.


--
-- Name: layoutpanes_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layoutpanes
    ADD CONSTRAINT layoutpanes_pkey PRIMARY KEY (layoutpane_id);


--
-- Name: layoutpanes_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY layoutpanes
    ADD CONSTRAINT layoutpanes_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES layouts(layout_id);


--
-- Name: layoutpanes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE layoutpanes FROM PUBLIC;
REVOKE ALL ON TABLE layoutpanes FROM jcms;
GRANT ALL ON TABLE layoutpanes TO jcms;
GRANT SELECT ON TABLE layoutpanes TO jcmsuser;
GRANT ALL ON TABLE layoutpanes TO jcmsadmin;


--
-- Name: layoutpanes_layoutpane_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE layoutpanes_layoutpane_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE layoutpanes_layoutpane_id_seq FROM jcms;
GRANT ALL ON SEQUENCE layoutpanes_layoutpane_id_seq TO jcms;
GRANT ALL ON SEQUENCE layoutpanes_layoutpane_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

