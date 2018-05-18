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
-- Name: accessusers; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessusers (
    accessuser_id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone
);


ALTER TABLE public.accessusers OWNER TO jcms;

--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE accessusers_accessuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.accessusers_accessuser_id_seq OWNER TO jcms;

--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE accessusers_accessuser_id_seq OWNED BY accessusers.accessuser_id;


--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('accessusers_accessuser_id_seq', 1, false);


--
-- Name: accessuser_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE accessusers ALTER COLUMN accessuser_id SET DEFAULT nextval('accessusers_accessuser_id_seq'::regclass);


--
-- Data for Name: accessusers; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY accessusers (accessuser_id, email, password, created, updated) FROM stdin;
0	public		2007-11-26 15:16:33-06	\N
\.


--
-- Name: accessusers_email_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY accessusers
    ADD CONSTRAINT accessusers_email_key UNIQUE (email);


--
-- Name: accessusers_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY accessusers
    ADD CONSTRAINT accessusers_pkey PRIMARY KEY (accessuser_id);


--
-- Name: accessusers; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessusers FROM PUBLIC;
REVOKE ALL ON TABLE accessusers FROM jcms;
GRANT ALL ON TABLE accessusers TO jcms;
GRANT ALL ON TABLE accessusers TO jcmsadmin;
GRANT SELECT ON TABLE accessusers TO jcmsuser;


--
-- Name: accessusers_accessuser_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE accessusers_accessuser_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE accessusers_accessuser_id_seq FROM jcms;
GRANT ALL ON SEQUENCE accessusers_accessuser_id_seq TO jcms;
GRANT ALL ON SEQUENCE accessusers_accessuser_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

