--
-- Calendar extra
--
-- NOTE: also requires new ROOT/WEB-INF/web.xml config parameters site.language and site.country for localization!
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100328');

-- Extras

INSERT INTO extras VALUES (13, NULL, 'Calendar', 'calendar.jsp', 'doc-calendar.jsp');

-- Settings

INSERT INTO settings VALUES (130, 'calendar_date_format', 'EEE, MMMM d', 'java.text.SimpleDateFormat for Calendar event date', false, false);
INSERT INTO settings VALUES (131, 'calendar_monthyear_format', 'MMMM yyyy', 'java.text.SimpleDateFormat for Calendar month/year display', false, false);
INSERT INTO settings VALUES (132, 'calendar_weekstartsmonday', 'false', 'calendar week starts on Monday (true/false)', false, true);
INSERT INTO settings VALUES (133, 'calendar_shortdaynames', 'false', 'calendar displays short day names (Sun, Mon, etc.): (true/false)', false, true);

INSERT INTO settings VALUES (134, 'calendar_eventwindow_left', '300', 'offset from left of calendar event window (int)', false, false);
INSERT INTO settings VALUES (135, 'calendar_eventwindow_top', '300', 'offset from top of calendar event window (int)', false, false);
INSERT INTO settings VALUES (136, 'calendar_eventwindow_width', '500', 'width of calendar event window (int)', false, false);
INSERT INTO settings VALUES (137, 'calendar_eventwindow_height', '50', 'height of calendar event window (int)', false, false);
INSERT INTO settings VALUES (138, 'calendar_eventwindow_theme', 'plain', 'name or path to theme of calendar event window', false, false);

-- Stylesheet

INSERT INTO stylesheetcategories VALUES (23, 'calendar', 23);

INSERT INTO stylesheet VALUES (600, 'div.cal', '', 1, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (601, 'table.cal', '', 2, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (602, 'td.cal-prev', '', 3, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (603, 'td.cal-next', '', 4, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (604, 'td.cal-month', '', 5, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (605, 'td.cal-day', '', 6, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (606, 'td.cal-date', '', 7, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (607, 'td.cal-emptydate', '', 8, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (608, 'td.cal-today', '', 9, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (609, 'td.cal-eventdate', '', 10, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (610, 'td.cal-weekend', '', 11, true, 0, 0, 23);

INSERT INTO stylesheet VALUES (620, 'div.event', '', 20, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (621, 'div.event-title', '', 21, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (622, 'div.event-time', '', 22, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (623, 'div.event-description', '', 23, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (624, 'a.event:link', '', 24, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (625, 'a.event:visited', '', 25, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (626, 'a.event:hover', '', 26, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (627, 'a.event:active', '', 27, true, 0, 0, 23);

-- events table

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
-- Name: event_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE events ALTER COLUMN event_id SET DEFAULT nextval('events_event_id_seq'::regclass);


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
