--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accessroles; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessroles (
    accessrole_id integer NOT NULL,
    accessrole character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone
);


ALTER TABLE public.accessroles OWNER TO jcms;

--
-- Name: accessroles_accessusers; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessroles_accessusers (
    accessrole_id integer NOT NULL,
    accessuser_id integer NOT NULL
);


ALTER TABLE public.accessroles_accessusers OWNER TO jcms;

--
-- Name: accessroles_media; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessroles_media (
    accessrole_id integer NOT NULL,
    mid integer NOT NULL
);


ALTER TABLE public.accessroles_media OWNER TO jcms;

--
-- Name: accessroles_nodes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessroles_nodes (
    accessrole_id integer NOT NULL,
    nid integer NOT NULL
);


ALTER TABLE public.accessroles_nodes OWNER TO jcms;

--
-- Name: accessusers; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessusers (
    accessuser_id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone
);


ALTER TABLE public.accessusers OWNER TO jcms;

--
-- Name: audit; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE audit (
    audit_id integer NOT NULL,
    "timestamp" timestamp(0) with time zone DEFAULT now() NOT NULL,
    tablename character varying NOT NULL,
    key integer NOT NULL,
    action character(1) NOT NULL,
    email character varying NOT NULL,
    description character varying
);


ALTER TABLE public.audit OWNER TO jcms;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE comments (
    comment_id integer NOT NULL,
    cid integer NOT NULL,
    timeposted timestamp(0) with time zone DEFAULT ('now'::text)::timestamp(0) with time zone NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    comment character varying NOT NULL,
    location character varying
);


ALTER TABLE public.comments OWNER TO jcms;

--
-- Name: content; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE content (
    cid integer NOT NULL,
    refid bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL,
    copy character varying,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone,
    label character varying,
    moduleurl character varying,
    moduleabove boolean DEFAULT false NOT NULL,
    modulecontext character varying
);


ALTER TABLE public.content OWNER TO jcms;

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
-- Name: extensions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE extensions (
    extid integer NOT NULL,
    num integer NOT NULL,
    name character varying NOT NULL,
    cpcontext character varying NOT NULL,
    cpurl character varying NOT NULL,
    parent_extid integer
);


ALTER TABLE public.extensions OWNER TO jcms;

--
-- Name: extras; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE extras (
    extra_id integer NOT NULL,
    parent_extra_id integer,
    name character varying NOT NULL,
    cpurl character varying NOT NULL,
    docurl character varying
);


ALTER TABLE public.extras OWNER TO jcms;

--
-- Name: formfieldoptions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE formfieldoptions (
    formfieldoption_id integer NOT NULL,
    formfield_id integer NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    value character varying NOT NULL,
    selected boolean DEFAULT false NOT NULL
);


ALTER TABLE public.formfieldoptions OWNER TO jcms;

--
-- Name: formfields; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE formfields (
    formfield_id integer NOT NULL,
    form_id integer NOT NULL,
    fieldname character varying NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    heading character varying NOT NULL,
    required boolean DEFAULT false NOT NULL,
    textinput boolean DEFAULT false NOT NULL,
    radio boolean DEFAULT false NOT NULL,
    checkbox boolean DEFAULT false NOT NULL,
    textarea boolean DEFAULT false NOT NULL,
    selectmenu boolean DEFAULT false NOT NULL,
    columns integer DEFAULT 1 NOT NULL,
    size integer DEFAULT 20 NOT NULL,
    rows integer DEFAULT 3 NOT NULL,
    cols integer DEFAULT 20 NOT NULL
);


ALTER TABLE public.formfields OWNER TO jcms;

--
-- Name: formlyrislists; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE formlyrislists (
    formlyrislist_id integer NOT NULL,
    form_id integer NOT NULL,
    listname character varying NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE public.formlyrislists OWNER TO jcms;

--
-- Name: forms; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE forms (
    form_id integer NOT NULL,
    title character varying NOT NULL,
    recipientname character varying NOT NULL,
    recipientemail character varying NOT NULL,
    sendername character varying NOT NULL,
    senderemail character varying NOT NULL,
    instructions character varying NOT NULL,
    thankyou character varying NOT NULL,
    confirmationmessage character varying,
    signupinstructions character varying
);


ALTER TABLE public.forms OWNER TO jcms;

--
-- Name: imagerotator; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE imagerotator (
    id integer NOT NULL,
    filename character varying NOT NULL,
    num integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    caption character varying,
    alt character varying
);


ALTER TABLE public.imagerotator OWNER TO jcms;

--
-- Name: layoutpanes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE layoutpanes (
    layoutpane_id integer NOT NULL,
    layout_id integer NOT NULL,
    pane integer DEFAULT 1 NOT NULL,
    vposition integer DEFAULT 1 NOT NULL,
    hposition integer DEFAULT 1 NOT NULL,
    colspan integer DEFAULT 1 NOT NULL,
    rowspan integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.layoutpanes OWNER TO jcms;

--
-- Name: layouts_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE layouts_layout_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.layouts_layout_id_seq OWNER TO jcms;

--
-- Name: layouts; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE layouts (
    layout_id integer DEFAULT nextval('layouts_layout_id_seq'::regclass) NOT NULL,
    layout character varying NOT NULL,
    cols integer NOT NULL,
    rows integer NOT NULL,
    num integer NOT NULL
);


ALTER TABLE public.layouts OWNER TO jcms;

--
-- Name: media; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE media (
    mid integer NOT NULL,
    refid bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL,
    filename character varying NOT NULL,
    filesize bigint NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone
);


ALTER TABLE public.media OWNER TO jcms;

SET default_with_oids = true;

--
-- Name: nodelinks; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE nodelinks (
    nlid integer NOT NULL,
    nid integer NOT NULL,
    pid integer,
    mid integer,
    url character varying,
    starttime timestamp(0) with time zone DEFAULT now() NOT NULL,
    refid bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL,
    redirectnid integer
);


ALTER TABLE public.nodelinks OWNER TO jcms;

--
-- Name: nodes_current; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodes_current AS
    SELECT nodelinks.nid, max(nodelinks.starttime) AS starttime FROM nodelinks WHERE (nodelinks.starttime < now()) GROUP BY nodelinks.nid ORDER BY nodelinks.nid;


ALTER TABLE public.nodes_current OWNER TO jcms;

--
-- Name: nodelinks_current; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodelinks_current AS
    SELECT nodelinks.nlid, nodelinks.nid, nodelinks.pid, nodelinks.mid, nodelinks.url, nodelinks.starttime, nodelinks.refid, nodelinks.redirectnid FROM nodelinks, nodes_current WHERE ((nodelinks.nid = nodes_current.nid) AND (nodelinks.starttime = nodes_current.starttime));


ALTER TABLE public.nodelinks_current OWNER TO jcms;

--
-- Name: nodelinks_future; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW nodelinks_future AS
    SELECT nodelinks.nlid, nodelinks.nid, nodelinks.pid, nodelinks.mid, nodelinks.url, nodelinks.starttime, nodelinks.refid, nodelinks.redirectnid FROM nodelinks WHERE ((nodelinks.pid IS NOT NULL) AND (nodelinks.starttime > now()));


ALTER TABLE public.nodelinks_future OWNER TO jcms;

--
-- Name: nodes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE nodes (
    nid integer NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    nodename character varying DEFAULT 'NEW NODE'::character varying NOT NULL,
    parent_nid integer,
    refid bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    alias character varying,
    updated timestamp(0) with time zone,
    ssl boolean DEFAULT false NOT NULL
);


ALTER TABLE public.nodes OWNER TO jcms;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE pages (
    pid integer NOT NULL,
    metakeywords character varying,
    metadescription character varying,
    headtitle character varying,
    title character varying,
    refid bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone,
    layout_id integer NOT NULL,
    label character varying,
    othermeta character varying
);


ALTER TABLE public.pages OWNER TO jcms;

SET default_with_oids = false;

--
-- Name: pages_content; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE pages_content (
    pid integer NOT NULL,
    cid integer NOT NULL,
    pane integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.pages_content OWNER TO jcms;

--
-- Name: photos; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE photos (
    photo_id integer NOT NULL,
    photoset_id integer,
    num integer DEFAULT 1 NOT NULL,
    timeposted timestamp(0) without time zone DEFAULT now() NOT NULL,
    imagefile character varying NOT NULL,
    imagewidth integer NOT NULL,
    imageheight integer NOT NULL,
    imagealt character varying,
    caption character varying,
    thumbnail character varying
);


ALTER TABLE public.photos OWNER TO jcms;

--
-- Name: photosets; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE photosets (
    photoset_id integer NOT NULL,
    title character varying NOT NULL,
    created timestamp(0) without time zone DEFAULT now() NOT NULL,
    description character varying,
    shootdate character varying,
    credit character varying
);


ALTER TABLE public.photosets OWNER TO jcms;

--
-- Name: postedformfields; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE postedformfields (
    postedform_id integer NOT NULL,
    fieldname character varying NOT NULL,
    num integer NOT NULL,
    value character varying
);


ALTER TABLE public.postedformfields OWNER TO jcms;

--
-- Name: postedforms; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE postedforms (
    postedform_id integer NOT NULL,
    form_id integer NOT NULL,
    timeposted timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.postedforms OWNER TO jcms;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE settings (
    setting_id integer NOT NULL,
    setting_name character varying NOT NULL,
    setting_value character varying NOT NULL,
    description character varying NOT NULL,
    password boolean DEFAULT false NOT NULL
);


ALTER TABLE public.settings OWNER TO jcms;

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
-- Name: stylesheetcategories; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE stylesheetcategories (
    stylesheetcategory_id integer NOT NULL,
    stylesheetcategory character varying NOT NULL,
    num integer
);


ALTER TABLE public.stylesheetcategories OWNER TO jcms;

--
-- Name: updatelog; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE updatelog (
    updated timestamp(0) without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE public.updatelog OWNER TO jcms;

--
-- Name: users; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users (
    uid integer NOT NULL,
    lastname character varying NOT NULL,
    firstname character varying NOT NULL,
    email character varying NOT NULL,
    password character varying,
    admin boolean DEFAULT false NOT NULL,
    editor boolean DEFAULT false NOT NULL,
    designer boolean DEFAULT false NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone,
    ldapuid character varying
);


ALTER TABLE public.users OWNER TO jcms;

--
-- Name: users_extensions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_extensions (
    uid integer NOT NULL,
    extid integer NOT NULL
);


ALTER TABLE public.users_extensions OWNER TO jcms;

--
-- Name: users_extras; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_extras (
    uid integer NOT NULL,
    extra_id integer NOT NULL
);


ALTER TABLE public.users_extras OWNER TO jcms;

--
-- Name: users_nodes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_nodes (
    uid integer NOT NULL,
    nid integer NOT NULL
);


ALTER TABLE public.users_nodes OWNER TO jcms;

--
-- Name: utilitylinks; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE utilitylinks (
    utilitylink_id integer NOT NULL,
    location character(1) NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    link_text character varying NOT NULL,
    link_url character varying NOT NULL,
    openwindow boolean DEFAULT false NOT NULL
);


ALTER TABLE public.utilitylinks OWNER TO jcms;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: sam
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO sam;

--
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE accessroles_accessrole_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.accessroles_accessrole_id_seq OWNER TO jcms;

--
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE accessroles_accessrole_id_seq OWNED BY accessroles.accessrole_id;


--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE accessusers_accessuser_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.accessusers_accessuser_id_seq OWNER TO jcms;

--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE accessusers_accessuser_id_seq OWNED BY accessusers.accessuser_id;


--
-- Name: audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE audit_audit_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.audit_audit_id_seq OWNER TO jcms;

--
-- Name: audit_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE audit_audit_id_seq OWNED BY audit.audit_id;


--
-- Name: comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE comments_comment_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.comments_comment_id_seq OWNER TO jcms;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE comments_comment_id_seq OWNED BY comments.comment_id;


--
-- Name: content_cid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE content_cid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.content_cid_seq OWNER TO jcms;

--
-- Name: content_cid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE content_cid_seq OWNED BY content.cid;


--
-- Name: extensions_extid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE extensions_extid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.extensions_extid_seq OWNER TO jcms;

--
-- Name: extensions_extid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE extensions_extid_seq OWNED BY extensions.extid;


--
-- Name: extras_extra_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE extras_extra_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.extras_extra_id_seq OWNER TO jcms;

--
-- Name: extras_extra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE extras_extra_id_seq OWNED BY extras.extra_id;


--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE formfieldoptions_formfieldoption_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formfieldoptions_formfieldoption_id_seq OWNER TO jcms;

--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE formfieldoptions_formfieldoption_id_seq OWNED BY formfieldoptions.formfieldoption_id;


--
-- Name: formfields_formfield_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE formfields_formfield_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formfields_formfield_id_seq OWNER TO jcms;

--
-- Name: formfields_formfield_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE formfields_formfield_id_seq OWNED BY formfields.formfield_id;


--
-- Name: formlyrislists_formlyrislist_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE formlyrislists_formlyrislist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.formlyrislists_formlyrislist_id_seq OWNER TO jcms;

--
-- Name: formlyrislists_formlyrislist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE formlyrislists_formlyrislist_id_seq OWNED BY formlyrislists.formlyrislist_id;


--
-- Name: forms_form_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE forms_form_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.forms_form_id_seq OWNER TO jcms;

--
-- Name: forms_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE forms_form_id_seq OWNED BY forms.form_id;


--
-- Name: imagerotator_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE imagerotator_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.imagerotator_id_seq OWNER TO jcms;

--
-- Name: imagerotator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE imagerotator_id_seq OWNED BY imagerotator.id;


--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE layoutpanes_layoutpane_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.layoutpanes_layoutpane_id_seq OWNER TO jcms;

--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE layoutpanes_layoutpane_id_seq OWNED BY layoutpanes.layoutpane_id;


--
-- Name: media_mid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE media_mid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.media_mid_seq OWNER TO jcms;

--
-- Name: media_mid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE media_mid_seq OWNED BY media.mid;


--
-- Name: nodelinks_nlid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE nodelinks_nlid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nodelinks_nlid_seq OWNER TO jcms;

--
-- Name: nodelinks_nlid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE nodelinks_nlid_seq OWNED BY nodelinks.nlid;


--
-- Name: nodes_nid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE nodes_nid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nodes_nid_seq OWNER TO jcms;

--
-- Name: nodes_nid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE nodes_nid_seq OWNED BY nodes.nid;


--
-- Name: pages_pid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE pages_pid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pages_pid_seq OWNER TO jcms;

--
-- Name: pages_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE pages_pid_seq OWNED BY pages.pid;


--
-- Name: photos_photo_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE photos_photo_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.photos_photo_id_seq OWNER TO jcms;

--
-- Name: photos_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE photos_photo_id_seq OWNED BY photos.photo_id;


--
-- Name: photosets_photoset_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE photosets_photoset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.photosets_photoset_id_seq OWNER TO jcms;

--
-- Name: photosets_photoset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE photosets_photoset_id_seq OWNED BY photosets.photoset_id;


--
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE postedforms_postedform_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.postedforms_postedform_id_seq OWNER TO jcms;

--
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE postedforms_postedform_id_seq OWNED BY postedforms.postedform_id;


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
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE users_uid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO jcms;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE users_uid_seq OWNED BY users.uid;


--
-- Name: utilitylinks_utilitylink_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE utilitylinks_utilitylink_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.utilitylinks_utilitylink_id_seq OWNER TO jcms;

--
-- Name: utilitylinks_utilitylink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE utilitylinks_utilitylink_id_seq OWNED BY utilitylinks.utilitylink_id;


--
-- Name: accessrole_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE accessroles ALTER COLUMN accessrole_id SET DEFAULT nextval('accessroles_accessrole_id_seq'::regclass);


--
-- Name: accessuser_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE accessusers ALTER COLUMN accessuser_id SET DEFAULT nextval('accessusers_accessuser_id_seq'::regclass);


--
-- Name: audit_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE audit ALTER COLUMN audit_id SET DEFAULT nextval('audit_audit_id_seq'::regclass);


--
-- Name: comment_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE comments ALTER COLUMN comment_id SET DEFAULT nextval('comments_comment_id_seq'::regclass);


--
-- Name: cid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE content ALTER COLUMN cid SET DEFAULT nextval('content_cid_seq'::regclass);


--
-- Name: extid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE extensions ALTER COLUMN extid SET DEFAULT nextval('extensions_extid_seq'::regclass);


--
-- Name: extra_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE extras ALTER COLUMN extra_id SET DEFAULT nextval('extras_extra_id_seq'::regclass);


--
-- Name: formfieldoption_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE formfieldoptions ALTER COLUMN formfieldoption_id SET DEFAULT nextval('formfieldoptions_formfieldoption_id_seq'::regclass);


--
-- Name: formfield_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE formfields ALTER COLUMN formfield_id SET DEFAULT nextval('formfields_formfield_id_seq'::regclass);


--
-- Name: formlyrislist_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE formlyrislists ALTER COLUMN formlyrislist_id SET DEFAULT nextval('formlyrislists_formlyrislist_id_seq'::regclass);


--
-- Name: form_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE forms ALTER COLUMN form_id SET DEFAULT nextval('forms_form_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE imagerotator ALTER COLUMN id SET DEFAULT nextval('imagerotator_id_seq'::regclass);


--
-- Name: layoutpane_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE layoutpanes ALTER COLUMN layoutpane_id SET DEFAULT nextval('layoutpanes_layoutpane_id_seq'::regclass);


--
-- Name: mid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE media ALTER COLUMN mid SET DEFAULT nextval('media_mid_seq'::regclass);


--
-- Name: nlid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE nodelinks ALTER COLUMN nlid SET DEFAULT nextval('nodelinks_nlid_seq'::regclass);


--
-- Name: nid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE nodes ALTER COLUMN nid SET DEFAULT nextval('nodes_nid_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE pages ALTER COLUMN pid SET DEFAULT nextval('pages_pid_seq'::regclass);


--
-- Name: photo_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE photos ALTER COLUMN photo_id SET DEFAULT nextval('photos_photo_id_seq'::regclass);


--
-- Name: photoset_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE photosets ALTER COLUMN photoset_id SET DEFAULT nextval('photosets_photoset_id_seq'::regclass);


--
-- Name: postedform_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE postedforms ALTER COLUMN postedform_id SET DEFAULT nextval('postedforms_postedform_id_seq'::regclass);


--
-- Name: class_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE stylesheet ALTER COLUMN class_id SET DEFAULT nextval('stylesheet_class_id_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);


--
-- Name: utilitylink_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE utilitylinks ALTER COLUMN utilitylink_id SET DEFAULT nextval('utilitylinks_utilitylink_id_seq'::regclass);


--
-- Name: accessroles_accessrole_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY accessroles
    ADD CONSTRAINT accessroles_accessrole_key UNIQUE (accessrole);


--
-- Name: accessroles_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY accessroles
    ADD CONSTRAINT accessroles_pkey PRIMARY KEY (accessrole_id);


--
-- Name: accessusers_email_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY accessusers
    ADD CONSTRAINT accessusers_email_key UNIQUE (email);


--
-- Name: accessusers_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY accessusers
    ADD CONSTRAINT accessusers_pkey PRIMARY KEY (accessuser_id);


--
-- Name: audit_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (audit_id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- Name: content_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY content
    ADD CONSTRAINT content_pkey PRIMARY KEY (cid);


--
-- Name: dhtmlcache_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY dhtmlcache
    ADD CONSTRAINT dhtmlcache_pkey PRIMARY KEY (accessuser_id);


--
-- Name: extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (extid);


--
-- Name: extras_name_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY extras
    ADD CONSTRAINT extras_name_key UNIQUE (name);


--
-- Name: extras_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY extras
    ADD CONSTRAINT extras_pkey PRIMARY KEY (extra_id);


--
-- Name: formfieldoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY formfieldoptions
    ADD CONSTRAINT formfieldoptions_pkey PRIMARY KEY (formfieldoption_id);


--
-- Name: formfields_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY formfields
    ADD CONSTRAINT formfields_pkey PRIMARY KEY (formfield_id);


--
-- Name: formlyrislists_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY formlyrislists
    ADD CONSTRAINT formlyrislists_pkey PRIMARY KEY (formlyrislist_id);


--
-- Name: forms_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (form_id);


--
-- Name: imagerotator_filename_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY imagerotator
    ADD CONSTRAINT imagerotator_filename_key UNIQUE (filename);


--
-- Name: imagerotator_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY imagerotator
    ADD CONSTRAINT imagerotator_pkey PRIMARY KEY (id);


--
-- Name: layoutpanes_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layoutpanes
    ADD CONSTRAINT layoutpanes_pkey PRIMARY KEY (layoutpane_id);


--
-- Name: layouts_num_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layouts
    ADD CONSTRAINT layouts_num_key UNIQUE (num);


--
-- Name: layouts_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layouts
    ADD CONSTRAINT layouts_pkey PRIMARY KEY (layout_id);


--
-- Name: media_filename_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_filename_key UNIQUE (filename);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (mid);


--
-- Name: nodelinks_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY nodelinks
    ADD CONSTRAINT nodelinks_pkey PRIMARY KEY (nlid);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (nid);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (pid);


--
-- Name: photos_imagefile_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_imagefile_key UNIQUE (imagefile);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (photo_id);


--
-- Name: photosets_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY photosets
    ADD CONSTRAINT photosets_pkey PRIMARY KEY (photoset_id);


--
-- Name: photosets_title_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY photosets
    ADD CONSTRAINT photosets_title_key UNIQUE (title);


--
-- Name: postedforms_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY postedforms
    ADD CONSTRAINT postedforms_pkey PRIMARY KEY (postedform_id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (setting_id);


--
-- Name: stylesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY stylesheet
    ADD CONSTRAINT stylesheet_pkey PRIMARY KEY (class_id);


--
-- Name: stylesheetcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY stylesheetcategories
    ADD CONSTRAINT stylesheetcategories_pkey PRIMARY KEY (stylesheetcategory_id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_ldapuid_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_ldapuid_key UNIQUE (ldapuid);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: utilitylinks_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY utilitylinks
    ADD CONSTRAINT utilitylinks_pkey PRIMARY KEY (utilitylink_id);


--
-- Name: audit_email_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX audit_email_idx ON audit USING btree (email);


--
-- Name: audit_tablename_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX audit_tablename_idx ON audit USING btree (tablename);


--
-- Name: content_label_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX content_label_idx ON content USING btree (label);


--
-- Name: formfieldoptions_unique_num; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX formfieldoptions_unique_num ON formfieldoptions USING btree (formfield_id, num);


--
-- Name: formfieldoptions_unique_value; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX formfieldoptions_unique_value ON formfieldoptions USING btree (formfield_id, value);


--
-- Name: formfields_unique_name; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX formfields_unique_name ON formfields USING btree (form_id, fieldname);


--
-- Name: formfields_unique_num; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX formfields_unique_num ON formfields USING btree (form_id, num);


--
-- Name: formlyrislists_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX formlyrislists_unique ON formlyrislists USING btree (form_id, listname);


--
-- Name: forms_unique_title; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX forms_unique_title ON forms USING btree (title);


--
-- Name: nodelinks_nid; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX nodelinks_nid ON nodelinks USING btree (nid);


--
-- Name: nodelinks_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX nodelinks_unique ON nodelinks USING btree (nid, starttime);


--
-- Name: nodes_alias_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX nodes_alias_unique ON nodes USING btree (alias);


--
-- Name: nodes_unique_refid; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX nodes_unique_refid ON nodes USING btree (refid);


--
-- Name: pages_content_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX pages_content_unique ON pages_content USING btree (pid, cid, pane);


--
-- Name: pages_label_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX pages_label_unique ON pages USING btree (label);


--
-- Name: pages_unique_refid; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX pages_unique_refid ON pages USING btree (refid);


--
-- Name: settings_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX settings_unique ON settings USING btree (setting_name);


--
-- Name: stylesheet_class_name_key; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX stylesheet_class_name_key ON stylesheet USING btree (class_name, level, level_num);


--
-- Name: updatelog_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX updatelog_unique ON updatelog USING btree (name, value);


--
-- Name: users_nodes_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX users_nodes_unique ON users_nodes USING btree (uid, nid);


--
-- Name: accessroles_accessusers_accessrole_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_accessusers
    ADD CONSTRAINT accessroles_accessusers_accessrole_id_fkey FOREIGN KEY (accessrole_id) REFERENCES accessroles(accessrole_id);


--
-- Name: accessroles_accessusers_accessuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_accessusers
    ADD CONSTRAINT accessroles_accessusers_accessuser_id_fkey FOREIGN KEY (accessuser_id) REFERENCES accessusers(accessuser_id);


--
-- Name: accessroles_media_accessrole_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_media
    ADD CONSTRAINT accessroles_media_accessrole_id_fkey FOREIGN KEY (accessrole_id) REFERENCES accessroles(accessrole_id);


--
-- Name: accessroles_media_mid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_media
    ADD CONSTRAINT accessroles_media_mid_fkey FOREIGN KEY (mid) REFERENCES media(mid);


--
-- Name: accessroles_nodes_accessrole_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_nodes
    ADD CONSTRAINT accessroles_nodes_accessrole_id_fkey FOREIGN KEY (accessrole_id) REFERENCES accessroles(accessrole_id);


--
-- Name: accessroles_nodes_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_nodes
    ADD CONSTRAINT accessroles_nodes_nid_fkey FOREIGN KEY (nid) REFERENCES nodes(nid);


--
-- Name: comments_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_cid_fkey FOREIGN KEY (cid) REFERENCES content(cid);


--
-- Name: dhtmlcache_accessuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY dhtmlcache
    ADD CONSTRAINT dhtmlcache_accessuser_id_fkey FOREIGN KEY (accessuser_id) REFERENCES accessusers(accessuser_id);


--
-- Name: extras_parent_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY extras
    ADD CONSTRAINT extras_parent_extra_id_fkey FOREIGN KEY (parent_extra_id) REFERENCES extras(extra_id);


--
-- Name: formfieldoptions_formfield_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formfieldoptions
    ADD CONSTRAINT formfieldoptions_formfield_id_fkey FOREIGN KEY (formfield_id) REFERENCES formfields(formfield_id);


--
-- Name: formfields_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formfields
    ADD CONSTRAINT formfields_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: formlyrislists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formlyrislists
    ADD CONSTRAINT formlyrislists_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: layoutpanes_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY layoutpanes
    ADD CONSTRAINT layoutpanes_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES layouts(layout_id);


--
-- Name: nodelinks_mid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY nodelinks
    ADD CONSTRAINT nodelinks_mid_fkey FOREIGN KEY (mid) REFERENCES media(mid);


--
-- Name: nodelinks_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY nodelinks
    ADD CONSTRAINT nodelinks_pid_fkey FOREIGN KEY (pid) REFERENCES pages(pid);


--
-- Name: nodelinks_redirectnid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY nodelinks
    ADD CONSTRAINT nodelinks_redirectnid_fkey FOREIGN KEY (redirectnid) REFERENCES nodes(nid);


--
-- Name: pages_content_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pages_content
    ADD CONSTRAINT pages_content_cid_fkey FOREIGN KEY (cid) REFERENCES content(cid);


--
-- Name: pages_content_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pages_content
    ADD CONSTRAINT pages_content_pid_fkey FOREIGN KEY (pid) REFERENCES pages(pid);


--
-- Name: pages_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES layouts(layout_id);


--
-- Name: photos_photoset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_photoset_id_fkey FOREIGN KEY (photoset_id) REFERENCES photosets(photoset_id);


--
-- Name: postedformfields_postedform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY postedformfields
    ADD CONSTRAINT postedformfields_postedform_id_fkey FOREIGN KEY (postedform_id) REFERENCES postedforms(postedform_id);


--
-- Name: postedforms_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY postedforms
    ADD CONSTRAINT postedforms_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: stylesheet_stylesheetcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY stylesheet
    ADD CONSTRAINT stylesheet_stylesheetcategory_id_fkey FOREIGN KEY (stylesheetcategory_id) REFERENCES stylesheetcategories(stylesheetcategory_id);


--
-- Name: users_extensions_extid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extensions
    ADD CONSTRAINT users_extensions_extid_fkey FOREIGN KEY (extid) REFERENCES extensions(extid);


--
-- Name: users_extensions_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extensions
    ADD CONSTRAINT users_extensions_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: users_extras_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extras
    ADD CONSTRAINT users_extras_extra_id_fkey FOREIGN KEY (extra_id) REFERENCES extras(extra_id);


--
-- Name: users_extras_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extras
    ADD CONSTRAINT users_extras_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: users_nodes_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_nodes
    ADD CONSTRAINT users_nodes_nid_fkey FOREIGN KEY (nid) REFERENCES nodes(nid);


--
-- Name: users_nodes_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_nodes
    ADD CONSTRAINT users_nodes_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: accessroles; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessroles FROM PUBLIC;
REVOKE ALL ON TABLE accessroles FROM jcms;
GRANT ALL ON TABLE accessroles TO jcms;
GRANT ALL ON TABLE accessroles TO jcmsadmin;
GRANT SELECT ON TABLE accessroles TO jcmsuser;


--
-- Name: accessroles_accessusers; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessroles_accessusers FROM PUBLIC;
REVOKE ALL ON TABLE accessroles_accessusers FROM jcms;
GRANT ALL ON TABLE accessroles_accessusers TO jcms;
GRANT ALL ON TABLE accessroles_accessusers TO jcmsadmin;
GRANT SELECT ON TABLE accessroles_accessusers TO jcmsuser;


--
-- Name: accessroles_media; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessroles_media FROM PUBLIC;
REVOKE ALL ON TABLE accessroles_media FROM jcms;
GRANT ALL ON TABLE accessroles_media TO jcms;
GRANT SELECT ON TABLE accessroles_media TO jcmsuser;
GRANT ALL ON TABLE accessroles_media TO jcmsadmin;


--
-- Name: accessroles_nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessroles_nodes FROM PUBLIC;
REVOKE ALL ON TABLE accessroles_nodes FROM jcms;
GRANT ALL ON TABLE accessroles_nodes TO jcms;
GRANT ALL ON TABLE accessroles_nodes TO jcmsadmin;
GRANT SELECT ON TABLE accessroles_nodes TO jcmsuser;


--
-- Name: accessusers; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE accessusers FROM PUBLIC;
REVOKE ALL ON TABLE accessusers FROM jcms;
GRANT ALL ON TABLE accessusers TO jcms;
GRANT ALL ON TABLE accessusers TO jcmsadmin;
GRANT SELECT ON TABLE accessusers TO jcmsuser;


--
-- Name: audit; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE audit FROM PUBLIC;
REVOKE ALL ON TABLE audit FROM jcms;
GRANT ALL ON TABLE audit TO jcms;
GRANT SELECT,INSERT ON TABLE audit TO jcmsadmin;
GRANT INSERT ON TABLE audit TO jcmsuser;


--
-- Name: comments; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE comments FROM PUBLIC;
REVOKE ALL ON TABLE comments FROM jcms;
GRANT ALL ON TABLE comments TO jcms;
GRANT SELECT,INSERT ON TABLE comments TO jcmsuser;
GRANT ALL ON TABLE comments TO jcmsadmin;


--
-- Name: content; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE content FROM PUBLIC;
REVOKE ALL ON TABLE content FROM jcms;
GRANT ALL ON TABLE content TO jcms;
GRANT SELECT ON TABLE content TO jcmsuser;
GRANT ALL ON TABLE content TO jcmsadmin;


--
-- Name: dhtmlcache; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE dhtmlcache FROM PUBLIC;
REVOKE ALL ON TABLE dhtmlcache FROM jcms;
GRANT ALL ON TABLE dhtmlcache TO jcms;
GRANT ALL ON TABLE dhtmlcache TO jcmsadmin;
GRANT SELECT ON TABLE dhtmlcache TO jcmsuser;


--
-- Name: extensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE extensions FROM PUBLIC;
REVOKE ALL ON TABLE extensions FROM jcms;
GRANT ALL ON TABLE extensions TO jcms;
GRANT ALL ON TABLE extensions TO jcmsadmin;


--
-- Name: extras; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE extras FROM PUBLIC;
REVOKE ALL ON TABLE extras FROM jcms;
GRANT ALL ON TABLE extras TO jcms;
GRANT SELECT ON TABLE extras TO jcmsadmin;


--
-- Name: formfieldoptions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formfieldoptions FROM PUBLIC;
REVOKE ALL ON TABLE formfieldoptions FROM jcms;
GRANT ALL ON TABLE formfieldoptions TO jcms;
GRANT ALL ON TABLE formfieldoptions TO jcmsadmin;
GRANT SELECT ON TABLE formfieldoptions TO jcmsuser;


--
-- Name: formfields; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formfields FROM PUBLIC;
REVOKE ALL ON TABLE formfields FROM jcms;
GRANT ALL ON TABLE formfields TO jcms;
GRANT ALL ON TABLE formfields TO jcmsadmin;
GRANT SELECT ON TABLE formfields TO jcmsuser;


--
-- Name: formlyrislists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formlyrislists FROM PUBLIC;
REVOKE ALL ON TABLE formlyrislists FROM jcms;
GRANT ALL ON TABLE formlyrislists TO jcms;
GRANT ALL ON TABLE formlyrislists TO jcmsadmin;
GRANT SELECT ON TABLE formlyrislists TO jcmsuser;


--
-- Name: forms; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE forms FROM PUBLIC;
REVOKE ALL ON TABLE forms FROM jcms;
GRANT ALL ON TABLE forms TO jcms;
GRANT ALL ON TABLE forms TO jcmsadmin;
GRANT SELECT ON TABLE forms TO jcmsuser;


--
-- Name: imagerotator; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE imagerotator FROM PUBLIC;
REVOKE ALL ON TABLE imagerotator FROM jcms;
GRANT ALL ON TABLE imagerotator TO jcms;
GRANT ALL ON TABLE imagerotator TO jcmsadmin;
GRANT SELECT ON TABLE imagerotator TO jcmsuser;


--
-- Name: layoutpanes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE layoutpanes FROM PUBLIC;
REVOKE ALL ON TABLE layoutpanes FROM jcms;
GRANT ALL ON TABLE layoutpanes TO jcms;
GRANT SELECT ON TABLE layoutpanes TO jcmsuser;
GRANT ALL ON TABLE layoutpanes TO jcmsadmin;


--
-- Name: layouts_layout_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE layouts_layout_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE layouts_layout_id_seq FROM jcms;
GRANT ALL ON SEQUENCE layouts_layout_id_seq TO jcms;
GRANT ALL ON SEQUENCE layouts_layout_id_seq TO jcmsadmin;


--
-- Name: layouts; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE layouts FROM PUBLIC;
REVOKE ALL ON TABLE layouts FROM jcms;
GRANT ALL ON TABLE layouts TO jcms;
GRANT SELECT ON TABLE layouts TO jcmsuser;
GRANT ALL ON TABLE layouts TO jcmsadmin;


--
-- Name: media; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE media FROM PUBLIC;
REVOKE ALL ON TABLE media FROM jcms;
GRANT ALL ON TABLE media TO jcms;
GRANT ALL ON TABLE media TO jcmsadmin;
GRANT SELECT ON TABLE media TO jcmsuser;


--
-- Name: nodelinks; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodelinks FROM PUBLIC;
REVOKE ALL ON TABLE nodelinks FROM jcms;
GRANT ALL ON TABLE nodelinks TO jcms;
GRANT ALL ON TABLE nodelinks TO jcmsadmin;
GRANT SELECT ON TABLE nodelinks TO jcmsuser;


--
-- Name: nodes_current; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodes_current FROM PUBLIC;
REVOKE ALL ON TABLE nodes_current FROM jcms;
GRANT ALL ON TABLE nodes_current TO jcms;
GRANT ALL ON TABLE nodes_current TO jcmsadmin;
GRANT SELECT ON TABLE nodes_current TO jcmsuser;


--
-- Name: nodelinks_current; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodelinks_current FROM PUBLIC;
REVOKE ALL ON TABLE nodelinks_current FROM jcms;
GRANT ALL ON TABLE nodelinks_current TO jcms;
GRANT ALL ON TABLE nodelinks_current TO jcmsadmin;
GRANT SELECT ON TABLE nodelinks_current TO jcmsuser;


--
-- Name: nodelinks_future; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodelinks_future FROM PUBLIC;
REVOKE ALL ON TABLE nodelinks_future FROM jcms;
GRANT ALL ON TABLE nodelinks_future TO jcms;
GRANT SELECT ON TABLE nodelinks_future TO jcmsuser;
GRANT SELECT ON TABLE nodelinks_future TO jcmsadmin;


--
-- Name: nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodes FROM PUBLIC;
REVOKE ALL ON TABLE nodes FROM jcms;
GRANT ALL ON TABLE nodes TO jcms;
GRANT ALL ON TABLE nodes TO jcmsadmin;
GRANT SELECT ON TABLE nodes TO jcmsuser;


--
-- Name: pages; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE pages FROM PUBLIC;
REVOKE ALL ON TABLE pages FROM jcms;
GRANT ALL ON TABLE pages TO jcms;
GRANT ALL ON TABLE pages TO jcmsadmin;
GRANT SELECT ON TABLE pages TO jcmsuser;


--
-- Name: pages_content; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE pages_content FROM PUBLIC;
REVOKE ALL ON TABLE pages_content FROM jcms;
GRANT ALL ON TABLE pages_content TO jcms;
GRANT SELECT ON TABLE pages_content TO jcmsuser;
GRANT ALL ON TABLE pages_content TO jcmsadmin;


--
-- Name: photos; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE photos FROM PUBLIC;
REVOKE ALL ON TABLE photos FROM jcms;
GRANT ALL ON TABLE photos TO jcms;
GRANT ALL ON TABLE photos TO jcmsadmin;
GRANT SELECT ON TABLE photos TO jcmsuser;


--
-- Name: photosets; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE photosets FROM PUBLIC;
REVOKE ALL ON TABLE photosets FROM jcms;
GRANT ALL ON TABLE photosets TO jcms;
GRANT ALL ON TABLE photosets TO jcmsadmin;
GRANT SELECT ON TABLE photosets TO jcmsuser;


--
-- Name: postedformfields; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE postedformfields FROM PUBLIC;
REVOKE ALL ON TABLE postedformfields FROM jcms;
GRANT ALL ON TABLE postedformfields TO jcms;
GRANT SELECT ON TABLE postedformfields TO jcmsadmin;
GRANT SELECT,INSERT ON TABLE postedformfields TO jcmsuser;


--
-- Name: postedforms; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE postedforms FROM PUBLIC;
REVOKE ALL ON TABLE postedforms FROM jcms;
GRANT ALL ON TABLE postedforms TO jcms;
GRANT SELECT ON TABLE postedforms TO jcmsadmin;
GRANT SELECT,INSERT ON TABLE postedforms TO jcmsuser;


--
-- Name: settings; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE settings FROM PUBLIC;
REVOKE ALL ON TABLE settings FROM jcms;
GRANT ALL ON TABLE settings TO jcms;
GRANT ALL ON TABLE settings TO jcmsadmin;
GRANT SELECT ON TABLE settings TO jcmsuser;


--
-- Name: stylesheet; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE stylesheet FROM PUBLIC;
REVOKE ALL ON TABLE stylesheet FROM jcms;
GRANT ALL ON TABLE stylesheet TO jcms;
GRANT ALL ON TABLE stylesheet TO jcmsadmin;
GRANT SELECT ON TABLE stylesheet TO jcmsuser;


--
-- Name: stylesheetcategories; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE stylesheetcategories FROM PUBLIC;
REVOKE ALL ON TABLE stylesheetcategories FROM jcms;
GRANT ALL ON TABLE stylesheetcategories TO jcms;
GRANT SELECT ON TABLE stylesheetcategories TO jcmsadmin;


--
-- Name: updatelog; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE updatelog FROM PUBLIC;
REVOKE ALL ON TABLE updatelog FROM jcms;
GRANT ALL ON TABLE updatelog TO jcms;
GRANT SELECT ON TABLE updatelog TO jcmsadmin;


--
-- Name: users; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM jcms;
GRANT ALL ON TABLE users TO jcms;
GRANT SELECT,INSERT,UPDATE ON TABLE users TO jcmsadmin;


--
-- Name: users_extensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users_extensions FROM PUBLIC;
REVOKE ALL ON TABLE users_extensions FROM jcms;
GRANT ALL ON TABLE users_extensions TO jcms;
GRANT ALL ON TABLE users_extensions TO jcmsadmin;


--
-- Name: users_extras; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users_extras FROM PUBLIC;
REVOKE ALL ON TABLE users_extras FROM jcms;
GRANT ALL ON TABLE users_extras TO jcms;
GRANT ALL ON TABLE users_extras TO jcmsadmin;


--
-- Name: users_nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE users_nodes FROM PUBLIC;
REVOKE ALL ON TABLE users_nodes FROM jcms;
GRANT ALL ON TABLE users_nodes TO jcms;
GRANT SELECT,INSERT,DELETE ON TABLE users_nodes TO jcmsadmin;


--
-- Name: utilitylinks; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE utilitylinks FROM PUBLIC;
REVOKE ALL ON TABLE utilitylinks FROM jcms;
GRANT ALL ON TABLE utilitylinks TO jcms;
GRANT ALL ON TABLE utilitylinks TO jcmsadmin;
GRANT SELECT ON TABLE utilitylinks TO jcmsuser;


--
-- Name: accessroles_accessrole_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE accessroles_accessrole_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE accessroles_accessrole_id_seq FROM jcms;
GRANT ALL ON SEQUENCE accessroles_accessrole_id_seq TO jcms;
GRANT ALL ON SEQUENCE accessroles_accessrole_id_seq TO jcmsadmin;


--
-- Name: accessusers_accessuser_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE accessusers_accessuser_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE accessusers_accessuser_id_seq FROM jcms;
GRANT ALL ON SEQUENCE accessusers_accessuser_id_seq TO jcms;
GRANT ALL ON SEQUENCE accessusers_accessuser_id_seq TO jcmsadmin;


--
-- Name: audit_audit_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE audit_audit_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE audit_audit_id_seq FROM jcms;
GRANT ALL ON SEQUENCE audit_audit_id_seq TO jcms;
GRANT ALL ON SEQUENCE audit_audit_id_seq TO jcmsadmin;


--
-- Name: comments_comment_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE comments_comment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE comments_comment_id_seq FROM jcms;
GRANT ALL ON SEQUENCE comments_comment_id_seq TO jcms;
GRANT ALL ON SEQUENCE comments_comment_id_seq TO jcmsuser;
GRANT ALL ON SEQUENCE comments_comment_id_seq TO jcmsadmin;


--
-- Name: content_cid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE content_cid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE content_cid_seq FROM jcms;
GRANT ALL ON SEQUENCE content_cid_seq TO jcms;
GRANT ALL ON SEQUENCE content_cid_seq TO jcmsadmin;


--
-- Name: extensions_extid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE extensions_extid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE extensions_extid_seq FROM jcms;
GRANT ALL ON SEQUENCE extensions_extid_seq TO jcms;
GRANT ALL ON SEQUENCE extensions_extid_seq TO jcmsadmin;


--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq FROM jcms;
GRANT ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq TO jcms;
GRANT ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq TO jcmsadmin;


--
-- Name: formfields_formfield_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE formfields_formfield_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE formfields_formfield_id_seq FROM jcms;
GRANT ALL ON SEQUENCE formfields_formfield_id_seq TO jcms;
GRANT ALL ON SEQUENCE formfields_formfield_id_seq TO jcmsadmin;


--
-- Name: formlyrislists_formlyrislist_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq FROM jcms;
GRANT ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq TO jcms;
GRANT ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq TO jcmsadmin;


--
-- Name: forms_form_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE forms_form_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE forms_form_id_seq FROM jcms;
GRANT ALL ON SEQUENCE forms_form_id_seq TO jcms;
GRANT ALL ON SEQUENCE forms_form_id_seq TO jcmsadmin;


--
-- Name: imagerotator_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE imagerotator_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE imagerotator_id_seq FROM jcms;
GRANT ALL ON SEQUENCE imagerotator_id_seq TO jcms;
GRANT ALL ON SEQUENCE imagerotator_id_seq TO PUBLIC;


--
-- Name: layoutpanes_layoutpane_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE layoutpanes_layoutpane_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE layoutpanes_layoutpane_id_seq FROM jcms;
GRANT ALL ON SEQUENCE layoutpanes_layoutpane_id_seq TO jcms;
GRANT ALL ON SEQUENCE layoutpanes_layoutpane_id_seq TO jcmsadmin;


--
-- Name: media_mid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE media_mid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_mid_seq FROM jcms;
GRANT ALL ON SEQUENCE media_mid_seq TO jcms;
GRANT ALL ON SEQUENCE media_mid_seq TO jcmsadmin;


--
-- Name: nodelinks_nlid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE nodelinks_nlid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE nodelinks_nlid_seq FROM jcms;
GRANT ALL ON SEQUENCE nodelinks_nlid_seq TO jcms;
GRANT ALL ON SEQUENCE nodelinks_nlid_seq TO jcmsadmin;


--
-- Name: nodes_nid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE nodes_nid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE nodes_nid_seq FROM jcms;
GRANT ALL ON SEQUENCE nodes_nid_seq TO jcms;
GRANT ALL ON SEQUENCE nodes_nid_seq TO jcmsadmin;


--
-- Name: pages_pid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE pages_pid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE pages_pid_seq FROM jcms;
GRANT ALL ON SEQUENCE pages_pid_seq TO jcms;
GRANT ALL ON SEQUENCE pages_pid_seq TO jcmsadmin;


--
-- Name: photos_photo_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE photos_photo_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE photos_photo_id_seq FROM jcms;
GRANT ALL ON SEQUENCE photos_photo_id_seq TO jcms;
GRANT ALL ON SEQUENCE photos_photo_id_seq TO jcmsadmin;


--
-- Name: photosets_photoset_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE photosets_photoset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE photosets_photoset_id_seq FROM jcms;
GRANT ALL ON SEQUENCE photosets_photoset_id_seq TO jcms;
GRANT ALL ON SEQUENCE photosets_photoset_id_seq TO jcmsadmin;


--
-- Name: postedforms_postedform_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE postedforms_postedform_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE postedforms_postedform_id_seq FROM jcms;
GRANT ALL ON SEQUENCE postedforms_postedform_id_seq TO jcms;
GRANT ALL ON SEQUENCE postedforms_postedform_id_seq TO jcmsuser;


--
-- Name: stylesheet_class_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE stylesheet_class_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE stylesheet_class_id_seq FROM jcms;
GRANT ALL ON SEQUENCE stylesheet_class_id_seq TO jcms;
GRANT ALL ON SEQUENCE stylesheet_class_id_seq TO jcmsadmin;


--
-- Name: users_uid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE users_uid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_uid_seq FROM jcms;
GRANT ALL ON SEQUENCE users_uid_seq TO jcms;
GRANT ALL ON SEQUENCE users_uid_seq TO jcmsadmin;


--
-- Name: utilitylinks_utilitylink_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE utilitylinks_utilitylink_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE utilitylinks_utilitylink_id_seq FROM jcms;
GRANT ALL ON SEQUENCE utilitylinks_utilitylink_id_seq TO jcms;
GRANT ALL ON SEQUENCE utilitylinks_utilitylink_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

