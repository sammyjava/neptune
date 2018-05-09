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
-- Name: paymentoptions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE paymentoptions (
    paymentoption_id integer NOT NULL,
    num integer NOT NULL,
    amount numeric(10,2) DEFAULT 0.00 NOT NULL,
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.paymentoptions OWNER TO jcms;

--
-- Name: paymentoptions_paymentoption_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE paymentoptions_paymentoption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paymentoptions_paymentoption_id_seq OWNER TO jcms;

--
-- Name: paymentoptions_paymentoption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE paymentoptions_paymentoption_id_seq OWNED BY paymentoptions.paymentoption_id;


--
-- Name: paymentoptions_paymentoption_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('paymentoptions_paymentoption_id_seq', 7, true);


--
-- Name: paymentoption_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE paymentoptions ALTER COLUMN paymentoption_id SET DEFAULT nextval('paymentoptions_paymentoption_id_seq'::regclass);


--
-- Data for Name: paymentoptions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY paymentoptions (paymentoption_id, num, amount, name, description) FROM stdin;
6	6	0.00	Project Fee for Multifamily Projects	Please click <a href="/uploads/media/MultiFamily_Fees_.pdf" target=_"blank">here</a> to view fee schedule.
2	2	400.00	Green Built Home Membership	1 year membership. Please click <a href="/greenbuilt-support" target="_blank">here<a/> for full instructions.
3	3	75.00	Project Fee (Green Built Home Members)	\N
4	4	150.00	Project Fee (Non Green Built Home Members)	\N
7	7	0.00	Become a Green Built Home Sponsor	Please click <a href="http://wi-ei.org/uploads/media/GBH_Sponsor&ProductQual.pdf" target="_blank">here<a/> for sponsor levels.
5	5	50.00	Bulk Rate Project Fee	This option is available to members that have a standard specification on file with GBH.
1	1	0.00	Donate	Support WEI!
\.


--
-- Name: paymentoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY paymentoptions
    ADD CONSTRAINT paymentoptions_pkey PRIMARY KEY (paymentoption_id);


--
-- Name: paymentoptions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE paymentoptions FROM PUBLIC;
REVOKE ALL ON TABLE paymentoptions FROM jcms;
GRANT ALL ON TABLE paymentoptions TO jcms;
GRANT SELECT ON TABLE paymentoptions TO jcmsuser;
GRANT ALL ON TABLE paymentoptions TO jcmsadmin;


--
-- Name: paymentoptions_paymentoption_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE paymentoptions_paymentoption_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE paymentoptions_paymentoption_id_seq FROM jcms;
GRANT ALL ON SEQUENCE paymentoptions_paymentoption_id_seq TO jcms;
GRANT ALL ON SEQUENCE paymentoptions_paymentoption_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

