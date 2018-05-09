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
-- Name: adplacement; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE adplacement (
    adplacement_id integer NOT NULL,
    ad_id integer NOT NULL,
    layoutpane_id integer NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    shown timestamp(0) with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.adplacement OWNER TO jcms;

--
-- Name: adplacement_adplacement_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE adplacement_adplacement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adplacement_adplacement_id_seq OWNER TO jcms;

--
-- Name: adplacement_adplacement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE adplacement_adplacement_id_seq OWNED BY adplacement.adplacement_id;


--
-- Name: adplacement_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY adplacement ALTER COLUMN adplacement_id SET DEFAULT nextval('adplacement_adplacement_id_seq'::regclass);


--
-- Name: adplacement_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY adplacement
    ADD CONSTRAINT adplacement_pkey PRIMARY KEY (adplacement_id);


--
-- Name: adplacement_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX adplacement_unique ON adplacement USING btree (ad_id, layoutpane_id);


--
-- Name: adplacement_ad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY adplacement
    ADD CONSTRAINT adplacement_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES ads(ad_id);


--
-- Name: adplacement; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE adplacement FROM PUBLIC;
REVOKE ALL ON TABLE adplacement FROM jcms;
GRANT ALL ON TABLE adplacement TO jcms;
GRANT ALL ON TABLE adplacement TO jcmsadmin;
GRANT SELECT,UPDATE ON TABLE adplacement TO jcmsuser;


--
-- Name: adplacement_adplacement_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE adplacement_adplacement_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE adplacement_adplacement_id_seq FROM jcms;
GRANT ALL ON SEQUENCE adplacement_adplacement_id_seq TO jcms;
GRANT ALL ON SEQUENCE adplacement_adplacement_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

