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
-- Name: stylesheetcategories; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE stylesheetcategories (
    stylesheetcategory_id integer NOT NULL,
    stylesheetcategory character varying NOT NULL,
    num integer
);


ALTER TABLE public.stylesheetcategories OWNER TO jcms;

--
-- Data for Name: stylesheetcategories; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY stylesheetcategories (stylesheetcategory_id, stylesheetcategory, num) FROM stdin;
9	layouts	9
4	secondary nav	7
11	sidebar	8
6	footer	10
10	dhtml	11
1	other	99
16	comments	16
18	email	18
17	blogger	17
14	sectionheader	5
8	main	6
0	body	1
2	header	2
3	primary nav	3
5	subheader	4
7	site map	13
12	search	14
13	access	15
15	quaternary nav	12
19	forms	19
\.


--
-- Name: stylesheetcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY stylesheetcategories
    ADD CONSTRAINT stylesheetcategories_pkey PRIMARY KEY (stylesheetcategory_id);


--
-- Name: stylesheetcategories; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE stylesheetcategories FROM PUBLIC;
REVOKE ALL ON TABLE stylesheetcategories FROM jcms;
GRANT ALL ON TABLE stylesheetcategories TO jcms;
GRANT SELECT ON TABLE stylesheetcategories TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

