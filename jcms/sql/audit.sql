--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: audit; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.audit (
    audit_id integer NOT NULL,
    "timestamp" timestamp(0) with time zone DEFAULT now() NOT NULL,
    tablename character varying NOT NULL,
    record_id integer NOT NULL,
    action character(1) NOT NULL,
    username character varying NOT NULL,
    description character varying
);


ALTER TABLE public.audit OWNER TO jcms;

--
-- Name: audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_audit_id_seq OWNER TO jcms;

--
-- Name: audit_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.audit_audit_id_seq OWNED BY public.audit.audit_id;


--
-- Name: audit_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.audit ALTER COLUMN audit_id SET DEFAULT nextval('public.audit_audit_id_seq'::regclass);


--
-- Name: audit_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (audit_id);


--
-- Name: audit_tablename_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX audit_tablename_idx ON public.audit USING btree (tablename);


--
-- Name: audit_username_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX audit_username_idx ON public.audit USING btree (username);


--
-- Name: TABLE audit; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.audit FROM PUBLIC;
REVOKE ALL ON TABLE public.audit FROM jcms;
GRANT ALL ON TABLE public.audit TO jcms;
GRANT SELECT,INSERT ON TABLE public.audit TO jcmsadmin;


--
-- Name: SEQUENCE audit_audit_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.audit_audit_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.audit_audit_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.audit_audit_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.audit_audit_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

