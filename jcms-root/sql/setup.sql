--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: sam
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO sam;

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
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE accessroles_accessrole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accessroles_accessrole_id_seq OWNER TO jcms;

--
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE accessroles_accessrole_id_seq OWNED BY accessroles.accessrole_id;


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
    mid integer NOT NULL,
    rolename character varying NOT NULL
);


ALTER TABLE public.accessroles_media OWNER TO jcms;

--
-- Name: accessroles_nodes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE accessroles_nodes (
    nid integer NOT NULL,
    rolename character varying NOT NULL
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
    updated timestamp(0) with time zone,
    resetkey character varying
);


ALTER TABLE public.accessusers OWNER TO jcms;

--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE accessusers_accessuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accessusers_accessuser_id_seq OWNER TO jcms;

--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE accessusers_accessuser_id_seq OWNED BY accessusers.accessuser_id;


--
-- Name: audit; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE audit (
    audit_id integer NOT NULL,
    "timestamp" timestamp(0) with time zone DEFAULT now() NOT NULL,
    tablename character varying NOT NULL,
    record_id integer NOT NULL,
    action character(1) NOT NULL,
    username character varying NOT NULL,
    description character varying
);


ALTER TABLE public.audit OWNER TO jcms;

--
-- Name: audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_audit_id_seq OWNER TO jcms;

--
-- Name: audit_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE audit_audit_id_seq OWNED BY audit.audit_id;


--
-- Name: commentblacklist; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE commentblacklist (
    word_id integer NOT NULL,
    word character varying NOT NULL
);


ALTER TABLE public.commentblacklist OWNER TO jcms;

--
-- Name: commentblacklist_word_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE commentblacklist_word_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commentblacklist_word_id_seq OWNER TO jcms;

--
-- Name: commentblacklist_word_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE commentblacklist_word_id_seq OWNED BY commentblacklist.word_id;


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
-- Name: comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE comments_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_comment_id_seq OWNER TO jcms;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE comments_comment_id_seq OWNED BY comments.comment_id;


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
-- Name: content_cid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE content_cid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_cid_seq OWNER TO jcms;

--
-- Name: content_cid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE content_cid_seq OWNED BY content.cid;


--
-- Name: cproles; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE cproles (
    username character varying NOT NULL,
    editor boolean DEFAULT false NOT NULL,
    designer boolean DEFAULT false NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.cproles OWNER TO jcms;

--
-- Name: dhtmlcache; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE dhtmlcache (
    accessuser character varying,
    dhtml character varying,
    updated timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.dhtmlcache OWNER TO jcms;

--
-- Name: events; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE events (
    event_id integer NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    title character varying NOT NULL,
    date date NOT NULL,
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
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO jcms;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE events_event_id_seq OWNED BY events.event_id;


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
-- Name: extensions_extid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE extensions_extid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extensions_extid_seq OWNER TO jcms;

--
-- Name: extensions_extid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE extensions_extid_seq OWNED BY extensions.extid;


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
-- Name: extras_extra_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE extras_extra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extras_extra_id_seq OWNER TO jcms;

--
-- Name: extras_extra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE extras_extra_id_seq OWNED BY extras.extra_id;


--
-- Name: formconstantcontactlists; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE formconstantcontactlists (
    form_id integer NOT NULL,
    link character varying NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.formconstantcontactlists OWNER TO jcms;

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
-- Name: formfieldoptions_formfieldoption_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE formfieldoptions_formfieldoption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formfieldoptions_formfieldoption_id_seq OWNER TO jcms;

--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE formfieldoptions_formfieldoption_id_seq OWNED BY formfieldoptions.formfieldoption_id;


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
    cols integer DEFAULT 20 NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


ALTER TABLE public.formfields OWNER TO jcms;

--
-- Name: formfields_formfield_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE formfields_formfield_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formfields_formfield_id_seq OWNER TO jcms;

--
-- Name: formfields_formfield_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE formfields_formfield_id_seq OWNED BY formfields.formfield_id;


--
-- Name: formicontactlists; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE formicontactlists (
    form_id integer NOT NULL,
    listid integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE public.formicontactlists OWNER TO jcms;

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
-- Name: formlyrislists_formlyrislist_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE formlyrislists_formlyrislist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formlyrislists_formlyrislist_id_seq OWNER TO jcms;

--
-- Name: formlyrislists_formlyrislist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE formlyrislists_formlyrislist_id_seq OWNED BY formlyrislists.formlyrislist_id;


--
-- Name: formmailchimplists; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE formmailchimplists (
    form_id integer NOT NULL,
    listid character varying NOT NULL,
    listname character varying NOT NULL
);


ALTER TABLE public.formmailchimplists OWNER TO jcms;

--
-- Name: forms; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE forms (
    form_id integer NOT NULL,
    title character varying NOT NULL,
    recipientname character varying NOT NULL,
    recipientemail character varying NOT NULL,
    sendername character varying,
    senderemail character varying,
    instructions character varying NOT NULL,
    thankyou character varying NOT NULL,
    confirmationmessage character varying,
    signupinstructions character varying,
    filetitle character varying,
    fileinstructions character varying,
    filerequired boolean DEFAULT false NOT NULL,
    filefieldsize integer DEFAULT 30 NOT NULL,
    redirecturl character varying,
    submitvalue character varying DEFAULT 'SEND'::character varying NOT NULL,
    usecaptcha boolean DEFAULT true NOT NULL,
    alertonerror boolean DEFAULT false NOT NULL,
    confirmationsubject character varying
);


ALTER TABLE public.forms OWNER TO jcms;

--
-- Name: forms_form_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE forms_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forms_form_id_seq OWNER TO jcms;

--
-- Name: forms_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE forms_form_id_seq OWNED BY forms.form_id;


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
    alt character varying,
    url character varying
);


ALTER TABLE public.imagerotator OWNER TO jcms;

--
-- Name: imagerotator_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE imagerotator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagerotator_id_seq OWNER TO jcms;

--
-- Name: imagerotator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE imagerotator_id_seq OWNED BY imagerotator.id;


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
    rowspan integer DEFAULT 1 NOT NULL,
    mobile boolean DEFAULT false NOT NULL
);


ALTER TABLE public.layoutpanes OWNER TO jcms;

--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE layoutpanes_layoutpane_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layoutpanes_layoutpane_id_seq OWNER TO jcms;

--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE layoutpanes_layoutpane_id_seq OWNED BY layoutpanes.layoutpane_id;


--
-- Name: layouts_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE layouts_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layouts_layout_id_seq OWNER TO jcms;

--
-- Name: layouts; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE layouts (
    layout_id integer DEFAULT nextval('layouts_layout_id_seq'::regclass) NOT NULL,
    layout character varying NOT NULL,
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

--
-- Name: media_mid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE media_mid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_mid_seq OWNER TO jcms;

--
-- Name: media_mid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE media_mid_seq OWNED BY media.mid;


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
    SELECT nodelinks.nid, max(nodelinks.starttime) AS starttime FROM nodelinks WHERE (nodelinks.starttime < now()) GROUP BY nodelinks.nid;


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
-- Name: nodelinks_nlid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE nodelinks_nlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nodelinks_nlid_seq OWNER TO jcms;

--
-- Name: nodelinks_nlid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE nodelinks_nlid_seq OWNED BY nodelinks.nlid;


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
-- Name: nodes_nid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE nodes_nid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nodes_nid_seq OWNER TO jcms;

--
-- Name: nodes_nid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE nodes_nid_seq OWNED BY nodes.nid;


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
-- Name: pages_pid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE pages_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_pid_seq OWNER TO jcms;

--
-- Name: pages_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE pages_pid_seq OWNED BY pages.pid;


--
-- Name: pagetags; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE pagetags (
    pid integer,
    tag character varying NOT NULL
);


ALTER TABLE public.pagetags OWNER TO jcms;

--
-- Name: paymentoptions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE paymentoptions (
    paymentoption_id integer NOT NULL,
    payment_id integer NOT NULL,
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
-- Name: payments; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE payments (
    payment_id integer NOT NULL,
    title character varying NOT NULL,
    instructions character varying NOT NULL,
    thankyou character varying NOT NULL,
    recipientemail character varying NOT NULL,
    recipientname character varying NOT NULL
);


ALTER TABLE public.payments OWNER TO jcms;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE payments_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_payment_id_seq OWNER TO jcms;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE payments_payment_id_seq OWNED BY payments.payment_id;


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
    title character varying,
    caption character varying,
    thumbnail character varying
);


ALTER TABLE public.photos OWNER TO jcms;

--
-- Name: photos_photo_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE photos_photo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_photo_id_seq OWNER TO jcms;

--
-- Name: photos_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE photos_photo_id_seq OWNED BY photos.photo_id;


--
-- Name: photosets; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE photosets (
    photoset_id integer NOT NULL,
    title character varying NOT NULL,
    created timestamp(0) without time zone DEFAULT now() NOT NULL,
    description character varying,
    shootdate character varying,
    credit character varying,
    thumbnailindex boolean DEFAULT false NOT NULL,
    thumbnailcolumns integer DEFAULT 4 NOT NULL
);


ALTER TABLE public.photosets OWNER TO jcms;

--
-- Name: photosets_photoset_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE photosets_photoset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photosets_photoset_id_seq OWNER TO jcms;

--
-- Name: photosets_photoset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE photosets_photoset_id_seq OWNED BY photosets.photoset_id;


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
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pollchoices_pollchoice_id_seq OWNER TO jcms;

--
-- Name: pollchoices_pollchoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE pollchoices_pollchoice_id_seq OWNED BY pollchoices.pollchoice_id;


--
-- Name: polls; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE polls (
    poll_id integer NOT NULL,
    starttime timestamp(0) without time zone NOT NULL,
    endtime timestamp(0) without time zone NOT NULL,
    question character varying NOT NULL,
    label character varying
);


ALTER TABLE public.polls OWNER TO jcms;

--
-- Name: polls_poll_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE polls_poll_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.polls_poll_id_seq OWNER TO jcms;

--
-- Name: polls_poll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE polls_poll_id_seq OWNED BY polls.poll_id;


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
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE postedforms_postedform_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.postedforms_postedform_id_seq OWNER TO jcms;

--
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE postedforms_postedform_id_seq OWNED BY postedforms.postedform_id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE settings (
    setting_id integer NOT NULL,
    setting_name character varying NOT NULL,
    setting_value character varying NOT NULL,
    description character varying NOT NULL,
    password boolean DEFAULT false NOT NULL,
    toggle boolean DEFAULT false NOT NULL
);


ALTER TABLE public.settings OWNER TO jcms;

--
-- Name: sidebarextensions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE sidebarextensions (
    sidebarextension_id integer NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    extensionurl character varying NOT NULL,
    extensioncontext character varying NOT NULL,
    location character(1) DEFAULT 'S'::bpchar NOT NULL
);


ALTER TABLE public.sidebarextensions OWNER TO jcms;

--
-- Name: sidebarextensions_sidebarextension_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE sidebarextensions_sidebarextension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sidebarextensions_sidebarextension_id_seq OWNER TO jcms;

--
-- Name: sidebarextensions_sidebarextension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE sidebarextensions_sidebarextension_id_seq OWNED BY sidebarextensions.sidebarextension_id;


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
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stylesheet_class_id_seq OWNER TO jcms;

--
-- Name: stylesheet_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE stylesheet_class_id_seq OWNED BY stylesheet.class_id;


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
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone
);


ALTER TABLE public.users OWNER TO jcms;

--
-- Name: users_extensions; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_extensions (
    extid integer NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.users_extensions OWNER TO jcms;

--
-- Name: users_extras; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_extras (
    extra_id integer NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.users_extras OWNER TO jcms;

--
-- Name: users_nodes; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE users_nodes (
    nid integer NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.users_nodes OWNER TO jcms;

--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO jcms;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE users_uid_seq OWNED BY users.uid;


--
-- Name: utilitycontent; Type: TABLE; Schema: public; Owner: jcms; Tablespace: 
--

CREATE TABLE utilitycontent (
    utilitycontent_id integer NOT NULL,
    location character(1) NOT NULL,
    num integer DEFAULT 1 NOT NULL,
    copy character varying,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone,
    modulecontext character varying,
    moduleurl character varying,
    moduleabove boolean DEFAULT false NOT NULL,
    showhome boolean DEFAULT false NOT NULL,
    showinside boolean DEFAULT false NOT NULL,
    showmobile boolean DEFAULT false NOT NULL
);


ALTER TABLE public.utilitycontent OWNER TO jcms;

--
-- Name: utilitycontent_utilitycontent_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE utilitycontent_utilitycontent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.utilitycontent_utilitycontent_id_seq OWNER TO jcms;

--
-- Name: utilitycontent_utilitycontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE utilitycontent_utilitycontent_id_seq OWNED BY utilitycontent.utilitycontent_id;


--
-- Name: accessrole_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles ALTER COLUMN accessrole_id SET DEFAULT nextval('accessroles_accessrole_id_seq'::regclass);


--
-- Name: accessuser_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessusers ALTER COLUMN accessuser_id SET DEFAULT nextval('accessusers_accessuser_id_seq'::regclass);


--
-- Name: audit_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY audit ALTER COLUMN audit_id SET DEFAULT nextval('audit_audit_id_seq'::regclass);


--
-- Name: word_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY commentblacklist ALTER COLUMN word_id SET DEFAULT nextval('commentblacklist_word_id_seq'::regclass);


--
-- Name: comment_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY comments ALTER COLUMN comment_id SET DEFAULT nextval('comments_comment_id_seq'::regclass);


--
-- Name: cid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY content ALTER COLUMN cid SET DEFAULT nextval('content_cid_seq'::regclass);


--
-- Name: event_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY events ALTER COLUMN event_id SET DEFAULT nextval('events_event_id_seq'::regclass);


--
-- Name: extid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY extensions ALTER COLUMN extid SET DEFAULT nextval('extensions_extid_seq'::regclass);


--
-- Name: extra_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY extras ALTER COLUMN extra_id SET DEFAULT nextval('extras_extra_id_seq'::regclass);


--
-- Name: formfieldoption_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formfieldoptions ALTER COLUMN formfieldoption_id SET DEFAULT nextval('formfieldoptions_formfieldoption_id_seq'::regclass);


--
-- Name: formfield_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formfields ALTER COLUMN formfield_id SET DEFAULT nextval('formfields_formfield_id_seq'::regclass);


--
-- Name: formlyrislist_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formlyrislists ALTER COLUMN formlyrislist_id SET DEFAULT nextval('formlyrislists_formlyrislist_id_seq'::regclass);


--
-- Name: form_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY forms ALTER COLUMN form_id SET DEFAULT nextval('forms_form_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY imagerotator ALTER COLUMN id SET DEFAULT nextval('imagerotator_id_seq'::regclass);


--
-- Name: layoutpane_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY layoutpanes ALTER COLUMN layoutpane_id SET DEFAULT nextval('layoutpanes_layoutpane_id_seq'::regclass);


--
-- Name: mid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY media ALTER COLUMN mid SET DEFAULT nextval('media_mid_seq'::regclass);


--
-- Name: nlid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY nodelinks ALTER COLUMN nlid SET DEFAULT nextval('nodelinks_nlid_seq'::regclass);


--
-- Name: nid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY nodes ALTER COLUMN nid SET DEFAULT nextval('nodes_nid_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pages ALTER COLUMN pid SET DEFAULT nextval('pages_pid_seq'::regclass);


--
-- Name: paymentoption_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY paymentoptions ALTER COLUMN paymentoption_id SET DEFAULT nextval('paymentoptions_paymentoption_id_seq'::regclass);


--
-- Name: payment_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY payments ALTER COLUMN payment_id SET DEFAULT nextval('payments_payment_id_seq'::regclass);


--
-- Name: photo_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY photos ALTER COLUMN photo_id SET DEFAULT nextval('photos_photo_id_seq'::regclass);


--
-- Name: photoset_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY photosets ALTER COLUMN photoset_id SET DEFAULT nextval('photosets_photoset_id_seq'::regclass);


--
-- Name: pollchoice_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pollchoices ALTER COLUMN pollchoice_id SET DEFAULT nextval('pollchoices_pollchoice_id_seq'::regclass);


--
-- Name: poll_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY polls ALTER COLUMN poll_id SET DEFAULT nextval('polls_poll_id_seq'::regclass);


--
-- Name: postedform_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY postedforms ALTER COLUMN postedform_id SET DEFAULT nextval('postedforms_postedform_id_seq'::regclass);


--
-- Name: sidebarextension_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY sidebarextensions ALTER COLUMN sidebarextension_id SET DEFAULT nextval('sidebarextensions_sidebarextension_id_seq'::regclass);


--
-- Name: class_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY stylesheet ALTER COLUMN class_id SET DEFAULT nextval('stylesheet_class_id_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);


--
-- Name: utilitycontent_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY utilitycontent ALTER COLUMN utilitycontent_id SET DEFAULT nextval('utilitycontent_utilitycontent_id_seq'::regclass);


--
-- Data for Name: accessroles; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY accessroles (accessrole_id, accessrole, created, updated) FROM stdin;
\.


--
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('accessroles_accessrole_id_seq', 1, false);


--
-- Data for Name: accessroles_accessusers; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY accessroles_accessusers (accessrole_id, accessuser_id) FROM stdin;
\.


--
-- Data for Name: accessroles_media; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY accessroles_media (mid, rolename) FROM stdin;
\.


--
-- Data for Name: accessroles_nodes; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY accessroles_nodes (nid, rolename) FROM stdin;
\.


--
-- Data for Name: accessusers; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY accessusers (accessuser_id, email, password, created, updated, resetkey) FROM stdin;
\.


--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('accessusers_accessuser_id_seq', 1, false);


--
-- Data for Name: audit; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY audit (audit_id, "timestamp", tablename, record_id, action, username, description) FROM stdin;
1	2007-11-26 16:33:15-06	stylesheet	15	U	support@ims.net	0 div#container
2	2007-11-26 16:33:44-06	stylesheet	25	U	support@ims.net	0 div#header
3	2007-11-26 16:37:41-06	stylesheet	403	U	support@ims.net	0 div#header-logo
4	2007-11-26 16:39:22-06	settings	340	U	support@ims.net	breadcrumbs_disable
5	2007-11-26 16:39:22-06	settings	341	U	support@ims.net	breadcrumbs_separator
6	2007-11-26 16:39:22-06	settings	51	U	support@ims.net	cp_defaulteditmode
7	2007-11-26 16:39:22-06	settings	401	U	support@ims.net	footer_copyrightshown
8	2007-11-26 16:39:22-06	settings	402	U	support@ims.net	footer_copyrighttext
9	2007-11-26 16:39:22-06	settings	411	U	support@ims.net	footer_dateformat
10	2007-11-26 16:39:22-06	settings	410	U	support@ims.net	footer_dateshown
11	2007-11-26 16:39:22-06	settings	400	U	support@ims.net	footer_disable
12	2007-11-26 16:39:22-06	settings	420	U	support@ims.net	footer_imscredit
13	2007-11-26 16:39:22-06	settings	430	U	support@ims.net	footer_lastupdate
14	2007-11-26 16:39:22-06	settings	100	U	support@ims.net	header_disable
15	2007-11-26 16:39:22-06	settings	110	U	support@ims.net	header_flash
16	2007-11-26 16:39:22-06	settings	115	U	support@ims.net	header_flash_bgcolor
17	2007-11-26 16:39:22-06	settings	114	U	support@ims.net	header_flash_height
18	2007-11-26 16:39:22-06	settings	112	U	support@ims.net	header_flash_homeonly
19	2007-11-26 16:39:22-06	settings	111	U	support@ims.net	header_flash_url
20	2007-11-26 16:39:23-06	settings	113	U	support@ims.net	header_flash_width
21	2007-11-26 16:39:23-06	settings	101	U	support@ims.net	header_search
22	2007-11-26 16:39:23-06	settings	60	U	support@ims.net	ldap_authentication
23	2007-11-26 16:39:23-06	settings	301	U	support@ims.net	navpri_dhtml
24	2007-11-26 16:39:23-06	settings	302	U	support@ims.net	navpri_images
25	2007-11-26 16:39:23-06	settings	303	U	support@ims.net	navpri_level1_disable
26	2007-11-26 16:39:23-06	settings	350	U	support@ims.net	pagetitle_disable
27	2007-11-26 16:39:23-06	settings	351	U	support@ims.net	pagetitle_level1
28	2007-11-26 16:39:23-06	settings	501	U	support@ims.net	printable_logo
29	2007-11-26 16:39:23-06	settings	503	U	support@ims.net	printable_logo_height
30	2007-11-26 16:39:23-06	settings	502	U	support@ims.net	printable_logo_width
31	2007-11-26 16:39:23-06	settings	531	U	support@ims.net	search_image
32	2007-11-26 16:39:23-06	settings	533	U	support@ims.net	search_imageheight
33	2007-11-26 16:39:23-06	settings	532	U	support@ims.net	search_imagewidth
34	2007-11-26 16:39:23-06	settings	530	U	support@ims.net	search_size
35	2007-11-26 16:39:23-06	settings	534	U	support@ims.net	searchblox_cssdir
36	2007-11-26 16:39:23-06	settings	535	U	support@ims.net	searchblox_xsldir
37	2007-11-26 16:39:23-06	settings	321	U	support@ims.net	sectionheader_disable
38	2007-11-26 16:39:23-06	settings	360	U	support@ims.net	sidebar_disable
39	2007-11-26 16:39:23-06	settings	20	U	support@ims.net	site_cssdir
40	2007-11-26 16:39:23-06	settings	21	U	support@ims.net	site_cssfolder
41	2007-11-26 16:39:23-06	settings	22	U	support@ims.net	site_debug
42	2007-11-26 16:39:23-06	settings	10	U	support@ims.net	site_designdir
43	2007-11-26 16:39:23-06	settings	9	U	support@ims.net	site_designfolder
44	2007-11-26 16:39:23-06	settings	6	U	support@ims.net	site_imagedir
45	2007-11-26 16:39:23-06	settings	5	U	support@ims.net	site_imagefolder
46	2007-11-26 16:39:23-06	settings	4	U	support@ims.net	site_maxuploadsize
47	2007-11-26 16:39:23-06	settings	8	U	support@ims.net	site_mediadir
48	2007-11-26 16:39:23-06	settings	7	U	support@ims.net	site_mediafolder
49	2007-11-26 16:39:23-06	settings	1	U	support@ims.net	site_name
50	2007-11-26 16:39:23-06	settings	19	U	support@ims.net	site_rootfolder
51	2007-11-26 16:39:23-06	settings	521	U	support@ims.net	sitemap_headtitle
52	2007-11-26 16:39:23-06	settings	520	U	support@ims.net	sitemap_pagetitle
53	2007-11-26 16:39:23-06	settings	202	U	support@ims.net	subheader_dateformat
54	2007-11-26 16:39:23-06	settings	201	U	support@ims.net	subheader_dateshown
55	2007-11-26 16:39:23-06	settings	200	U	support@ims.net	subheader_disable
56	2007-11-26 16:39:23-06	settings	210	U	support@ims.net	subheader_flash
57	2007-11-26 16:39:23-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
58	2007-11-26 16:39:23-06	settings	214	U	support@ims.net	subheader_flash_height
59	2007-11-26 16:39:23-06	settings	212	U	support@ims.net	subheader_flash_homeonly
60	2007-11-26 16:39:23-06	settings	211	U	support@ims.net	subheader_flash_url
61	2007-11-26 16:39:23-06	settings	213	U	support@ims.net	subheader_flash_width
62	2007-11-26 16:40:28-06	stylesheet	25	U	support@ims.net	0 div#header
63	2007-11-26 16:40:43-06	stylesheet	403	U	support@ims.net	0 div#header-logo
64	2007-11-26 16:40:48-06	stylesheet	403	U	support@ims.net	0 div#header-logo
65	2007-11-26 16:40:59-06	stylesheet	25	U	support@ims.net	0 div#header
66	2007-11-26 16:41:20-06	settings	340	U	support@ims.net	breadcrumbs_disable
67	2007-11-26 16:41:20-06	settings	341	U	support@ims.net	breadcrumbs_separator
68	2007-11-26 16:41:20-06	settings	51	U	support@ims.net	cp_defaulteditmode
69	2007-11-26 16:41:20-06	settings	401	U	support@ims.net	footer_copyrightshown
70	2007-11-26 16:41:20-06	settings	402	U	support@ims.net	footer_copyrighttext
71	2007-11-26 16:41:20-06	settings	411	U	support@ims.net	footer_dateformat
72	2007-11-26 16:41:20-06	settings	410	U	support@ims.net	footer_dateshown
73	2007-11-26 16:41:20-06	settings	400	U	support@ims.net	footer_disable
74	2007-11-26 16:41:20-06	settings	420	U	support@ims.net	footer_imscredit
75	2007-11-26 16:41:20-06	settings	430	U	support@ims.net	footer_lastupdate
76	2007-11-26 16:41:20-06	settings	100	U	support@ims.net	header_disable
77	2007-11-26 16:41:20-06	settings	110	U	support@ims.net	header_flash
78	2007-11-26 16:41:20-06	settings	115	U	support@ims.net	header_flash_bgcolor
79	2007-11-26 16:41:20-06	settings	114	U	support@ims.net	header_flash_height
80	2007-11-26 16:41:20-06	settings	112	U	support@ims.net	header_flash_homeonly
81	2007-11-26 16:41:20-06	settings	111	U	support@ims.net	header_flash_url
82	2007-11-26 16:41:20-06	settings	113	U	support@ims.net	header_flash_width
83	2007-11-26 16:41:20-06	settings	101	U	support@ims.net	header_search
84	2007-11-26 16:41:20-06	settings	60	U	support@ims.net	ldap_authentication
85	2007-11-26 16:41:20-06	settings	301	U	support@ims.net	navpri_dhtml
86	2007-11-26 16:41:20-06	settings	302	U	support@ims.net	navpri_images
87	2007-11-26 16:41:20-06	settings	303	U	support@ims.net	navpri_level1_disable
88	2007-11-26 16:41:20-06	settings	350	U	support@ims.net	pagetitle_disable
89	2007-11-26 16:41:20-06	settings	351	U	support@ims.net	pagetitle_level1
90	2007-11-26 16:41:20-06	settings	501	U	support@ims.net	printable_logo
91	2007-11-26 16:41:20-06	settings	503	U	support@ims.net	printable_logo_height
92	2007-11-26 16:41:20-06	settings	502	U	support@ims.net	printable_logo_width
93	2007-11-26 16:41:20-06	settings	531	U	support@ims.net	search_image
94	2007-11-26 16:41:20-06	settings	533	U	support@ims.net	search_imageheight
95	2007-11-26 16:41:20-06	settings	532	U	support@ims.net	search_imagewidth
96	2007-11-26 16:41:20-06	settings	530	U	support@ims.net	search_size
97	2007-11-26 16:41:20-06	settings	534	U	support@ims.net	searchblox_cssdir
98	2007-11-26 16:41:20-06	settings	535	U	support@ims.net	searchblox_xsldir
99	2007-11-26 16:41:20-06	settings	321	U	support@ims.net	sectionheader_disable
100	2007-11-26 16:41:20-06	settings	360	U	support@ims.net	sidebar_disable
101	2007-11-26 16:41:20-06	settings	20	U	support@ims.net	site_cssdir
102	2007-11-26 16:41:20-06	settings	21	U	support@ims.net	site_cssfolder
103	2007-11-26 16:41:20-06	settings	22	U	support@ims.net	site_debug
104	2007-11-26 16:41:20-06	settings	10	U	support@ims.net	site_designdir
105	2007-11-26 16:41:20-06	settings	9	U	support@ims.net	site_designfolder
106	2007-11-26 16:41:20-06	settings	6	U	support@ims.net	site_imagedir
107	2007-11-26 16:41:20-06	settings	5	U	support@ims.net	site_imagefolder
108	2007-11-26 16:41:20-06	settings	4	U	support@ims.net	site_maxuploadsize
109	2007-11-26 16:41:20-06	settings	8	U	support@ims.net	site_mediadir
110	2007-11-26 16:41:20-06	settings	7	U	support@ims.net	site_mediafolder
111	2007-11-26 16:41:20-06	settings	1	U	support@ims.net	site_name
112	2007-11-26 16:41:20-06	settings	19	U	support@ims.net	site_rootfolder
113	2007-11-26 16:41:20-06	settings	521	U	support@ims.net	sitemap_headtitle
114	2007-11-26 16:41:20-06	settings	520	U	support@ims.net	sitemap_pagetitle
115	2007-11-26 16:41:20-06	settings	202	U	support@ims.net	subheader_dateformat
116	2007-11-26 16:41:20-06	settings	201	U	support@ims.net	subheader_dateshown
117	2007-11-26 16:41:20-06	settings	200	U	support@ims.net	subheader_disable
118	2007-11-26 16:41:20-06	settings	210	U	support@ims.net	subheader_flash
119	2007-11-26 16:41:20-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
120	2007-11-26 16:41:20-06	settings	214	U	support@ims.net	subheader_flash_height
121	2007-11-26 16:41:20-06	settings	212	U	support@ims.net	subheader_flash_homeonly
122	2007-11-26 16:41:20-06	settings	211	U	support@ims.net	subheader_flash_url
123	2007-11-26 16:41:20-06	settings	213	U	support@ims.net	subheader_flash_width
124	2007-11-26 16:41:50-06	stylesheet	15	U	support@ims.net	0 div#container
125	2007-11-26 16:42:17-06	settings	340	U	support@ims.net	breadcrumbs_disable
126	2007-11-26 16:42:17-06	settings	341	U	support@ims.net	breadcrumbs_separator
127	2007-11-26 16:42:17-06	settings	51	U	support@ims.net	cp_defaulteditmode
128	2007-11-26 16:42:17-06	settings	401	U	support@ims.net	footer_copyrightshown
129	2007-11-26 16:42:17-06	settings	402	U	support@ims.net	footer_copyrighttext
130	2007-11-26 16:42:17-06	settings	411	U	support@ims.net	footer_dateformat
131	2007-11-26 16:42:17-06	settings	410	U	support@ims.net	footer_dateshown
132	2007-11-26 16:42:17-06	settings	400	U	support@ims.net	footer_disable
133	2007-11-26 16:42:17-06	settings	420	U	support@ims.net	footer_imscredit
134	2007-11-26 16:42:17-06	settings	430	U	support@ims.net	footer_lastupdate
135	2007-11-26 16:42:17-06	settings	100	U	support@ims.net	header_disable
136	2007-11-26 16:42:17-06	settings	110	U	support@ims.net	header_flash
137	2007-11-26 16:42:17-06	settings	115	U	support@ims.net	header_flash_bgcolor
138	2007-11-26 16:42:17-06	settings	114	U	support@ims.net	header_flash_height
139	2007-11-26 16:42:17-06	settings	112	U	support@ims.net	header_flash_homeonly
140	2007-11-26 16:42:17-06	settings	111	U	support@ims.net	header_flash_url
141	2007-11-26 16:42:17-06	settings	113	U	support@ims.net	header_flash_width
142	2007-11-26 16:42:17-06	settings	101	U	support@ims.net	header_search
143	2007-11-26 16:42:17-06	settings	60	U	support@ims.net	ldap_authentication
144	2007-11-26 16:42:17-06	settings	301	U	support@ims.net	navpri_dhtml
145	2007-11-26 16:42:17-06	settings	302	U	support@ims.net	navpri_images
146	2007-11-26 16:42:17-06	settings	303	U	support@ims.net	navpri_level1_disable
147	2007-11-26 16:42:17-06	settings	350	U	support@ims.net	pagetitle_disable
148	2007-11-26 16:42:17-06	settings	351	U	support@ims.net	pagetitle_level1
149	2007-11-26 16:42:17-06	settings	501	U	support@ims.net	printable_logo
150	2007-11-26 16:42:17-06	settings	503	U	support@ims.net	printable_logo_height
151	2007-11-26 16:42:17-06	settings	502	U	support@ims.net	printable_logo_width
152	2007-11-26 16:42:17-06	settings	531	U	support@ims.net	search_image
153	2007-11-26 16:42:17-06	settings	533	U	support@ims.net	search_imageheight
154	2007-11-26 16:42:17-06	settings	532	U	support@ims.net	search_imagewidth
155	2007-11-26 16:42:17-06	settings	530	U	support@ims.net	search_size
156	2007-11-26 16:42:17-06	settings	534	U	support@ims.net	searchblox_cssdir
157	2007-11-26 16:42:17-06	settings	535	U	support@ims.net	searchblox_xsldir
158	2007-11-26 16:42:17-06	settings	321	U	support@ims.net	sectionheader_disable
159	2007-11-26 16:42:17-06	settings	360	U	support@ims.net	sidebar_disable
160	2007-11-26 16:42:17-06	settings	20	U	support@ims.net	site_cssdir
161	2007-11-26 16:42:17-06	settings	21	U	support@ims.net	site_cssfolder
162	2007-11-26 16:42:17-06	settings	22	U	support@ims.net	site_debug
163	2007-11-26 16:42:17-06	settings	10	U	support@ims.net	site_designdir
164	2007-11-26 16:42:17-06	settings	9	U	support@ims.net	site_designfolder
165	2007-11-26 16:42:17-06	settings	6	U	support@ims.net	site_imagedir
166	2007-11-26 16:42:17-06	settings	5	U	support@ims.net	site_imagefolder
167	2007-11-26 16:42:17-06	settings	4	U	support@ims.net	site_maxuploadsize
168	2007-11-26 16:42:17-06	settings	8	U	support@ims.net	site_mediadir
169	2007-11-26 16:42:17-06	settings	7	U	support@ims.net	site_mediafolder
170	2007-11-26 16:42:17-06	settings	1	U	support@ims.net	site_name
171	2007-11-26 16:42:17-06	settings	19	U	support@ims.net	site_rootfolder
172	2007-11-26 16:42:17-06	settings	521	U	support@ims.net	sitemap_headtitle
173	2007-11-26 16:42:17-06	settings	520	U	support@ims.net	sitemap_pagetitle
174	2007-11-26 16:42:17-06	settings	202	U	support@ims.net	subheader_dateformat
175	2007-11-26 16:42:17-06	settings	201	U	support@ims.net	subheader_dateshown
176	2007-11-26 16:42:17-06	settings	200	U	support@ims.net	subheader_disable
177	2007-11-26 16:42:17-06	settings	210	U	support@ims.net	subheader_flash
178	2007-11-26 16:42:17-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
179	2007-11-26 16:42:18-06	settings	214	U	support@ims.net	subheader_flash_height
180	2007-11-26 16:42:18-06	settings	212	U	support@ims.net	subheader_flash_homeonly
181	2007-11-26 16:42:18-06	settings	211	U	support@ims.net	subheader_flash_url
182	2007-11-26 16:42:18-06	settings	213	U	support@ims.net	subheader_flash_width
183	2007-11-26 16:42:44-06	stylesheet	403	U	support@ims.net	0 div#header-logo
184	2007-11-26 16:42:54-06	stylesheet	25	U	support@ims.net	0 div#header
185	2007-11-26 16:43:11-06	stylesheet	403	U	support@ims.net	0 div#header-logo
186	2007-11-26 16:43:29-06	stylesheet	26	U	support@ims.net	0 table#navpri
187	2007-11-26 16:43:33-06	stylesheet	26	U	support@ims.net	0 table#navpri
188	2007-11-26 16:43:55-06	stylesheet	29	U	support@ims.net	0 table#subheader
189	2007-11-26 16:44:16-06	stylesheet	200	U	support@ims.net	0 table#sectionheader
190	2007-11-26 16:44:28-06	stylesheet	200	U	support@ims.net	0 table#sectionheader
191	2007-11-26 16:45:04-06	stylesheet	579	U	support@ims.net	0 td#main-left
192	2007-11-26 16:45:24-06	stylesheet	431	U	support@ims.net	-1 div#header
193	2007-11-26 16:46:29-06	stylesheet	403	U	support@ims.net	0 div#header-logo
194	2007-11-26 16:47:09-06	pages	2	I	support@ims.net	\N
195	2007-11-26 16:47:27-06	pages	2	U	support@ims.net	section 1 (Section 1)
196	2007-11-26 16:47:44-06	pages	2	U	support@ims.net	layout 1 (Layout 1)
197	2007-11-26 16:48:45-06	content	1	U	support@ims.net	lorem ipsum text
198	2007-11-26 16:49:20-06	content	1	U	support@ims.net	lorem ipsum text
199	2007-11-26 16:49:45-06	pages	3	I	support@ims.net	\N
200	2007-11-26 16:50:01-06	pages	3	U	support@ims.net	layout 2 (Layout 2)
201	2007-11-26 16:50:22-06	pages	4	I	support@ims.net	\N
202	2007-11-26 16:50:37-06	pages	4	U	support@ims.net	layout 3 (Layout 3)
203	2007-11-26 16:51:22-06	nodes	1	I	support@ims.net	1 NEW NODE
204	2007-11-26 16:51:29-06	nodes	1	U	support@ims.net	1 Layout 1
205	2007-11-26 16:51:39-06	nodes	2	I	support@ims.net	2 NEW NODE
206	2007-11-26 16:51:45-06	nodes	2	U	support@ims.net	2 Layout 2
207	2007-11-26 16:51:53-06	nodes	3	I	support@ims.net	3 NEW NODE
208	2007-11-26 16:51:59-06	nodes	3	U	support@ims.net	3 Layout 3
209	2007-11-26 16:53:00-06	stylesheet	25	U	support@ims.net	0 div#header
210	2007-11-26 16:53:11-06	stylesheet	403	U	support@ims.net	0 div#header-logo
211	2007-11-26 16:53:20-06	stylesheet	403	U	support@ims.net	0 div#header-logo
212	2007-11-26 16:54:32-06	settings	340	U	support@ims.net	breadcrumbs_disable
213	2007-11-26 16:54:32-06	settings	341	U	support@ims.net	breadcrumbs_separator
214	2007-11-26 16:54:32-06	settings	51	U	support@ims.net	cp_defaulteditmode
215	2007-11-26 16:54:32-06	settings	401	U	support@ims.net	footer_copyrightshown
216	2007-11-26 16:54:32-06	settings	402	U	support@ims.net	footer_copyrighttext
217	2007-11-26 16:54:32-06	settings	411	U	support@ims.net	footer_dateformat
218	2007-11-26 16:54:32-06	settings	410	U	support@ims.net	footer_dateshown
219	2007-11-26 16:54:32-06	settings	400	U	support@ims.net	footer_disable
220	2007-11-26 16:54:32-06	settings	420	U	support@ims.net	footer_imscredit
221	2007-11-26 16:54:32-06	settings	430	U	support@ims.net	footer_lastupdate
222	2007-11-26 16:54:32-06	settings	100	U	support@ims.net	header_disable
223	2007-11-26 16:54:32-06	settings	110	U	support@ims.net	header_flash
224	2007-11-26 16:54:32-06	settings	115	U	support@ims.net	header_flash_bgcolor
225	2007-11-26 16:54:32-06	settings	114	U	support@ims.net	header_flash_height
226	2007-11-26 16:54:32-06	settings	112	U	support@ims.net	header_flash_homeonly
227	2007-11-26 16:54:32-06	settings	111	U	support@ims.net	header_flash_url
228	2007-11-26 16:54:32-06	settings	113	U	support@ims.net	header_flash_width
229	2007-11-26 16:54:32-06	settings	101	U	support@ims.net	header_search
230	2007-11-26 16:54:32-06	settings	60	U	support@ims.net	ldap_authentication
231	2007-11-26 16:54:32-06	settings	301	U	support@ims.net	navpri_dhtml
232	2007-11-26 16:54:32-06	settings	302	U	support@ims.net	navpri_images
233	2007-11-26 16:54:32-06	settings	303	U	support@ims.net	navpri_level1_disable
234	2007-11-26 16:54:32-06	settings	350	U	support@ims.net	pagetitle_disable
235	2007-11-26 16:54:32-06	settings	351	U	support@ims.net	pagetitle_level1
236	2007-11-26 16:54:32-06	settings	501	U	support@ims.net	printable_logo
237	2007-11-26 16:54:32-06	settings	503	U	support@ims.net	printable_logo_height
238	2007-11-26 16:54:33-06	settings	502	U	support@ims.net	printable_logo_width
239	2007-11-26 16:54:33-06	settings	531	U	support@ims.net	search_image
240	2007-11-26 16:54:33-06	settings	533	U	support@ims.net	search_imageheight
241	2007-11-26 16:54:33-06	settings	532	U	support@ims.net	search_imagewidth
242	2007-11-26 16:54:33-06	settings	530	U	support@ims.net	search_size
243	2007-11-26 16:54:33-06	settings	534	U	support@ims.net	searchblox_cssdir
244	2007-11-26 16:54:33-06	settings	535	U	support@ims.net	searchblox_xsldir
245	2007-11-26 16:54:33-06	settings	321	U	support@ims.net	sectionheader_disable
246	2007-11-26 16:54:33-06	settings	360	U	support@ims.net	sidebar_disable
247	2007-11-26 16:54:33-06	settings	20	U	support@ims.net	site_cssdir
248	2007-11-26 16:54:33-06	settings	21	U	support@ims.net	site_cssfolder
249	2007-11-26 16:54:33-06	settings	22	U	support@ims.net	site_debug
250	2007-11-26 16:54:33-06	settings	10	U	support@ims.net	site_designdir
251	2007-11-26 16:54:33-06	settings	9	U	support@ims.net	site_designfolder
252	2007-11-26 16:54:33-06	settings	6	U	support@ims.net	site_imagedir
253	2007-11-26 16:54:33-06	settings	5	U	support@ims.net	site_imagefolder
254	2007-11-26 16:54:33-06	settings	4	U	support@ims.net	site_maxuploadsize
255	2007-11-26 16:54:33-06	settings	8	U	support@ims.net	site_mediadir
256	2007-11-26 16:54:33-06	settings	7	U	support@ims.net	site_mediafolder
257	2007-11-26 16:54:33-06	settings	1	U	support@ims.net	site_name
258	2007-11-26 16:54:33-06	settings	19	U	support@ims.net	site_rootfolder
259	2007-11-26 16:54:33-06	settings	521	U	support@ims.net	sitemap_headtitle
260	2007-11-26 16:54:33-06	settings	520	U	support@ims.net	sitemap_pagetitle
261	2007-11-26 16:54:33-06	settings	202	U	support@ims.net	subheader_dateformat
262	2007-11-26 16:54:33-06	settings	201	U	support@ims.net	subheader_dateshown
263	2007-11-26 16:54:33-06	settings	200	U	support@ims.net	subheader_disable
264	2007-11-26 16:54:33-06	settings	210	U	support@ims.net	subheader_flash
265	2007-11-26 16:54:33-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
266	2007-11-26 16:54:33-06	settings	214	U	support@ims.net	subheader_flash_height
267	2007-11-26 16:54:33-06	settings	212	U	support@ims.net	subheader_flash_homeonly
268	2007-11-26 16:54:33-06	settings	211	U	support@ims.net	subheader_flash_url
270	2007-11-26 16:55:24-06	nodes	4	I	support@ims.net	1.1 NEW NODE
269	2007-11-26 16:54:33-06	settings	213	U	support@ims.net	subheader_flash_width
272	2007-11-26 16:55:43-06	nodes	5	I	support@ims.net	1.2 NEW NODE
273	2007-11-26 16:55:50-06	nodes	5	U	support@ims.net	1.2 Layout 2 Redux
275	2007-11-26 16:56:11-06	nodes	6	U	support@ims.net	1.3 Layout 3 Redux
277	2007-11-26 17:08:04-06	stylesheet	40	U	support@ims.net	0 td.navpri
278	2007-11-26 17:08:15-06	stylesheet	71	D	support@ims.net	1 td.navpri-on
280	2007-11-26 17:08:22-06	stylesheet	73	D	support@ims.net	3 td.navpri-on
282	2007-11-26 17:08:41-06	stylesheet	68	U	support@ims.net	0 td.navpri-over
283	2007-11-26 17:08:46-06	stylesheet	556	U	support@ims.net	0 a.navpri-on:link
284	2007-11-26 17:08:49-06	stylesheet	557	U	support@ims.net	0 a.navpri-on:visited
285	2007-11-26 17:08:51-06	stylesheet	558	U	support@ims.net	0 a.navpri-on: hover
286	2007-11-26 17:08:54-06	stylesheet	559	U	support@ims.net	0 a.navpri-on: active
289	2007-11-26 17:10:35-06	stylesheet	45	U	support@ims.net	0 a.navpri:active
290	2007-11-26 17:10:55-06	stylesheet	44	U	support@ims.net	0 a.navpri:hover
291	2007-11-26 17:11:00-06	stylesheet	41	U	support@ims.net	0 a.navpri:link
292	2007-11-26 17:11:09-06	stylesheet	42	U	support@ims.net	0 a.navpri:visited
294	2007-11-27 11:05:41-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
295	2007-11-27 11:05:58-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
296	2007-11-27 11:06:10-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
297	2007-11-27 11:06:23-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
303	2007-11-27 11:08:37-06	stylesheet	403	U	support@ims.net	0 div#header-logo
304	2007-11-27 11:08:57-06	stylesheet	403	U	support@ims.net	0 div#header-logo
305	2007-11-27 11:27:20-06	stylesheet	403	U	support@ims.net	0 div#header-logo
306	2007-11-27 11:27:33-06	stylesheet	403	U	support@ims.net	0 div#header-logo
313	2007-11-27 12:25:18-06	stylesheet	26	U	support@ims.net	0 table#navpri
319	2007-11-27 15:34:43-06	stylesheet	40	U	support@ims.net	0 td.navpri
320	2007-11-27 15:34:50-06	stylesheet	40	U	support@ims.net	0 td.navpri
321	2007-11-27 15:34:59-06	stylesheet	40	U	support@ims.net	0 td.navpri
322	2007-11-27 15:35:13-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
323	2007-11-27 15:35:33-06	stylesheet	40	U	support@ims.net	0 td.navpri
328	2007-11-27 15:36:43-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
329	2007-11-27 15:37:04-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
330	2007-11-27 15:37:16-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
331	2007-11-27 15:37:28-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
333	2007-11-27 15:39:05-06	stylesheet	626	D	support@ims.net	1 td#main-left
334	2007-11-27 15:39:10-06	stylesheet	627	D	support@ims.net	2 td#main-left
336	2007-11-27 15:39:42-06	stylesheet	102	D	support@ims.net	1 div.navsec-on
338	2007-11-27 15:39:49-06	stylesheet	84	D	support@ims.net	3 div#navsec-box
339	2007-11-27 15:39:51-06	stylesheet	104	D	support@ims.net	3 div.navsec-on
346	2007-11-27 17:19:44-06	nodes	7	I	support@ims.net	2.1 NEW NODE
347	2007-11-27 17:19:53-06	nodes	7	U	support@ims.net	2.1 More Lorem
349	2007-11-27 17:20:09-06	nodes	8	U	support@ims.net	2.2 More Ipsum
350	2007-11-27 17:24:09-06	stylesheet	132	U	support@ims.net	0 #layer1
351	2007-11-27 17:24:22-06	stylesheet	132	U	support@ims.net	0 #layer1
355	2007-11-27 17:25:53-06	stylesheet	142	U	support@ims.net	0 td.dhtml-off
356	2007-11-27 17:26:27-06	stylesheet	141	U	support@ims.net	0 table.dhtml
363	2007-11-27 17:27:42-06	stylesheet	135	U	support@ims.net	0 #layer4
364	2007-11-27 17:27:49-06	stylesheet	136	U	support@ims.net	0 #layer5
365	2007-11-27 17:27:56-06	stylesheet	155	U	support@ims.net	0 #layer6
431	2007-11-27 17:54:20-06	stylesheet	25	U	support@ims.net	0 div#header
432	2007-11-27 17:54:28-06	stylesheet	403	U	support@ims.net	0 div#header-logo
433	2007-11-27 17:54:32-06	stylesheet	25	U	support@ims.net	0 div#header
434	2007-11-27 17:54:49-06	stylesheet	480	U	support@ims.net	0 table.search
676	2007-12-13 11:25:20-06	stylesheet	132	U	support@ims.net	0 #layer1
677	2007-12-13 11:25:25-06	stylesheet	133	U	support@ims.net	0 #layer2
678	2007-12-13 11:25:29-06	stylesheet	134	U	support@ims.net	0 #layer3
679	2007-12-13 11:25:33-06	stylesheet	135	U	support@ims.net	0 #layer4
680	2007-12-13 11:25:37-06	stylesheet	136	U	support@ims.net	0 #layer5
681	2007-12-13 11:25:41-06	stylesheet	155	U	support@ims.net	0 #layer6
689	2008-04-15 10:15:37-05	settings	77	U	support@ims.net	blogger_application_name
690	2008-04-15 10:15:38-05	settings	79	U	support@ims.net	blogger_comment_post_uri
691	2008-04-15 10:15:38-05	settings	73	U	support@ims.net	blogger_comments_feed_uri_suffix
692	2008-04-15 10:15:38-05	settings	78	U	support@ims.net	blogger_dateformat
693	2008-04-15 10:15:38-05	settings	71	U	support@ims.net	blogger_feed_uri_base
694	2008-04-15 10:15:38-05	settings	70	U	support@ims.net	blogger_metafeed_url
695	2008-04-15 10:15:38-05	settings	75	U	support@ims.net	blogger_password
696	2008-04-15 10:15:38-05	settings	72	U	support@ims.net	blogger_posts_feed_uri_suffix
271	2007-11-26 16:55:35-06	nodes	4	U	support@ims.net	1.1 Layout 1 Redux
274	2007-11-26 16:56:03-06	nodes	6	I	support@ims.net	1.3 NEW NODE
276	2007-11-26 16:57:18-06	stylesheet	17	U	support@ims.net	0 table#footer
279	2007-11-26 17:08:19-06	stylesheet	72	D	support@ims.net	2 td.navpri-on
281	2007-11-26 17:08:32-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
287	2007-11-26 17:10:03-06	stylesheet	76	U	support@ims.net	0 td.navpri-off
288	2007-11-26 17:10:29-06	stylesheet	44	U	support@ims.net	0 a.navpri:hover
293	2007-11-27 11:05:24-06	stylesheet	40	U	support@ims.net	0 td.navpri
298	2007-11-27 11:06:46-06	stylesheet	40	U	support@ims.net	0 td.navpri
299	2007-11-27 11:07:00-06	stylesheet	40	U	support@ims.net	0 td.navpri
300	2007-11-27 11:07:14-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
301	2007-11-27 11:07:29-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
302	2007-11-27 11:08:21-06	stylesheet	403	U	support@ims.net	0 div#header-logo
307	2007-11-27 11:27:51-06	stylesheet	403	U	support@ims.net	0 div#header-logo
308	2007-11-27 11:28:00-06	stylesheet	25	U	support@ims.net	0 div#header
309	2007-11-27 11:28:09-06	stylesheet	25	U	support@ims.net	0 div#header
310	2007-11-27 11:28:18-06	stylesheet	25	U	support@ims.net	0 div#header
311	2007-11-27 11:44:53-06	content	1	U	support@ims.net	lorem ipsum text
312	2007-11-27 12:24:53-06	stylesheet	25	U	support@ims.net	0 div#header
314	2007-11-27 12:25:28-06	stylesheet	29	U	support@ims.net	0 table#subheader
315	2007-11-27 15:33:39-06	stylesheet	40	U	support@ims.net	0 td.navpri
316	2007-11-27 15:33:44-06	stylesheet	40	U	support@ims.net	0 td.navpri
317	2007-11-27 15:34:01-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
318	2007-11-27 15:34:22-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
324	2007-11-27 15:35:43-06	stylesheet	40	U	support@ims.net	0 td.navpri
325	2007-11-27 15:36:01-06	stylesheet	94	U	support@ims.net	0 td.navpri-right
326	2007-11-27 15:36:15-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
327	2007-11-27 15:36:30-06	stylesheet	40	U	support@ims.net	0 td.navpri
332	2007-11-27 15:37:45-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
335	2007-11-27 15:39:14-06	stylesheet	628	D	support@ims.net	3 td#main-left
337	2007-11-27 15:39:46-06	stylesheet	103	D	support@ims.net	2 div.navsec-on
340	2007-11-27 17:18:42-06	stylesheet	132	U	support@ims.net	0 #layer1
341	2007-11-27 17:18:49-06	stylesheet	133	U	support@ims.net	0 #layer2
342	2007-11-27 17:18:54-06	stylesheet	134	U	support@ims.net	0 #layer3
343	2007-11-27 17:18:59-06	stylesheet	135	U	support@ims.net	0 #layer4
344	2007-11-27 17:19:05-06	stylesheet	136	U	support@ims.net	0 #layer5
345	2007-11-27 17:19:10-06	stylesheet	155	U	support@ims.net	0 #layer6
348	2007-11-27 17:20:03-06	nodes	8	I	support@ims.net	2.2 NEW NODE
352	2007-11-27 17:25:06-06	stylesheet	132	U	support@ims.net	0 #layer1
353	2007-11-27 17:25:29-06	stylesheet	141	U	support@ims.net	0 table.dhtml
354	2007-11-27 17:25:33-06	stylesheet	141	U	support@ims.net	0 table.dhtml
357	2007-11-27 17:26:44-06	stylesheet	132	U	support@ims.net	0 #layer1
358	2007-11-27 17:26:53-06	stylesheet	132	U	support@ims.net	0 #layer1
359	2007-11-27 17:27:01-06	stylesheet	132	U	support@ims.net	0 #layer1
360	2007-11-27 17:27:09-06	stylesheet	132	U	support@ims.net	0 #layer1
361	2007-11-27 17:27:28-06	stylesheet	133	U	support@ims.net	0 #layer2
362	2007-11-27 17:27:34-06	stylesheet	134	U	support@ims.net	0 #layer3
366	2007-11-27 17:29:14-06	stylesheet	133	U	support@ims.net	0 #layer2
367	2007-11-27 17:29:23-06	stylesheet	133	U	support@ims.net	0 #layer2
368	2007-11-27 17:29:32-06	stylesheet	133	U	support@ims.net	0 #layer2
369	2007-11-27 17:49:10-06	stylesheet	633	U	support@ims.net	0 td#l3_p3
370	2007-11-27 17:52:32-06	settings	340	U	support@ims.net	breadcrumbs_disable
371	2007-11-27 17:52:32-06	settings	341	U	support@ims.net	breadcrumbs_separator
372	2007-11-27 17:52:32-06	settings	51	U	support@ims.net	cp_defaulteditmode
373	2007-11-27 17:52:32-06	settings	401	U	support@ims.net	footer_copyrightshown
374	2007-11-27 17:52:32-06	settings	402	U	support@ims.net	footer_copyrighttext
375	2007-11-27 17:52:32-06	settings	411	U	support@ims.net	footer_dateformat
376	2007-11-27 17:52:32-06	settings	410	U	support@ims.net	footer_dateshown
377	2007-11-27 17:52:32-06	settings	400	U	support@ims.net	footer_disable
378	2007-11-27 17:52:32-06	settings	420	U	support@ims.net	footer_imscredit
379	2007-11-27 17:52:32-06	settings	430	U	support@ims.net	footer_lastupdate
380	2007-11-27 17:52:32-06	settings	100	U	support@ims.net	header_disable
381	2007-11-27 17:52:32-06	settings	110	U	support@ims.net	header_flash
382	2007-11-27 17:52:32-06	settings	115	U	support@ims.net	header_flash_bgcolor
383	2007-11-27 17:52:32-06	settings	114	U	support@ims.net	header_flash_height
384	2007-11-27 17:52:32-06	settings	112	U	support@ims.net	header_flash_homeonly
385	2007-11-27 17:52:32-06	settings	111	U	support@ims.net	header_flash_url
386	2007-11-27 17:52:32-06	settings	113	U	support@ims.net	header_flash_width
387	2007-11-27 17:52:32-06	settings	101	U	support@ims.net	header_search
388	2007-11-27 17:52:33-06	settings	60	U	support@ims.net	ldap_authentication
389	2007-11-27 17:52:33-06	settings	301	U	support@ims.net	navpri_dhtml
390	2007-11-27 17:52:33-06	settings	302	U	support@ims.net	navpri_images
391	2007-11-27 17:52:33-06	settings	303	U	support@ims.net	navpri_level1_disable
392	2007-11-27 17:52:33-06	settings	350	U	support@ims.net	pagetitle_disable
393	2007-11-27 17:52:33-06	settings	351	U	support@ims.net	pagetitle_level1
394	2007-11-27 17:52:33-06	settings	501	U	support@ims.net	printable_logo
395	2007-11-27 17:52:33-06	settings	503	U	support@ims.net	printable_logo_height
396	2007-11-27 17:52:33-06	settings	502	U	support@ims.net	printable_logo_width
397	2007-11-27 17:52:33-06	settings	531	U	support@ims.net	search_image
398	2007-11-27 17:52:33-06	settings	533	U	support@ims.net	search_imageheight
399	2007-11-27 17:52:33-06	settings	532	U	support@ims.net	search_imagewidth
400	2007-11-27 17:52:33-06	settings	530	U	support@ims.net	search_size
401	2007-11-27 17:52:33-06	settings	534	U	support@ims.net	searchblox_cssdir
402	2007-11-27 17:52:33-06	settings	535	U	support@ims.net	searchblox_xsldir
403	2007-11-27 17:52:33-06	settings	321	U	support@ims.net	sectionheader_disable
404	2007-11-27 17:52:33-06	settings	360	U	support@ims.net	sidebar_disable
405	2007-11-27 17:52:33-06	settings	20	U	support@ims.net	site_cssdir
406	2007-11-27 17:52:33-06	settings	21	U	support@ims.net	site_cssfolder
407	2007-11-27 17:52:33-06	settings	22	U	support@ims.net	site_debug
408	2007-11-27 17:52:33-06	settings	10	U	support@ims.net	site_designdir
409	2007-11-27 17:52:33-06	settings	9	U	support@ims.net	site_designfolder
410	2007-11-27 17:52:33-06	settings	6	U	support@ims.net	site_imagedir
411	2007-11-27 17:52:33-06	settings	5	U	support@ims.net	site_imagefolder
412	2007-11-27 17:52:33-06	settings	4	U	support@ims.net	site_maxuploadsize
413	2007-11-27 17:52:33-06	settings	8	U	support@ims.net	site_mediadir
414	2007-11-27 17:52:33-06	settings	7	U	support@ims.net	site_mediafolder
415	2007-11-27 17:52:33-06	settings	1	U	support@ims.net	site_name
416	2007-11-27 17:52:33-06	settings	19	U	support@ims.net	site_rootfolder
417	2007-11-27 17:52:33-06	settings	521	U	support@ims.net	sitemap_headtitle
418	2007-11-27 17:52:33-06	settings	520	U	support@ims.net	sitemap_pagetitle
419	2007-11-27 17:52:33-06	settings	202	U	support@ims.net	subheader_dateformat
420	2007-11-27 17:52:33-06	settings	201	U	support@ims.net	subheader_dateshown
421	2007-11-27 17:52:33-06	settings	200	U	support@ims.net	subheader_disable
422	2007-11-27 17:52:33-06	settings	210	U	support@ims.net	subheader_flash
423	2007-11-27 17:52:33-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
424	2007-11-27 17:52:33-06	settings	214	U	support@ims.net	subheader_flash_height
425	2007-11-27 17:52:33-06	settings	212	U	support@ims.net	subheader_flash_homeonly
426	2007-11-27 17:52:33-06	settings	211	U	support@ims.net	subheader_flash_url
427	2007-11-27 17:52:33-06	settings	213	U	support@ims.net	subheader_flash_width
428	2007-11-27 17:52:59-06	stylesheet	25	U	support@ims.net	0 div#header
429	2007-11-27 17:53:14-06	stylesheet	25	U	support@ims.net	0 div#header
430	2007-11-27 17:53:56-06	stylesheet	480	U	support@ims.net	0 table.search
435	2007-11-27 17:56:04-06	stylesheet	480	U	support@ims.net	0 table.search
436	2007-11-28 13:24:46-06	stylesheet	579	U	support@ims.net	0 td#main-left
437	2007-11-28 13:25:03-06	stylesheet	579	U	support@ims.net	0 td#main-left
438	2007-11-28 13:25:12-06	stylesheet	579	U	support@ims.net	0 td#main-left
439	2007-11-28 13:25:21-06	stylesheet	579	U	support@ims.net	0 td#main-left
440	2007-11-28 13:25:28-06	stylesheet	579	U	support@ims.net	0 td#main-left
441	2007-11-28 13:28:39-06	stylesheet	658	D	support@ims.net	1 table#sectionheader
442	2007-11-28 13:28:42-06	stylesheet	663	D	support@ims.net	2 table#sectionheader
443	2007-11-28 13:28:46-06	stylesheet	662	D	support@ims.net	3 table#sectionheader
444	2007-11-28 13:38:10-06	stylesheet	480	U	support@ims.net	0 table.search
445	2007-11-28 13:38:49-06	stylesheet	480	U	support@ims.net	0 table.search
446	2007-11-28 13:38:52-06	stylesheet	482	U	support@ims.net	0 td.search-word
447	2007-11-28 13:39:02-06	stylesheet	482	U	support@ims.net	0 td.search-word
448	2007-11-28 13:39:16-06	stylesheet	480	U	support@ims.net	0 table.search
449	2007-11-28 13:39:27-06	stylesheet	482	U	support@ims.net	0 td.search-word
450	2007-11-28 13:39:34-06	stylesheet	482	U	support@ims.net	0 td.search-word
451	2007-11-28 13:39:51-06	stylesheet	482	U	support@ims.net	0 td.search-word
452	2007-11-28 13:57:38-06	stylesheet	482	U	support@ims.net	0 td.search-word
453	2007-11-28 13:57:48-06	stylesheet	482	U	support@ims.net	0 td.search-word
454	2007-11-28 13:58:19-06	stylesheet	485	U	support@ims.net	0 input.search
455	2007-11-28 13:58:30-06	stylesheet	485	U	support@ims.net	0 input.search
456	2007-11-28 13:58:44-06	stylesheet	481	U	support@ims.net	0 td.search-input
457	2007-11-28 13:59:14-06	stylesheet	498	U	support@ims.net	0 td.search-button
458	2007-11-28 13:59:29-06	stylesheet	498	U	support@ims.net	0 td.search-button
463	2007-11-28 14:00:48-06	stylesheet	482	U	support@ims.net	0 td.search-word
464	2007-11-28 14:01:04-06	stylesheet	482	U	support@ims.net	0 td.search-word
465	2007-11-28 14:01:13-06	stylesheet	482	U	support@ims.net	0 td.search-word
466	2007-11-28 14:01:21-06	stylesheet	482	U	support@ims.net	0 td.search-word
467	2007-11-28 14:01:34-06	stylesheet	482	U	support@ims.net	0 td.search-word
472	2007-11-28 14:02:38-06	stylesheet	481	U	support@ims.net	0 td.search-input
473	2007-11-28 14:02:48-06	stylesheet	498	U	support@ims.net	0 td.search-button
474	2007-11-28 14:03:04-06	stylesheet	485	U	support@ims.net	0 input.search
475	2007-11-28 14:03:07-06	stylesheet	485	U	support@ims.net	0 input.search
476	2007-11-28 14:03:10-06	stylesheet	481	U	support@ims.net	0 td.search-input
477	2007-11-28 14:03:18-06	stylesheet	481	U	support@ims.net	0 td.search-input
482	2007-11-28 14:04:42-06	stylesheet	486	U	support@ims.net	0 div#search
483	2007-11-28 14:04:55-06	stylesheet	480	U	support@ims.net	0 table.search
485	2007-11-28 14:22:21-06	stylesheet	162	U	support@ims.net	0 table#main
487	2007-11-28 14:23:23-06	utilitylinks	1	I	support@ims.net	H: Home
488	2007-11-28 14:23:37-06	utilitylinks	2	I	support@ims.net	H: Site Map
494	2007-11-28 14:26:50-06	stylesheet	30	U	support@ims.net	0 a.subheader:link
495	2007-11-28 14:26:54-06	stylesheet	31	U	support@ims.net	0 a.subheader:visited
496	2007-11-28 14:26:58-06	stylesheet	32	U	support@ims.net	0 a.subheader:hover
497	2007-11-28 14:27:01-06	stylesheet	33	U	support@ims.net	0 a.subheader:active
500	2007-11-28 14:44:12-06	stylesheet	163	U	support@ims.net	0 div.navsec-on
560	2007-11-28 15:30:22-06	settings	340	U	support@ims.net	breadcrumbs_disable
561	2007-11-28 15:30:22-06	settings	341	U	support@ims.net	breadcrumbs_separator
562	2007-11-28 15:30:22-06	settings	51	U	support@ims.net	cp_defaulteditmode
563	2007-11-28 15:30:22-06	settings	401	U	support@ims.net	footer_copyrightshown
564	2007-11-28 15:30:22-06	settings	402	U	support@ims.net	footer_copyrighttext
565	2007-11-28 15:30:22-06	settings	411	U	support@ims.net	footer_dateformat
566	2007-11-28 15:30:22-06	settings	410	U	support@ims.net	footer_dateshown
567	2007-11-28 15:30:22-06	settings	400	U	support@ims.net	footer_disable
568	2007-11-28 15:30:22-06	settings	420	U	support@ims.net	footer_imscredit
569	2007-11-28 15:30:22-06	settings	430	U	support@ims.net	footer_lastupdate
570	2007-11-28 15:30:22-06	settings	100	U	support@ims.net	header_disable
571	2007-11-28 15:30:22-06	settings	110	U	support@ims.net	header_flash
572	2007-11-28 15:30:22-06	settings	115	U	support@ims.net	header_flash_bgcolor
573	2007-11-28 15:30:22-06	settings	114	U	support@ims.net	header_flash_height
574	2007-11-28 15:30:22-06	settings	112	U	support@ims.net	header_flash_homeonly
575	2007-11-28 15:30:22-06	settings	111	U	support@ims.net	header_flash_url
576	2007-11-28 15:30:22-06	settings	113	U	support@ims.net	header_flash_width
577	2007-11-28 15:30:22-06	settings	101	U	support@ims.net	header_search
578	2007-11-28 15:30:22-06	settings	60	U	support@ims.net	ldap_authentication
579	2007-11-28 15:30:22-06	settings	301	U	support@ims.net	navpri_dhtml
580	2007-11-28 15:30:22-06	settings	302	U	support@ims.net	navpri_images
581	2007-11-28 15:30:22-06	settings	303	U	support@ims.net	navpri_level1_disable
582	2007-11-28 15:30:22-06	settings	350	U	support@ims.net	pagetitle_disable
583	2007-11-28 15:30:22-06	settings	351	U	support@ims.net	pagetitle_level1
584	2007-11-28 15:30:22-06	settings	501	U	support@ims.net	printable_logo
585	2007-11-28 15:30:22-06	settings	503	U	support@ims.net	printable_logo_height
586	2007-11-28 15:30:22-06	settings	502	U	support@ims.net	printable_logo_width
587	2007-11-28 15:30:22-06	settings	531	U	support@ims.net	search_image
588	2007-11-28 15:30:22-06	settings	533	U	support@ims.net	search_imageheight
589	2007-11-28 15:30:22-06	settings	532	U	support@ims.net	search_imagewidth
590	2007-11-28 15:30:22-06	settings	530	U	support@ims.net	search_size
591	2007-11-28 15:30:22-06	settings	534	U	support@ims.net	searchblox_cssdir
592	2007-11-28 15:30:22-06	settings	535	U	support@ims.net	searchblox_xsldir
593	2007-11-28 15:30:22-06	settings	321	U	support@ims.net	sectionheader_disable
594	2007-11-28 15:30:22-06	settings	360	U	support@ims.net	sidebar_disable
595	2007-11-28 15:30:22-06	settings	20	U	support@ims.net	site_cssdir
596	2007-11-28 15:30:22-06	settings	21	U	support@ims.net	site_cssfolder
597	2007-11-28 15:30:22-06	settings	22	U	support@ims.net	site_debug
598	2007-11-28 15:30:22-06	settings	10	U	support@ims.net	site_designdir
599	2007-11-28 15:30:22-06	settings	9	U	support@ims.net	site_designfolder
600	2007-11-28 15:30:22-06	settings	6	U	support@ims.net	site_imagedir
601	2007-11-28 15:30:22-06	settings	5	U	support@ims.net	site_imagefolder
602	2007-11-28 15:30:22-06	settings	4	U	support@ims.net	site_maxuploadsize
603	2007-11-28 15:30:22-06	settings	8	U	support@ims.net	site_mediadir
604	2007-11-28 15:30:22-06	settings	7	U	support@ims.net	site_mediafolder
459	2007-11-28 13:59:38-06	stylesheet	498	U	support@ims.net	0 td.search-button
460	2007-11-28 14:00:07-06	stylesheet	485	U	support@ims.net	0 input.search
461	2007-11-28 14:00:19-06	stylesheet	485	U	support@ims.net	0 input.search
462	2007-11-28 14:00:33-06	stylesheet	485	U	support@ims.net	0 input.search
468	2007-11-28 14:01:55-06	stylesheet	498	U	support@ims.net	0 td.search-button
469	2007-11-28 14:02:05-06	stylesheet	498	U	support@ims.net	0 td.search-button
470	2007-11-28 14:02:13-06	stylesheet	498	U	support@ims.net	0 td.search-button
471	2007-11-28 14:02:24-06	stylesheet	481	U	support@ims.net	0 td.search-input
478	2007-11-28 14:03:47-06	stylesheet	482	U	support@ims.net	0 td.search-word
479	2007-11-28 14:04:02-06	stylesheet	486	U	support@ims.net	0 div#search
480	2007-11-28 14:04:20-06	stylesheet	486	U	support@ims.net	0 div#search
481	2007-11-28 14:04:30-06	stylesheet	486	U	support@ims.net	0 div#search
484	2007-11-28 14:21:07-06	stylesheet	200	U	support@ims.net	0 table#sectionheader
486	2007-11-28 14:22:40-06	stylesheet	162	U	support@ims.net	0 table#main
489	2007-11-28 14:24:00-06	utilitylinks	3	I	support@ims.net	H: Printer-Friendly
490	2007-11-28 14:26:12-06	stylesheet	30	U	support@ims.net	0 a.subheader:link
491	2007-11-28 14:26:17-06	stylesheet	31	U	support@ims.net	0 a.subheader:visited
492	2007-11-28 14:26:20-06	stylesheet	32	U	support@ims.net	0 a.subheader:hover
493	2007-11-28 14:26:23-06	stylesheet	33	U	support@ims.net	0 a.subheader:active
498	2007-11-28 14:27:41-06	stylesheet	39	U	support@ims.net	0 td.subheader
499	2007-11-28 14:27:55-06	stylesheet	39	U	support@ims.net	0 td.subheader
501	2007-11-28 14:54:21-06	settings	340	U	support@ims.net	breadcrumbs_disable
502	2007-11-28 14:54:21-06	settings	341	U	support@ims.net	breadcrumbs_separator
503	2007-11-28 14:54:21-06	settings	51	U	support@ims.net	cp_defaulteditmode
504	2007-11-28 14:54:21-06	settings	401	U	support@ims.net	footer_copyrightshown
505	2007-11-28 14:54:21-06	settings	402	U	support@ims.net	footer_copyrighttext
506	2007-11-28 14:54:21-06	settings	411	U	support@ims.net	footer_dateformat
507	2007-11-28 14:54:21-06	settings	410	U	support@ims.net	footer_dateshown
508	2007-11-28 14:54:21-06	settings	400	U	support@ims.net	footer_disable
509	2007-11-28 14:54:21-06	settings	420	U	support@ims.net	footer_imscredit
510	2007-11-28 14:54:21-06	settings	430	U	support@ims.net	footer_lastupdate
511	2007-11-28 14:54:21-06	settings	100	U	support@ims.net	header_disable
512	2007-11-28 14:54:21-06	settings	110	U	support@ims.net	header_flash
513	2007-11-28 14:54:21-06	settings	115	U	support@ims.net	header_flash_bgcolor
514	2007-11-28 14:54:21-06	settings	114	U	support@ims.net	header_flash_height
515	2007-11-28 14:54:21-06	settings	112	U	support@ims.net	header_flash_homeonly
516	2007-11-28 14:54:21-06	settings	111	U	support@ims.net	header_flash_url
517	2007-11-28 14:54:21-06	settings	113	U	support@ims.net	header_flash_width
518	2007-11-28 14:54:21-06	settings	101	U	support@ims.net	header_search
519	2007-11-28 14:54:21-06	settings	60	U	support@ims.net	ldap_authentication
520	2007-11-28 14:54:21-06	settings	301	U	support@ims.net	navpri_dhtml
521	2007-11-28 14:54:21-06	settings	302	U	support@ims.net	navpri_images
522	2007-11-28 14:54:21-06	settings	303	U	support@ims.net	navpri_level1_disable
523	2007-11-28 14:54:21-06	settings	350	U	support@ims.net	pagetitle_disable
524	2007-11-28 14:54:21-06	settings	351	U	support@ims.net	pagetitle_level1
525	2007-11-28 14:54:21-06	settings	501	U	support@ims.net	printable_logo
526	2007-11-28 14:54:21-06	settings	503	U	support@ims.net	printable_logo_height
527	2007-11-28 14:54:21-06	settings	502	U	support@ims.net	printable_logo_width
528	2007-11-28 14:54:21-06	settings	531	U	support@ims.net	search_image
529	2007-11-28 14:54:21-06	settings	533	U	support@ims.net	search_imageheight
530	2007-11-28 14:54:21-06	settings	532	U	support@ims.net	search_imagewidth
531	2007-11-28 14:54:21-06	settings	530	U	support@ims.net	search_size
532	2007-11-28 14:54:21-06	settings	534	U	support@ims.net	searchblox_cssdir
533	2007-11-28 14:54:21-06	settings	535	U	support@ims.net	searchblox_xsldir
534	2007-11-28 14:54:21-06	settings	321	U	support@ims.net	sectionheader_disable
535	2007-11-28 14:54:21-06	settings	360	U	support@ims.net	sidebar_disable
536	2007-11-28 14:54:21-06	settings	20	U	support@ims.net	site_cssdir
537	2007-11-28 14:54:21-06	settings	21	U	support@ims.net	site_cssfolder
538	2007-11-28 14:54:21-06	settings	22	U	support@ims.net	site_debug
539	2007-11-28 14:54:21-06	settings	10	U	support@ims.net	site_designdir
540	2007-11-28 14:54:21-06	settings	9	U	support@ims.net	site_designfolder
541	2007-11-28 14:54:21-06	settings	6	U	support@ims.net	site_imagedir
542	2007-11-28 14:54:21-06	settings	5	U	support@ims.net	site_imagefolder
543	2007-11-28 14:54:21-06	settings	4	U	support@ims.net	site_maxuploadsize
544	2007-11-28 14:54:21-06	settings	8	U	support@ims.net	site_mediadir
545	2007-11-28 14:54:21-06	settings	7	U	support@ims.net	site_mediafolder
546	2007-11-28 14:54:21-06	settings	1	U	support@ims.net	site_name
547	2007-11-28 14:54:21-06	settings	19	U	support@ims.net	site_rootfolder
548	2007-11-28 14:54:21-06	settings	521	U	support@ims.net	sitemap_headtitle
549	2007-11-28 14:54:21-06	settings	520	U	support@ims.net	sitemap_pagetitle
550	2007-11-28 14:54:21-06	settings	202	U	support@ims.net	subheader_dateformat
551	2007-11-28 14:54:21-06	settings	201	U	support@ims.net	subheader_dateshown
552	2007-11-28 14:54:21-06	settings	200	U	support@ims.net	subheader_disable
553	2007-11-28 14:54:21-06	settings	210	U	support@ims.net	subheader_flash
554	2007-11-28 14:54:21-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
555	2007-11-28 14:54:21-06	settings	214	U	support@ims.net	subheader_flash_height
556	2007-11-28 14:54:21-06	settings	212	U	support@ims.net	subheader_flash_homeonly
557	2007-11-28 14:54:21-06	settings	211	U	support@ims.net	subheader_flash_url
558	2007-11-28 14:54:21-06	settings	213	U	support@ims.net	subheader_flash_width
559	2007-11-28 15:30:07-06	stylesheet	431	U	support@ims.net	-1 div#header
621	2007-11-28 15:35:50-06	stylesheet	441	U	support@ims.net	-1 table#subheader
622	2007-11-28 15:36:09-06	stylesheet	396	U	support@ims.net	-1 a.subheader:active
623	2007-11-28 15:36:19-06	stylesheet	467	U	support@ims.net	-1 td.subheader-left
624	2007-11-28 15:36:33-06	stylesheet	469	U	support@ims.net	-1 td.subheader-right
625	2007-11-28 15:36:36-06	stylesheet	469	U	support@ims.net	-1 td.subheader-right
626	2007-11-28 15:44:14-06	stylesheet	467	U	support@ims.net	-1 td.subheader-left
629	2007-11-28 15:45:45-06	stylesheet	465	U	support@ims.net	-1 td.subheader
634	2007-11-28 15:57:50-06	stylesheet	581	U	support@ims.net	-1 td#main-right
635	2007-11-28 15:58:00-06	stylesheet	581	U	support@ims.net	-1 td#main-right
636	2007-11-29 12:49:04-06	stylesheet	76	U	support@ims.net	0 td.navpri-off
637	2007-11-29 12:49:28-06	stylesheet	41	U	support@ims.net	0 a.navpri:link
638	2007-11-29 12:49:32-06	stylesheet	42	U	support@ims.net	0 a.navpri:visited
639	2007-11-29 12:49:35-06	stylesheet	44	U	support@ims.net	0 a.navpri:hover
646	2007-11-29 12:50:56-06	stylesheet	556	U	support@ims.net	0 a.navpri-on:link
647	2007-11-29 12:50:59-06	stylesheet	557	U	support@ims.net	0 a.navpri-on:visited
648	2007-11-29 12:51:01-06	stylesheet	558	U	support@ims.net	0 a.navpri-on: hover
649	2007-11-29 12:51:03-06	stylesheet	559	U	support@ims.net	0 a.navpri-on: active
650	2007-11-29 12:51:23-06	stylesheet	161	U	support@ims.net	0 td.navpri-on
651	2007-11-29 13:37:38-06	stylesheet	62	U	support@ims.net	0 table.sitemap
652	2007-11-29 13:38:13-06	stylesheet	62	U	support@ims.net	0 table.sitemap
653	2007-11-29 13:38:26-06	stylesheet	62	U	support@ims.net	0 table.sitemap
654	2007-11-29 13:38:33-06	stylesheet	62	U	support@ims.net	0 table.sitemap
659	2007-11-29 13:41:48-06	stylesheet	63	U	support@ims.net	0 td.sitemap
660	2007-11-29 13:42:06-06	stylesheet	62	U	support@ims.net	0 table.sitemap
661	2007-11-29 13:42:19-06	stylesheet	62	U	support@ims.net	0 table.sitemap
662	2007-11-29 13:44:23-06	stylesheet	62	U	support@ims.net	0 table.sitemap
663	2007-11-29 13:44:36-06	stylesheet	62	U	support@ims.net	0 table.sitemap
666	2007-11-29 13:45:31-06	stylesheet	440	U	support@ims.net	-1 table.sitemap
667	2007-11-29 13:45:36-06	stylesheet	464	U	support@ims.net	-1 td.sitemap
682	2007-12-20 14:43:36-06	stylesheet	532	U	support@ims.net	0 div.error
683	2007-12-20 14:43:40-06	stylesheet	533	U	support@ims.net	0 div.message
684	2007-12-20 14:43:44-06	stylesheet	59	U	support@ims.net	0 div.debug
697	2008-04-15 10:15:38-05	settings	76	U	support@ims.net	blogger_service_name
698	2008-04-15 10:15:38-05	settings	74	U	support@ims.net	blogger_username
699	2008-04-15 10:15:38-05	settings	340	U	support@ims.net	breadcrumbs_disable
700	2008-04-15 10:15:38-05	settings	341	U	support@ims.net	breadcrumbs_separator
701	2008-04-15 10:15:38-05	settings	544	U	support@ims.net	comments_buttontext
702	2008-04-15 10:15:38-05	settings	540	U	support@ims.net	comments_dateformat
703	2008-04-15 10:15:38-05	settings	541	U	support@ims.net	comments_inputsize
704	2008-04-15 10:15:38-05	settings	542	U	support@ims.net	comments_textcols
705	2008-04-15 10:15:38-05	settings	543	U	support@ims.net	comments_textrows
706	2008-04-15 10:15:38-05	settings	51	U	support@ims.net	cp_defaulteditmode
707	2008-04-15 10:15:38-05	settings	401	U	support@ims.net	footer_copyrightshown
708	2008-04-15 10:15:38-05	settings	402	U	support@ims.net	footer_copyrighttext
709	2008-04-15 10:15:38-05	settings	411	U	support@ims.net	footer_dateformat
710	2008-04-15 10:15:38-05	settings	410	U	support@ims.net	footer_dateshown
711	2008-04-15 10:15:38-05	settings	400	U	support@ims.net	footer_disable
712	2008-04-15 10:15:38-05	settings	420	U	support@ims.net	footer_imscredit
713	2008-04-15 10:15:38-05	settings	430	U	support@ims.net	footer_lastupdate
714	2008-04-15 10:15:38-05	settings	100	U	support@ims.net	header_disable
715	2008-04-15 10:15:38-05	settings	110	U	support@ims.net	header_flash
716	2008-04-15 10:15:38-05	settings	115	U	support@ims.net	header_flash_bgcolor
717	2008-04-15 10:15:38-05	settings	114	U	support@ims.net	header_flash_height
605	2007-11-28 15:30:22-06	settings	1	U	support@ims.net	site_name
606	2007-11-28 15:30:22-06	settings	19	U	support@ims.net	site_rootfolder
607	2007-11-28 15:30:22-06	settings	521	U	support@ims.net	sitemap_headtitle
608	2007-11-28 15:30:22-06	settings	520	U	support@ims.net	sitemap_pagetitle
609	2007-11-28 15:30:22-06	settings	202	U	support@ims.net	subheader_dateformat
610	2007-11-28 15:30:22-06	settings	201	U	support@ims.net	subheader_dateshown
611	2007-11-28 15:30:22-06	settings	200	U	support@ims.net	subheader_disable
612	2007-11-28 15:30:22-06	settings	210	U	support@ims.net	subheader_flash
613	2007-11-28 15:30:22-06	settings	215	U	support@ims.net	subheader_flash_bgcolor
614	2007-11-28 15:30:22-06	settings	214	U	support@ims.net	subheader_flash_height
615	2007-11-28 15:30:22-06	settings	212	U	support@ims.net	subheader_flash_homeonly
616	2007-11-28 15:30:22-06	settings	211	U	support@ims.net	subheader_flash_url
617	2007-11-28 15:30:22-06	settings	213	U	support@ims.net	subheader_flash_width
618	2007-11-28 15:30:42-06	stylesheet	431	U	support@ims.net	-1 div#header
619	2007-11-28 15:30:58-06	stylesheet	431	U	support@ims.net	-1 div#header
620	2007-11-28 15:31:08-06	stylesheet	431	U	support@ims.net	-1 div#header
627	2007-11-28 15:44:43-06	stylesheet	466	U	support@ims.net	-1 td.subheader-date
628	2007-11-28 15:45:07-06	stylesheet	469	U	support@ims.net	-1 td.subheader-right
630	2007-11-28 15:46:45-06	stylesheet	441	U	support@ims.net	-1 table#subheader
631	2007-11-28 15:48:43-06	stylesheet	416	U	support@ims.net	-1 div#pagetitle
632	2007-11-28 15:48:58-06	stylesheet	416	U	support@ims.net	-1 div#pagetitle
633	2007-11-28 15:57:33-06	stylesheet	581	U	support@ims.net	-1 td#main-right
640	2007-11-29 12:49:43-06	stylesheet	44	U	support@ims.net	0 a.navpri:hover
641	2007-11-29 12:50:00-06	stylesheet	68	U	support@ims.net	0 td.navpri-over
642	2007-11-29 12:50:17-06	stylesheet	556	U	support@ims.net	0 a.navpri-on:link
643	2007-11-29 12:50:21-06	stylesheet	557	U	support@ims.net	0 a.navpri-on:visited
644	2007-11-29 12:50:23-06	stylesheet	558	U	support@ims.net	0 a.navpri-on: hover
645	2007-11-29 12:50:25-06	stylesheet	559	U	support@ims.net	0 a.navpri-on: active
655	2007-11-29 13:38:44-06	stylesheet	62	U	support@ims.net	0 table.sitemap
656	2007-11-29 13:39:04-06	stylesheet	62	U	support@ims.net	0 table.sitemap
657	2007-11-29 13:39:15-06	stylesheet	63	U	support@ims.net	0 td.sitemap
658	2007-11-29 13:41:26-06	stylesheet	62	U	support@ims.net	0 table.sitemap
664	2007-11-29 13:44:50-06	stylesheet	62	U	support@ims.net	0 table.sitemap
665	2007-11-29 13:45:02-06	stylesheet	62	U	support@ims.net	0 table.sitemap
668	2007-11-29 13:45:54-06	stylesheet	440	U	support@ims.net	-1 table.sitemap
669	2007-11-29 13:46:10-06	stylesheet	464	U	support@ims.net	-1 td.sitemap
670	2007-11-29 13:46:50-06	stylesheet	431	U	support@ims.net	-1 div#header
671	2007-11-29 13:47:02-06	stylesheet	431	U	support@ims.net	-1 div#header
672	2007-12-12 15:38:29-06	stylesheet	545	D	support@ims.net	0 table.debug
673	2007-12-12 15:38:36-06	stylesheet	622	D	support@ims.net	0 .caption
674	2007-12-12 15:38:43-06	stylesheet	621	D	support@ims.net	0 div.image
675	2007-12-12 15:38:51-06	stylesheet	656	D	support@ims.net	0 td.teamnav
685	2008-04-02 19:27:33-05	layouts	1	U	support@ims.net	l1: single pane
686	2008-04-02 19:27:43-05	layouts	2	U	support@ims.net	l2: two columns
687	2008-04-02 19:27:52-05	layouts	3	U	support@ims.net	l3: two columns above full-width pane
688	2008-04-02 20:22:23-05	users	1	U	support@ims.net	support@ims.net
718	2008-04-15 10:15:38-05	settings	112	U	support@ims.net	header_flash_homeonly
719	2008-04-15 10:15:38-05	settings	111	U	support@ims.net	header_flash_url
720	2008-04-15 10:15:38-05	settings	113	U	support@ims.net	header_flash_width
721	2008-04-15 10:15:38-05	settings	101	U	support@ims.net	header_search
722	2008-04-15 10:15:38-05	settings	60	U	support@ims.net	ldap_authentication
723	2008-04-15 10:15:38-05	settings	301	U	support@ims.net	navpri_dhtml_disable
724	2008-04-15 10:15:38-05	settings	302	U	support@ims.net	navpri_images
725	2008-04-15 10:15:38-05	settings	303	U	support@ims.net	navpri_level1_disable
726	2008-04-15 10:15:38-05	settings	330	U	support@ims.net	navquat_disable
727	2008-04-15 10:15:38-05	settings	350	U	support@ims.net	pagetitle_disable
728	2008-04-15 10:15:38-05	settings	351	U	support@ims.net	pagetitle_level1
729	2008-04-15 10:15:38-05	settings	501	U	support@ims.net	printable_logo
730	2008-04-15 10:15:38-05	settings	503	U	support@ims.net	printable_logo_height
731	2008-04-15 10:15:38-05	settings	502	U	support@ims.net	printable_logo_width
732	2008-04-15 10:15:38-05	settings	34	U	support@ims.net	root_footer_disable
733	2008-04-15 10:15:38-05	settings	30	U	support@ims.net	root_header_disable
734	2008-04-15 10:15:38-05	settings	31	U	support@ims.net	root_nav_primary_disable
735	2008-04-15 10:15:38-05	settings	32	U	support@ims.net	root_sectionheader_disable
736	2008-04-15 10:15:38-05	settings	33	U	support@ims.net	root_subheader_disable
737	2008-04-15 10:15:38-05	settings	531	U	support@ims.net	search_image
738	2008-04-15 10:15:38-05	settings	533	U	support@ims.net	search_imageheight
739	2008-04-15 10:15:38-05	settings	532	U	support@ims.net	search_imagewidth
740	2008-04-15 10:15:38-05	settings	530	U	support@ims.net	search_size
741	2008-04-15 10:15:38-05	settings	534	U	support@ims.net	searchblox_cssdir
742	2008-04-15 10:15:38-05	settings	535	U	support@ims.net	searchblox_xsldir
743	2008-04-15 10:15:38-05	settings	321	U	support@ims.net	sectionheader_disable
744	2008-04-15 10:15:38-05	settings	360	U	support@ims.net	sidebar_disable
745	2008-04-15 10:15:38-05	settings	25	U	support@ims.net	site_center
746	2008-04-15 10:15:38-05	settings	20	U	support@ims.net	site_cssdir
747	2008-04-15 10:15:38-05	settings	21	U	support@ims.net	site_cssfolder
748	2008-04-15 10:15:38-05	settings	22	U	support@ims.net	site_debug
749	2008-04-15 10:15:38-05	settings	10	U	support@ims.net	site_designdir
750	2008-04-15 10:15:38-05	settings	9	U	support@ims.net	site_designfolder
751	2008-04-15 10:15:38-05	settings	23	U	support@ims.net	site_host
752	2008-04-15 10:15:38-05	settings	6	U	support@ims.net	site_imagedir
753	2008-04-15 10:15:38-05	settings	5	U	support@ims.net	site_imagefolder
754	2008-04-15 10:15:38-05	settings	4	U	support@ims.net	site_maxuploadsize
755	2008-04-15 10:15:38-05	settings	8	U	support@ims.net	site_mediadir
756	2008-04-15 10:15:38-05	settings	7	U	support@ims.net	site_mediafolder
757	2008-04-15 10:15:38-05	settings	1	U	support@ims.net	site_name
758	2008-04-15 10:15:38-05	settings	19	U	support@ims.net	site_rootfolder
759	2008-04-15 10:15:38-05	settings	24	U	support@ims.net	site_sslhost
760	2008-04-15 10:15:38-05	settings	521	U	support@ims.net	sitemap_headtitle
761	2008-04-15 10:15:38-05	settings	520	U	support@ims.net	sitemap_pagetitle
762	2008-04-15 10:15:38-05	settings	203	U	support@ims.net	subheader_date_homeonly
763	2008-04-15 10:15:38-05	settings	202	U	support@ims.net	subheader_dateformat
764	2008-04-15 10:15:38-05	settings	201	U	support@ims.net	subheader_dateshown
765	2008-04-15 10:15:38-05	settings	200	U	support@ims.net	subheader_disable
766	2008-04-15 10:15:38-05	settings	210	U	support@ims.net	subheader_flash
767	2008-04-15 10:15:38-05	settings	215	U	support@ims.net	subheader_flash_bgcolor
768	2008-04-15 10:15:38-05	settings	214	U	support@ims.net	subheader_flash_height
769	2008-04-15 10:15:38-05	settings	212	U	support@ims.net	subheader_flash_homeonly
770	2008-04-15 10:15:38-05	settings	211	U	support@ims.net	subheader_flash_url
771	2008-04-15 10:15:38-05	settings	213	U	support@ims.net	subheader_flash_width
772	2008-04-15 10:15:55-05	settings	77	U	support@ims.net	blogger_application_name
773	2008-04-15 10:15:55-05	settings	79	U	support@ims.net	blogger_comment_post_uri
774	2008-04-15 10:15:55-05	settings	73	U	support@ims.net	blogger_comments_feed_uri_suffix
775	2008-04-15 10:15:55-05	settings	78	U	support@ims.net	blogger_dateformat
776	2008-04-15 10:15:55-05	settings	71	U	support@ims.net	blogger_feed_uri_base
777	2008-04-15 10:15:55-05	settings	70	U	support@ims.net	blogger_metafeed_url
778	2008-04-15 10:15:55-05	settings	75	U	support@ims.net	blogger_password
779	2008-04-15 10:15:55-05	settings	72	U	support@ims.net	blogger_posts_feed_uri_suffix
780	2008-04-15 10:15:55-05	settings	76	U	support@ims.net	blogger_service_name
781	2008-04-15 10:15:55-05	settings	74	U	support@ims.net	blogger_username
782	2008-04-15 10:15:55-05	settings	340	U	support@ims.net	breadcrumbs_disable
783	2008-04-15 10:15:55-05	settings	341	U	support@ims.net	breadcrumbs_separator
784	2008-04-15 10:15:55-05	settings	544	U	support@ims.net	comments_buttontext
785	2008-04-15 10:15:55-05	settings	540	U	support@ims.net	comments_dateformat
786	2008-04-15 10:15:55-05	settings	541	U	support@ims.net	comments_inputsize
787	2008-04-15 10:15:55-05	settings	542	U	support@ims.net	comments_textcols
788	2008-04-15 10:15:55-05	settings	543	U	support@ims.net	comments_textrows
789	2008-04-15 10:15:56-05	settings	51	U	support@ims.net	cp_defaulteditmode
790	2008-04-15 10:15:56-05	settings	401	U	support@ims.net	footer_copyrightshown
791	2008-04-15 10:15:56-05	settings	402	U	support@ims.net	footer_copyrighttext
792	2008-04-15 10:15:56-05	settings	411	U	support@ims.net	footer_dateformat
793	2008-04-15 10:15:56-05	settings	410	U	support@ims.net	footer_dateshown
794	2008-04-15 10:15:56-05	settings	400	U	support@ims.net	footer_disable
795	2008-04-15 10:15:56-05	settings	420	U	support@ims.net	footer_imscredit
796	2008-04-15 10:15:56-05	settings	430	U	support@ims.net	footer_lastupdate
797	2008-04-15 10:15:56-05	settings	100	U	support@ims.net	header_disable
798	2008-04-15 10:15:56-05	settings	110	U	support@ims.net	header_flash
799	2008-04-15 10:15:56-05	settings	115	U	support@ims.net	header_flash_bgcolor
800	2008-04-15 10:15:56-05	settings	114	U	support@ims.net	header_flash_height
801	2008-04-15 10:15:56-05	settings	112	U	support@ims.net	header_flash_homeonly
802	2008-04-15 10:15:56-05	settings	111	U	support@ims.net	header_flash_url
803	2008-04-15 10:15:56-05	settings	113	U	support@ims.net	header_flash_width
804	2008-04-15 10:15:56-05	settings	101	U	support@ims.net	header_search
805	2008-04-15 10:15:56-05	settings	60	U	support@ims.net	ldap_authentication
806	2008-04-15 10:15:56-05	settings	301	U	support@ims.net	navpri_dhtml_disable
807	2008-04-15 10:15:56-05	settings	302	U	support@ims.net	navpri_images
808	2008-04-15 10:15:56-05	settings	303	U	support@ims.net	navpri_level1_disable
809	2008-04-15 10:15:56-05	settings	330	U	support@ims.net	navquat_disable
810	2008-04-15 10:15:56-05	settings	350	U	support@ims.net	pagetitle_disable
811	2008-04-15 10:15:56-05	settings	351	U	support@ims.net	pagetitle_level1
812	2008-04-15 10:15:56-05	settings	501	U	support@ims.net	printable_logo
813	2008-04-15 10:15:56-05	settings	503	U	support@ims.net	printable_logo_height
814	2008-04-15 10:15:56-05	settings	502	U	support@ims.net	printable_logo_width
815	2008-04-15 10:15:56-05	settings	34	U	support@ims.net	root_footer_disable
816	2008-04-15 10:15:56-05	settings	30	U	support@ims.net	root_header_disable
817	2008-04-15 10:15:56-05	settings	31	U	support@ims.net	root_nav_primary_disable
818	2008-04-15 10:15:56-05	settings	32	U	support@ims.net	root_sectionheader_disable
819	2008-04-15 10:15:56-05	settings	33	U	support@ims.net	root_subheader_disable
820	2008-04-15 10:15:56-05	settings	531	U	support@ims.net	search_image
821	2008-04-15 10:15:56-05	settings	533	U	support@ims.net	search_imageheight
822	2008-04-15 10:15:56-05	settings	532	U	support@ims.net	search_imagewidth
823	2008-04-15 10:15:56-05	settings	530	U	support@ims.net	search_size
824	2008-04-15 10:15:56-05	settings	534	U	support@ims.net	searchblox_cssdir
825	2008-04-15 10:15:56-05	settings	535	U	support@ims.net	searchblox_xsldir
826	2008-04-15 10:15:56-05	settings	321	U	support@ims.net	sectionheader_disable
827	2008-04-15 10:15:56-05	settings	360	U	support@ims.net	sidebar_disable
828	2008-04-15 10:15:56-05	settings	25	U	support@ims.net	site_center
829	2008-04-15 10:15:56-05	settings	20	U	support@ims.net	site_cssdir
830	2008-04-15 10:15:56-05	settings	21	U	support@ims.net	site_cssfolder
831	2008-04-15 10:15:56-05	settings	22	U	support@ims.net	site_debug
832	2008-04-15 10:15:56-05	settings	10	U	support@ims.net	site_designdir
833	2008-04-15 10:15:56-05	settings	9	U	support@ims.net	site_designfolder
834	2008-04-15 10:15:56-05	settings	23	U	support@ims.net	site_host
835	2008-04-15 10:15:56-05	settings	6	U	support@ims.net	site_imagedir
836	2008-04-15 10:15:56-05	settings	5	U	support@ims.net	site_imagefolder
837	2008-04-15 10:15:56-05	settings	4	U	support@ims.net	site_maxuploadsize
838	2008-04-15 10:15:56-05	settings	8	U	support@ims.net	site_mediadir
839	2008-04-15 10:15:56-05	settings	7	U	support@ims.net	site_mediafolder
840	2008-04-15 10:15:56-05	settings	1	U	support@ims.net	site_name
841	2008-04-15 10:15:56-05	settings	19	U	support@ims.net	site_rootfolder
842	2008-04-15 10:15:56-05	settings	24	U	support@ims.net	site_sslhost
843	2008-04-15 10:15:56-05	settings	521	U	support@ims.net	sitemap_headtitle
844	2008-04-15 10:15:56-05	settings	520	U	support@ims.net	sitemap_pagetitle
845	2008-04-15 10:15:56-05	settings	203	U	support@ims.net	subheader_date_homeonly
846	2008-04-15 10:15:56-05	settings	202	U	support@ims.net	subheader_dateformat
847	2008-04-15 10:15:56-05	settings	201	U	support@ims.net	subheader_dateshown
848	2008-04-15 10:15:56-05	settings	200	U	support@ims.net	subheader_disable
849	2008-04-15 10:15:56-05	settings	210	U	support@ims.net	subheader_flash
850	2008-04-15 10:15:56-05	settings	215	U	support@ims.net	subheader_flash_bgcolor
851	2008-04-15 10:15:56-05	settings	214	U	support@ims.net	subheader_flash_height
852	2008-04-15 10:15:56-05	settings	212	U	support@ims.net	subheader_flash_homeonly
853	2008-04-15 10:15:56-05	settings	211	U	support@ims.net	subheader_flash_url
854	2008-04-15 10:15:56-05	settings	213	U	support@ims.net	subheader_flash_width
855	2008-04-15 10:16:21-05	settings	77	U	support@ims.net	blogger_application_name
856	2008-04-15 10:16:21-05	settings	79	U	support@ims.net	blogger_comment_post_uri
857	2008-04-15 10:16:21-05	settings	73	U	support@ims.net	blogger_comments_feed_uri_suffix
858	2008-04-15 10:16:21-05	settings	78	U	support@ims.net	blogger_dateformat
859	2008-04-15 10:16:21-05	settings	71	U	support@ims.net	blogger_feed_uri_base
860	2008-04-15 10:16:21-05	settings	70	U	support@ims.net	blogger_metafeed_url
861	2008-04-15 10:16:21-05	settings	75	U	support@ims.net	blogger_password
862	2008-04-15 10:16:21-05	settings	72	U	support@ims.net	blogger_posts_feed_uri_suffix
863	2008-04-15 10:16:21-05	settings	76	U	support@ims.net	blogger_service_name
864	2008-04-15 10:16:21-05	settings	74	U	support@ims.net	blogger_username
865	2008-04-15 10:16:21-05	settings	340	U	support@ims.net	breadcrumbs_disable
866	2008-04-15 10:16:21-05	settings	341	U	support@ims.net	breadcrumbs_separator
867	2008-04-15 10:16:21-05	settings	544	U	support@ims.net	comments_buttontext
868	2008-04-15 10:16:21-05	settings	540	U	support@ims.net	comments_dateformat
869	2008-04-15 10:16:21-05	settings	541	U	support@ims.net	comments_inputsize
870	2008-04-15 10:16:21-05	settings	542	U	support@ims.net	comments_textcols
871	2008-04-15 10:16:21-05	settings	543	U	support@ims.net	comments_textrows
872	2008-04-15 10:16:21-05	settings	51	U	support@ims.net	cp_defaulteditmode
873	2008-04-15 10:16:21-05	settings	401	U	support@ims.net	footer_copyrightshown
874	2008-04-15 10:16:21-05	settings	402	U	support@ims.net	footer_copyrighttext
875	2008-04-15 10:16:21-05	settings	411	U	support@ims.net	footer_dateformat
876	2008-04-15 10:16:21-05	settings	410	U	support@ims.net	footer_dateshown
877	2008-04-15 10:16:21-05	settings	400	U	support@ims.net	footer_disable
878	2008-04-15 10:16:21-05	settings	420	U	support@ims.net	footer_imscredit
879	2008-04-15 10:16:21-05	settings	430	U	support@ims.net	footer_lastupdate
880	2008-04-15 10:16:21-05	settings	100	U	support@ims.net	header_disable
881	2008-04-15 10:16:21-05	settings	110	U	support@ims.net	header_flash
882	2008-04-15 10:16:21-05	settings	115	U	support@ims.net	header_flash_bgcolor
883	2008-04-15 10:16:21-05	settings	114	U	support@ims.net	header_flash_height
884	2008-04-15 10:16:21-05	settings	112	U	support@ims.net	header_flash_homeonly
885	2008-04-15 10:16:21-05	settings	111	U	support@ims.net	header_flash_url
886	2008-04-15 10:16:21-05	settings	113	U	support@ims.net	header_flash_width
887	2008-04-15 10:16:21-05	settings	101	U	support@ims.net	header_search
888	2008-04-15 10:16:21-05	settings	60	U	support@ims.net	ldap_authentication
889	2008-04-15 10:16:21-05	settings	301	U	support@ims.net	navpri_dhtml_disable
890	2008-04-15 10:16:21-05	settings	302	U	support@ims.net	navpri_images
891	2008-04-15 10:16:21-05	settings	303	U	support@ims.net	navpri_level1_disable
892	2008-04-15 10:16:21-05	settings	330	U	support@ims.net	navquat_disable
893	2008-04-15 10:16:21-05	settings	350	U	support@ims.net	pagetitle_disable
894	2008-04-15 10:16:21-05	settings	351	U	support@ims.net	pagetitle_level1
895	2008-04-15 10:16:21-05	settings	501	U	support@ims.net	printable_logo
896	2008-04-15 10:16:21-05	settings	503	U	support@ims.net	printable_logo_height
897	2008-04-15 10:16:21-05	settings	502	U	support@ims.net	printable_logo_width
898	2008-04-15 10:16:21-05	settings	34	U	support@ims.net	root_footer_disable
899	2008-04-15 10:16:21-05	settings	30	U	support@ims.net	root_header_disable
900	2008-04-15 10:16:21-05	settings	31	U	support@ims.net	root_nav_primary_disable
901	2008-04-15 10:16:21-05	settings	32	U	support@ims.net	root_sectionheader_disable
902	2008-04-15 10:16:21-05	settings	33	U	support@ims.net	root_subheader_disable
903	2008-04-15 10:16:21-05	settings	531	U	support@ims.net	search_image
904	2008-04-15 10:16:21-05	settings	533	U	support@ims.net	search_imageheight
905	2008-04-15 10:16:21-05	settings	532	U	support@ims.net	search_imagewidth
906	2008-04-15 10:16:21-05	settings	530	U	support@ims.net	search_size
907	2008-04-15 10:16:21-05	settings	534	U	support@ims.net	searchblox_cssdir
908	2008-04-15 10:16:21-05	settings	535	U	support@ims.net	searchblox_xsldir
909	2008-04-15 10:16:21-05	settings	321	U	support@ims.net	sectionheader_disable
910	2008-04-15 10:16:22-05	settings	360	U	support@ims.net	sidebar_disable
911	2008-04-15 10:16:22-05	settings	25	U	support@ims.net	site_center
912	2008-04-15 10:16:22-05	settings	20	U	support@ims.net	site_cssdir
913	2008-04-15 10:16:22-05	settings	21	U	support@ims.net	site_cssfolder
914	2008-04-15 10:16:22-05	settings	22	U	support@ims.net	site_debug
915	2008-04-15 10:16:22-05	settings	10	U	support@ims.net	site_designdir
916	2008-04-15 10:16:22-05	settings	9	U	support@ims.net	site_designfolder
917	2008-04-15 10:16:22-05	settings	23	U	support@ims.net	site_host
918	2008-04-15 10:16:22-05	settings	6	U	support@ims.net	site_imagedir
919	2008-04-15 10:16:22-05	settings	5	U	support@ims.net	site_imagefolder
920	2008-04-15 10:16:22-05	settings	4	U	support@ims.net	site_maxuploadsize
921	2008-04-15 10:16:22-05	settings	8	U	support@ims.net	site_mediadir
922	2008-04-15 10:16:22-05	settings	7	U	support@ims.net	site_mediafolder
923	2008-04-15 10:16:22-05	settings	1	U	support@ims.net	site_name
924	2008-04-15 10:16:22-05	settings	19	U	support@ims.net	site_rootfolder
925	2008-04-15 10:16:22-05	settings	24	U	support@ims.net	site_sslhost
926	2008-04-15 10:16:22-05	settings	521	U	support@ims.net	sitemap_headtitle
927	2008-04-15 10:16:22-05	settings	520	U	support@ims.net	sitemap_pagetitle
928	2008-04-15 10:16:22-05	settings	203	U	support@ims.net	subheader_date_homeonly
929	2008-04-15 10:16:22-05	settings	202	U	support@ims.net	subheader_dateformat
930	2008-04-15 10:16:22-05	settings	201	U	support@ims.net	subheader_dateshown
931	2008-04-15 10:16:22-05	settings	200	U	support@ims.net	subheader_disable
932	2008-04-15 10:16:22-05	settings	210	U	support@ims.net	subheader_flash
933	2008-04-15 10:16:22-05	settings	215	U	support@ims.net	subheader_flash_bgcolor
934	2008-04-15 10:16:22-05	settings	214	U	support@ims.net	subheader_flash_height
935	2008-04-15 10:16:22-05	settings	212	U	support@ims.net	subheader_flash_homeonly
936	2008-04-15 10:16:22-05	settings	211	U	support@ims.net	subheader_flash_url
937	2008-04-15 10:16:22-05	settings	213	U	support@ims.net	subheader_flash_width
938	2009-02-27 15:48:51-06	stylesheet	403	U	support@ims.net	0 div#header-logo
939	2009-04-10 14:17:56-05	stylesheet	664	I	support@ims.net	0 input
940	2009-04-10 14:18:03-05	stylesheet	665	I	support@ims.net	0 textarea
941	2009-04-10 14:22:04-05	stylesheet	0	U	support@ims.net	0 textarea
942	2009-04-10 14:22:16-05	stylesheet	501	U	support@ims.net	0 input
943	2009-04-10 14:22:26-05	stylesheet	502	U	support@ims.net	0 textarea
944	2009-04-10 14:22:34-05	stylesheet	501	U	support@ims.net	0 input
945	2009-11-06 12:23:47-06	settings	550	U	support@ims.net	photos_dir
946	2010-02-16 16:35:54-06	users	1	U	support@ims.net	support@ims.net
947	2010-03-25 13:26:55-05	settings	430	U	support@ims.net	footer_lastupdate
948	2010-04-05 15:55:39-05	stylesheet	9	U	support@ims.net	0 h1
949	2010-04-05 15:55:50-05	stylesheet	16	U	support@ims.net	0 hr
950	2010-04-05 15:56:19-05	stylesheet	156	U	support@ims.net	0 #layer7
951	2010-04-05 15:56:27-05	stylesheet	157	U	support@ims.net	0 #layer8
952	2010-04-05 15:56:37-05	stylesheet	158	U	support@ims.net	0 #layer9
953	2010-04-05 15:56:59-05	stylesheet	132	U	support@ims.net	0 #layer1
954	2010-04-05 15:57:47-05	stylesheet	132	U	support@ims.net	0 #layer1
955	2010-04-05 15:58:21-05	stylesheet	133	U	support@ims.net	0 #layer2
956	2010-04-05 15:58:30-05	stylesheet	134	U	support@ims.net	0 #layer3
957	2010-04-05 15:58:40-05	stylesheet	136	U	support@ims.net	0 #layer5
958	2010-04-05 15:58:54-05	stylesheet	135	U	support@ims.net	0 #layer4
959	2010-04-05 15:59:03-05	stylesheet	155	U	support@ims.net	0 #layer6
960	2010-04-05 15:59:12-05	stylesheet	156	U	support@ims.net	0 #layer7
961	2010-04-05 15:59:20-05	stylesheet	157	U	support@ims.net	0 #layer8
962	2010-04-05 15:59:27-05	stylesheet	158	U	support@ims.net	0 #layer9
963	2010-08-17 11:31:50-05	settings	11	U	support@ims.net	site_formuploadsdir
964	2010-10-21 13:53:48-05	settings	150	U	support@ims.net	icontact_accountid
965	2010-10-25 14:19:16-05	settings	150	U	support@ims.net	icontact_accountid
966	2010-10-25 14:20:36-05	stylesheet	26	U	support@ims.net	0 table#navpri
967	2010-10-25 14:20:41-05	stylesheet	40	U	support@ims.net	0 td.navpri
968	2010-10-25 14:20:45-05	stylesheet	93	U	support@ims.net	0 td.navpri-left
969	2010-10-25 14:20:48-05	stylesheet	94	U	support@ims.net	0 td.navpri-right
970	2010-10-25 14:20:51-05	stylesheet	41	U	support@ims.net	0 a.navpri:link
971	2010-10-25 14:20:55-05	stylesheet	42	U	support@ims.net	0 a.navpri:visited
972	2010-10-25 14:20:58-05	stylesheet	44	U	support@ims.net	0 a.navpri:hover
973	2010-10-25 14:21:02-05	stylesheet	45	U	support@ims.net	0 a.navpri:active
974	2010-10-25 14:21:05-05	stylesheet	68	U	support@ims.net	0 td.navpri-over
975	2010-10-25 14:21:08-05	stylesheet	76	U	support@ims.net	0 td.navpri-off
976	2010-10-25 14:21:11-05	stylesheet	161	U	support@ims.net	0 td.navpri-on
977	2010-10-25 14:21:15-05	stylesheet	556	U	support@ims.net	0 a.navpri-on:link
978	2010-10-25 14:21:18-05	stylesheet	557	U	support@ims.net	0 a.navpri-on:visited
979	2010-10-25 14:21:21-05	stylesheet	558	U	support@ims.net	0 a.navpri-on: hover
980	2010-10-25 14:21:25-05	stylesheet	559	U	support@ims.net	0 a.navpri-on: active
981	2010-10-25 14:21:47-05	stylesheet	28	U	support@ims.net	0 div#navsec-box
982	2010-10-25 14:21:51-05	stylesheet	36	U	support@ims.net	0 div.navsec
983	2010-10-25 14:21:55-05	stylesheet	98	U	support@ims.net	0 div#navsec-bottom
984	2010-10-25 14:21:58-05	stylesheet	97	U	support@ims.net	0 div#navsec-top
985	2010-10-25 14:22:01-05	stylesheet	35	U	support@ims.net	0 a.navsec:link
986	2010-10-25 14:22:04-05	stylesheet	34	U	support@ims.net	0 a.navsec:visited
987	2010-10-25 14:22:07-05	stylesheet	37	U	support@ims.net	0 a.navsec:hover
988	2010-10-25 14:22:10-05	stylesheet	38	U	support@ims.net	0 a.navsec:active
989	2010-10-25 14:22:13-05	stylesheet	99	U	support@ims.net	0 div.navsec-over
990	2010-10-25 14:22:16-05	stylesheet	163	U	support@ims.net	0 div.navsec-on
991	2010-10-25 14:22:18-05	stylesheet	101	U	support@ims.net	0 div.navsec-off
992	2010-10-25 14:22:22-05	stylesheet	53	U	support@ims.net	0 div.navter-box
993	2010-10-25 14:22:26-05	stylesheet	54	U	support@ims.net	0 div.navter
994	2010-10-25 14:22:29-05	stylesheet	55	U	support@ims.net	0 a.navter:link
995	2010-10-25 14:22:33-05	stylesheet	56	U	support@ims.net	0 a.navter:visited
996	2010-10-25 14:22:36-05	stylesheet	57	U	support@ims.net	0 a.navter:hover
997	2010-10-25 14:22:39-05	stylesheet	58	U	support@ims.net	0 a.navter:active
998	2010-10-25 14:22:43-05	stylesheet	111	U	support@ims.net	0 div.navter-over
999	2010-10-25 14:22:46-05	stylesheet	109	U	support@ims.net	0 div.navter-on
1000	2010-10-25 14:22:50-05	stylesheet	110	U	support@ims.net	0 div.navter-off
1001	2010-10-25 14:23:19-05	stylesheet	516	U	support@ims.net	0 form.access
1002	2010-10-25 14:23:23-05	stylesheet	517	U	support@ims.net	0 input.access-text
1003	2010-10-25 14:23:26-05	stylesheet	518	U	support@ims.net	0 input.access-submit
1004	2010-10-25 14:23:30-05	stylesheet	519	U	support@ims.net	0 table.access
1005	2010-10-25 14:23:33-05	stylesheet	520	U	support@ims.net	0 td.access
1006	2010-10-25 14:24:47-05	stylesheet	533	U	support@ims.net	0 div.message
1007	2010-10-25 15:51:06-05	settings	550	U	support@ims.net	photos_dir
1008	2010-10-25 15:51:20-05	settings	20	U	support@ims.net	site_cssdir
1009	2010-10-25 15:51:32-05	settings	10	U	support@ims.net	site_designdir
1010	2010-10-25 15:51:49-05	settings	11	U	support@ims.net	site_formuploadsdir
1011	2010-10-25 15:51:57-05	settings	6	U	support@ims.net	site_imagedir
1012	2010-10-25 15:52:05-05	settings	8	U	support@ims.net	site_mediadir
1013	2010-11-12 16:39:58-06	stylesheet	15	U	support@ims.net	0 div#container
1014	2010-11-23 13:27:49-06	stylesheet	1	U	support@ims.net	0 body
1015	2010-11-23 13:28:04-06	stylesheet	1	U	support@ims.net	0 body
1016	2010-11-23 13:28:15-06	stylesheet	15	U	support@ims.net	0 div#container
1017	2010-11-23 13:28:32-06	stylesheet	1	U	support@ims.net	0 body
1018	2010-11-23 13:28:37-06	stylesheet	1	U	support@ims.net	0 body
1019	2010-11-23 13:28:44-06	stylesheet	15	U	support@ims.net	0 div#container
1020	2010-11-23 13:29:28-06	stylesheet	132	U	support@ims.net	0 #layer1
1021	2010-11-23 13:29:56-06	stylesheet	133	U	support@ims.net	0 #layer2
1022	2010-11-23 13:30:03-06	stylesheet	132	U	support@ims.net	0 #layer1
1023	2010-11-23 13:30:06-06	stylesheet	133	U	support@ims.net	0 #layer2
1024	2010-11-23 13:30:18-06	stylesheet	134	U	support@ims.net	0 #layer3
1025	2010-11-23 13:30:31-06	stylesheet	135	U	support@ims.net	0 #layer4
1026	2010-11-23 13:30:39-06	stylesheet	136	U	support@ims.net	0 #layer5
1027	2010-11-23 13:30:45-06	stylesheet	155	U	support@ims.net	0 #layer6
1028	2010-11-23 13:30:51-06	stylesheet	156	U	support@ims.net	0 #layer7
1029	2010-11-23 13:30:58-06	stylesheet	157	U	support@ims.net	0 #layer8
1030	2010-11-23 13:31:04-06	stylesheet	158	U	support@ims.net	0 #layer9
1031	2010-11-23 13:31:31-06	stylesheet	40	U	support@ims.net	0 td.navpri
1032	2010-11-23 13:32:20-06	stylesheet	132	U	support@ims.net	0 #layer1
1033	2010-11-23 13:32:30-06	stylesheet	132	U	support@ims.net	0 #layer1
1034	2010-11-23 13:32:39-06	stylesheet	132	U	support@ims.net	0 #layer1
1035	2010-11-23 13:32:50-06	stylesheet	133	U	support@ims.net	0 #layer2
1036	2010-11-23 13:33:41-06	stylesheet	40	U	support@ims.net	0 td.navpri
1037	2010-11-23 13:33:51-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
1038	2010-11-23 13:34:03-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
1039	2010-11-23 13:34:07-06	stylesheet	40	U	support@ims.net	0 td.navpri
1040	2010-11-23 13:34:47-06	stylesheet	142	U	support@ims.net	0 td.dhtml-off
1041	2010-11-23 13:34:51-06	stylesheet	143	U	support@ims.net	0 td.dhtml-on
1042	2010-11-23 13:35:01-06	stylesheet	141	U	support@ims.net	0 table.dhtml
1043	2010-11-23 13:35:21-06	stylesheet	141	U	support@ims.net	0 table.dhtml
1044	2010-11-23 13:35:35-06	stylesheet	142	U	support@ims.net	0 td.dhtml-off
1045	2010-11-23 13:35:39-06	stylesheet	143	U	support@ims.net	0 td.dhtml-on
1046	2010-11-23 13:35:52-06	stylesheet	142	U	support@ims.net	0 td.dhtml-off
1047	2010-11-23 13:35:56-06	stylesheet	143	U	support@ims.net	0 td.dhtml-on
1048	2010-11-23 13:36:13-06	stylesheet	133	U	support@ims.net	0 #layer2
1049	2010-11-23 13:36:25-06	stylesheet	133	U	support@ims.net	0 #layer2
1050	2010-11-23 13:36:35-06	stylesheet	133	U	support@ims.net	0 #layer2
1051	2010-11-23 13:37:34-06	stylesheet	40	U	support@ims.net	0 td.navpri
1052	2010-11-23 13:38:24-06	stylesheet	40	U	support@ims.net	0 td.navpri
1053	2010-11-23 13:39:02-06	stylesheet	40	U	support@ims.net	0 td.navpri
1054	2010-11-23 13:39:53-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
1055	2010-11-23 13:40:23-06	stylesheet	132	U	support@ims.net	0 #layer1
1056	2010-11-23 13:40:33-06	stylesheet	133	U	support@ims.net	0 #layer2
1057	2010-11-23 13:40:57-06	stylesheet	133	U	support@ims.net	0 #layer2
1058	2010-11-23 13:41:07-06	stylesheet	133	U	support@ims.net	0 #layer2
1059	2010-11-23 13:41:19-06	stylesheet	134	U	support@ims.net	0 #layer3
1060	2010-11-23 13:41:31-06	stylesheet	135	U	support@ims.net	0 #layer4
1061	2010-11-23 13:41:37-06	stylesheet	136	U	support@ims.net	0 #layer5
1062	2010-11-23 13:41:46-06	stylesheet	155	U	support@ims.net	0 #layer6
1063	2010-11-23 13:41:51-06	stylesheet	156	U	support@ims.net	0 #layer7
1064	2010-11-23 13:41:56-06	stylesheet	157	U	support@ims.net	0 #layer8
1065	2010-11-23 13:42:03-06	stylesheet	158	U	support@ims.net	0 #layer9
1066	2010-11-23 13:42:33-06	stylesheet	142	U	support@ims.net	0 td.dhtml-off
1067	2010-11-23 13:42:41-06	stylesheet	143	U	support@ims.net	0 td.dhtml-on
1068	2010-11-23 13:42:46-06	stylesheet	137	U	support@ims.net	0 a.dhtml:link
1069	2010-11-23 13:42:49-06	stylesheet	138	U	support@ims.net	0 a.dhtml:visited
1070	2010-11-23 13:42:52-06	stylesheet	139	U	support@ims.net	0 a.dhtml:active
1071	2010-11-23 13:42:56-06	stylesheet	140	U	support@ims.net	0 a.dhtml:hover
1072	2010-11-23 13:43:15-06	stylesheet	143	U	support@ims.net	0 td.dhtml-on
1073	2010-11-23 13:43:19-06	stylesheet	143	U	support@ims.net	0 td.dhtml-on
1074	2010-12-10 13:11:04-06	utilitycontent	4	U	support@ims.net	H:2
1075	2010-12-10 13:11:45-06	utilitycontent	8	I	support@ims.net	H:1
1076	2010-12-10 13:12:37-06	utilitycontent	4	U	support@ims.net	H:2
1077	2010-12-10 13:12:52-06	utilitycontent	4	U	support@ims.net	H:2
1078	2010-12-10 13:13:10-06	utilitycontent	4	U	support@ims.net	H:2
1079	2010-12-10 13:13:23-06	utilitycontent	4	U	support@ims.net	H:2
1080	2010-12-10 13:13:36-06	utilitycontent	4	U	support@ims.net	H:2
1081	2010-12-10 13:14:03-06	utilitycontent	4	U	support@ims.net	H:2
1082	2010-12-10 13:14:22-06	stylesheet	82	U	support@ims.net	0 td.header
1083	2010-12-10 13:14:31-06	stylesheet	46	D	support@ims.net	0 div#header-flash
1084	2010-12-10 13:14:33-06	stylesheet	403	D	support@ims.net	0 div#header-logo
1085	2010-12-10 13:15:12-06	stylesheet	81	U	support@ims.net	0 table#header
1086	2010-12-10 13:15:18-06	stylesheet	81	U	support@ims.net	0 table#header
1087	2010-12-10 13:16:10-06	stylesheet	87	U	support@ims.net	0 td.header-right
1088	2010-12-10 13:16:46-06	stylesheet	81	U	support@ims.net	0 table#header
1089	2010-12-10 13:17:07-06	stylesheet	80	U	support@ims.net	0 td.header-left
1090	2010-12-10 13:17:14-06	stylesheet	80	U	support@ims.net	0 td.header-left
1091	2010-12-10 13:17:19-06	stylesheet	82	U	support@ims.net	0 td.header
1092	2010-12-10 13:17:30-06	stylesheet	82	U	support@ims.net	0 td.header
1093	2010-12-10 13:17:49-06	utilitycontent	4	U	support@ims.net	H:2
1094	2010-12-10 13:18:04-06	utilitycontent	4	U	support@ims.net	H:2
1095	2010-12-10 13:18:20-06	utilitycontent	4	U	support@ims.net	H:2
1096	2010-12-10 13:18:29-06	utilitycontent	4	U	support@ims.net	H:2
1097	2010-12-10 13:18:36-06	utilitycontent	4	U	support@ims.net	H:2
1098	2010-12-10 13:18:50-06	stylesheet	87	U	support@ims.net	0 td.header-right
1099	2010-12-10 13:19:22-06	stylesheet	202	U	support@ims.net	0 td.sectionheader
1100	2010-12-10 13:19:37-06	stylesheet	83	U	support@ims.net	0 a.header:link
1101	2010-12-10 13:19:41-06	stylesheet	84	U	support@ims.net	0 a.header:visited
1102	2010-12-10 13:19:45-06	stylesheet	85	U	support@ims.net	0 a.header:hover
1103	2010-12-10 13:19:48-06	stylesheet	86	U	support@ims.net	0 a.header:active
1104	2010-12-10 13:20:16-06	stylesheet	29	U	support@ims.net	0 table#subheader
1105	2010-12-10 13:20:34-06	stylesheet	95	U	support@ims.net	0 td.subheader-left
1106	2010-12-10 13:20:43-06	stylesheet	96	U	support@ims.net	0 td.subheader-right
1107	2010-12-10 13:20:57-06	stylesheet	39	U	support@ims.net	0 td.subheader
1108	2010-12-10 13:21:08-06	stylesheet	39	U	support@ims.net	0 td.subheader
1109	2010-12-10 13:21:36-06	utilitycontent	5	U	support@ims.net	S:10
1110	2010-12-10 13:21:40-06	utilitycontent	3	U	support@ims.net	S:4
1111	2010-12-10 14:32:20-06	utilitycontent	2	U	support@ims.net	S:3
1112	2010-12-10 14:32:27-06	utilitycontent	1	U	support@ims.net	S:2
1113	2010-12-10 14:32:33-06	utilitycontent	5	U	support@ims.net	S:1
1114	2010-12-10 14:33:06-06	settings	2	U	support@ims.net	site_dateformat
1115	2010-12-10 14:33:30-06	utilitycontent	1	U	support@ims.net	S:2
1116	2010-12-10 14:33:36-06	utilitycontent	2	U	support@ims.net	S:3
1117	2010-12-10 14:35:06-06	stylesheet	414	U	support@ims.net	0 a.breadcrumbs.active
1118	2010-12-10 14:35:24-06	stylesheet	412	U	support@ims.net	0 a.breadcrumbs:visited
1119	2010-12-10 14:35:29-06	stylesheet	413	U	support@ims.net	0 a.breadcrumbs:hover
1120	2010-12-10 14:35:35-06	stylesheet	412	U	support@ims.net	0 a.breadcrumbs:visited
1121	2010-12-10 14:35:53-06	stylesheet	165	U	support@ims.net	0 div#sidebar-top
1122	2010-12-10 14:35:57-06	stylesheet	166	U	support@ims.net	0 div.sidebar
1123	2010-12-10 14:36:07-06	stylesheet	166	U	support@ims.net	0 div.sidebar
1124	2010-12-10 14:36:11-06	stylesheet	167	U	support@ims.net	0 div#sidebar-bottom
1125	2010-12-10 14:36:20-06	stylesheet	168	U	support@ims.net	0 a.sidebar:link
1126	2010-12-10 14:36:23-06	stylesheet	169	U	support@ims.net	0 a.sidebar:visited
1127	2010-12-10 14:36:27-06	stylesheet	170	U	support@ims.net	0 a.sidebar:hover
1128	2010-12-10 14:36:30-06	stylesheet	171	U	support@ims.net	0 a.sidebar:active
1129	2010-12-10 14:36:56-06	stylesheet	97	U	support@ims.net	0 div#navsec-top
1130	2010-12-10 14:37:01-06	stylesheet	36	U	support@ims.net	0 div.navsec
1131	2010-12-10 14:37:12-06	stylesheet	36	U	support@ims.net	0 div.navsec
1132	2010-12-10 14:37:19-06	stylesheet	98	U	support@ims.net	0 div#navsec-bottom
1133	2010-12-10 14:37:34-06	stylesheet	101	U	support@ims.net	0 div.navsec-off
1134	2010-12-10 14:37:46-06	stylesheet	101	U	support@ims.net	0 div.navsec-off
1135	2010-12-10 14:37:52-06	stylesheet	163	U	support@ims.net	0 div.navsec-on
1136	2010-12-10 14:38:08-06	stylesheet	99	U	support@ims.net	0 div.navsec-over
1137	2010-12-10 14:38:15-06	stylesheet	163	U	support@ims.net	0 div.navsec-on
1138	2010-12-10 14:38:25-06	stylesheet	53	U	support@ims.net	0 div.navter-box
1139	2010-12-10 14:38:34-06	stylesheet	54	U	support@ims.net	0 div.navter
1140	2010-12-10 14:38:41-06	stylesheet	55	U	support@ims.net	0 a.navter:link
1141	2010-12-10 14:38:55-06	stylesheet	56	U	support@ims.net	0 a.navter:visited
1142	2010-12-10 14:39:02-06	stylesheet	57	U	support@ims.net	0 a.navter:hover
1143	2010-12-10 14:39:07-06	stylesheet	58	U	support@ims.net	0 a.navter:active
1144	2010-12-10 14:39:28-06	stylesheet	111	U	support@ims.net	0 div.navter-over
1145	2010-12-10 14:39:33-06	stylesheet	109	U	support@ims.net	0 div.navter-on
1146	2010-12-10 14:40:19-06	stylesheet	160	U	support@ims.net	0 table#l1
1147	2010-12-10 14:40:27-06	stylesheet	455	U	support@ims.net	0 td#l1_p1
1148	2010-12-10 14:40:34-06	stylesheet	160	U	support@ims.net	0 table#l1
1149	2010-12-10 14:41:33-06	stylesheet	572	D	support@ims.net	0 a.footer-ims:active
1150	2010-12-10 14:41:35-06	stylesheet	571	D	support@ims.net	0 a.footer-ims:hover
1151	2010-12-10 14:41:37-06	stylesheet	569	D	support@ims.net	0 a.footer-ims:link
1152	2010-12-10 14:41:39-06	stylesheet	570	D	support@ims.net	0 a.footer-ims:visited
1153	2010-12-10 14:45:03-06	utilitycontent	7	U	support@ims.net	F:2
1154	2010-12-10 14:45:50-06	utilitycontent	7	U	support@ims.net	F:2
1155	2010-12-10 14:46:12-06	stylesheet	107	U	support@ims.net	0 td.footer-left
1156	2010-12-10 14:46:27-06	stylesheet	18	U	support@ims.net	0 td.footer
1157	2010-12-10 14:46:32-06	stylesheet	108	U	support@ims.net	0 td.footer-right
1158	2010-12-10 14:46:48-06	stylesheet	108	U	support@ims.net	0 td.footer-right
1159	2010-12-10 14:46:51-06	stylesheet	107	U	support@ims.net	0 td.footer-left
1160	2010-12-10 14:47:09-06	stylesheet	108	U	support@ims.net	0 td.footer-right
1161	2010-12-10 14:47:18-06	stylesheet	108	U	support@ims.net	0 td.footer-right
1162	2010-12-10 14:48:56-06	stylesheet	59	U	support@ims.net	0 div.debug
1163	2011-01-13 11:07:06-06	stylesheet	93	U	support@ims.net	0 td.navpri-left
1164	2011-01-13 11:08:24-06	stylesheet	40	U	support@ims.net	0 td.navpri
1165	2011-01-13 11:10:37-06	stylesheet	579	U	support@ims.net	0 td#main-left
1166	2011-01-13 11:13:53-06	stylesheet	1	U	support@ims.net	0 body
1167	2011-01-13 11:15:03-06	stylesheet	402	U	support@ims.net	-1 body
1168	2011-01-13 11:15:17-06	stylesheet	1	U	support@ims.net	0 body
1169	2011-07-26 13:22:56-05	stylesheet	26	U	support@ims.net	0 table#navpri
1170	2012-06-29 11:36:54-05	settings	550	U	support@ims.net	photos_dir
1171	2012-06-29 11:37:07-05	settings	20	U	support@ims.net	site_cssdir
1172	2012-06-29 11:37:17-05	settings	10	U	support@ims.net	site_designdir
1173	2012-06-29 11:37:29-05	settings	11	U	support@ims.net	site_formuploadsdir
1174	2012-06-29 11:37:38-05	settings	6	U	support@ims.net	site_imagedir
1175	2012-06-29 11:37:49-05	settings	8	U	support@ims.net	site_mediadir
1176	2013-10-03 16:39:29-05	stylesheet	1	U	support@ims.net	0 body
\.


--
-- Name: audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('audit_audit_id_seq', 1176, true);


--
-- Data for Name: commentblacklist; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY commentblacklist (word_id, word) FROM stdin;
\.


--
-- Name: commentblacklist_word_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('commentblacklist_word_id_seq', 1, false);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY comments (comment_id, cid, timeposted, name, email, comment, location) FROM stdin;
\.


--
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('comments_comment_id_seq', 1, false);


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY content (cid, refid, copy, created, updated, label, moduleurl, moduleabove, modulecontext) FROM stdin;
1	1196111793310	<h1>h1: Lorem ipsum dolor sit amet</h1>\r\n<h2>h2: Lorem ipsum dolor sit amet</h2>\r\n<h3>h3: Lorem ipsum dolor sit amet</h3>\r\n\r\n<p>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n</p>\r\n\r\n<p>\r\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n</p>	2007-11-26 15:16:33-06	2007-11-27 11:44:53-06	lorem ipsum text	\N	f	\N
\.


--
-- Name: content_cid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('content_cid_seq', 1, true);


--
-- Data for Name: cproles; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY cproles (username, editor, designer, admin) FROM stdin;
support@ims.net	t	t	t
\.


--
-- Data for Name: dhtmlcache; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY dhtmlcache (accessuser, dhtml, updated) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY events (event_id, num, title, date, "time", description, url) FROM stdin;
\.


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('events_event_id_seq', 1, false);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY extensions (extid, num, name, cpcontext, cpurl, parent_extid) FROM stdin;
\.


--
-- Name: extensions_extid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('extensions_extid_seq', 1, false);


--
-- Data for Name: extras; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY extras (extra_id, parent_extra_id, name, cpurl, docurl) FROM stdin;
1	\N	Comments	comments.jsp	doc-comments.jsp
2	\N	Contact Forms	forms.jsp	doc-forms.jsp
3	\N	Image Rotator	imagerotator.jsp	doc-imagerotator.jsp
4	\N	Photo Sets	photosets.jsp	doc-photosets.jsp
5	\N	SearchBlox	searchblox.jsp	doc-searchblox.jsp
6	5	CSS Editor	searchblox-css.jsp	\N
7	5	XSL Editor	searchblox-xsl.jsp	\N
8	\N	Access Users	access-users.jsp	doc-access.jsp
9	8	Access Roles	access-roles.jsp	\N
10	\N	Polls	polls.jsp	doc-polls.jsp
11	\N	CP Users	jcmsusers.jsp	doc-jcmsusers.jsp
12	\N	SoftSlate	/administrator	\N
13	\N	Calendar	calendar.jsp	doc-calendar.jsp
14	1	Blacklisted Words	comment-blacklist.jsp	doc-blacklist.jsp
15	\N	Payments	payments.jsp	doc-payments.jsp
\.


--
-- Name: extras_extra_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('extras_extra_id_seq', 7, true);


--
-- Data for Name: formconstantcontactlists; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY formconstantcontactlists (form_id, link, name) FROM stdin;
\.


--
-- Data for Name: formfieldoptions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY formfieldoptions (formfieldoption_id, formfield_id, num, value, selected) FROM stdin;
\.


--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('formfieldoptions_formfieldoption_id_seq', 1, false);


--
-- Data for Name: formfields; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY formfields (formfield_id, form_id, fieldname, num, heading, required, textinput, radio, checkbox, textarea, selectmenu, columns, size, rows, cols, hidden) FROM stdin;
\.


--
-- Name: formfields_formfield_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('formfields_formfield_id_seq', 1, false);


--
-- Data for Name: formicontactlists; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY formicontactlists (form_id, listid, name, description) FROM stdin;
\.


--
-- Data for Name: formlyrislists; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY formlyrislists (formlyrislist_id, form_id, listname, num, description) FROM stdin;
\.


--
-- Name: formlyrislists_formlyrislist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('formlyrislists_formlyrislist_id_seq', 1, false);


--
-- Data for Name: formmailchimplists; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY formmailchimplists (form_id, listid, listname) FROM stdin;
\.


--
-- Data for Name: forms; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY forms (form_id, title, recipientname, recipientemail, sendername, senderemail, instructions, thankyou, confirmationmessage, signupinstructions, filetitle, fileinstructions, filerequired, filefieldsize, redirecturl, submitvalue, usecaptcha, alertonerror, confirmationsubject) FROM stdin;
\.


--
-- Name: forms_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('forms_form_id_seq', 1, false);


--
-- Data for Name: imagerotator; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY imagerotator (id, filename, num, width, height, caption, alt, url) FROM stdin;
\.


--
-- Name: imagerotator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('imagerotator_id_seq', 1, false);


--
-- Data for Name: layoutpanes; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY layoutpanes (layoutpane_id, layout_id, pane, vposition, hposition, colspan, rowspan, mobile) FROM stdin;
1	1	1	1	1	1	1	f
2	2	1	1	1	1	1	f
3	2	2	1	2	1	1	f
4	3	1	1	1	1	1	f
5	3	2	1	2	1	1	f
6	3	3	2	1	2	1	f
7	1	1	1	1	1	1	t
8	2	1	1	1	1	1	t
9	2	2	1	2	1	1	t
10	3	1	1	1	1	1	t
11	3	2	1	2	1	1	t
12	3	3	2	1	2	1	t
\.


--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('layoutpanes_layoutpane_id_seq', 14, true);


--
-- Data for Name: layouts; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY layouts (layout_id, layout, num) FROM stdin;
1	single pane	1
2	two columns	2
3	two columns above full-width pane	3
\.


--
-- Name: layouts_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('layouts_layout_id_seq', 3, true);


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY media (mid, refid, filename, filesize, created, updated) FROM stdin;
\.


--
-- Name: media_mid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('media_mid_seq', 1, false);


--
-- Data for Name: nodelinks; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY nodelinks (nlid, nid, pid, mid, url, starttime, refid, redirectnid) FROM stdin;
1	0	1	\N	\N	2007-11-26 15:16:33-06	1196111793313	\N
2	1	2	\N	\N	2007-11-26 16:51:36-06	1196117495931	\N
3	2	3	\N	\N	2007-11-26 16:51:50-06	1196117510133	\N
4	3	4	\N	\N	2007-11-26 16:52:06-06	1196117525929	\N
5	4	2	\N	\N	2007-11-26 16:55:40-06	1196117740489	\N
6	5	3	\N	\N	2007-11-26 16:55:57-06	1196117756649	\N
7	6	4	\N	\N	2007-11-26 16:56:17-06	1196117776812	\N
8	7	2	\N	\N	2007-11-27 17:20:00-06	1196205599986	\N
9	8	3	\N	\N	2007-11-27 17:20:16-06	1196205616228	\N
\.


--
-- Name: nodelinks_nlid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('nodelinks_nlid_seq', 9, true);


--
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY nodes (nid, num, nodename, parent_nid, refid, created, hidden, alias, updated, ssl) FROM stdin;
0	0	Home Page	\N	1196111793281	2007-11-26 15:16:33-06	f	\N	\N	f
1	1	Layout 1	0	1196117481548	2007-11-26 16:51:22-06	f	\N	2007-11-26 16:51:28-06	f
2	2	Layout 2	0	1196117498858	2007-11-26 16:51:39-06	f	\N	2007-11-26 16:51:45-06	f
3	3	Layout 3	0	1196117513049	2007-11-26 16:51:53-06	f	\N	2007-11-26 16:51:59-06	f
4	1	Layout 1 Redux	1	1196117724203	2007-11-26 16:55:24-06	f	\N	2007-11-26 16:55:35-06	f
5	2	Layout 2 Redux	1	1196117743232	2007-11-26 16:55:43-06	f	\N	2007-11-26 16:55:50-06	f
6	3	Layout 3 Redux	1	1196117762504	2007-11-26 16:56:03-06	f	\N	2007-11-26 16:56:11-06	f
7	1	More Lorem	2	1196205584074	2007-11-27 17:19:44-06	f	\N	2007-11-27 17:19:53-06	f
8	2	More Ipsum	2	1196205603192	2007-11-27 17:20:03-06	f	\N	2007-11-27 17:20:09-06	f
\.


--
-- Name: nodes_nid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('nodes_nid_seq', 8, true);


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY pages (pid, metakeywords, metadescription, headtitle, title, refid, created, updated, layout_id, label, othermeta) FROM stdin;
2	\N	\N	Setup : Layout 1	Layout 1	1196117229007	2007-11-26 16:47:09-06	2007-11-27 11:44:53-06	1	layout 1	\N
1	\N	\N	Home	Home	1196111793307	2007-11-26 15:16:33-06	2007-11-27 11:44:53-06	1	Home	\N
4	\N	\N	Neptune Setup : Layout 3	Layout 3	1196117421611	2007-11-26 16:50:22-06	2007-11-27 11:44:53-06	3	layout 3	\N
3	\N	\N	Neptune Setup : Layout 2	Layout 2	1196117384901	2007-11-26 16:49:45-06	2007-11-27 11:44:53-06	2	layout 2	\N
\.


--
-- Data for Name: pages_content; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY pages_content (pid, cid, pane) FROM stdin;
1	1	1
2	1	1
3	1	1
3	1	2
4	1	1
4	1	2
4	1	3
\.


--
-- Name: pages_pid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('pages_pid_seq', 4, true);


--
-- Data for Name: pagetags; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY pagetags (pid, tag) FROM stdin;
\.


--
-- Data for Name: paymentoptions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY paymentoptions (paymentoption_id, payment_id, num, amount, name, description) FROM stdin;
\.


--
-- Name: paymentoptions_paymentoption_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('paymentoptions_paymentoption_id_seq', 1, false);


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY payments (payment_id, title, instructions, thankyou, recipientemail, recipientname) FROM stdin;
\.


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('payments_payment_id_seq', 1, false);


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY photos (photo_id, photoset_id, num, timeposted, imagefile, imagewidth, imageheight, title, caption, thumbnail) FROM stdin;
\.


--
-- Name: photos_photo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('photos_photo_id_seq', 1, false);


--
-- Data for Name: photosets; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY photosets (photoset_id, title, created, description, shootdate, credit, thumbnailindex, thumbnailcolumns) FROM stdin;
\.


--
-- Name: photosets_photoset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('photosets_photoset_id_seq', 1, false);


--
-- Data for Name: pollchoices; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY pollchoices (pollchoice_id, poll_id, num, choice) FROM stdin;
\.


--
-- Name: pollchoices_pollchoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('pollchoices_pollchoice_id_seq', 1, false);


--
-- Data for Name: polls; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY polls (poll_id, starttime, endtime, question, label) FROM stdin;
\.


--
-- Name: polls_poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('polls_poll_id_seq', 1, false);


--
-- Data for Name: pollsubmissions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY pollsubmissions (pollchoice_id, timeposted, ip) FROM stdin;
\.


--
-- Data for Name: postedformfields; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY postedformfields (postedform_id, fieldname, num, value) FROM stdin;
\.


--
-- Data for Name: postedforms; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY postedforms (postedform_id, form_id, timeposted) FROM stdin;
\.


--
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('postedforms_postedform_id_seq', 1, false);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY settings (setting_id, setting_name, setting_value, description, password, toggle) FROM stdin;
77	blogger_application_name	exampleCo-exampleApp-1	Google Service application name	f	f
79	blogger_comment_post_uri	https://www.blogger.com/comment.g	The URI used for posting comments	f	f
73	blogger_comments_feed_uri_suffix	/comments/default	URI suffix for Blogger comments	f	f
78	blogger_dateformat	yyyy-MM-dd HH:mm	java.text.SimpleDateFormat for the blog dates	f	f
71	blogger_feed_uri_base	http://www.blogger.com/feeds	base portion of Blogger feed URI	f	f
70	blogger_metafeed_url	http://www.blogger.com/feeds/default/blogs	Blogger metafeed URL	f	f
75	blogger_password		Blogger password	t	f
72	blogger_posts_feed_uri_suffix	/posts/default	URI suffix for Blogger posts	f	f
76	blogger_service_name	blogger	Google Service name	f	f
74	blogger_username		Blogger username	f	f
341	breadcrumbs_separator	:	Separator character between breadcrumbs links.	f	f
544	comments_buttontext	POST	Label on comment posting button.	f	f
540	comments_dateformat	yyyy-MM-dd HH:mm	Format (java.text.SimpleDateFormat) for the comment posted date/time.	f	f
541	comments_inputsize	32	Size of text input fields on comment posting form.	f	f
542	comments_textcols	32	Number of columns in comment textarea.	f	f
543	comments_textrows	5	Number of rows in comment textarea.	f	f
6	site_imagedir	/var/lib/tomcat/neptune-setup/uploads/images/	Content images directory path, including trailing slash.	f	f
112	simplecaptcha_instructions	Please enter the word shown below (reduces spam).	Instructions shown above SimpleCaptcha.	f	f
3	site_head		Site-wide content placed in HEAD tag	f	f
12	site_404_headtitle	Page Not Found	The HEAD title shown on a 404 response.	f	f
13	site_404_pagetitle	Page Not Found	The page title shown on a 404 response.	f	f
14	site_404_content	The page you have requested does not exist on this site. Please select a page from the navigation.	The content shown on a 404 response.	f	f
501	printable_logo	/design/logo-printable.gif	URL of the printer-friendly page logo image.	f	f
503	printable_logo_height	100	Height of the printer-friendly page logo image.	f	f
502	printable_logo_width	200	Width of the printer-friendly page logo image.	f	f
15	site_email	webmaster@ims.net	From: address for notification emails sent from contact forms, e.g. webmaster@yourdomain.com	f	f
534	searchblox_cssdir	/home/sites/setup/searchblox	SearchBlox css directory path.	f	f
535	searchblox_xsldir	/home/sites/setup/searchblox/stylesheets	SearchBlox xsl directory path.	f	f
546	comments_numshown	0	Number of most recent comments to show by default; 0 to show all.	f	f
21	site_cssfolder	/css	css folder, without trailing slash.	f	f
9	site_designfolder	/design	Design images folder, without trailing slash.	f	f
23	site_host		Non-SSL host for non-SSL pages on sites with SSL host set	f	f
5	site_imagefolder	/images	Content images folder, without trailing slash.	f	f
4	site_maxuploadsize	10000000	Maxiumum size of uploaded files, in bytes.	f	f
7	site_mediafolder	/media	Media uploads folder, without trailing slash.	f	f
1	site_name	Neptune Site Setup	Site name.	f	f
8	site_mediadir	/var/lib/tomcat/neptune-setup/uploads/media/	Media uploads directory, with trailing slash.	f	f
24	site_sslhost		SSL host for pages to be served via SSL	f	f
521	sitemap_headtitle	Neptune Site Setup : Site Map	Title for the HEAD tag on the site map.	f	f
520	sitemap_pagetitle	Site Map	Page title for the site map.	f	f
40	access_denied_title	Access Denied	Title shown on Access Denied page.	f	f
41	access_denied_instructions	If you are a registered site member, log in below to gain access to restricted content.	Instructions shown on Access Denied page.	f	f
42	access_login_title	Restricted Access Authorization	Title shown on Access login page.	f	f
551	photos_folder	/photos	Photos folder, without trailing slash.	f	f
552	photos_max_memory	10000000	Max memory used by photo uploader, bytes.	f	f
553	photos_max_request	20000000	Max request size for photo uploader, bytes.	f	f
554	photos_max_chunk	500000	Max chunk size used by photo uploader, bytes.	f	f
555	photos_max_width	1024	Max allowed width of an uploaded photo.	f	f
556	photos_max_height	1024	Max allowed height of an uploaded photo.	f	f
557	photos_thumbnail_width	100	Width of thumbnail images.	f	f
90	google_tracker_id		Google Tracker ID, e.g. UA-6716421-1	f	f
43	access_passwordreset_fromaddress		From: address on password reset email sent to users.	f	f
44	access_passwordreset_fromname		From: name on password reset email sent to users.	f	f
340	breadcrumbs_enable	true	Show breadcrumb links above page title: true/false.	f	t
80	blogger_enable	false	Enable blogger extra: true/false.	f	t
26	site_showrssicon	false	Show RSS icon in location bar (true/false)	f	t
302	navpri_images	false	Use rollover images for the primary navigation: true/false.  Rollover images are named navpri#-off|on|over.gif, where # is the primary node number.	f	t
351	pagetitle_level1	true	Show the page title on level 1 (primary) pages: true/false.	f	t
22	site_debug	false	Debug mode: true/false.	f	t
301	navpri_dhtml_enable	true	Enable DHTML primary nav dropdowns.	f	t
303	navpri_level1_enable	true	Enable primary nav level 1 links (requires navpri_dhtml=true).	f	t
330	navquat_enable	false	Enable quaternary navigation.	f	t
350	pagetitle_enable	true	Enable page title.	f	t
34	root_footer_enable	true	Enable footer on root node.	f	t
30	root_header_enable	true	Enable header on root node.	f	t
31	root_nav_primary_enable	true	Enable primary nav on root node.	f	t
32	root_sectionheader_enable	true	Enable section header on root node.	f	t
33	root_subheader_enable	true	Enable subheader on root node.	f	t
321	sectionheader_enable	true	Enable section header.	f	t
360	sidebar_enable	true	Enable sidebar.	f	t
170	lastmodified_prefix	Last modified	Text before lastmodified.jsp date/time output	f	f
110	recaptcha_private_key	6Lfxh9gSAAAAAA6ppKFhQ5r8vlYNuZiNiqQJ6fCB	Instructions shown above CAPTCHA on forms instructing to fill it in.	f	f
100	header_enable	true	Enable header.	f	t
200	subheader_enable	true	Enable subheader.	f	t
400	footer_enable	true	Enable footer.	f	t
545	comments_notify		Email address of person notified of every comment post.  Optional.	f	f
60	lyris_host		Host name of Lyris ListManager server.	f	f
61	lyris_list		Lyris ListManager list for RSS feed.	f	f
130	calendar_date_format	EEE, MMMM d	java.text.SimpleDateFormat for Calendar event date	f	f
131	calendar_monthyear_format	MMMM yyyy	java.text.SimpleDateFormat for Calendar month/year display	f	f
132	calendar_weekstartsmonday	false	calendar week starts on Monday (true/false)	f	t
133	calendar_shortdaynames	false	calendar displays short day names (Sun, Mon, etc.): (true/false)	f	t
134	calendar_eventwindow_left	300	offset from left of calendar event window (int)	f	f
135	calendar_eventwindow_top	300	offset from top of calendar event window (int)	f	f
136	calendar_eventwindow_width	500	width of calendar event window (int)	f	f
561	softslate_enable	false	Enable SoftSlate stylesheet, etc: true/false.	f	t
560	softslate_context	/softslate	SoftSlate web app context	f	f
562	softslate_sitemap	false	Show SoftSlate categories on site map; true/false.	f	t
137	calendar_eventwindow_height	50	height of calendar event window (int)	f	f
138	calendar_eventwindow_theme	plain	name or path to theme of calendar event window	f	f
140	headlines_showdescription	false	Show page meta description under headline (true/false)	f	t
141	headlines_readmore	Read more.	Text for the "Read more" link at the end of the description.	f	f
142	headlines_showpagetitle	false	Show page title rather than node names as headlines (true/false).	f	t
143	headlines_showhidden	false	Include hidden node headlines (true/false).	f	t
85	atom_uri	http://wordpress.org/news/feed/atom	URI of Atom feed	f	f
86	atom_dateformat	yyyy-MM-dd HH:mm	java.text.SimpleDateFormat for the atom feed dates	f	f
87	atom_maxlisted	0	maximum number of atom feed entries shown; 0 for no limit	f	f
558	photos_index_label	back to index	Label shown on link to photo index (thumbnails) on a given photo page, if photoset thumbnail index is toggled on.	f	f
171	lastmodified_dateformat	HH:mm yyyy-MM-dd	Date format used by lastmodified.jsp	f	f
304	navpri_vertical	false	Display primary navigation vertically along with secondary; automatically disables DHTML navigation. (true/false)	f	t
151	icontact_clientfolderid		iContact clientFolderId (int)	f	f
150	icontact_accountid	707320	iContact accountId (int)	f	f
402	site_copyrighttext	Neptune Setup	Text shown after the copyright year in copyright.jsp	f	f
504	printable_linktext	printer-friendly	Text shown on printer-friendly link in printablelink.jsp	f	f
45	access_login_linktext	log in	Text shown on access login link in accesslink.jsp	f	f
46	access_logout_linktext	log out	Text shown on access logout link in accesslink.jsp	f	f
120	mobile_enable	false	Enables mobile stylesheet if mobile device detected	f	t
121	mobile_toggle_desktop	switch to desktop version	Text displayed on link that toggles to desktop version on mobile device	f	f
122	mobile_toggle_mobile	switch to mobile version	Text displayed on link that toggles back to mobile version on mobile device	f	f
162	payments_netsol	true	Show Network Solutions SSL seal on Payments form	f	t
163	payments_enable	false	Enable Payments extra, requires PayPal info in web.xml	f	t
50	cp_enable_wysiwyg	true	Enable WYSIWYG content editor (true/false).	f	t
550	photos_dir	/var/lib/tomcat/neptune-setup/uploads/photos/	Photos directory, with trailing slash.	f	f
20	site_cssdir	/var/lib/tomcat/neptune-setup/uploads/css/	css directory path, including trailing slash.	f	f
10	site_designdir	/var/lib/tomcat/neptune-setup/uploads/design/	Design images directory path, including trailing slash.	f	f
11	site_formuploadsdir	/var/lib/tomcat/neptune-setup/uploads/forms/	Contact Forms file uploads directory, with trailing slash.	f	f
19	site_rootfolder		Context of the site root, typically /.	f	f
547	comments_viewmore	View earlier comments	Text for view-more-comments link, shown when there are more comments than shown.	f	f
111	recaptcha_public_key	6Lfxh9gSAAAAAKwOQQ7sCbwKunW76-djvqOx0iyJ	Instructions shown below CAPTCHA on forms instructing to click it to get a new image.	f	f
113	simplecaptcha_regenerate	Click the image to generate a new one.	Instructions to regenerate SimpleCaptcha.	f	f
114	simplecaptcha_inputsize	5	Size of text input for SimpleCaptcha.	f	f
2	site_dateformat	EEEE, MMMM dd, yyyy	Date format used by currentdate.jsp	f	f
\.


--
-- Data for Name: sidebarextensions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY sidebarextensions (sidebarextension_id, num, extensionurl, extensioncontext, location) FROM stdin;
\.


--
-- Name: sidebarextensions_sidebarextension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('sidebarextensions_sidebarextension_id_seq', 1, false);


--
-- Data for Name: stylesheet; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY stylesheet (class_id, class_name, class_value, num, required, level, level_num, stylesheetcategory_id) FROM stdin;
270	div.blogpost		1	t	0	0	17
271	div.blogposttitle		2	t	0	0	17
82	td.header	padding: 0;	3	t	0	0	2
272	div.blogpostauthor		3	t	0	0	17
310	div.headline-description		7	t	0	0	18
312	a.headline-readmore:link		8	t	0	0	18
313	a.headline-readmore:visited		9	t	0	0	18
8	a:active	color:red;\r\ntext-decoration: underline;	7	t	0	0	0
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
81	table#header	border: 1px solid gray;	1	t	0	0	2
277	div.blogcommentauthor		7	t	0	0	17
66	div.sitemap3	margin-left: 20px;\r\nfont-size: 12px;	30	t	0	0	7
67	div.sitemap4	margin-left: 30px;\r\nfont-size: 10px;\r\n	40	t	0	0	7
10	h2	font-size: 14px;	9	t	0	0	0
11	h3	font-size: 12px;	10	t	0	0	0
314	a.headline-readmore:hover		10	t	0	0	18
14	li		13	t	0	0	0
12	ol		11	t	0	0	0
278	div.blogcommentdate		8	t	0	0	17
279	div.blogcommentcontent		9	t	0	0	17
630	td.event-date-heading		31	t	0	0	23
83	a.header:link		5	t	0	0	2
180	div.content-lastmodified		2	t	0	0	1
280	a.blogcommentpost:link		10	t	0	0	17
281	a.blogcommentpost:visited		10	t	0	0	17
282	a.blogcommentpost:hover		10	t	0	0	17
283	a.blogcommentpost:active		10	t	0	0	17
80	td.header-left	padding:0;	2	t	0	0	2
84	a.header:visited		6	t	0	0	2
85	a.header:hover		7	t	0	0	2
86	a.header:active		8	t	0	0	2
95	td.subheader-left	width: 100%;\r\npadding: 0;	2	t	0	0	5
96	td.subheader-right	padding: 0;	4	t	0	0	5
168	a.sidebar:link	color: white;\r\ntext-decoration: none;	4	t	0	0	11
34	a.navsec:visited	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: none;	6	t	0	0	4
37	a.navsec:hover	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: underline;	7	t	0	0	4
38	a.navsec:active	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: none;	8	t	0	0	4
101	div.navsec-off		10	t	0	0	4
56	a.navter:visited	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: none;	16	t	0	0	4
57	a.navter:hover	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: underline;	17	t	0	0	4
58	a.navter:active	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: underline;	18	t	0	0	4
631	td.event-time-heading		31	t	0	0	23
137	a.dhtml:link	color: white;\r\ntext-decoration: none;	11	t	0	0	10
138	a.dhtml:visited	color: white;\r\ntext-decoration: none;	12	t	0	0	10
139	a.dhtml:active	color: white;\r\ntext-decoration: underline;	13	t	0	0	10
140	a.dhtml:hover	color: white;\r\ntext-decoration: underline;	14	t	0	0	10
169	a.sidebar:visited	color: white;\r\ntext-decoration: none;	5	t	0	0	11
88	table#header		1	t	1	-1	2
25	td.footer	padding: 3px 20px 3px 20px;	3	t	0	0	6
107	td.footer-left	padding: 0;	2	t	0	0	6
108	td.footer-right	padding: 0;	4	t	0	0	6
21	a.footer:link	color: white;\r\ntext-decoration: underline;	5	t	0	0	6
22	a.footer:visited	color: white;\r\ntext-decoration: underline;	6	t	0	0	6
23	a.footer:hover	color: red;\r\ntext-decoration: underline;	7	t	0	0	6
24	a.footer:active	color: red;\r\ntext-decoration: underline;	8	t	0	0	6
170	a.sidebar:hover	color: white;\r\ntext-decoration: underline;	6	t	0	0	11
171	a.sidebar:active	color: white;\r\ntext-decoration: underline;	7	t	0	0	11
55	a.navter:link	font-size: 10px;\r\ncolor: white;\r\ntext-decoration: none;	15	t	0	0	4
19	img		20	t	0	0	0
534	div.imagerotator		1	t	0	0	1
535	div.fetch		1	t	0	0	1
98	div#navsec-bottom	height: 20px;	4	t	0	0	4
99	div.navsec-over	background-color: #553333;	11	t	0	0	4
59	div.debug	width: 500px;\r\nfont-family: Courier, monospaced; font-size: 8pt; color: blue;\r\nmargin: 10pt 0pt 0pt 0pt;	1	t	0	0	1
373	a:active	color:red;\r\ntext-decoration: underline;	7	t	1	-1	0
17	table		15	t	0	0	0
18	td	font-size: 12px;	16	t	0	0	0
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
257	div#comments-viewmore		13	t	0	0	16
402	body	font-family: Arial, Helvetica, sans-serif;\r\nfont-size: 12pt;\r\nfont-weight: normal;\r\nmargin: 10px 10px 10px 10px;	1	t	1	-1	0
266	a.comments-viewall:link		14	t	0	0	16
632	td.event-copy-heading		31	t	0	0	23
471	ul		12	t	1	-1	0
421	h1	font-size: 16pt;	8	t	1	-1	0
422	h2	font-size: 14pt;	9	t	1	-1	0
423	h3	font-size: 12pt;	10	t	1	-1	0
424	hr	border: 0;\r\nheight: 1px;\r\ncolor: black;\r\nbackground-color: black;	14	t	1	-1	0
633	td.event-date		32	t	0	0	23
634	td.event-time		32	t	0	0	23
7	a:hover	color: red;\r\ntext-decoration: underline;	6	t	0	0	0
500	form	margin: 10px 0px 0px 0px;	17	t	0	0	0
635	td.event-copy		32	t	0	0	23
532	div.error	color: red;\r\nmargin: 10px;	1	t	0	0	1
636	.event-title		33	t	0	0	23
13	ul	margin-top: 5px;\r\nmargin-bottom: 5px;	12	t	0	0	0
544	div.access	margin: 10px;	1	t	0	0	13
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
315	a.headline-readmore:active		11	t	0	0	18
637	.event-description		33	t	0	0	23
638	tr.event		32	t	0	0	23
639	table#events		30	t	0	0	23
640	table#event-selector		29	t	0	0	23
641	td.event-month-selector		29	t	0	0	23
642	td.event-year-selector		29	t	0	0	23
92	td.navpri-first		9	t	0	0	3
516	form.access		2	t	0	0	13
517	input.access-text	font-size: 12px;	3	t	0	0	13
518	input.access-submit	background-color: gray;\r\ncolor: white;\r\nfont-size: 14px;\r\nfont-weight: bold;	4	t	0	0	13
519	table.access	background: lightgray;\r\nborder-spacing: 5px;	5	t	0	0	13
520	td.access	font-size: 12px;\r\nfont-weight: bold;	6	t	0	0	13
533	div.message	color: green;\r\nmargin: 10px;	1	t	0	0	1
267	a.comments-viewall:visited		15	t	0	0	16
90	td.header		3	t	1	-1	2
447	td.footer-left	height: 21px;\r\nwidth: 5px;	2	t	1	-1	6
444	td.footer	padding-left: 20px;\r\npadding-right: 20px;\r\ntext-align: left;	3	t	1	-1	6
448	td.footer-right	width: 5px;	4	t	1	-1	6
432	table#l1	width: 100%;\r\nborder-spacing: 0px;	10	t	1	-1	9
178	table#l2	width: 100%;\r\nborder-spacing: 0px;	20	t	0	0	9
433	table#l2	width: 100%;\r\nborder-spacing: 0px;	20	t	1	-1	9
434	table#l3	width: 100%;\r\nborder-spacing: 0px;	30	t	1	-1	9
450	td#l1_p1	padding: 0px;\r\nborder: 0px solid black;\nfont-size: 12px;\r\nmargin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;\r\n	11	t	1	-1	9
451	td#l2_p1	padding: 0px;\nfont-size: 12px;\r\nmargin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;	21	t	1	-1	9
452	td#l2_p2	padding: 0px;\r\nborder-left: 1px dashed black;\nfont-size: 11px;\r\nmargin-top: 5px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;\r\n	22	t	1	-1	9
411	a.breadcrumbs:link	color: green;\r\ntext-decoration: none;	5	t	0	0	8
63	td.sitemap	padding: 10px;\r\nwidth: 150px;\r\nborder-right: 1px solid black;	2	t	0	0	7
323	div.formfield		4	t	0	0	19
453	td#l3_p1	padding: 0px;\r\nborder-right: 1px dashed black;\nfont-size: 11px;\r\nmargin-top: 5px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;	31	t	1	-1	9
454	td#l3_p2	padding: 0px;\nfont-size: 12px;\r\nmargin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;	32	t	1	-1	9
179	table#l3	width: 100%;	30	t	0	0	9
202	td.sectionheader	padding: 0px;	3	t	0	0	14
87	td.header-right	padding: 0;\r\nwidth: 10px;	4	t	0	0	2
29	table#subheader	border: 1px solid purple;	1	t	0	0	5
414	a.breadcrumbs.active	color: green;\r\ntext-decoration: underline;	6	t	0	0	8
165	div#sidebar-top	height: 10px;	1	t	0	0	11
410	div#breadcrumbs	font-size: 10px;\r\npadding: 10px;	4	t	0	0	8
413	a.breadcrumbs:hover	color: blue;\r\ntext-decoration: underlined;	7	t	0	0	8
201	td.sectionheader-left	padding: 0px;	2	t	0	0	14
412	a.breadcrumbs:visited	color: green;\r\ntext-decoration: none;	8	t	0	0	8
203	td.sectionheader-right	padding: 0px;	4	t	0	0	14
27	div#pagetitle	clear: right;\r\ncolor: white; background-color: green;\r\nfont-size: 14px;\r\nfont-weight: bold;\r\npadding: 10px 0 10px 10px;	3	t	0	0	8
580	td#main-right	padding: 0;	2	t	0	0	8
93	td.navpri-left	background-color: gray;\r\npadding: 0;	3	t	0	0	3
438	table#main	width: 700px;\r\nborder-spacing: 0px;\r\nborder: 0;	1	t	1	-1	8
167	div#sidebar-bottom	height: 10px;	2	t	0	0	11
430	table#footer	width: 700px;\r\nfont-size: 10pt;\r\ncolor: black;\r\nbackground-color: lightgray;\r\nborder: 1px solid black;	1	t	1	-1	6
579	td#main-left	background-color: lightgray;\r\npadding: 0;	2	t	0	0	8
268	a.comments-viewall:hover		16	t	0	0	16
166	div.sidebar	padding: 5px;	3	t	0	0	11
269	a.comments-viewall:active		17	t	0	0	16
97	div#navsec-top	height: 36px;	2	t	0	0	4
53	div.navter-box		13	t	0	0	4
135	#layer4	left: 523;\r\nvisibility: hidden; position: absolute; z-index:90;	4	t	0	0	10
136	#layer5	left: 624;\r\nvisibility: hidden; position: absolute; z-index:90;	5	t	0	0	10
142	td.dhtml-off	font-size: 11px;\r\nbackground-color: gray;\r\npadding: 5px;\r\nborder-bottom: 1px solid black;	21	t	0	0	10
155	#layer6	left: 725;\r\nvisibility: hidden; position: absolute; z-index:90;	6	t	0	0	10
265	div#comments-rss		8	t	0	0	16
629	div.event-ics		23	t	0	0	23
134	#layer3	left: 422;;\r\nvisibility: hidden; position: absolute; z-index:90;	3	t	0	0	10
94	td.navpri-right	padding: 0;\r\nborder-left: 1px solid black;\r\nbackground-color: gray;	4	t	0	0	3
41	a.navpri:link	font-size: 14px; font-weight: bold;\r\ncolor: white;\r\ntext-decoration: none;	5	t	0	0	3
42	a.navpri:visited	font-size: 14px; font-weight: bold;\r\ncolor: white;\r\ntext-decoration: none;	6	t	0	0	3
45	a.navpri:active	font-size: 14px; font-weight: bold;\r\ncolor: red;\r\ntext-decoration: none;	8	t	0	0	3
28	div#navsec-box	width: 149px;	1	t	0	0	4
54	div.navter	font-size: 10px;\r\ncolor: white;\r\npadding: 3px 3px 0px 20px;	14	t	0	0	4
111	div.navter-over	background-color: #553333;	21	t	0	0	4
109	div.navter-on	background: url("/design/arrow.gif") 8px 4px no-repeat;	22	t	0	0	4
20	table#footer	width: 100%;\r\nclear: both;\r\nfont-size: 10px;\r\ncolor: white;\r\nbackground-color: gray;\r\nborder: 1px solid brown;	1	t	0	0	6
455	td#l1_p1	border: 0px solid black;\r\nheight: 200px;\r\nfont-size: 12px;\r\npadding: 10px;	11	t	0	0	9
110	div.navter-off		20	t	0	0	4
240	div.related		1	t	0	0	24
141	table.dhtml	width: 150px;\r\nborder-top: 1px solid black;\r\nborder-left: 1px solid black;\r\nborder-right: 1px solid black;	20	t	0	0	10
204	table#sectionheader		1	t	1	-1	14
205	td.sectionheader-left	padding:0;	2	t	1	-1	14
206	td.sectionheader		3	t	1	-1	14
207	td.sectionheader-right	padding:0;	4	t	1	-1	14
160	table#l1	width: 100%;	10	t	0	0	9
456	td#l2_p1	font-size: 12px;\r\npadding: 10px;	21	t	0	0	9
457	td#l2_p2	width: 200px;\r\nborder-left: 1px dashed black;\r\nfont-size: 11px;\r\npadding: 5px;	22	t	0	0	9
458	td#l3_p1	width: 200px;\r\nborder-right: 1px dashed black;\r\nfont-size: 11px;\r\npadding: 5px;	31	t	0	0	9
459	td#l3_p2	font-size: 12px;\r\npadding: 10px;	32	t	0	0	9
89	td.header-left	padding:0;	2	t	1	-1	2
91	td.header-right	padding:0;	4	t	1	-1	2
39	td.subheader	padding: 5px 10px 5px 10px;\r\ncolor: black;\r\nwhite-space: nowrap;	3	t	0	0	5
163	div.navsec-on	background-color: #553333;	12	t	0	0	4
200	table#sectionheader	height: 25px;\r\nbackground-color: brown;	1	t	0	0	14
241	div.related-link		2	t	0	0	24
62	table.sitemap	border-left: 1px solid black;\r\nmargin-top: 10px;\r\nmargin-bottom: 10px;	1	t	0	0	7
440	table.sitemap	border-left: 1px solid black;\r\nmargin-top: 10px;\r\nmargin-bottom: 10px;	1	t	1	-1	7
464	td.sitemap	padding: 10px;\r\nwidth: 150px;\r\nborder-right: 1px solid black;	2	t	1	-1	7
210	div#navquat-box		1	t	0	0	15
162	table#main	border: 1px solid blue;	1	t	0	0	8
211	div#navquat-top		2	t	0	0	15
416	div#pagetitle	color: black;\r\nfont-size: 14pt;\r\nfont-weight: bold;\r\nmargin: 10px 0 10px 0;	3	t	1	-1	8
212	div.navquat		3	t	0	0	15
213	div.navquat-on		4	t	0	0	15
581	td#main-right	padding: 0px 0px 10px 0px;	2	t	1	-1	8
214	div.navquat-off		5	t	0	0	15
215	div.navquat-over		6	t	0	0	15
216	div#navquat-bottom		7	t	0	0	15
220	a.navquat:link		10	t	0	0	15
221	a.navquat:visited		11	t	0	0	15
230	div.payments		1	t	0	0	25
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
324	.required		5	t	0	0	19
325	.optional		6	t	0	0	19
326	table.checkboxes		7	t	0	0	19
327	td.checkbox		8	t	0	0	19
328	table.radios		9	t	0	0	19
329	td.radio		10	t	0	0	19
330	td.lyris		11	t	0	0	19
334	input.submit		15	t	0	0	19
335	div#thankyou		16	t	0	0	19
350	table.photoset		1	t	0	0	20
351	td.photoset-header		2	t	0	0	20
352	div.photoset-title		3	t	0	0	20
353	div.photoset-description		4	t	0	0	20
354	div.photoset-shootdate		5	t	0	0	20
355	div.photoset-credit		6	t	0	0	20
356	td.thumbnail		7	t	0	0	20
357	img.thumbnail		8	t	0	0	20
358	div.photo		9	t	0	0	20
340	div.poll-topic		1	t	0	0	21
341	table.poll-choices		2	t	0	0	21
342	form.poll-choice	margin: 0;	3	t	0	0	21
343	td.poll-choice		4	t	0	0	21
344	td.poll-button		5	t	0	0	21
345	image.poll-button		6	t	0	0	21
346	td.poll-tally		7	t	0	0	21
347	div.poll		1	t	0	0	21
348	body.poll		1	t	0	0	21
300	div.headlines		1	t	0	0	18
68	td.navpri-over	background-color: gray;	9	t	0	0	3
76	td.navpri-off	background-color: gray;	10	t	0	0	3
161	td.navpri-on	background-color: green;	11	t	0	0	3
556	a.navpri-on:link		12	t	0	0	3
557	a.navpri-on:visited		13	t	0	0	3
558	a.navpri-on: hover		14	t	0	0	3
559	a.navpri-on: active		15	t	0	0	3
243	a.related-link:link		3	t	0	0	24
469	td.subheader-right		4	t	1	-1	5
30	a.subheader:link	font-size: 12px;\r\ntext-decoration: none;\r\ncolor: green;	5	t	0	0	5
31	a.subheader:visited	font-size: 12px;\r\ntext-decoration: none;\r\ncolor: green;	6	t	0	0	5
32	a.subheader:hover	font-size: 12px;\r\ntext-decoration: underline;\r\ncolor: green;	7	t	0	0	5
33	a.subheader:active	font-size: 12px;\r\ntext-decoration: underline;\r\ncolor: green;	8	t	0	0	5
441	table#subheader	width: 702px;\r\nbackground-color: lightgray;\r\nborder: 1px solid black;\r\nempty-cells: show;	1	t	1	-1	5
467	td.subheader-left	width: 100%;	2	t	1	-1	5
465	td.subheader	font-size: 12pt;\r\nfont-style: normal;\r\ncolor: black;	3	t	1	-1	5
40	td.navpri	padding: 5px 0 5px 0;\r\ntext-align: center;\r\nborder-left: 1px solid black;	2	t	0	0	3
502	textarea	font-family: Arial, Helvetica, sans-serif;\r\nfont-size: 12px;\r\nfont-weight: normal;	19	t	0	0	0
501	input	font-family: Arial, Helvetica, sans-serif;\r\nfont-size: 12px;\r\nfont-weight: normal;	18	t	0	0	0
600	div.cal		1	t	0	0	23
359	img.photo		11	t	0	0	20
360	div.photo-caption		12	t	0	0	20
361	div.photo-title	font-weight: bold;	10	t	0	0	20
301	div.headline		2	t	0	0	18
302	a.headline:link		3	t	0	0	18
303	a.headline:visited		4	t	0	0	18
304	a.headline:hover		5	t	0	0	18
305	a.headline:active		6	t	0	0	18
601	table.cal		2	t	0	0	23
602	td.cal-prev		3	t	0	0	23
603	td.cal-next		4	t	0	0	23
604	td.cal-month		5	t	0	0	23
605	td.cal-day		6	t	0	0	23
606	td.cal-date		7	t	0	0	23
607	td.cal-emptydate		8	t	0	0	23
608	td.cal-today		9	t	0	0	23
609	td.cal-eventdate		10	t	0	0	23
610	td.cal-weekend		11	t	0	0	23
620	div.event		20	t	0	0	23
621	div.event-title		21	t	0	0	23
622	div.event-time		22	t	0	0	23
623	div.event-description		23	t	0	0	23
624	a.event:link		24	t	0	0	23
625	a.event:visited		25	t	0	0	23
626	a.event:hover		26	t	0	0	23
627	a.event:active		27	t	0	0	23
628	div.event-rss		23	t	0	0	23
9	h1	font-size: 16px;	8	t	0	0	0
16	hr		14	t	0	0	0
26	table#navpri	empty-cells: show;	1	t	0	0	3
143	td.dhtml-on	font-size: 11px;\r\nbackground-color: #553333;\r\npadding: 5px;\r\nborder-bottom: 1px solid black;	22	t	0	0	10
362	table.thumbnails		7	t	0	0	20
363	div.photoset-indexlink		13	t	0	0	20
332	div.captcha		13	t	0	0	19
331	div.submit		12	t	0	0	19
364	a.photoset-indexlink:link		14	t	0	0	20
365	a.photoset-indexlink:visited		15	t	0	0	20
366	a.photoset-indexlink:hover		16	t	0	0	20
367	a.photoset-indexlink:active		17	t	0	0	20
44	a.navpri:hover	font-size: 14px; font-weight: bold;\r\ncolor: red;\r\ntext-decoration: none;	7	t	0	0	3
35	a.navsec:link	font-size: 12px;\r\ncolor: white;\r\ntext-decoration: none;	5	t	0	0	4
244	a.related-link:visited		4	t	0	0	24
245	a.related-link:hover		5	t	0	0	24
246	a.related-link:active		6	t	0	0	24
36	div.navsec	font-size: 12px; color: white;\r\nborder: 1px solid black;\r\npadding: 3px 3px 3px 3px;\r\nmargin: 2px;	3	t	0	0	4
15	div#container	text-align: left;\r\nposition: relative;\r\nmargin: auto;\r\nwidth: 1000px;	1	t	0	0	0
132	#layer1	left: 200;\r\nvisibility: hidden; position: absolute;	1	t	0	0	10
133	#layer2	left: 321;\r\nvisibility: hidden; position: absolute;	2	t	0	0	10
156	#layer7	left: 826;\r\nvisibility: hidden; position: absolute; z-index:90;	7	t	0	0	10
157	#layer8	left: 927;\r\nvisibility: hidden; position: absolute; z-index:90;	8	t	0	0	10
158	#layer9	left: 1028;\r\nvisibility: hidden; position: absolute; z-index:90;	9	t	0	0	10
238	div.payment-summary		2	t	0	0	25
239	div.payment-confirmation		3	t	0	0	25
231	table.payments		4	t	0	0	25
232	td.payment-option		5	t	0	0	25
233	td.payment-amount		6	t	0	0	25
234	td.payment-description		7	t	0	0	25
235	.payment-name		8	t	0	0	25
236	table.creditcard		9	t	0	0	25
237	td.creditcard		10	t	0	0	25
181	div.page-lastmodified		2	t	0	0	1
1	body	font-family: Arial, Helvetica, sans-serif; \r\nfont-size: 12px; \r\nfont-weight: normal;\r\ntext-align: center;	1	t	0	0	0
531	.error	color:red	1	t	0	0	1
\.


--
-- Name: stylesheet_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('stylesheet_class_id_seq', 665, true);


--
-- Data for Name: stylesheetcategories; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY stylesheetcategories (stylesheetcategory_id, stylesheetcategory, num) FROM stdin;
9	layouts	9
6	footer	10
10	dhtml	11
1	other	99
16	comments	16
17	blogger	17
8	main	6
0	body	1
2	header	2
3	primary nav	3
7	site map	13
13	access	15
15	quaternary nav	12
19	forms	19
20	photosets	20
21	polls	21
22	softslate	22
18	headlines	18
23	calendar	23
14	sectionheader	4
5	subheader	5
11	sidebar	7
4	secondary nav	8
24	related	24
25	payments	25
\.


--
-- Data for Name: updatelog; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY updatelog (updated, name, value) FROM stdin;
2008-10-28 10:55:44	db_version	20081027
2008-10-28 10:55:44	extra_added	forms
2008-11-13 12:00:34	db_version	20081113
2008-12-05 15:38:18	db_version	20081205
2008-12-08 14:48:26	db_version	20081208
2008-12-19 15:37:15	db_version	20081219
2009-01-21 15:05:33	db_version	20090121
2009-01-23 11:51:15	db_version	20090123
2009-02-02 17:35:14	db_version	20090202
2009-02-13 10:57:11	db_version	20090212
2009-02-16 15:25:14	db_version	20090216
2009-03-11 20:39:55	db_version	20090311
2009-04-29 17:44:37	db_version	20090429
2009-05-27 14:35:56	db_version	20090527
2009-09-24 17:16:39	db_version	20090924
2009-10-23 11:33:02	db_version	20091023
2009-10-26 15:22:38	db_version	20091026
2009-11-30 10:59:22	db_version	20091120
2009-11-30 10:59:25	db_version	20091125
2010-02-19 16:17:32	db_version	20100219
2010-02-26 09:33:42	db_version	20100226
2010-03-01 16:56:59	db_version	20100301
2010-03-28 23:50:50	db_version	20100328
2010-04-06 21:23:45	db_version	20100406
2010-04-15 15:39:17	db_version	20100413
2010-05-24 14:06:15	db_version	20100524
2010-06-02 15:35:53	db_version	20100528
2010-07-01 17:29:12	db_version	20100701
2010-07-09 16:10:24	db_version	20100709
2010-07-20 12:32:12	db_version	20100720
2010-07-29 16:41:05	db_version	20100729
2010-08-04 15:37:08	db_version	20100804
2010-08-09 14:03:25	db_version	20100809
2010-08-18 13:51:30	db_version	20100818
2010-09-14 14:30:33	db_version	20100901
2010-11-04 16:52:30	db_version	20101104
2010-11-16 17:25:31	db_version	20111116
2010-12-07 16:44:07	db_version	20101207
2010-12-14 10:37:25	db_version	20101214
2011-01-30 19:19:36	db_version	20110120
2011-03-23 10:26:08	db_version	20110323
2011-06-13 17:35:43	db_version	20110613
2011-06-21 16:40:54	db_version	20110621
2011-07-06 17:09:48	db_version	20110706
2011-07-25 12:29:12	db_version	20110725
2011-07-26 13:21:45	db_version	20110726
2011-11-15 15:34:28	db_version	20111115
2012-01-16 10:41:48	db_version	20120105
2012-02-06 16:40:30	db_version	20120129
2012-02-26 18:13:29	db_version	20120214
2012-04-06 14:33:33	db_version	20120320
2012-07-02 18:29:36	db_version	20120629
2012-04-06 14:33:47	db_version	20120323
2012-03-21 19:32:27	db_version	20120321
2012-03-28 11:33:29	db_version	20120328
2012-07-10 15:06:16	db_version	20120710
2012-08-29 12:53:09	db_version	20120829
2012-08-31 15:15:42	db_version	20120830
2012-11-02 12:25:45	db_version	20121102
2012-11-03 11:21:19	db_version	20121103
2013-06-20 18:10:39	db_version	20130620
2013-10-11 09:25:23	db_version	20131010
2014-02-28 12:26:00	db_version	20140228
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users (uid, lastname, firstname, email, password, created, updated) FROM stdin;
1	Support	IMS	support@ims.net	b/+4xDJqE5OGDNiqwVxHEcJosbI=	2007-11-26 15:16:33-06	2010-02-16 16:35:54-06
\.


--
-- Data for Name: users_extensions; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users_extensions (extid, username) FROM stdin;
\.


--
-- Data for Name: users_extras; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users_extras (extra_id, username) FROM stdin;
11	support@ims.net
\.


--
-- Data for Name: users_nodes; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY users_nodes (nid, username) FROM stdin;
0	support@ims.net
\.


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('users_uid_seq', 1, true);


--
-- Data for Name: utilitycontent; Type: TABLE DATA; Schema: public; Owner: jcms
--

COPY utilitycontent (utilitycontent_id, location, num, copy, created, updated, modulecontext, moduleurl, moduleabove, showhome, showinside, showmobile) FROM stdin;
6	F	1	\N	2010-12-10 12:39:56-06	\N	/	/copyright.jsp	f	t	t	f
8	H	1	<!-- utility content: site logo -->\r\n<a href="/"><img src="/design/logo.gif" border="0" /></a>	2010-12-10 13:11:45-06	\N	\N	\N	f	t	t	f
4	H	2	<!-- utility content: search form -->\r\n  <form class="search" action="/searchblox/servlet/SearchServlet" method="post">\r\n    <table class="search" cellspacing="0" align="right">\r\n      <tr>\r\n        <td><img src="/design/search-bg.gif" width="54" height="11" alt="search" /></td>\r\n        <td><input type="text" class="search" size="20" name="query" /></td>\r\n        <td><input type="image" name="search" src="/design/search-button.gif" width="16" height="16" /></td>\r\n      </tr>\r\n    </table>\r\n  </form>	2010-12-10 12:39:56-06	\N	\N	\N	f	t	t	f
3	S	4	\N	2010-12-10 12:39:56-06	\N	/	/printablelink.jsp	f	t	t	f
5	S	1	\N	2010-12-10 12:39:56-06	\N	/	/currentdate.jsp	f	t	t	f
1	S	2	<a class="subheader" href="/index.jsp">home</a>	2010-12-10 12:39:56-06	\N	\N	\N	f	t	t	f
2	S	3	<a class="subheader" href="/sitemap.jsp">site map</a>	2010-12-10 12:39:56-06	\N	\N	\N	f	t	t	f
7	F	2	<div style="text-align:right;"><a target="_blank" href="http://www.ims.net/"><img src="/design/powered-by-ims.png" width="125" height="27" border="0" alt="Powered by IMS"/></a></div>	2010-12-10 12:39:56-06	\N	\N	\N	f	t	t	f
\.


--
-- Name: utilitycontent_utilitycontent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jcms
--

SELECT pg_catalog.setval('utilitycontent_utilitycontent_id_seq', 8, true);


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
-- Name: commentblacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY commentblacklist
    ADD CONSTRAINT commentblacklist_pkey PRIMARY KEY (word_id);


--
-- Name: commentblacklist_word_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY commentblacklist
    ADD CONSTRAINT commentblacklist_word_key UNIQUE (word);


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
-- Name: cproles_username_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY cproles
    ADD CONSTRAINT cproles_username_key UNIQUE (username);


--
-- Name: dhtmlcache_accessuser_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY dhtmlcache
    ADD CONSTRAINT dhtmlcache_accessuser_key UNIQUE (accessuser);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


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
-- Name: formconstantcontactlists_link_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY formconstantcontactlists
    ADD CONSTRAINT formconstantcontactlists_link_key UNIQUE (link);


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
-- Name: layoutpanes_unique; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY layoutpanes
    ADD CONSTRAINT layoutpanes_unique UNIQUE (layout_id, pane, mobile);


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
-- Name: paymentoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY paymentoptions
    ADD CONSTRAINT paymentoptions_pkey PRIMARY KEY (paymentoption_id);


--
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: photos_imagefile_key; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_imagefile_key UNIQUE (photoset_id, imagefile);


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
-- Name: pollchoices_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY pollchoices
    ADD CONSTRAINT pollchoices_pkey PRIMARY KEY (pollchoice_id);


--
-- Name: polls_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (poll_id);


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
-- Name: sidebarextensions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY sidebarextensions
    ADD CONSTRAINT sidebarextensions_pkey PRIMARY KEY (sidebarextension_id);


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
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: utilitycontent_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms; Tablespace: 
--

ALTER TABLE ONLY utilitycontent
    ADD CONSTRAINT utilitycontent_pkey PRIMARY KEY (utilitycontent_id);


--
-- Name: accessroles_media_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX accessroles_media_idx ON accessroles_media USING btree (rolename);


--
-- Name: accessroles_nodes_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX accessroles_nodes_idx ON accessroles_nodes USING btree (rolename);


--
-- Name: audit_tablename_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX audit_tablename_idx ON audit USING btree (tablename);


--
-- Name: audit_username_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX audit_username_idx ON audit USING btree (username);


--
-- Name: content_label_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX content_label_unique ON content USING btree (label);


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
-- Name: pagetags_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX pagetags_unique ON pagetags USING btree (pid, tag);


--
-- Name: pollchoices_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX pollchoices_unique ON pollchoices USING btree (poll_id, num);


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
-- Name: users_extensions_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX users_extensions_idx ON users_extensions USING btree (username);


--
-- Name: users_extensions_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX users_extensions_unique ON users_extensions USING btree (username, extid);


--
-- Name: users_extras_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX users_extras_idx ON users_extras USING btree (username);


--
-- Name: users_extras_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX users_extras_unique ON users_extras USING btree (username, extra_id);


--
-- Name: users_nodes_idx; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE INDEX users_nodes_idx ON users_nodes USING btree (username);


--
-- Name: users_nodes_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX users_nodes_unique ON users_nodes USING btree (username, nid);


--
-- Name: utilitycontent_unique; Type: INDEX; Schema: public; Owner: jcms; Tablespace: 
--

CREATE UNIQUE INDEX utilitycontent_unique ON utilitycontent USING btree (location, num);


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
-- Name: accessroles_media_mid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY accessroles_media
    ADD CONSTRAINT accessroles_media_mid_fkey FOREIGN KEY (mid) REFERENCES media(mid);


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
-- Name: extras_parent_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY extras
    ADD CONSTRAINT extras_parent_extra_id_fkey FOREIGN KEY (parent_extra_id) REFERENCES extras(extra_id);


--
-- Name: formconstantcontactlists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formconstantcontactlists
    ADD CONSTRAINT formconstantcontactlists_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


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
-- Name: formicontactlists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formicontactlists
    ADD CONSTRAINT formicontactlists_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: formlyrislists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formlyrislists
    ADD CONSTRAINT formlyrislists_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: formmailchimplists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY formmailchimplists
    ADD CONSTRAINT formmailchimplists_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


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
-- Name: nodelinks_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY nodelinks
    ADD CONSTRAINT nodelinks_nid_fkey FOREIGN KEY (nid) REFERENCES nodes(nid);


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
-- Name: pagetags_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pagetags
    ADD CONSTRAINT pagetags_pid_fkey FOREIGN KEY (pid) REFERENCES pages(pid);


--
-- Name: paymentoptions_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY paymentoptions
    ADD CONSTRAINT paymentoptions_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES payments(payment_id);


--
-- Name: photos_photoset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_photoset_id_fkey FOREIGN KEY (photoset_id) REFERENCES photosets(photoset_id);


--
-- Name: pollchoices_poll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pollchoices
    ADD CONSTRAINT pollchoices_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES polls(poll_id);


--
-- Name: pollsubmissions_pollchoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY pollsubmissions
    ADD CONSTRAINT pollsubmissions_pollchoice_id_fkey FOREIGN KEY (pollchoice_id) REFERENCES pollchoices(pollchoice_id);


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
-- Name: users_extras_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_extras
    ADD CONSTRAINT users_extras_extra_id_fkey FOREIGN KEY (extra_id) REFERENCES extras(extra_id);


--
-- Name: users_nodes_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY users_nodes
    ADD CONSTRAINT users_nodes_nid_fkey FOREIGN KEY (nid) REFERENCES nodes(nid);


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
-- Name: accessroles_accessrole_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE accessroles_accessrole_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE accessroles_accessrole_id_seq FROM jcms;
GRANT ALL ON SEQUENCE accessroles_accessrole_id_seq TO jcms;
GRANT ALL ON SEQUENCE accessroles_accessrole_id_seq TO jcmsadmin;


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
GRANT SELECT,UPDATE ON TABLE accessusers TO jcmsuser;


--
-- Name: accessusers_accessuser_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE accessusers_accessuser_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE accessusers_accessuser_id_seq FROM jcms;
GRANT ALL ON SEQUENCE accessusers_accessuser_id_seq TO jcms;
GRANT ALL ON SEQUENCE accessusers_accessuser_id_seq TO jcmsadmin;


--
-- Name: audit; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE audit FROM PUBLIC;
REVOKE ALL ON TABLE audit FROM jcms;
GRANT ALL ON TABLE audit TO jcms;
GRANT SELECT,INSERT ON TABLE audit TO jcmsadmin;


--
-- Name: audit_audit_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE audit_audit_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE audit_audit_id_seq FROM jcms;
GRANT ALL ON SEQUENCE audit_audit_id_seq TO jcms;
GRANT ALL ON SEQUENCE audit_audit_id_seq TO jcmsadmin;


--
-- Name: commentblacklist; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE commentblacklist FROM PUBLIC;
REVOKE ALL ON TABLE commentblacklist FROM jcms;
GRANT ALL ON TABLE commentblacklist TO jcms;
GRANT ALL ON TABLE commentblacklist TO jcmsadmin;
GRANT SELECT ON TABLE commentblacklist TO jcmsuser;


--
-- Name: commentblacklist_word_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE commentblacklist_word_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE commentblacklist_word_id_seq FROM jcms;
GRANT ALL ON SEQUENCE commentblacklist_word_id_seq TO jcms;
GRANT ALL ON SEQUENCE commentblacklist_word_id_seq TO jcmsadmin;


--
-- Name: comments; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE comments FROM PUBLIC;
REVOKE ALL ON TABLE comments FROM jcms;
GRANT ALL ON TABLE comments TO jcms;
GRANT SELECT,INSERT ON TABLE comments TO jcmsuser;
GRANT ALL ON TABLE comments TO jcmsadmin;


--
-- Name: comments_comment_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE comments_comment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE comments_comment_id_seq FROM jcms;
GRANT ALL ON SEQUENCE comments_comment_id_seq TO jcms;
GRANT ALL ON SEQUENCE comments_comment_id_seq TO jcmsuser;
GRANT ALL ON SEQUENCE comments_comment_id_seq TO jcmsadmin;


--
-- Name: content; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE content FROM PUBLIC;
REVOKE ALL ON TABLE content FROM jcms;
GRANT ALL ON TABLE content TO jcms;
GRANT SELECT ON TABLE content TO jcmsuser;
GRANT ALL ON TABLE content TO jcmsadmin;


--
-- Name: content_cid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE content_cid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE content_cid_seq FROM jcms;
GRANT ALL ON SEQUENCE content_cid_seq TO jcms;
GRANT ALL ON SEQUENCE content_cid_seq TO jcmsadmin;


--
-- Name: cproles; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE cproles FROM PUBLIC;
REVOKE ALL ON TABLE cproles FROM jcms;
GRANT ALL ON TABLE cproles TO jcms;
GRANT ALL ON TABLE cproles TO jcmsadmin;


--
-- Name: dhtmlcache; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE dhtmlcache FROM PUBLIC;
REVOKE ALL ON TABLE dhtmlcache FROM jcms;
GRANT ALL ON TABLE dhtmlcache TO jcms;
GRANT DELETE ON TABLE dhtmlcache TO jcmsadmin;
GRANT SELECT,INSERT ON TABLE dhtmlcache TO jcmsuser;


--
-- Name: events; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE events FROM PUBLIC;
REVOKE ALL ON TABLE events FROM jcms;
GRANT ALL ON TABLE events TO jcms;
GRANT ALL ON TABLE events TO jcmsadmin;
GRANT SELECT ON TABLE events TO jcmsuser;


--
-- Name: events_event_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE events_event_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE events_event_id_seq FROM jcms;
GRANT ALL ON SEQUENCE events_event_id_seq TO jcms;
GRANT ALL ON SEQUENCE events_event_id_seq TO jcmsadmin;


--
-- Name: extensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE extensions FROM PUBLIC;
REVOKE ALL ON TABLE extensions FROM jcms;
GRANT ALL ON TABLE extensions TO jcms;
GRANT ALL ON TABLE extensions TO jcmsadmin;


--
-- Name: extensions_extid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE extensions_extid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE extensions_extid_seq FROM jcms;
GRANT ALL ON SEQUENCE extensions_extid_seq TO jcms;
GRANT ALL ON SEQUENCE extensions_extid_seq TO jcmsadmin;


--
-- Name: extras; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE extras FROM PUBLIC;
REVOKE ALL ON TABLE extras FROM jcms;
GRANT ALL ON TABLE extras TO jcms;
GRANT SELECT ON TABLE extras TO jcmsadmin;


--
-- Name: formconstantcontactlists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formconstantcontactlists FROM PUBLIC;
REVOKE ALL ON TABLE formconstantcontactlists FROM jcms;
GRANT ALL ON TABLE formconstantcontactlists TO jcms;
GRANT SELECT ON TABLE formconstantcontactlists TO jcmsuser;
GRANT ALL ON TABLE formconstantcontactlists TO jcmsadmin;


--
-- Name: formfieldoptions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formfieldoptions FROM PUBLIC;
REVOKE ALL ON TABLE formfieldoptions FROM jcms;
GRANT ALL ON TABLE formfieldoptions TO jcms;
GRANT ALL ON TABLE formfieldoptions TO jcmsadmin;
GRANT SELECT ON TABLE formfieldoptions TO jcmsuser;


--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq FROM jcms;
GRANT ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq TO jcms;
GRANT ALL ON SEQUENCE formfieldoptions_formfieldoption_id_seq TO jcmsadmin;


--
-- Name: formfields; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formfields FROM PUBLIC;
REVOKE ALL ON TABLE formfields FROM jcms;
GRANT ALL ON TABLE formfields TO jcms;
GRANT ALL ON TABLE formfields TO jcmsadmin;
GRANT SELECT ON TABLE formfields TO jcmsuser;


--
-- Name: formfields_formfield_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE formfields_formfield_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE formfields_formfield_id_seq FROM jcms;
GRANT ALL ON SEQUENCE formfields_formfield_id_seq TO jcms;
GRANT ALL ON SEQUENCE formfields_formfield_id_seq TO jcmsadmin;


--
-- Name: formicontactlists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formicontactlists FROM PUBLIC;
REVOKE ALL ON TABLE formicontactlists FROM jcms;
GRANT ALL ON TABLE formicontactlists TO jcms;
GRANT SELECT ON TABLE formicontactlists TO jcmsuser;
GRANT ALL ON TABLE formicontactlists TO jcmsadmin;


--
-- Name: formlyrislists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formlyrislists FROM PUBLIC;
REVOKE ALL ON TABLE formlyrislists FROM jcms;
GRANT ALL ON TABLE formlyrislists TO jcms;
GRANT ALL ON TABLE formlyrislists TO jcmsadmin;
GRANT SELECT ON TABLE formlyrislists TO jcmsuser;


--
-- Name: formlyrislists_formlyrislist_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq FROM jcms;
GRANT ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq TO jcms;
GRANT ALL ON SEQUENCE formlyrislists_formlyrislist_id_seq TO jcmsadmin;


--
-- Name: formmailchimplists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE formmailchimplists FROM PUBLIC;
REVOKE ALL ON TABLE formmailchimplists FROM jcms;
GRANT ALL ON TABLE formmailchimplists TO jcms;
GRANT ALL ON TABLE formmailchimplists TO jcmsadmin;
GRANT SELECT ON TABLE formmailchimplists TO jcmsuser;


--
-- Name: forms; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE forms FROM PUBLIC;
REVOKE ALL ON TABLE forms FROM jcms;
GRANT ALL ON TABLE forms TO jcms;
GRANT ALL ON TABLE forms TO jcmsadmin;
GRANT SELECT ON TABLE forms TO jcmsuser;


--
-- Name: forms_form_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE forms_form_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE forms_form_id_seq FROM jcms;
GRANT ALL ON SEQUENCE forms_form_id_seq TO jcms;
GRANT ALL ON SEQUENCE forms_form_id_seq TO jcmsadmin;


--
-- Name: imagerotator; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE imagerotator FROM PUBLIC;
REVOKE ALL ON TABLE imagerotator FROM jcms;
GRANT ALL ON TABLE imagerotator TO jcms;
GRANT ALL ON TABLE imagerotator TO jcmsadmin;
GRANT SELECT ON TABLE imagerotator TO jcmsuser;


--
-- Name: imagerotator_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE imagerotator_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE imagerotator_id_seq FROM jcms;
GRANT ALL ON SEQUENCE imagerotator_id_seq TO jcms;
GRANT ALL ON SEQUENCE imagerotator_id_seq TO PUBLIC;


--
-- Name: layoutpanes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE layoutpanes FROM PUBLIC;
REVOKE ALL ON TABLE layoutpanes FROM jcms;
GRANT ALL ON TABLE layoutpanes TO jcms;
GRANT SELECT ON TABLE layoutpanes TO jcmsuser;
GRANT ALL ON TABLE layoutpanes TO jcmsadmin;


--
-- Name: layoutpanes_layoutpane_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE layoutpanes_layoutpane_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE layoutpanes_layoutpane_id_seq FROM jcms;
GRANT ALL ON SEQUENCE layoutpanes_layoutpane_id_seq TO jcms;
GRANT ALL ON SEQUENCE layoutpanes_layoutpane_id_seq TO jcmsadmin;


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
-- Name: media_mid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE media_mid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_mid_seq FROM jcms;
GRANT ALL ON SEQUENCE media_mid_seq TO jcms;
GRANT ALL ON SEQUENCE media_mid_seq TO jcmsadmin;


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
-- Name: nodelinks_nlid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE nodelinks_nlid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE nodelinks_nlid_seq FROM jcms;
GRANT ALL ON SEQUENCE nodelinks_nlid_seq TO jcms;
GRANT ALL ON SEQUENCE nodelinks_nlid_seq TO jcmsadmin;


--
-- Name: nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE nodes FROM PUBLIC;
REVOKE ALL ON TABLE nodes FROM jcms;
GRANT ALL ON TABLE nodes TO jcms;
GRANT ALL ON TABLE nodes TO jcmsadmin;
GRANT SELECT ON TABLE nodes TO jcmsuser;


--
-- Name: nodes_nid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE nodes_nid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE nodes_nid_seq FROM jcms;
GRANT ALL ON SEQUENCE nodes_nid_seq TO jcms;
GRANT ALL ON SEQUENCE nodes_nid_seq TO jcmsadmin;


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
-- Name: pages_pid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE pages_pid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE pages_pid_seq FROM jcms;
GRANT ALL ON SEQUENCE pages_pid_seq TO jcms;
GRANT ALL ON SEQUENCE pages_pid_seq TO jcmsadmin;


--
-- Name: pagetags; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE pagetags FROM PUBLIC;
REVOKE ALL ON TABLE pagetags FROM jcms;
GRANT ALL ON TABLE pagetags TO jcms;
GRANT ALL ON TABLE pagetags TO jcmsadmin;
GRANT SELECT ON TABLE pagetags TO jcmsuser;


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
-- Name: payments; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE payments FROM PUBLIC;
REVOKE ALL ON TABLE payments FROM jcms;
GRANT ALL ON TABLE payments TO jcms;
GRANT SELECT ON TABLE payments TO jcmsuser;
GRANT ALL ON TABLE payments TO jcmsadmin;


--
-- Name: payments_payment_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE payments_payment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE payments_payment_id_seq FROM jcms;
GRANT ALL ON SEQUENCE payments_payment_id_seq TO jcms;
GRANT ALL ON SEQUENCE payments_payment_id_seq TO jcmsadmin;


--
-- Name: photos; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE photos FROM PUBLIC;
REVOKE ALL ON TABLE photos FROM jcms;
GRANT ALL ON TABLE photos TO jcms;
GRANT ALL ON TABLE photos TO jcmsadmin;
GRANT SELECT ON TABLE photos TO jcmsuser;


--
-- Name: photos_photo_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE photos_photo_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE photos_photo_id_seq FROM jcms;
GRANT ALL ON SEQUENCE photos_photo_id_seq TO jcms;
GRANT ALL ON SEQUENCE photos_photo_id_seq TO jcmsadmin;


--
-- Name: photosets; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE photosets FROM PUBLIC;
REVOKE ALL ON TABLE photosets FROM jcms;
GRANT ALL ON TABLE photosets TO jcms;
GRANT ALL ON TABLE photosets TO jcmsadmin;
GRANT SELECT ON TABLE photosets TO jcmsuser;


--
-- Name: photosets_photoset_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE photosets_photoset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE photosets_photoset_id_seq FROM jcms;
GRANT ALL ON SEQUENCE photosets_photoset_id_seq TO jcms;
GRANT ALL ON SEQUENCE photosets_photoset_id_seq TO jcmsadmin;


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
-- Name: pollsubmissions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE pollsubmissions FROM PUBLIC;
REVOKE ALL ON TABLE pollsubmissions FROM jcms;
GRANT ALL ON TABLE pollsubmissions TO jcms;
GRANT SELECT,INSERT ON TABLE pollsubmissions TO jcmsuser;
GRANT SELECT,DELETE ON TABLE pollsubmissions TO jcmsadmin;


--
-- Name: postedformfields; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE postedformfields FROM PUBLIC;
REVOKE ALL ON TABLE postedformfields FROM jcms;
GRANT ALL ON TABLE postedformfields TO jcms;
GRANT ALL ON TABLE postedformfields TO jcmsadmin;
GRANT SELECT,INSERT ON TABLE postedformfields TO jcmsuser;


--
-- Name: postedforms; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE postedforms FROM PUBLIC;
REVOKE ALL ON TABLE postedforms FROM jcms;
GRANT ALL ON TABLE postedforms TO jcms;
GRANT ALL ON TABLE postedforms TO jcmsadmin;
GRANT SELECT,INSERT ON TABLE postedforms TO jcmsuser;


--
-- Name: postedforms_postedform_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE postedforms_postedform_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE postedforms_postedform_id_seq FROM jcms;
GRANT ALL ON SEQUENCE postedforms_postedform_id_seq TO jcms;
GRANT ALL ON SEQUENCE postedforms_postedform_id_seq TO jcmsuser;


--
-- Name: settings; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE settings FROM PUBLIC;
REVOKE ALL ON TABLE settings FROM jcms;
GRANT ALL ON TABLE settings TO jcms;
GRANT ALL ON TABLE settings TO jcmsadmin;
GRANT SELECT ON TABLE settings TO jcmsuser;


--
-- Name: sidebarextensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE sidebarextensions FROM PUBLIC;
REVOKE ALL ON TABLE sidebarextensions FROM jcms;
GRANT ALL ON TABLE sidebarextensions TO jcms;
GRANT ALL ON TABLE sidebarextensions TO jcmsadmin;
GRANT SELECT ON TABLE sidebarextensions TO jcmsuser;


--
-- Name: sidebarextensions_sidebarextension_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE sidebarextensions_sidebarextension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sidebarextensions_sidebarextension_id_seq FROM jcms;
GRANT ALL ON SEQUENCE sidebarextensions_sidebarextension_id_seq TO jcms;
GRANT ALL ON SEQUENCE sidebarextensions_sidebarextension_id_seq TO jcmsadmin;


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
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE users TO jcmsadmin;


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
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE users_nodes TO jcmsadmin;


--
-- Name: users_uid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE users_uid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_uid_seq FROM jcms;
GRANT ALL ON SEQUENCE users_uid_seq TO jcms;
GRANT ALL ON SEQUENCE users_uid_seq TO jcmsadmin;


--
-- Name: utilitycontent; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE utilitycontent FROM PUBLIC;
REVOKE ALL ON TABLE utilitycontent FROM jcms;
GRANT ALL ON TABLE utilitycontent TO jcms;
GRANT ALL ON TABLE utilitycontent TO jcmsadmin;
GRANT SELECT ON TABLE utilitycontent TO jcmsuser;


--
-- Name: utilitycontent_utilitycontent_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE utilitycontent_utilitycontent_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE utilitycontent_utilitycontent_id_seq FROM jcms;
GRANT ALL ON SEQUENCE utilitycontent_utilitycontent_id_seq TO jcms;
GRANT ALL ON SEQUENCE utilitycontent_utilitycontent_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

