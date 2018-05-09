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
-- Name: dhtmlcache; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE dhtmlcache (
    accessuser_id integer NOT NULL,
    dhtml character varying,
    updated timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.dhtmlcache OWNER TO jcms;

--
-- Data for Name: dhtmlcache; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY dhtmlcache (accessuser_id, dhtml, updated) FROM stdin;
0	<div id="layer1">\n  <table class="dhtml" cellspacing="0">\n    <tr>\n      <td class="dhtml-off" onMouseOver="this.className='dhtml-on'; showLayer('layer1');" onMouseOut="this.className='dhtml-off'; hideLayer('layer1');" ><a class="dhtml" onMouseOver="showLayer('layer1');" href="/index.jsp?nid=4">Layout 1 Redux</a></td>\n    </tr>\n    <tr>\n      <td class="dhtml-off" onMouseOver="this.className='dhtml-on'; showLayer('layer1');" onMouseOut="this.className='dhtml-off'; hideLayer('layer1');" ><a class="dhtml" onMouseOver="showLayer('layer1');" href="/index.jsp?nid=5">Layout 2 Redux</a></td>\n    </tr>\n    <tr>\n      <td class="dhtml-off" onMouseOver="this.className='dhtml-on'; showLayer('layer1');" onMouseOut="this.className='dhtml-off'; hideLayer('layer1');" ><a class="dhtml" onMouseOver="showLayer('layer1');" href="/index.jsp?nid=6">Layout 3 Redux</a></td>\n    </tr>\n  </table>\n</div>\n\n<div id="layer2">\n  <table class="dhtml" cellspacing="0">\n    <tr>\n      <td class="dhtml-off" onMouseOver="this.className='dhtml-on'; showLayer('layer2');" onMouseOut="this.className='dhtml-off'; hideLayer('layer2');" ><a class="dhtml" onMouseOver="showLayer('layer2');" href="/index.jsp?nid=7">More Lorem</a></td>\n    </tr>\n    <tr>\n      <td class="dhtml-off" onMouseOver="this.className='dhtml-on'; showLayer('layer2');" onMouseOut="this.className='dhtml-off'; hideLayer('layer2');" ><a class="dhtml" onMouseOver="showLayer('layer2');" href="/index.jsp?nid=8">More Ipsum</a></td>\n    </tr>\n  </table>\n</div>\n\n<div id="layer3">\n  <table class="dhtml" cellspacing="0">\n  </table>\n</div>	2008-10-29 17:07:31-05
\.


--
-- Name: dhtmlcache_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY dhtmlcache
    ADD CONSTRAINT dhtmlcache_pkey PRIMARY KEY (accessuser_id);


--
-- Name: dhtmlcache_accessuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY dhtmlcache
    ADD CONSTRAINT dhtmlcache_accessuser_id_fkey FOREIGN KEY (accessuser_id) REFERENCES accessusers(accessuser_id);


--
-- Name: dhtmlcache; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE dhtmlcache FROM PUBLIC;
REVOKE ALL ON TABLE dhtmlcache FROM jcms;
GRANT ALL ON TABLE dhtmlcache TO jcms;
GRANT ALL ON TABLE dhtmlcache TO jcmsadmin;
GRANT SELECT ON TABLE dhtmlcache TO jcmsuser;


--
-- PostgreSQL database dump complete
--

