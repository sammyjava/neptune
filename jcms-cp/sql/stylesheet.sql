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
-- Name: stylesheet; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE stylesheet (
    class_id integer NOT NULL,
    class_name character varying NOT NULL,
    class_value character varying NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    required boolean DEFAULT false NOT NULL,
    level integer NOT NULL,
    level_num integer NOT NULL,
    stylesheetcategory_id integer NOT NULL
);


ALTER TABLE public.stylesheet OWNER TO jcms;

--
-- Name: stylesheet_class_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE stylesheet_class_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.stylesheet_class_id_seq OWNER TO jcms;

--
-- Name: stylesheet_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE stylesheet_class_id_seq OWNED BY stylesheet.class_id;


--
-- Name: stylesheet_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('stylesheet_class_id_seq', 663, true);


--
-- Name: class_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE stylesheet ALTER COLUMN class_id SET DEFAULT nextval('stylesheet_class_id_seq'::regclass);


--
-- Data for Name: stylesheet; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY stylesheet (class_id, class_name, class_value, num, required, level, level_num, stylesheetcategory_id) FROM stdin;
270	div.blogpost		1	t	0	0	17
271	div.blogposttitle		2	t	0	0	17
95	td.subheader-left	width: 100%;	2	t	0	0	5
96	td.subheader-right		11	t	0	0	5
159	td.subheader-middle		3	t	0	0	5
272	div.blogpostauthor		3	t	0	0	17
156	#layer7		7	t	0	0	10
157	#layer8		8	t	0	0	10
158	#layer9		9	t	0	0	10
8	a:active	color:red;\r\ntext-decoration: underline;	7	t	0	0	0
139	a.dhtml:active	font-size: 11px;\r\ncolor: white;\r\ntext-decoration: underline;	13	t	0	0	10
140	a.dhtml:hover	font-size: 11px;\r\ncolor: white;\r\ntext-decoration: underline;	14	t	0	0	10
137	a.dhtml:link	font-size: 11px;\r\ncolor: white;\r\ntext-decoration: none;	11	t	0	0	10
138	a.dhtml:visited	font-size: 11px;\r\ncolor: white;\r\ntext-decoration: none;	12	t	0	0	10
23	a.footer:hover	color: red;\r\ntext-decoration: underline;	24	t	0	0	6
21	a.footer:link	color: white;\r\ntext-decoration: underline;	22	t	0	0	6
22	a.footer:visited	color: white;\r\ntext-decoration: underline;	23	t	0	0	6
5	a:link	text-decoration: underline;	4	t	0	0	0
116	a.sitemap1:active	text-decoration: underline;\r\ncolor: red;	13	t	0	0	7
117	a.sitemap1:hover	text-decoration: underline;\r\ncolor: blue;	14	t	0	0	7
114	a.sitemap1:link	text-decoration: none;\r\ncolor: blue;	11	t	0	0	7
115	a.sitemap1:visited	text-decoration: none;\r\ncolor: blue;	12	t	0	0	7
120	a.sitemap2:active	text-decoration: underline;\r\ncolor: red;	23	t	0	0	7
121	a.sitemap2:hover	text-decoration: underline;\r\ncolor: red;	24	t	0	0	7
118	a.sitemap2:link	text-decoration: none;\r\ncolor: blue;	21	t	0	0	7
119	a.sitemap2:visited	text-decoration: none;\r\ncolor: blue;	22	t	0	0	7
124	a.sitemap3:active	text-decoration: underline;\r\ncolor: red;	33	t	0	0	7
125	a.sitemap3:hover	text-decoration: underline;\r\ncolor: red;	34	t	0	0	7
122	a.sitemap3:link	text-decoration: none;\r\ncolor: blue;	31	t	0	0	7
123	a.sitemap3:visited	text-decoration: none;\r\ncolor: blue;	32	t	0	0	7
128	a.sitemap4:active	text-decoration: underline;\r\ncolor: red;	43	t	0	0	7
129	a.sitemap4:hover	text-decoration: underline;\r\ncolor: red;	44	t	0	0	7
126	a.sitemap4:link	text-decoration: none;\r\ncolor: blue;	41	t	0	0	7
127	a.sitemap4:visited	text-decoration: none;\r\ncolor: blue;	42	t	0	0	7
273	div.blogpostdate		4	t	0	0	17
274	div.blogpostcontent		5	t	0	0	17
275	div.blogcomment		6	t	0	0	17
6	a:visited	text-decoration: underline;	5	t	0	0	0
3	b	font-weight: bold;	3	t	0	0	0
64	div.sitemap1	font-size: 16px;\r\nfont-weight: bold;	10	t	0	0	7
65	div.sitemap2	margin-left: 10px;\r\nmargin-top: 10px;\r\nfont-size: 14px;	20	t	0	0	7
131	td.footer-ims	text-align: right;	6	t	0	0	6
277	div.blogcommentauthor		7	t	0	0	17
24	a.footer:active	color: red;\r\ntext-decoration: underline;	25	t	0	0	6
101	div.navsec-off		38	t	0	0	4
66	div.sitemap3	margin-left: 20px;\r\nfont-size: 12px;	30	t	0	0	7
67	div.sitemap4	margin-left: 30px;\r\nfont-size: 10px;\r\n	40	t	0	0	7
10	h2	font-size: 14px;	9	t	0	0	0
11	h3	font-size: 12px;	10	t	0	0	0
16	hr	border: 0;\r\nheight: 1px;\r\ncolor: blue;\r\nbackground-color: blue;	14	t	0	0	0
14	li		13	t	0	0	0
12	ol		11	t	0	0	0
278	div.blogcommentdate		8	t	0	0	17
279	div.blogcommentcontent		9	t	0	0	17
143	td.dhtml-on	background-color: #553333;\r\nheight: 31px;\r\npadding: 0px 3px 0px 3px;	22	t	0	0	10
18	td.footer	padding-left: 20px;\r\npadding-right: 20px;\r\ntext-align: left;	2	t	0	0	6
130	td.footer-copyright	width: 200px;	5	t	0	0	6
107	td.footer-left	height: 21px;\r\nwidth: 5px;	3	t	0	0	6
108	td.footer-right	width: 5px;	4	t	0	0	6
38	a.navsec:active	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: none;	35	t	0	0	4
37	a.navsec:hover	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: underline;	34	t	0	0	4
35	a.navsec:link	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: none;	32	t	0	0	4
34	a.navsec:visited	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: none;	33	t	0	0	4
58	a.navter:active	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: underline;	75	t	0	0	4
57	a.navter:hover	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: underline;	74	t	0	0	4
55	a.navter:link	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: none;	72	t	0	0	4
280	a.blogcommentpost:link		10	t	0	0	17
281	a.blogcommentpost:visited		10	t	0	0	17
282	a.blogcommentpost:hover		10	t	0	0	17
283	a.blogcommentpost:active		10	t	0	0	17
56	a.navter:visited	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: none;	73	t	0	0	4
168	a.sidebar:link	color: white;\r\ntext-decoration: none;	5	t	0	0	11
169	a.sidebar:visited	color: white;\r\ntext-decoration: none;	6	t	0	0	11
170	a.sidebar:hover	color: white;\r\ntext-decoration: underline;	7	t	0	0	11
171	a.sidebar:active	color: white;\r\ntext-decoration: underline;	8	t	0	0	11
300	body#emailform		1	t	0	0	18
301	form#emailform		2	t	0	0	18
302	table#emailform		3	t	0	0	18
303	td.emailform		4	t	0	0	18
304	input.emailfield		5	t	0	0	18
305	textarea.emailfield		6	t	0	0	18
306	input.emailbutton		7	t	0	0	18
398	a.subheader:link	font-size: 12pt;\r\ncolor: white;\r\ntext-decoration: none;	12	t	1	-1	5
399	a.subheader:visited	font-size: 12pt;\r\ncolor: white;\r\ntext-decoration: none;	13	t	1	-1	5
397	a.subheader:hover	font-size: 12pt;\r\ncolor: white;\r\ntext-decoration: underline;	14	t	1	-1	5
373	a:active	color:red;\r\ntext-decoration: underline;	7	t	1	-1	0
374	a.footer:active	color: red;\r\ntext-decoration: underline;	25	t	1	-1	6
375	a.footer:hover	color: red;\r\ntext-decoration: underline;	24	t	1	-1	6
378	a:hover	color: red;\r\ntext-decoration: underline;	6	t	1	-1	0
379	a:link	text-decoration: underline;	4	t	1	-1	0
380	a.sitemap1:active	text-decoration: underline;\r\ncolor: red;	13	t	1	-1	7
384	a.sitemap2:active	text-decoration: underline;\r\ncolor: red;	23	t	1	-1	7
385	a.sitemap2:hover	text-decoration: underline;\r\ncolor: red;	24	t	1	-1	7
388	a.sitemap3:active	text-decoration: underline;\r\ncolor: red;	33	t	1	-1	7
389	a.sitemap3:hover	text-decoration: underline;\r\ncolor: red;	34	t	1	-1	7
392	a.sitemap4:active	text-decoration: underline;\r\ncolor: red;	43	t	1	-1	7
393	a.sitemap4:hover	text-decoration: underline;\r\ncolor: red;	44	t	1	-1	7
4	div#container		1	t	0	-1	0
400	a:visited	text-decoration: underline;	5	t	1	-1	0
401	b	font-weight: bold;	3	t	1	-1	0
417	div.sitemap1	font-size: 16px;\r\nfont-weight: bold;	10	t	1	-1	7
418	div.sitemap2	margin-left: 10px;\r\nmargin-top: 10px;\r\nfont-size: 14px;	20	t	1	-1	7
419	div.sitemap3	margin-left: 20px;\r\nfont-size: 12px;	30	t	1	-1	7
420	div.sitemap4	margin-left: 30px;\r\nfont-size: 10px;\r\n	40	t	1	-1	7
425	li		13	t	1	-1	0
426	ol		11	t	1	-1	0
427	p		2	t	1	-1	0
428	table		15	t	1	-1	0
443	td		16	t	1	-1	0
444	td.footer	padding-left: 20px;\r\npadding-right: 20px;\r\ntext-align: left;	2	t	1	-1	6
445	td.footer-copyright	width: 160px;	5	t	1	-1	6
446	td.footer-ims	width: 100px;\r\ntext-align: right;	6	t	1	-1	6
447	td.footer-left	height: 21px;\r\nwidth: 5px;	3	t	1	-1	6
448	td.footer-right	width: 5px;	4	t	1	-1	6
36	div.navsec	font-size: 12px;\r\ncolor: white;\r\nborder: 1px solid black;\r\npadding: 3px 3px 3px 3px;\r\nmargin: 2px;	31	t	0	0	4
98	div#navsec-bottom	height: 20px;	31	t	0	0	4
468	td.subheader-middle		3	t	1	-1	5
471	ul		12	t	1	-1	0
421	h1	font-size: 16pt;	8	t	1	-1	0
422	h2	font-size: 14pt;	9	t	1	-1	0
423	h3	font-size: 12pt;	10	t	1	-1	0
424	hr	border: 0;\r\nheight: 1px;\r\ncolor: black;\r\nbackground-color: black;	14	t	1	-1	0
376	a.footer:link	color: black;\r\ntext-decoration: underline;	22	t	1	-1	6
377	a.footer:visited	color: black;\r\ntext-decoration: underline;	23	t	1	-1	6
7	a:hover	color: red;\r\ntext-decoration: underline;	6	t	0	0	0
500	form	margin: 10px 0px 0px 0px;	17	t	0	0	0
484	form.search	margin: 0px;	1	t	0	0	12
532	div.error	color: red;\r\nmargin: 10px;	1	t	0	0	1
533	div.message	color: green;\r\nmargin-top: 10px;\r\nmargin-bottom: 10px;	1	t	0	0	1
19	table		15	t	0	0	0
519	table.access	background: lightgray;\r\nborder-spacing: 5px;	20	t	0	0	13
520	td.access	font-size: 12px;\r\nfont-weight: bold;	21	t	0	0	13
517	input.access-text	font-size: 12px;	11	t	0	0	13
518	input.access-submit	\r\nbackground-color: gray;\r\ncolor: white;\r\nfont-size: 14px;\r\nfont-weight: bold;	12	t	0	0	13
531	table.form	border: 1px solid black;	1	t	0	0	1
13	ul	margin-top: 5px;\r\nmargin-bottom: 5px;	12	t	0	0	0
59	div.debug	width: 500px;\r\nfont-family: Courier, monospaced;\r\nfont-size: 8pt;\r\ncolor: blue;\r\nmargin: 10pt 0pt 0pt 0pt;	1	t	0	0	1
544	div.access	margin: 10px;	1	t	0	0	13
516	form.access		10	t	0	0	13
382	a.sitemap1:link	text-decoration: none;\r\ncolor: black;	11	t	1	-1	7
387	a.sitemap2:visited	text-decoration: none;\r\ncolor: black;	22	t	1	-1	7
383	a.sitemap1:visited	text-decoration: none;\r\ncolor: black;	12	t	1	-1	7
381	a.sitemap1:hover	text-decoration: underline;\r\ncolor: red;	14	t	1	-1	7
386	a.sitemap2:link	text-decoration: none;\r\ncolor: black;	21	t	1	-1	7
390	a.sitemap3:link	text-decoration: none;\r\ncolor: black;	31	t	1	-1	7
391	a.sitemap3:visited	text-decoration: none;\r\ncolor: black;	32	t	1	-1	7
394	a.sitemap4:link	text-decoration: none;\r\ncolor: black;	41	t	1	-1	7
395	a.sitemap4:visited	text-decoration: none;\r\ncolor: black;	42	t	1	-1	7
2	p		2	t	0	0	0
9	h1	font-size: 16px;\r\nmargin: 0;	8	t	0	0	0
20	td	font-size: 12px;	16	t	0	0	0
624	.caption	font-size: 9pt;\r\nfont-style: italic;	2	f	1	-1	1
623	div.image	text-align: center;\r\nmargin: 10px;	1	f	1	-1	1
402	body	font-family: Arial, Helvetica, sans-serif;\r\nfont-size: 12pt;\r\nfont-weight: normal;\r\nmargin: 10px 10px 10px 10px;	1	t	1	-1	0
99	div.navsec-over	background-color: #553333;	36	t	0	0	4
566	td.footer-date	padding-right: 10px;\r\ntext-align: right;	7	t	1	-1	6
565	td.footer-date	text-align: right;	7	t	0	0	6
1	body	font-family: Arial, Helvetica, sans-serif;\r\nfont-size: 12px;\r\nfont-weight: normal;\r\nmargin: 5px;	1	t	0	0	0
569	a.footer-ims:link	color: white;\r\nfont-weight: bold;\r\ntext-decoration: none;	30	t	0	0	6
570	a.footer-ims:visited	color: white;\r\nfont-weight: bold;\r\ntext-decoration: none;	31	t	0	0	6
571	a.footer-ims:hover	color: white;\r\nfont-weight: bold;\r\ntext-decoration: underline;	32	t	0	0	6
572	a.footer-ims:active	color: white;\r\nfont-weight: bold;\r\ntext-decoration: underline;	33	t	0	0	6
97	div#navsec-top	height: 36px;	31	t	0	0	4
111	div.navter-over	background-color: #553333;	76	t	0	0	4
110	div.navter-off		78	t	0	0	4
53	div.navter-box		70	t	0	0	4
54	div.navter	font-size: 10px;\r\ncolor: white;\r\npadding: 3px 3px 0px 20px;	71	t	0	0	4
109	div.navter-on	background: url("/design/arrow.gif") 8px 4px no-repeat;	77	t	0	0	4
165	div#sidebar-top	height: 10px;	2	t	0	0	11
167	div#sidebar-bottom	height: 10px;	4	t	0	0	11
166	div.sidebar	padding: 5px;	3	t	0	0	11
432	table#l1	width: 100%;\r\nborder-spacing: 0px;	10	t	1	-1	9
178	table#l2	width: 100%;\r\nborder-spacing: 0px;	20	t	0	0	9
433	table#l2	width: 100%;\r\nborder-spacing: 0px;	20	t	1	-1	9
434	table#l3	width: 100%;\r\nborder-spacing: 0px;	30	t	1	-1	9
450	td#l1_p1	padding: 0px;\r\nborder: 0px solid black;\nfont-size: 12px;\r\nmargin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;\r\n	11	t	1	-1	9
414	a.breadcrumbs.active	color: green;\r\ntext-decoration: underline;	5	t	0	0	8
451	td#l2_p1	padding: 0px;\nfont-size: 12px;\r\nmargin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;	21	t	1	-1	9
452	td#l2_p2	padding: 0px;\r\nborder-left: 1px dashed black;\nfont-size: 11px;\r\nmargin-top: 5px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;\r\n	22	t	1	-1	9
411	a.breadcrumbs:link	color: green;\r\ntext-decoration: none;	5	t	0	0	8
453	td#l3_p1	padding: 0px;\r\nborder-right: 1px dashed black;\nfont-size: 11px;\r\nmargin-top: 5px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;	31	t	1	-1	9
412	a.breadcrumbs:visited	color: green;\r\ntext-decoration: none;	5	t	0	0	8
454	td#l3_p2	padding: 0px;\nfont-size: 12px;\r\nmargin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;	32	t	1	-1	9
635	td#l3_p3	\n	33	t	1	-1	9
179	table#l3	width: 100%;	30	t	0	0	9
89	td#l3_p1	width: 200px;\r\nborder-right: 1px dashed black;\r\nfont-size: 11px;\r\npadding: 5px;	31	t	0	0	9
91	td#l3_p2	font-size: 12px;\r\npadding: 10px;	32	t	0	0	9
52	td#l2_p1	font-size: 12px;\r\npadding: 10px;	21	t	0	0	9
51	td#l1_p1	border: 0px solid black;\r\nheight: 200px;\r\nfont-size: 12px;\r\npadding: 10px;	11	t	0	0	9
87	td#l2_p2	width: 200px;\r\nborder-left: 1px dashed black;\r\nfont-size: 11px;\r\npadding: 5px;	22	t	0	0	9
413	a.breadcrumbs:hover	color: blue;\r\ntext-decoration: underlined;	5	t	0	0	8
430	table#footer	width: 700px;\r\nfont-size: 10pt;\r\ncolor: black;\r\nbackground-color: lightgray;\r\nborder: 1px solid black;	1	t	1	-1	6
410	div#breadcrumbs	font-size: 10px;\r\npadding: 10px;	4	t	0	0	8
112	td.subheader-date	font-weight: bold;\r\npadding-right: 30px;	4	t	0	0	5
201	td.sectionheader-left	padding: 0px;	2	t	0	0	14
202	td.sectionheader-middle	padding: 0px;	3	t	0	0	14
203	td.sectionheader-right	padding: 0px;	4	t	0	0	14
28	div#navsec-box	width: 149px;	30	t	0	0	4
27	div#pagetitle	clear: right;\r\ncolor: white; background-color: green;\r\nfont-size: 14px;\r\nfont-weight: bold;\r\npadding: 10px 0 10px 10px;	3	t	0	0	8
160	table#l1	width: 100%;	10	t	0	0	9
580	td#main-right	padding: 0;	2	t	0	0	8
46	div#header-flash		2	t	0	0	2
438	table#main	width: 700px;\r\nborder-spacing: 0px;\r\nborder: 0;	1	t	1	-1	8
164	div#sidebar-box		1	t	0	0	11
15	div#container	text-align: left;	1	t	0	0	0
17	table#footer	width: 100%;\r\nclear: both;\r\nfont-size: 10px;\r\ncolor: white;\r\nbackground-color: gray;\r\nborder: 1px solid brown;	1	t	0	0	6
45	a.navpri:active	font-size: 14px; font-weight: bold;\r\ncolor: red;\r\ntext-decoration: none;	55	t	0	0	3
135	#layer4	visibility: hidden;\r\nleft: 507; top: 135;\r\nposition: absolute; \r\nwidth: 200; height: 200; \r\nbackground-color: transparent;\r\nlayer-background-color: transparent;\r\nz-index:90;	4	t	0	0	10
136	#layer5	visibility: hidden;\r\nleft: 607; top: 135;\r\nposition: absolute; \r\nwidth: 200; height: 200; \r\nbackground-color: transparent;\r\nlayer-background-color: transparent;\r\nz-index:90;	5	t	0	0	10
155	#layer6	visibility: hidden;\r\nleft: 707; top: 135;\r\nposition: absolute; \r\nwidth: 200; height: 200; \r\nbackground-color: transparent;\r\nlayer-background-color: transparent;\r\nz-index:90;	6	t	0	0	10
26	table#navpri	empty-cells: show;	50	t	0	0	3
94	td.navpri-right	padding: 0;\r\nborder-left: 1px solid black;\r\nbackground-color: gray;	51	t	0	0	3
93	td.navpri-left	background-color: gray;\r\nwidth: 200px;	51	t	0	0	3
142	td.dhtml-off	background-color: gray;\r\nheight: 31px;\r\npadding: 0px 3px 0px 3px;\r\nborder-bottom: 1px solid black;	21	t	0	0	10
403	div#header-logo	width: 200px; height: 100px;\r\nborder: 1px solid red;\r\nbackground: url("/design/logo.gif") 0 0 no-repeat white;\r\nfloat: left;	1	t	0	0	2
41	a.navpri:link	font-size: 14px; font-weight: bold;\r\ncolor: white;\r\ntext-decoration: none;	52	t	0	0	3
42	a.navpri:visited	font-size: 14px; font-weight: bold;\r\ncolor: white;\r\ntext-decoration: none;	53	t	0	0	3
132	#layer1	visibility: hidden;\r\nleft: 207; top: 135;\r\nposition: absolute; \r\nwidth: 200; height: 200; \r\nbackground-color: transparent; \r\nlayer-background-color: transparent; \r\nz-index:90;	1	t	0	0	10
134	#layer3	visibility: hidden;\r\nleft: 407; top: 135;\r\nposition: absolute; \r\nwidth: 200; height: 200; \r\nbackground-color: transparent;\r\nlayer-background-color: transparent;\r\nz-index:90;	3	t	0	0	10
29	table#subheader	border: 1px solid purple;\r\nfont-size: 12px;\r\nfont-style: normal;\r\ncolor: white;\r\nempty-cells: show;	1	t	0	0	5
40	td.navpri	padding: 5px;\r\nheight: 25px; width: 100px;\r\ntext-align: center;\r\nborder-left: 1px solid black;	51	t	0	0	3
141	table.dhtml	border-top: 1px solid black;\r\nborder-left: 1px solid black;\r\nborder-right: 1px solid black;	20	t	0	0	10
133	#layer2	visibility: hidden;\r\nleft: 318; top: 135;\r\nposition: absolute; \r\nwidth: 200; height: 200; \r\nbackground-color: transparent;\r\nlayer-background-color: transparent;\r\nz-index:90;	2	t	0	0	10
633	td#l3_p3	padding: 10px;\r\nborder-top: 1px dashed black;	33	t	0	0	9
25	div#header	height: 102px; \r\nborder: 1px solid green;	1	t	0	0	2
579	td#main-left	background-color: lightgray;\r\nwidth: 150px;\r\npadding: 0;	2	t	0	0	8
498	td.search-button	padding: 0px 0px 0px 2px;	5	t	0	0	12
485	input.search	background: #E0E0E0;\r\nborder: 1px solid black;\r\npadding: 0px 0px 0px 2px;\r\nfont-size: 12px;	4	t	0	0	12
481	td.search-input	padding: 1px 0px 0px 0px;	4	t	0	0	12
482	td.search-word	width: 55px; height: 22px;\r\nbackground: url("/design/search-bg.gif") 0px 6px no-repeat;	2	t	0	0	12
486	div#search	float: right;\r\nmargin: 50px 25px 0 0;	1	t	0	0	12
480	table.search	empty-cells: show;	2	t	0	0	12
200	table#sectionheader	height: 25px;\r\nbackground-color: brown;	1	t	0	0	14
30	a.subheader:link	font-size: 12px;\r\ntext-decoration: none;\r\ncolor: green;	12	t	0	0	5
31	a.subheader:visited	font-size: 12px;\r\ntext-decoration: none;\r\ncolor: green;	13	t	0	0	5
32	a.subheader:hover	font-size: 12px;\r\ntext-decoration: underline;\r\ncolor: green;	14	t	0	0	5
33	a.subheader:active	font-size: 12px;\r\ntext-decoration: underline;\r\ncolor: green;	15	t	0	0	5
39	td.subheader	padding: 5px 10px 5px 10px;	10	t	0	0	5
396	a.subheader:active	font-size: 12pt;\r\ntext-decoration: underline;	15	t	1	-1	5
467	td.subheader-left	width: 100%;	2	t	1	-1	5
469	td.subheader-right		11	t	1	-1	5
465	td.subheader	font-size: 12pt;\r\nfont-style: normal;\r\ncolor: black;	10	t	1	-1	5
441	table#subheader	width: 702px;\r\nbackground-color: lightgray;\r\nborder: 1px solid black;\r\nempty-cells: show;	1	t	1	-1	5
76	td.navpri-off	background-color: gray;	58	t	0	0	3
44	a.navpri:hover	font-size: 14px; font-weight: bold;\r\ncolor: red;\r\ntext-decoration: none;	54	t	0	0	3
161	td.navpri-on	background-color: green;	59	t	0	0	3
62	table.sitemap	border-left: 1px solid black;\r\nmargin-top: 10px;\r\nmargin-bottom: 10px;	1	t	0	0	7
440	table.sitemap	border-left: 1px solid black;\r\nmargin-top: 10px;\r\nmargin-bottom: 10px;	1	t	1	-1	7
464	td.sitemap	padding: 10px;\r\nwidth: 150px;\r\nborder-right: 1px solid black;	2	t	1	-1	7
431	div#header	width: 700px;\r\nborder: 1px solid black;	26	t	1	-1	2
210	div#navquat-box		1	t	0	0	15
162	table#main	border: 1px solid blue;	1	t	0	0	8
163	div.navsec-on	background-color: #553333;	37	t	0	0	4
466	td.subheader-date	font-size: 10pt;\r\ncolor: black;\r\nfont-weight: bold;	4	t	1	-1	5
211	div#navquat-top		2	t	0	0	15
416	div#pagetitle	color: black;\r\nfont-size: 14pt;\r\nfont-weight: bold;\r\nmargin: 10px 0 10px 0;	3	t	1	-1	8
212	div.navquat		3	t	0	0	15
213	div.navquat-on		4	t	0	0	15
581	td#main-right	padding: 0px 0px 10px 0px;	2	t	1	-1	8
68	td.navpri-over	background-color: gray;	56	t	0	0	3
214	div.navquat-off		5	t	0	0	15
215	div.navquat-over		6	t	0	0	15
216	div#navquat-bottom		7	t	0	0	15
220	a.navquat:link		10	t	0	0	15
556	a.navpri-on:link		60	t	0	0	3
557	a.navpri-on:visited		61	t	0	0	3
558	a.navpri-on: hover		62	t	0	0	3
559	a.navpri-on: active		63	t	0	0	3
221	a.navquat:visited		11	t	0	0	15
63	td.sitemap	padding: 10px;\r\nwidth: 150px;\r\nborder-right: 1px solid black;	2	t	0	0	7
222	a.navquat:hover		12	t	0	0	15
223	a.navquat:active		13	t	0	0	15
250	div#commentform		1	t	0	0	16
251	form#commentform		2	t	0	0	16
252	table#commentform		3	t	0	0	16
253	td.commentform		4	t	0	0	16
254	input.commentfield		5	t	0	0	16
255	textarea.commentfield		6	t	0	0	16
256	input.commentbutton		7	t	0	0	16
260	div.comments		8	t	0	0	16
264	div.comment		12	t	0	0	16
261	.commentlocation		9	t	0	0	16
262	.commentname		10	t	0	0	16
263	.commenttime		11	t	0	0	16
320	div#form		1	t	0	0	19
321	div#forminstructions		2	t	0	0	19
322	table#form		3	t	0	0	19
323	td.formfield		4	t	0	0	19
324	.required		5	t	0	0	19
325	.optional		6	t	0	0	19
326	table.checkboxes		7	t	0	0	19
327	td.checkbox		8	t	0	0	19
328	table.radios		9	t	0	0	19
329	td.radio		10	t	0	0	19
330	td.lyris		11	t	0	0	19
331	table.submit		12	t	0	0	19
332	td.captcha		13	t	0	0	19
333	input.captcha		14	t	0	0	19
334	input.submit		15	t	0	0	19
335	div#thankyou		16	t	0	0	19
\.


--
-- Name: stylesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY stylesheet
    ADD CONSTRAINT stylesheet_pkey PRIMARY KEY (class_id);


--
-- Name: stylesheet_class_name_key; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX stylesheet_class_name_key ON stylesheet USING btree (class_name, level, level_num);


--
-- Name: stylesheet_stylesheetcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY stylesheet
    ADD CONSTRAINT stylesheet_stylesheetcategory_id_fkey FOREIGN KEY (stylesheetcategory_id) REFERENCES stylesheetcategories(stylesheetcategory_id);


--
-- Name: stylesheet; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE stylesheet FROM PUBLIC;
REVOKE ALL ON TABLE stylesheet FROM jcms;
GRANT ALL ON TABLE stylesheet TO jcms;
GRANT ALL ON TABLE stylesheet TO jcmsadmin;
GRANT SELECT ON TABLE stylesheet TO jcmsuser;


--
-- Name: stylesheet_class_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE stylesheet_class_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE stylesheet_class_id_seq FROM jcms;
GRANT ALL ON SEQUENCE stylesheet_class_id_seq TO jcms;
GRANT ALL ON SEQUENCE stylesheet_class_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

