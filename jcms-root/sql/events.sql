--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE events (
    event_id integer NOT NULL,
    num integer NOT NULL DEFAULT 1,
    title character varying NOT NULL,
    "date" date NOT NULL,
    "time" character varying,
    description character varying,
    url character varying
);


ALTER TABLE public.events OWNER TO jcms;

--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO jcms;

GRANT ALL ON public.events_event_id_seq TO jcmsadmin;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE events_event_id_seq OWNED BY events.event_id;


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('events_event_id_seq', 3, true);


--
-- Name: event_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE events ALTER COLUMN event_id SET DEFAULT nextval('events_event_id_seq'::regclass);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY events (event_id, title, "date", "time", description, url) FROM stdin;
1	First Test Event	2010-03-24	12pm	This is the first test event.  It is very vague as to what it actually is.	/privacy
2	Second Test Event	2010-03-26	early afternoon	This is the second test event.  It is also very vague as to what it actually is.	/imagerotator
3	Third Test Event	2010-04-12	12:00-16:00	This is the third test event.  It is in April.  April showers bring May flowers.	/headlines
\.


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: events; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE events FROM PUBLIC;
REVOKE ALL ON TABLE events FROM jcms;
GRANT ALL ON TABLE events TO jcms;
GRANT ALL ON TABLE events TO jcmsadmin;
GRANT SELECT ON TABLE events TO jcmsuser;


--
-- PostgreSQL database dump complete
--

