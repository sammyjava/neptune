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
-- Name: ads; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE ads (
    ad_id integer NOT NULL,
    sponsor_id integer NOT NULL,
    created timestamp(0) without time zone DEFAULT now() NOT NULL,
    url character varying NOT NULL,
    imagefile character varying NOT NULL,
    imagewidth integer NOT NULL,
    imageheight integer NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    clicks integer DEFAULT 0 NOT NULL,
    cleared timestamp(0) with time zone DEFAULT now() NOT NULL,
    starttime timestamp(0) without time zone,
    endtime timestamp(0) without time zone,
    maxviews integer
);


ALTER TABLE public.ads OWNER TO jcms;

--
-- Name: ads_ad_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE ads_ad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ads_ad_id_seq OWNER TO jcms;

--
-- Name: ads_ad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE ads_ad_id_seq OWNED BY ads.ad_id;


--
-- Name: ad_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY ads ALTER COLUMN ad_id SET DEFAULT nextval('ads_ad_id_seq'::regclass);


--
-- Name: ads_imagefile_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT ads_imagefile_key UNIQUE (imagefile);


--
-- Name: ads_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (ad_id);


--
-- Name: ads_sponsor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT ads_sponsor_id_fkey FOREIGN KEY (sponsor_id) REFERENCES sponsors(sponsor_id);


--
-- Name: ads; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE ads FROM PUBLIC;
REVOKE ALL ON TABLE ads FROM jcms;
GRANT ALL ON TABLE ads TO jcms;
GRANT ALL ON TABLE ads TO jcmsadmin;
GRANT SELECT,UPDATE ON TABLE ads TO jcmsuser;


--
-- Name: ads_ad_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE ads_ad_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ads_ad_id_seq FROM jcms;
GRANT ALL ON SEQUENCE ads_ad_id_seq TO jcms;
GRANT ALL ON SEQUENCE ads_ad_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

