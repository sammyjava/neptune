--
-- Polls extra
--

\connect - jcms

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


// INSERT INTO updatelog (name,value) VALUES ('db_version','20081203');

--
-- extras table record
--
INSERT INTO extras VALUES (10, NULL, 'Polls', 'polls.jsp', 'doc-polls.jsp');

--
-- stylesheet
--
INSERT INTO stylesheetcategories VALUES (21, 'polls', 21);

INSERT INTO stylesheet VALUES (340, 'div.poll-topic', '', 1, true, 0, 0, 21);
INSERT INTO stylesheet VALUES (341, 'table.poll-choices', '', 2, true, 0, 0, 21);
INSERT INTO stylesheet VALUES (342, 'form.poll-choice', 'margin: 0;', 3, true, 0, 0, 21);
INSERT INTO stylesheet VALUES (343, 'td.poll-choice', '', 4, true, 0, 0, 21);
INSERT INTO stylesheet VALUES (344, 'td.poll-button', '', 5, true, 0, 0, 21);
INSERT INTO stylesheet VALUES (345, 'image.poll-button', '', 6, true, 0, 0, 21);
INSERT INTO stylesheet VALUES (346, 'td.poll-tally', '', 7, true, 0, 0, 21);

--
-- Name: polls; Type: TABLE; Schema: public; Owner: forte; Tablespace: 
--

CREATE TABLE polls (
    poll_id integer NOT NULL,
    starttime timestamp(0) without time zone NOT NULL,
    endtime timestamp(0) without time zone NOT NULL,
    question character varying NOT NULL
);


ALTER TABLE public.polls OWNER TO jcms;

--
-- Name: polls_poll_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE polls_poll_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.polls_poll_id_seq OWNER TO jcms;

--
-- Name: polls_poll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE polls_poll_id_seq OWNED BY polls.poll_id;


--
-- Name: poll_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE polls ALTER COLUMN poll_id SET DEFAULT nextval('polls_poll_id_seq'::regclass);


--
-- Name: polls_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (poll_id);


--
-- Name: polls; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE polls FROM PUBLIC;
REVOKE ALL ON TABLE polls FROM jcms;
GRANT ALL ON TABLE polls TO jcms;
GRANT ALL ON TABLE polls TO jcmsadmin;
GRANT SELECT ON TABLE polls TO jcmsuser;


--
-- Name: polls_poll_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE polls_poll_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE polls_poll_id_seq FROM jcms;
GRANT ALL ON SEQUENCE polls_poll_id_seq TO jcms;
GRANT ALL ON SEQUENCE polls_poll_id_seq TO jcmsadmin;


--
-- Name: pollchoices; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE pollchoices (
    pollchoice_id integer NOT NULL,
    poll_id integer NOT NULL,
    num integer NOT NULL,
    choice character varying NOT NULL
);


ALTER TABLE public.pollchoices OWNER TO jcms;

--
-- Name: pollchoices_pollchoice_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE pollchoices_pollchoice_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pollchoices_pollchoice_id_seq OWNER TO jcms;

--
-- Name: pollchoices_pollchoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE pollchoices_pollchoice_id_seq OWNED BY pollchoices.pollchoice_id;


--
-- Name: pollchoice_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE pollchoices ALTER COLUMN pollchoice_id SET DEFAULT nextval('pollchoices_pollchoice_id_seq'::regclass);


--
-- Name: pollchoices_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY pollchoices
    ADD CONSTRAINT pollchoices_pkey PRIMARY KEY (pollchoice_id);


--
-- Name: pollchoices_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX pollchoices_unique ON pollchoices USING btree (poll_id, num);


--
-- Name: pollchoices_poll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pollchoices
    ADD CONSTRAINT pollchoices_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES polls(poll_id);


--
-- Name: pollchoices; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE pollchoices FROM PUBLIC;
REVOKE ALL ON TABLE pollchoices FROM jcms;
GRANT ALL ON TABLE pollchoices TO jcms;
GRANT ALL ON TABLE pollchoices TO jcmsadmin;
GRANT SELECT ON TABLE pollchoices TO jcmsuser;


--
-- Name: pollchoices_pollchoice_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE pollchoices_pollchoice_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE pollchoices_pollchoice_id_seq FROM jcms;
GRANT ALL ON SEQUENCE pollchoices_pollchoice_id_seq TO jcms;
GRANT ALL ON SEQUENCE pollchoices_pollchoice_id_seq TO jcmsadmin;


--
-- Name: pollsubmissions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE pollsubmissions (
    pollchoice_id integer NOT NULL,
    timeposted timestamp(0) without time zone DEFAULT now() NOT NULL,
    ip character varying
);


ALTER TABLE public.pollsubmissions OWNER TO jcms;

--
-- Name: pollsubmissions_pollchoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pollsubmissions
    ADD CONSTRAINT pollsubmissions_pollchoice_id_fkey FOREIGN KEY (pollchoice_id) REFERENCES pollchoices(pollchoice_id);


--
-- Name: pollsubmissions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE pollsubmissions FROM PUBLIC;
REVOKE ALL ON TABLE pollsubmissions FROM jcms;
GRANT ALL ON TABLE pollsubmissions TO jcms;
GRANT SELECT,INSERT ON TABLE pollsubmissions TO jcmsuser;
GRANT SELECT,DELETE ON TABLE pollsubmissions TO jcmsadmin;


--
-- PostgreSQL database dump complete
--
