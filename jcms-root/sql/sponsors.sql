--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: sponsors; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE sponsors (
    sponsor_id integer NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    company character varying NOT NULL
);


ALTER TABLE public.sponsors OWNER TO jcms;

--
-- Name: sponsors_sponsor_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE sponsors_sponsor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sponsors_sponsor_id_seq OWNER TO jcms;

--
-- Name: sponsors_sponsor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE sponsors_sponsor_id_seq OWNED BY sponsors.sponsor_id;


--
-- Name: sponsor_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY sponsors ALTER COLUMN sponsor_id SET DEFAULT nextval('sponsors_sponsor_id_seq'::regclass);


--
-- Name: sponsors_company_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY sponsors
    ADD CONSTRAINT sponsors_company_key UNIQUE (company);


--
-- Name: sponsors_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY sponsors
    ADD CONSTRAINT sponsors_pkey PRIMARY KEY (sponsor_id);


--
-- Name: sponsors; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE sponsors FROM PUBLIC;
REVOKE ALL ON TABLE sponsors FROM jcms;
GRANT ALL ON TABLE sponsors TO jcms;
GRANT ALL ON TABLE sponsors TO jcmsadmin;
GRANT SELECT ON TABLE sponsors TO jcmsuser;


--
-- Name: sponsors_sponsor_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE sponsors_sponsor_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sponsors_sponsor_id_seq FROM jcms;
GRANT ALL ON SEQUENCE sponsors_sponsor_id_seq TO jcms;
GRANT ALL ON SEQUENCE sponsors_sponsor_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

