--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: sam
--

CREATE FUNCTION public.plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO sam;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accessroles; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.accessroles (
    accessrole_id integer NOT NULL,
    accessrole character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated timestamp(0) with time zone
);


ALTER TABLE public.accessroles OWNER TO jcms;

--
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.accessroles_accessrole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accessroles_accessrole_id_seq OWNER TO jcms;

--
-- Name: accessroles_accessrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.accessroles_accessrole_id_seq OWNED BY public.accessroles.accessrole_id;


--
-- Name: accessroles_accessusers; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.accessroles_accessusers (
    accessrole_id integer NOT NULL,
    accessuser_id integer NOT NULL
);


ALTER TABLE public.accessroles_accessusers OWNER TO jcms;

--
-- Name: accessroles_media; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.accessroles_media (
    mid integer NOT NULL,
    rolename character varying NOT NULL
);


ALTER TABLE public.accessroles_media OWNER TO jcms;

--
-- Name: accessroles_nodes; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.accessroles_nodes (
    nid integer NOT NULL,
    rolename character varying NOT NULL
);


ALTER TABLE public.accessroles_nodes OWNER TO jcms;

--
-- Name: accessusers; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.accessusers (
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

CREATE SEQUENCE public.accessusers_accessuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accessusers_accessuser_id_seq OWNER TO jcms;

--
-- Name: accessusers_accessuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.accessusers_accessuser_id_seq OWNED BY public.accessusers.accessuser_id;


--
-- Name: audit; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.audit (
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

CREATE SEQUENCE public.audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_audit_id_seq OWNER TO jcms;

--
-- Name: audit_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.audit_audit_id_seq OWNED BY public.audit.audit_id;


--
-- Name: commentblacklist; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.commentblacklist (
    word_id integer NOT NULL,
    word character varying NOT NULL
);


ALTER TABLE public.commentblacklist OWNER TO jcms;

--
-- Name: commentblacklist_word_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.commentblacklist_word_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commentblacklist_word_id_seq OWNER TO jcms;

--
-- Name: commentblacklist_word_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.commentblacklist_word_id_seq OWNED BY public.commentblacklist.word_id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.comments (
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

CREATE SEQUENCE public.comments_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_comment_id_seq OWNER TO jcms;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;


--
-- Name: content; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.content (
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

CREATE SEQUENCE public.content_cid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_cid_seq OWNER TO jcms;

--
-- Name: content_cid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.content_cid_seq OWNED BY public.content.cid;


--
-- Name: cproles; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.cproles (
    username character varying NOT NULL,
    editor boolean DEFAULT false NOT NULL,
    designer boolean DEFAULT false NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.cproles OWNER TO jcms;

--
-- Name: dhtmlcache; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.dhtmlcache (
    accessuser character varying,
    dhtml character varying,
    updated timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.dhtmlcache OWNER TO jcms;

--
-- Name: events; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.events (
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

CREATE SEQUENCE public.events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO jcms;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events.event_id;


--
-- Name: extensions; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.extensions (
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

CREATE SEQUENCE public.extensions_extid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extensions_extid_seq OWNER TO jcms;

--
-- Name: extensions_extid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.extensions_extid_seq OWNED BY public.extensions.extid;


--
-- Name: extras; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.extras (
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

CREATE SEQUENCE public.extras_extra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extras_extra_id_seq OWNER TO jcms;

--
-- Name: extras_extra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.extras_extra_id_seq OWNED BY public.extras.extra_id;


--
-- Name: formconstantcontactlists; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.formconstantcontactlists (
    form_id integer NOT NULL,
    link character varying NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.formconstantcontactlists OWNER TO jcms;

--
-- Name: formfieldoptions; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.formfieldoptions (
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

CREATE SEQUENCE public.formfieldoptions_formfieldoption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formfieldoptions_formfieldoption_id_seq OWNER TO jcms;

--
-- Name: formfieldoptions_formfieldoption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.formfieldoptions_formfieldoption_id_seq OWNED BY public.formfieldoptions.formfieldoption_id;


--
-- Name: formfields; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.formfields (
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

CREATE SEQUENCE public.formfields_formfield_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formfields_formfield_id_seq OWNER TO jcms;

--
-- Name: formfields_formfield_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.formfields_formfield_id_seq OWNED BY public.formfields.formfield_id;


--
-- Name: formicontactlists; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.formicontactlists (
    form_id integer NOT NULL,
    listid integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE public.formicontactlists OWNER TO jcms;

--
-- Name: formlyrislists; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.formlyrislists (
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

CREATE SEQUENCE public.formlyrislists_formlyrislist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formlyrislists_formlyrislist_id_seq OWNER TO jcms;

--
-- Name: formlyrislists_formlyrislist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.formlyrislists_formlyrislist_id_seq OWNED BY public.formlyrislists.formlyrislist_id;


--
-- Name: formmailchimplists; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.formmailchimplists (
    form_id integer NOT NULL,
    listid character varying NOT NULL,
    listname character varying NOT NULL
);


ALTER TABLE public.formmailchimplists OWNER TO jcms;

--
-- Name: forms; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.forms (
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

CREATE SEQUENCE public.forms_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forms_form_id_seq OWNER TO jcms;

--
-- Name: forms_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.forms_form_id_seq OWNED BY public.forms.form_id;


--
-- Name: imagerotator; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.imagerotator (
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

CREATE SEQUENCE public.imagerotator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagerotator_id_seq OWNER TO jcms;

--
-- Name: imagerotator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.imagerotator_id_seq OWNED BY public.imagerotator.id;


--
-- Name: layoutpanes; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.layoutpanes (
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

CREATE SEQUENCE public.layoutpanes_layoutpane_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layoutpanes_layoutpane_id_seq OWNER TO jcms;

--
-- Name: layoutpanes_layoutpane_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.layoutpanes_layoutpane_id_seq OWNED BY public.layoutpanes.layoutpane_id;


--
-- Name: layouts_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.layouts_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layouts_layout_id_seq OWNER TO jcms;

--
-- Name: layouts; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.layouts (
    layout_id integer DEFAULT nextval('public.layouts_layout_id_seq'::regclass) NOT NULL,
    layout character varying NOT NULL,
    num integer NOT NULL
);


ALTER TABLE public.layouts OWNER TO jcms;

--
-- Name: media; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.media (
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

CREATE SEQUENCE public.media_mid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_mid_seq OWNER TO jcms;

--
-- Name: media_mid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.media_mid_seq OWNED BY public.media.mid;


SET default_with_oids = true;

--
-- Name: nodelinks; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.nodelinks (
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

CREATE VIEW public.nodes_current AS
 SELECT nodelinks.nid,
    max(nodelinks.starttime) AS starttime
   FROM public.nodelinks
  WHERE (nodelinks.starttime < now())
  GROUP BY nodelinks.nid;


ALTER TABLE public.nodes_current OWNER TO jcms;

--
-- Name: nodelinks_current; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW public.nodelinks_current AS
 SELECT nodelinks.nlid,
    nodelinks.nid,
    nodelinks.pid,
    nodelinks.mid,
    nodelinks.url,
    nodelinks.starttime,
    nodelinks.refid,
    nodelinks.redirectnid
   FROM public.nodelinks,
    public.nodes_current
  WHERE ((nodelinks.nid = nodes_current.nid) AND (nodelinks.starttime = nodes_current.starttime));


ALTER TABLE public.nodelinks_current OWNER TO jcms;

--
-- Name: nodelinks_future; Type: VIEW; Schema: public; Owner: jcms
--

CREATE VIEW public.nodelinks_future AS
 SELECT nodelinks.nlid,
    nodelinks.nid,
    nodelinks.pid,
    nodelinks.mid,
    nodelinks.url,
    nodelinks.starttime,
    nodelinks.refid,
    nodelinks.redirectnid
   FROM public.nodelinks
  WHERE ((nodelinks.pid IS NOT NULL) AND (nodelinks.starttime > now()));


ALTER TABLE public.nodelinks_future OWNER TO jcms;

--
-- Name: nodelinks_nlid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.nodelinks_nlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nodelinks_nlid_seq OWNER TO jcms;

--
-- Name: nodelinks_nlid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.nodelinks_nlid_seq OWNED BY public.nodelinks.nlid;


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.nodes (
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

CREATE SEQUENCE public.nodes_nid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nodes_nid_seq OWNER TO jcms;

--
-- Name: nodes_nid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.nodes_nid_seq OWNED BY public.nodes.nid;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.pages (
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
-- Name: pages_content; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.pages_content (
    pid integer NOT NULL,
    cid integer NOT NULL,
    pane integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.pages_content OWNER TO jcms;

--
-- Name: pages_pid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.pages_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_pid_seq OWNER TO jcms;

--
-- Name: pages_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.pages_pid_seq OWNED BY public.pages.pid;


--
-- Name: pagetags; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.pagetags (
    pid integer,
    tag character varying NOT NULL
);


ALTER TABLE public.pagetags OWNER TO jcms;

--
-- Name: paymentoptions; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.paymentoptions (
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

CREATE SEQUENCE public.paymentoptions_paymentoption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paymentoptions_paymentoption_id_seq OWNER TO jcms;

--
-- Name: paymentoptions_paymentoption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.paymentoptions_paymentoption_id_seq OWNED BY public.paymentoptions.paymentoption_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.payments (
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

CREATE SEQUENCE public.payments_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_payment_id_seq OWNER TO jcms;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.photos (
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

CREATE SEQUENCE public.photos_photo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_photo_id_seq OWNER TO jcms;

--
-- Name: photos_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.photos_photo_id_seq OWNED BY public.photos.photo_id;


--
-- Name: photosets; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.photosets (
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

CREATE SEQUENCE public.photosets_photoset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photosets_photoset_id_seq OWNER TO jcms;

--
-- Name: photosets_photoset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.photosets_photoset_id_seq OWNED BY public.photosets.photoset_id;


--
-- Name: pollchoices; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.pollchoices (
    pollchoice_id integer NOT NULL,
    poll_id integer NOT NULL,
    num integer NOT NULL,
    choice character varying NOT NULL
);


ALTER TABLE public.pollchoices OWNER TO jcms;

--
-- Name: pollchoices_pollchoice_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.pollchoices_pollchoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pollchoices_pollchoice_id_seq OWNER TO jcms;

--
-- Name: pollchoices_pollchoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.pollchoices_pollchoice_id_seq OWNED BY public.pollchoices.pollchoice_id;


--
-- Name: polls; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.polls (
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

CREATE SEQUENCE public.polls_poll_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.polls_poll_id_seq OWNER TO jcms;

--
-- Name: polls_poll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.polls_poll_id_seq OWNED BY public.polls.poll_id;


--
-- Name: pollsubmissions; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.pollsubmissions (
    pollchoice_id integer NOT NULL,
    timeposted timestamp(0) without time zone DEFAULT now() NOT NULL,
    ip character varying
);


ALTER TABLE public.pollsubmissions OWNER TO jcms;

--
-- Name: postedformfields; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.postedformfields (
    postedform_id integer NOT NULL,
    fieldname character varying NOT NULL,
    num integer NOT NULL,
    value character varying
);


ALTER TABLE public.postedformfields OWNER TO jcms;

--
-- Name: postedforms; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.postedforms (
    postedform_id integer NOT NULL,
    form_id integer NOT NULL,
    timeposted timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.postedforms OWNER TO jcms;

--
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.postedforms_postedform_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.postedforms_postedform_id_seq OWNER TO jcms;

--
-- Name: postedforms_postedform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.postedforms_postedform_id_seq OWNED BY public.postedforms.postedform_id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.settings (
    setting_id integer NOT NULL,
    setting_name character varying NOT NULL,
    setting_value character varying NOT NULL,
    description character varying NOT NULL,
    password boolean DEFAULT false NOT NULL,
    toggle boolean DEFAULT false NOT NULL
);


ALTER TABLE public.settings OWNER TO jcms;

--
-- Name: sidebarextensions; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.sidebarextensions (
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

CREATE SEQUENCE public.sidebarextensions_sidebarextension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sidebarextensions_sidebarextension_id_seq OWNER TO jcms;

--
-- Name: sidebarextensions_sidebarextension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.sidebarextensions_sidebarextension_id_seq OWNED BY public.sidebarextensions.sidebarextension_id;


--
-- Name: stylesheet; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.stylesheet (
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

CREATE SEQUENCE public.stylesheet_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stylesheet_class_id_seq OWNER TO jcms;

--
-- Name: stylesheet_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.stylesheet_class_id_seq OWNED BY public.stylesheet.class_id;


--
-- Name: stylesheetcategories; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.stylesheetcategories (
    stylesheetcategory_id integer NOT NULL,
    stylesheetcategory character varying NOT NULL,
    num integer
);


ALTER TABLE public.stylesheetcategories OWNER TO jcms;

--
-- Name: updatelog; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.updatelog (
    updated timestamp(0) without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE public.updatelog OWNER TO jcms;

--
-- Name: users; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.users (
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
-- Name: users_extensions; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.users_extensions (
    extid integer NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.users_extensions OWNER TO jcms;

--
-- Name: users_extras; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.users_extras (
    extra_id integer NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.users_extras OWNER TO jcms;

--
-- Name: users_nodes; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.users_nodes (
    nid integer NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.users_nodes OWNER TO jcms;

--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: jcms
--

CREATE SEQUENCE public.users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO jcms;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;


--
-- Name: utilitycontent; Type: TABLE; Schema: public; Owner: jcms
--

CREATE TABLE public.utilitycontent (
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

CREATE SEQUENCE public.utilitycontent_utilitycontent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.utilitycontent_utilitycontent_id_seq OWNER TO jcms;

--
-- Name: utilitycontent_utilitycontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jcms
--

ALTER SEQUENCE public.utilitycontent_utilitycontent_id_seq OWNED BY public.utilitycontent.utilitycontent_id;


--
-- Name: accessrole_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles ALTER COLUMN accessrole_id SET DEFAULT nextval('public.accessroles_accessrole_id_seq'::regclass);


--
-- Name: accessuser_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessusers ALTER COLUMN accessuser_id SET DEFAULT nextval('public.accessusers_accessuser_id_seq'::regclass);


--
-- Name: audit_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.audit ALTER COLUMN audit_id SET DEFAULT nextval('public.audit_audit_id_seq'::regclass);


--
-- Name: word_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.commentblacklist ALTER COLUMN word_id SET DEFAULT nextval('public.commentblacklist_word_id_seq'::regclass);


--
-- Name: comment_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);


--
-- Name: cid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.content ALTER COLUMN cid SET DEFAULT nextval('public.content_cid_seq'::regclass);


--
-- Name: event_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.events ALTER COLUMN event_id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: extid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.extensions ALTER COLUMN extid SET DEFAULT nextval('public.extensions_extid_seq'::regclass);


--
-- Name: extra_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.extras ALTER COLUMN extra_id SET DEFAULT nextval('public.extras_extra_id_seq'::regclass);


--
-- Name: formfieldoption_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formfieldoptions ALTER COLUMN formfieldoption_id SET DEFAULT nextval('public.formfieldoptions_formfieldoption_id_seq'::regclass);


--
-- Name: formfield_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formfields ALTER COLUMN formfield_id SET DEFAULT nextval('public.formfields_formfield_id_seq'::regclass);


--
-- Name: formlyrislist_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formlyrislists ALTER COLUMN formlyrislist_id SET DEFAULT nextval('public.formlyrislists_formlyrislist_id_seq'::regclass);


--
-- Name: form_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.forms ALTER COLUMN form_id SET DEFAULT nextval('public.forms_form_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.imagerotator ALTER COLUMN id SET DEFAULT nextval('public.imagerotator_id_seq'::regclass);


--
-- Name: layoutpane_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.layoutpanes ALTER COLUMN layoutpane_id SET DEFAULT nextval('public.layoutpanes_layoutpane_id_seq'::regclass);


--
-- Name: mid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.media ALTER COLUMN mid SET DEFAULT nextval('public.media_mid_seq'::regclass);


--
-- Name: nlid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodelinks ALTER COLUMN nlid SET DEFAULT nextval('public.nodelinks_nlid_seq'::regclass);


--
-- Name: nid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodes ALTER COLUMN nid SET DEFAULT nextval('public.nodes_nid_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pages ALTER COLUMN pid SET DEFAULT nextval('public.pages_pid_seq'::regclass);


--
-- Name: paymentoption_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.paymentoptions ALTER COLUMN paymentoption_id SET DEFAULT nextval('public.paymentoptions_paymentoption_id_seq'::regclass);


--
-- Name: payment_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: photo_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photos ALTER COLUMN photo_id SET DEFAULT nextval('public.photos_photo_id_seq'::regclass);


--
-- Name: photoset_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photosets ALTER COLUMN photoset_id SET DEFAULT nextval('public.photosets_photoset_id_seq'::regclass);


--
-- Name: pollchoice_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pollchoices ALTER COLUMN pollchoice_id SET DEFAULT nextval('public.pollchoices_pollchoice_id_seq'::regclass);


--
-- Name: poll_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.polls ALTER COLUMN poll_id SET DEFAULT nextval('public.polls_poll_id_seq'::regclass);


--
-- Name: postedform_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.postedforms ALTER COLUMN postedform_id SET DEFAULT nextval('public.postedforms_postedform_id_seq'::regclass);


--
-- Name: sidebarextension_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.sidebarextensions ALTER COLUMN sidebarextension_id SET DEFAULT nextval('public.sidebarextensions_sidebarextension_id_seq'::regclass);


--
-- Name: class_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.stylesheet ALTER COLUMN class_id SET DEFAULT nextval('public.stylesheet_class_id_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.users ALTER COLUMN uid SET DEFAULT nextval('public.users_uid_seq'::regclass);


--
-- Name: utilitycontent_id; Type: DEFAULT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.utilitycontent ALTER COLUMN utilitycontent_id SET DEFAULT nextval('public.utilitycontent_utilitycontent_id_seq'::regclass);


--
-- Name: accessroles_accessrole_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles
    ADD CONSTRAINT accessroles_accessrole_key UNIQUE (accessrole);


--
-- Name: accessroles_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles
    ADD CONSTRAINT accessroles_pkey PRIMARY KEY (accessrole_id);


--
-- Name: accessusers_email_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessusers
    ADD CONSTRAINT accessusers_email_key UNIQUE (email);


--
-- Name: accessusers_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessusers
    ADD CONSTRAINT accessusers_pkey PRIMARY KEY (accessuser_id);


--
-- Name: audit_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (audit_id);


--
-- Name: commentblacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.commentblacklist
    ADD CONSTRAINT commentblacklist_pkey PRIMARY KEY (word_id);


--
-- Name: commentblacklist_word_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.commentblacklist
    ADD CONSTRAINT commentblacklist_word_key UNIQUE (word);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- Name: content_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (cid);


--
-- Name: cproles_username_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.cproles
    ADD CONSTRAINT cproles_username_key UNIQUE (username);


--
-- Name: dhtmlcache_accessuser_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.dhtmlcache
    ADD CONSTRAINT dhtmlcache_accessuser_key UNIQUE (accessuser);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (extid);


--
-- Name: extras_name_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.extras
    ADD CONSTRAINT extras_name_key UNIQUE (name);


--
-- Name: extras_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.extras
    ADD CONSTRAINT extras_pkey PRIMARY KEY (extra_id);


--
-- Name: formconstantcontactlists_link_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formconstantcontactlists
    ADD CONSTRAINT formconstantcontactlists_link_key UNIQUE (link);


--
-- Name: formfieldoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formfieldoptions
    ADD CONSTRAINT formfieldoptions_pkey PRIMARY KEY (formfieldoption_id);


--
-- Name: formfields_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formfields
    ADD CONSTRAINT formfields_pkey PRIMARY KEY (formfield_id);


--
-- Name: formlyrislists_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formlyrislists
    ADD CONSTRAINT formlyrislists_pkey PRIMARY KEY (formlyrislist_id);


--
-- Name: forms_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (form_id);


--
-- Name: imagerotator_filename_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.imagerotator
    ADD CONSTRAINT imagerotator_filename_key UNIQUE (filename);


--
-- Name: imagerotator_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.imagerotator
    ADD CONSTRAINT imagerotator_pkey PRIMARY KEY (id);


--
-- Name: layoutpanes_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.layoutpanes
    ADD CONSTRAINT layoutpanes_pkey PRIMARY KEY (layoutpane_id);


--
-- Name: layoutpanes_unique; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.layoutpanes
    ADD CONSTRAINT layoutpanes_unique UNIQUE (layout_id, pane, mobile);


--
-- Name: layouts_num_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.layouts
    ADD CONSTRAINT layouts_num_key UNIQUE (num);


--
-- Name: layouts_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.layouts
    ADD CONSTRAINT layouts_pkey PRIMARY KEY (layout_id);


--
-- Name: media_filename_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_filename_key UNIQUE (filename);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (mid);


--
-- Name: nodelinks_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodelinks
    ADD CONSTRAINT nodelinks_pkey PRIMARY KEY (nlid);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (nid);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (pid);


--
-- Name: paymentoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.paymentoptions
    ADD CONSTRAINT paymentoptions_pkey PRIMARY KEY (paymentoption_id);


--
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: photos_imagefile_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_imagefile_key UNIQUE (photoset_id, imagefile);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (photo_id);


--
-- Name: photosets_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photosets
    ADD CONSTRAINT photosets_pkey PRIMARY KEY (photoset_id);


--
-- Name: photosets_title_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photosets
    ADD CONSTRAINT photosets_title_key UNIQUE (title);


--
-- Name: pollchoices_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pollchoices
    ADD CONSTRAINT pollchoices_pkey PRIMARY KEY (pollchoice_id);


--
-- Name: polls_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (poll_id);


--
-- Name: postedforms_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.postedforms
    ADD CONSTRAINT postedforms_pkey PRIMARY KEY (postedform_id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (setting_id);


--
-- Name: sidebarextensions_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.sidebarextensions
    ADD CONSTRAINT sidebarextensions_pkey PRIMARY KEY (sidebarextension_id);


--
-- Name: stylesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.stylesheet
    ADD CONSTRAINT stylesheet_pkey PRIMARY KEY (class_id);


--
-- Name: stylesheetcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.stylesheetcategories
    ADD CONSTRAINT stylesheetcategories_pkey PRIMARY KEY (stylesheetcategory_id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: utilitycontent_pkey; Type: CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.utilitycontent
    ADD CONSTRAINT utilitycontent_pkey PRIMARY KEY (utilitycontent_id);


--
-- Name: accessroles_media_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX accessroles_media_idx ON public.accessroles_media USING btree (rolename);


--
-- Name: accessroles_nodes_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX accessroles_nodes_idx ON public.accessroles_nodes USING btree (rolename);


--
-- Name: audit_tablename_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX audit_tablename_idx ON public.audit USING btree (tablename);


--
-- Name: audit_username_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX audit_username_idx ON public.audit USING btree (username);


--
-- Name: content_label_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX content_label_unique ON public.content USING btree (label);


--
-- Name: formfieldoptions_unique_num; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX formfieldoptions_unique_num ON public.formfieldoptions USING btree (formfield_id, num);


--
-- Name: formfieldoptions_unique_value; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX formfieldoptions_unique_value ON public.formfieldoptions USING btree (formfield_id, value);


--
-- Name: formfields_unique_name; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX formfields_unique_name ON public.formfields USING btree (form_id, fieldname);


--
-- Name: formfields_unique_num; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX formfields_unique_num ON public.formfields USING btree (form_id, num);


--
-- Name: formlyrislists_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX formlyrislists_unique ON public.formlyrislists USING btree (form_id, listname);


--
-- Name: forms_unique_title; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX forms_unique_title ON public.forms USING btree (title);


--
-- Name: nodelinks_nid; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX nodelinks_nid ON public.nodelinks USING btree (nid);


--
-- Name: nodelinks_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX nodelinks_unique ON public.nodelinks USING btree (nid, starttime);


--
-- Name: nodes_alias_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX nodes_alias_unique ON public.nodes USING btree (alias);


--
-- Name: nodes_unique_refid; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX nodes_unique_refid ON public.nodes USING btree (refid);


--
-- Name: pages_content_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX pages_content_unique ON public.pages_content USING btree (pid, cid, pane);


--
-- Name: pages_label_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX pages_label_unique ON public.pages USING btree (label);


--
-- Name: pages_unique_refid; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX pages_unique_refid ON public.pages USING btree (refid);


--
-- Name: pagetags_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX pagetags_unique ON public.pagetags USING btree (pid, tag);


--
-- Name: pollchoices_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX pollchoices_unique ON public.pollchoices USING btree (poll_id, num);


--
-- Name: settings_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX settings_unique ON public.settings USING btree (setting_name);


--
-- Name: stylesheet_class_name_key; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX stylesheet_class_name_key ON public.stylesheet USING btree (class_name, level, level_num);


--
-- Name: updatelog_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX updatelog_unique ON public.updatelog USING btree (name, value);


--
-- Name: users_extensions_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX users_extensions_idx ON public.users_extensions USING btree (username);


--
-- Name: users_extensions_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX users_extensions_unique ON public.users_extensions USING btree (username, extid);


--
-- Name: users_extras_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX users_extras_idx ON public.users_extras USING btree (username);


--
-- Name: users_extras_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX users_extras_unique ON public.users_extras USING btree (username, extra_id);


--
-- Name: users_nodes_idx; Type: INDEX; Schema: public; Owner: jcms
--

CREATE INDEX users_nodes_idx ON public.users_nodes USING btree (username);


--
-- Name: users_nodes_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX users_nodes_unique ON public.users_nodes USING btree (username, nid);


--
-- Name: utilitycontent_unique; Type: INDEX; Schema: public; Owner: jcms
--

CREATE UNIQUE INDEX utilitycontent_unique ON public.utilitycontent USING btree (location, num);


--
-- Name: accessroles_accessusers_accessrole_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles_accessusers
    ADD CONSTRAINT accessroles_accessusers_accessrole_id_fkey FOREIGN KEY (accessrole_id) REFERENCES public.accessroles(accessrole_id);


--
-- Name: accessroles_accessusers_accessuser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles_accessusers
    ADD CONSTRAINT accessroles_accessusers_accessuser_id_fkey FOREIGN KEY (accessuser_id) REFERENCES public.accessusers(accessuser_id);


--
-- Name: accessroles_media_mid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles_media
    ADD CONSTRAINT accessroles_media_mid_fkey FOREIGN KEY (mid) REFERENCES public.media(mid);


--
-- Name: accessroles_nodes_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.accessroles_nodes
    ADD CONSTRAINT accessroles_nodes_nid_fkey FOREIGN KEY (nid) REFERENCES public.nodes(nid);


--
-- Name: comments_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_cid_fkey FOREIGN KEY (cid) REFERENCES public.content(cid);


--
-- Name: extras_parent_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.extras
    ADD CONSTRAINT extras_parent_extra_id_fkey FOREIGN KEY (parent_extra_id) REFERENCES public.extras(extra_id);


--
-- Name: formconstantcontactlists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formconstantcontactlists
    ADD CONSTRAINT formconstantcontactlists_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- Name: formfieldoptions_formfield_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formfieldoptions
    ADD CONSTRAINT formfieldoptions_formfield_id_fkey FOREIGN KEY (formfield_id) REFERENCES public.formfields(formfield_id);


--
-- Name: formfields_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formfields
    ADD CONSTRAINT formfields_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- Name: formicontactlists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formicontactlists
    ADD CONSTRAINT formicontactlists_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- Name: formlyrislists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formlyrislists
    ADD CONSTRAINT formlyrislists_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- Name: formmailchimplists_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.formmailchimplists
    ADD CONSTRAINT formmailchimplists_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- Name: layoutpanes_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.layoutpanes
    ADD CONSTRAINT layoutpanes_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES public.layouts(layout_id);


--
-- Name: nodelinks_mid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodelinks
    ADD CONSTRAINT nodelinks_mid_fkey FOREIGN KEY (mid) REFERENCES public.media(mid);


--
-- Name: nodelinks_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodelinks
    ADD CONSTRAINT nodelinks_nid_fkey FOREIGN KEY (nid) REFERENCES public.nodes(nid);


--
-- Name: nodelinks_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodelinks
    ADD CONSTRAINT nodelinks_pid_fkey FOREIGN KEY (pid) REFERENCES public.pages(pid);


--
-- Name: nodelinks_redirectnid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.nodelinks
    ADD CONSTRAINT nodelinks_redirectnid_fkey FOREIGN KEY (redirectnid) REFERENCES public.nodes(nid);


--
-- Name: pages_content_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pages_content
    ADD CONSTRAINT pages_content_cid_fkey FOREIGN KEY (cid) REFERENCES public.content(cid);


--
-- Name: pages_content_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pages_content
    ADD CONSTRAINT pages_content_pid_fkey FOREIGN KEY (pid) REFERENCES public.pages(pid);


--
-- Name: pages_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES public.layouts(layout_id);


--
-- Name: pagetags_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pagetags
    ADD CONSTRAINT pagetags_pid_fkey FOREIGN KEY (pid) REFERENCES public.pages(pid);


--
-- Name: paymentoptions_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.paymentoptions
    ADD CONSTRAINT paymentoptions_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(payment_id);


--
-- Name: photos_photoset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_photoset_id_fkey FOREIGN KEY (photoset_id) REFERENCES public.photosets(photoset_id);


--
-- Name: pollchoices_poll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pollchoices
    ADD CONSTRAINT pollchoices_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES public.polls(poll_id);


--
-- Name: pollsubmissions_pollchoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.pollsubmissions
    ADD CONSTRAINT pollsubmissions_pollchoice_id_fkey FOREIGN KEY (pollchoice_id) REFERENCES public.pollchoices(pollchoice_id);


--
-- Name: postedformfields_postedform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.postedformfields
    ADD CONSTRAINT postedformfields_postedform_id_fkey FOREIGN KEY (postedform_id) REFERENCES public.postedforms(postedform_id);


--
-- Name: postedforms_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.postedforms
    ADD CONSTRAINT postedforms_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- Name: stylesheet_stylesheetcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.stylesheet
    ADD CONSTRAINT stylesheet_stylesheetcategory_id_fkey FOREIGN KEY (stylesheetcategory_id) REFERENCES public.stylesheetcategories(stylesheetcategory_id);


--
-- Name: users_extensions_extid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.users_extensions
    ADD CONSTRAINT users_extensions_extid_fkey FOREIGN KEY (extid) REFERENCES public.extensions(extid);


--
-- Name: users_extras_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.users_extras
    ADD CONSTRAINT users_extras_extra_id_fkey FOREIGN KEY (extra_id) REFERENCES public.extras(extra_id);


--
-- Name: users_nodes_nid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jcms
--

ALTER TABLE ONLY public.users_nodes
    ADD CONSTRAINT users_nodes_nid_fkey FOREIGN KEY (nid) REFERENCES public.nodes(nid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE accessroles; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.accessroles FROM PUBLIC;
REVOKE ALL ON TABLE public.accessroles FROM jcms;
GRANT ALL ON TABLE public.accessroles TO jcms;
GRANT ALL ON TABLE public.accessroles TO jcmsadmin;
GRANT SELECT ON TABLE public.accessroles TO jcmsuser;


--
-- Name: SEQUENCE accessroles_accessrole_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.accessroles_accessrole_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.accessroles_accessrole_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.accessroles_accessrole_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.accessroles_accessrole_id_seq TO jcmsadmin;


--
-- Name: TABLE accessroles_accessusers; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.accessroles_accessusers FROM PUBLIC;
REVOKE ALL ON TABLE public.accessroles_accessusers FROM jcms;
GRANT ALL ON TABLE public.accessroles_accessusers TO jcms;
GRANT ALL ON TABLE public.accessroles_accessusers TO jcmsadmin;
GRANT SELECT ON TABLE public.accessroles_accessusers TO jcmsuser;


--
-- Name: TABLE accessroles_media; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.accessroles_media FROM PUBLIC;
REVOKE ALL ON TABLE public.accessroles_media FROM jcms;
GRANT ALL ON TABLE public.accessroles_media TO jcms;
GRANT SELECT ON TABLE public.accessroles_media TO jcmsuser;
GRANT ALL ON TABLE public.accessroles_media TO jcmsadmin;


--
-- Name: TABLE accessroles_nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.accessroles_nodes FROM PUBLIC;
REVOKE ALL ON TABLE public.accessroles_nodes FROM jcms;
GRANT ALL ON TABLE public.accessroles_nodes TO jcms;
GRANT ALL ON TABLE public.accessroles_nodes TO jcmsadmin;
GRANT SELECT ON TABLE public.accessroles_nodes TO jcmsuser;


--
-- Name: TABLE accessusers; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.accessusers FROM PUBLIC;
REVOKE ALL ON TABLE public.accessusers FROM jcms;
GRANT ALL ON TABLE public.accessusers TO jcms;
GRANT ALL ON TABLE public.accessusers TO jcmsadmin;
GRANT SELECT,UPDATE ON TABLE public.accessusers TO jcmsuser;


--
-- Name: SEQUENCE accessusers_accessuser_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.accessusers_accessuser_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.accessusers_accessuser_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.accessusers_accessuser_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.accessusers_accessuser_id_seq TO jcmsadmin;


--
-- Name: TABLE audit; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.audit FROM PUBLIC;
REVOKE ALL ON TABLE public.audit FROM jcms;
GRANT ALL ON TABLE public.audit TO jcms;
GRANT SELECT,INSERT ON TABLE public.audit TO jcmsadmin;


--
-- Name: SEQUENCE audit_audit_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.audit_audit_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.audit_audit_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.audit_audit_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.audit_audit_id_seq TO jcmsadmin;


--
-- Name: TABLE commentblacklist; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.commentblacklist FROM PUBLIC;
REVOKE ALL ON TABLE public.commentblacklist FROM jcms;
GRANT ALL ON TABLE public.commentblacklist TO jcms;
GRANT ALL ON TABLE public.commentblacklist TO jcmsadmin;
GRANT SELECT ON TABLE public.commentblacklist TO jcmsuser;


--
-- Name: SEQUENCE commentblacklist_word_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.commentblacklist_word_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.commentblacklist_word_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.commentblacklist_word_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.commentblacklist_word_id_seq TO jcmsadmin;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.comments FROM PUBLIC;
REVOKE ALL ON TABLE public.comments FROM jcms;
GRANT ALL ON TABLE public.comments TO jcms;
GRANT SELECT,INSERT ON TABLE public.comments TO jcmsuser;
GRANT ALL ON TABLE public.comments TO jcmsadmin;


--
-- Name: SEQUENCE comments_comment_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.comments_comment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.comments_comment_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.comments_comment_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.comments_comment_id_seq TO jcmsadmin;
GRANT ALL ON SEQUENCE public.comments_comment_id_seq TO jcmsuser;


--
-- Name: TABLE content; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.content FROM PUBLIC;
REVOKE ALL ON TABLE public.content FROM jcms;
GRANT ALL ON TABLE public.content TO jcms;
GRANT SELECT ON TABLE public.content TO jcmsuser;
GRANT ALL ON TABLE public.content TO jcmsadmin;


--
-- Name: SEQUENCE content_cid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.content_cid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.content_cid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.content_cid_seq TO jcms;
GRANT ALL ON SEQUENCE public.content_cid_seq TO jcmsadmin;


--
-- Name: TABLE cproles; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.cproles FROM PUBLIC;
REVOKE ALL ON TABLE public.cproles FROM jcms;
GRANT ALL ON TABLE public.cproles TO jcms;
GRANT ALL ON TABLE public.cproles TO jcmsadmin;


--
-- Name: TABLE dhtmlcache; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.dhtmlcache FROM PUBLIC;
REVOKE ALL ON TABLE public.dhtmlcache FROM jcms;
GRANT ALL ON TABLE public.dhtmlcache TO jcms;
GRANT DELETE ON TABLE public.dhtmlcache TO jcmsadmin;
GRANT SELECT,INSERT ON TABLE public.dhtmlcache TO jcmsuser;


--
-- Name: TABLE events; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.events FROM PUBLIC;
REVOKE ALL ON TABLE public.events FROM jcms;
GRANT ALL ON TABLE public.events TO jcms;
GRANT ALL ON TABLE public.events TO jcmsadmin;
GRANT SELECT ON TABLE public.events TO jcmsuser;


--
-- Name: SEQUENCE events_event_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.events_event_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.events_event_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.events_event_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.events_event_id_seq TO jcmsadmin;


--
-- Name: TABLE extensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.extensions FROM PUBLIC;
REVOKE ALL ON TABLE public.extensions FROM jcms;
GRANT ALL ON TABLE public.extensions TO jcms;
GRANT ALL ON TABLE public.extensions TO jcmsadmin;


--
-- Name: SEQUENCE extensions_extid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.extensions_extid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.extensions_extid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.extensions_extid_seq TO jcms;
GRANT ALL ON SEQUENCE public.extensions_extid_seq TO jcmsadmin;


--
-- Name: TABLE extras; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.extras FROM PUBLIC;
REVOKE ALL ON TABLE public.extras FROM jcms;
GRANT ALL ON TABLE public.extras TO jcms;
GRANT SELECT ON TABLE public.extras TO jcmsadmin;


--
-- Name: TABLE formconstantcontactlists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.formconstantcontactlists FROM PUBLIC;
REVOKE ALL ON TABLE public.formconstantcontactlists FROM jcms;
GRANT ALL ON TABLE public.formconstantcontactlists TO jcms;
GRANT SELECT ON TABLE public.formconstantcontactlists TO jcmsuser;
GRANT ALL ON TABLE public.formconstantcontactlists TO jcmsadmin;


--
-- Name: TABLE formfieldoptions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.formfieldoptions FROM PUBLIC;
REVOKE ALL ON TABLE public.formfieldoptions FROM jcms;
GRANT ALL ON TABLE public.formfieldoptions TO jcms;
GRANT ALL ON TABLE public.formfieldoptions TO jcmsadmin;
GRANT SELECT ON TABLE public.formfieldoptions TO jcmsuser;


--
-- Name: SEQUENCE formfieldoptions_formfieldoption_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.formfieldoptions_formfieldoption_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.formfieldoptions_formfieldoption_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.formfieldoptions_formfieldoption_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.formfieldoptions_formfieldoption_id_seq TO jcmsadmin;


--
-- Name: TABLE formfields; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.formfields FROM PUBLIC;
REVOKE ALL ON TABLE public.formfields FROM jcms;
GRANT ALL ON TABLE public.formfields TO jcms;
GRANT ALL ON TABLE public.formfields TO jcmsadmin;
GRANT SELECT ON TABLE public.formfields TO jcmsuser;


--
-- Name: SEQUENCE formfields_formfield_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.formfields_formfield_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.formfields_formfield_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.formfields_formfield_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.formfields_formfield_id_seq TO jcmsadmin;


--
-- Name: TABLE formicontactlists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.formicontactlists FROM PUBLIC;
REVOKE ALL ON TABLE public.formicontactlists FROM jcms;
GRANT ALL ON TABLE public.formicontactlists TO jcms;
GRANT SELECT ON TABLE public.formicontactlists TO jcmsuser;
GRANT ALL ON TABLE public.formicontactlists TO jcmsadmin;


--
-- Name: TABLE formlyrislists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.formlyrislists FROM PUBLIC;
REVOKE ALL ON TABLE public.formlyrislists FROM jcms;
GRANT ALL ON TABLE public.formlyrislists TO jcms;
GRANT ALL ON TABLE public.formlyrislists TO jcmsadmin;
GRANT SELECT ON TABLE public.formlyrislists TO jcmsuser;


--
-- Name: SEQUENCE formlyrislists_formlyrislist_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.formlyrislists_formlyrislist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.formlyrislists_formlyrislist_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.formlyrislists_formlyrislist_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.formlyrislists_formlyrislist_id_seq TO jcmsadmin;


--
-- Name: TABLE formmailchimplists; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.formmailchimplists FROM PUBLIC;
REVOKE ALL ON TABLE public.formmailchimplists FROM jcms;
GRANT ALL ON TABLE public.formmailchimplists TO jcms;
GRANT ALL ON TABLE public.formmailchimplists TO jcmsadmin;
GRANT SELECT ON TABLE public.formmailchimplists TO jcmsuser;


--
-- Name: TABLE forms; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.forms FROM PUBLIC;
REVOKE ALL ON TABLE public.forms FROM jcms;
GRANT ALL ON TABLE public.forms TO jcms;
GRANT ALL ON TABLE public.forms TO jcmsadmin;
GRANT SELECT ON TABLE public.forms TO jcmsuser;


--
-- Name: SEQUENCE forms_form_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.forms_form_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.forms_form_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.forms_form_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.forms_form_id_seq TO jcmsadmin;


--
-- Name: TABLE imagerotator; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.imagerotator FROM PUBLIC;
REVOKE ALL ON TABLE public.imagerotator FROM jcms;
GRANT ALL ON TABLE public.imagerotator TO jcms;
GRANT ALL ON TABLE public.imagerotator TO jcmsadmin;
GRANT SELECT ON TABLE public.imagerotator TO jcmsuser;


--
-- Name: SEQUENCE imagerotator_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.imagerotator_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.imagerotator_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.imagerotator_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.imagerotator_id_seq TO PUBLIC;


--
-- Name: TABLE layoutpanes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.layoutpanes FROM PUBLIC;
REVOKE ALL ON TABLE public.layoutpanes FROM jcms;
GRANT ALL ON TABLE public.layoutpanes TO jcms;
GRANT SELECT ON TABLE public.layoutpanes TO jcmsuser;
GRANT ALL ON TABLE public.layoutpanes TO jcmsadmin;


--
-- Name: SEQUENCE layoutpanes_layoutpane_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.layoutpanes_layoutpane_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.layoutpanes_layoutpane_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.layoutpanes_layoutpane_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.layoutpanes_layoutpane_id_seq TO jcmsadmin;


--
-- Name: SEQUENCE layouts_layout_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.layouts_layout_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.layouts_layout_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.layouts_layout_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.layouts_layout_id_seq TO jcmsadmin;


--
-- Name: TABLE layouts; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.layouts FROM PUBLIC;
REVOKE ALL ON TABLE public.layouts FROM jcms;
GRANT ALL ON TABLE public.layouts TO jcms;
GRANT SELECT ON TABLE public.layouts TO jcmsuser;
GRANT ALL ON TABLE public.layouts TO jcmsadmin;


--
-- Name: TABLE media; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.media FROM PUBLIC;
REVOKE ALL ON TABLE public.media FROM jcms;
GRANT ALL ON TABLE public.media TO jcms;
GRANT ALL ON TABLE public.media TO jcmsadmin;
GRANT SELECT ON TABLE public.media TO jcmsuser;


--
-- Name: SEQUENCE media_mid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.media_mid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.media_mid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.media_mid_seq TO jcms;
GRANT ALL ON SEQUENCE public.media_mid_seq TO jcmsadmin;


--
-- Name: TABLE nodelinks; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.nodelinks FROM PUBLIC;
REVOKE ALL ON TABLE public.nodelinks FROM jcms;
GRANT ALL ON TABLE public.nodelinks TO jcms;
GRANT ALL ON TABLE public.nodelinks TO jcmsadmin;
GRANT SELECT ON TABLE public.nodelinks TO jcmsuser;


--
-- Name: TABLE nodes_current; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.nodes_current FROM PUBLIC;
REVOKE ALL ON TABLE public.nodes_current FROM jcms;
GRANT ALL ON TABLE public.nodes_current TO jcms;
GRANT ALL ON TABLE public.nodes_current TO jcmsadmin;
GRANT SELECT ON TABLE public.nodes_current TO jcmsuser;


--
-- Name: TABLE nodelinks_current; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.nodelinks_current FROM PUBLIC;
REVOKE ALL ON TABLE public.nodelinks_current FROM jcms;
GRANT ALL ON TABLE public.nodelinks_current TO jcms;
GRANT ALL ON TABLE public.nodelinks_current TO jcmsadmin;
GRANT SELECT ON TABLE public.nodelinks_current TO jcmsuser;


--
-- Name: TABLE nodelinks_future; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.nodelinks_future FROM PUBLIC;
REVOKE ALL ON TABLE public.nodelinks_future FROM jcms;
GRANT ALL ON TABLE public.nodelinks_future TO jcms;
GRANT SELECT ON TABLE public.nodelinks_future TO jcmsadmin;
GRANT SELECT ON TABLE public.nodelinks_future TO jcmsuser;


--
-- Name: SEQUENCE nodelinks_nlid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.nodelinks_nlid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.nodelinks_nlid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.nodelinks_nlid_seq TO jcms;
GRANT ALL ON SEQUENCE public.nodelinks_nlid_seq TO jcmsadmin;


--
-- Name: TABLE nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.nodes FROM PUBLIC;
REVOKE ALL ON TABLE public.nodes FROM jcms;
GRANT ALL ON TABLE public.nodes TO jcms;
GRANT ALL ON TABLE public.nodes TO jcmsadmin;
GRANT SELECT ON TABLE public.nodes TO jcmsuser;


--
-- Name: SEQUENCE nodes_nid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.nodes_nid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.nodes_nid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.nodes_nid_seq TO jcms;
GRANT ALL ON SEQUENCE public.nodes_nid_seq TO jcmsadmin;


--
-- Name: TABLE pages; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.pages FROM PUBLIC;
REVOKE ALL ON TABLE public.pages FROM jcms;
GRANT ALL ON TABLE public.pages TO jcms;
GRANT ALL ON TABLE public.pages TO jcmsadmin;
GRANT SELECT ON TABLE public.pages TO jcmsuser;


--
-- Name: TABLE pages_content; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.pages_content FROM PUBLIC;
REVOKE ALL ON TABLE public.pages_content FROM jcms;
GRANT ALL ON TABLE public.pages_content TO jcms;
GRANT SELECT ON TABLE public.pages_content TO jcmsuser;
GRANT ALL ON TABLE public.pages_content TO jcmsadmin;


--
-- Name: SEQUENCE pages_pid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.pages_pid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.pages_pid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.pages_pid_seq TO jcms;
GRANT ALL ON SEQUENCE public.pages_pid_seq TO jcmsadmin;


--
-- Name: TABLE pagetags; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.pagetags FROM PUBLIC;
REVOKE ALL ON TABLE public.pagetags FROM jcms;
GRANT ALL ON TABLE public.pagetags TO jcms;
GRANT ALL ON TABLE public.pagetags TO jcmsadmin;
GRANT SELECT ON TABLE public.pagetags TO jcmsuser;


--
-- Name: TABLE paymentoptions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.paymentoptions FROM PUBLIC;
REVOKE ALL ON TABLE public.paymentoptions FROM jcms;
GRANT ALL ON TABLE public.paymentoptions TO jcms;
GRANT SELECT ON TABLE public.paymentoptions TO jcmsuser;
GRANT ALL ON TABLE public.paymentoptions TO jcmsadmin;


--
-- Name: SEQUENCE paymentoptions_paymentoption_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.paymentoptions_paymentoption_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.paymentoptions_paymentoption_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.paymentoptions_paymentoption_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.paymentoptions_paymentoption_id_seq TO jcmsadmin;


--
-- Name: TABLE payments; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.payments FROM PUBLIC;
REVOKE ALL ON TABLE public.payments FROM jcms;
GRANT ALL ON TABLE public.payments TO jcms;
GRANT SELECT ON TABLE public.payments TO jcmsuser;
GRANT ALL ON TABLE public.payments TO jcmsadmin;


--
-- Name: SEQUENCE payments_payment_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.payments_payment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.payments_payment_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.payments_payment_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.payments_payment_id_seq TO jcmsadmin;


--
-- Name: TABLE photos; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.photos FROM PUBLIC;
REVOKE ALL ON TABLE public.photos FROM jcms;
GRANT ALL ON TABLE public.photos TO jcms;
GRANT ALL ON TABLE public.photos TO jcmsadmin;
GRANT SELECT ON TABLE public.photos TO jcmsuser;


--
-- Name: SEQUENCE photos_photo_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.photos_photo_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.photos_photo_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.photos_photo_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.photos_photo_id_seq TO jcmsadmin;


--
-- Name: TABLE photosets; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.photosets FROM PUBLIC;
REVOKE ALL ON TABLE public.photosets FROM jcms;
GRANT ALL ON TABLE public.photosets TO jcms;
GRANT ALL ON TABLE public.photosets TO jcmsadmin;
GRANT SELECT ON TABLE public.photosets TO jcmsuser;


--
-- Name: SEQUENCE photosets_photoset_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.photosets_photoset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.photosets_photoset_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.photosets_photoset_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.photosets_photoset_id_seq TO jcmsadmin;


--
-- Name: TABLE pollchoices; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.pollchoices FROM PUBLIC;
REVOKE ALL ON TABLE public.pollchoices FROM jcms;
GRANT ALL ON TABLE public.pollchoices TO jcms;
GRANT ALL ON TABLE public.pollchoices TO jcmsadmin;
GRANT SELECT ON TABLE public.pollchoices TO jcmsuser;


--
-- Name: SEQUENCE pollchoices_pollchoice_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.pollchoices_pollchoice_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.pollchoices_pollchoice_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.pollchoices_pollchoice_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.pollchoices_pollchoice_id_seq TO jcmsadmin;


--
-- Name: TABLE polls; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.polls FROM PUBLIC;
REVOKE ALL ON TABLE public.polls FROM jcms;
GRANT ALL ON TABLE public.polls TO jcms;
GRANT ALL ON TABLE public.polls TO jcmsadmin;
GRANT SELECT ON TABLE public.polls TO jcmsuser;


--
-- Name: SEQUENCE polls_poll_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.polls_poll_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.polls_poll_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.polls_poll_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.polls_poll_id_seq TO jcmsadmin;


--
-- Name: TABLE pollsubmissions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.pollsubmissions FROM PUBLIC;
REVOKE ALL ON TABLE public.pollsubmissions FROM jcms;
GRANT ALL ON TABLE public.pollsubmissions TO jcms;
GRANT SELECT,INSERT ON TABLE public.pollsubmissions TO jcmsuser;
GRANT SELECT,DELETE ON TABLE public.pollsubmissions TO jcmsadmin;


--
-- Name: TABLE postedformfields; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.postedformfields FROM PUBLIC;
REVOKE ALL ON TABLE public.postedformfields FROM jcms;
GRANT ALL ON TABLE public.postedformfields TO jcms;
GRANT SELECT,INSERT ON TABLE public.postedformfields TO jcmsuser;
GRANT ALL ON TABLE public.postedformfields TO jcmsadmin;


--
-- Name: TABLE postedforms; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.postedforms FROM PUBLIC;
REVOKE ALL ON TABLE public.postedforms FROM jcms;
GRANT ALL ON TABLE public.postedforms TO jcms;
GRANT SELECT,INSERT ON TABLE public.postedforms TO jcmsuser;
GRANT ALL ON TABLE public.postedforms TO jcmsadmin;


--
-- Name: SEQUENCE postedforms_postedform_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.postedforms_postedform_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.postedforms_postedform_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.postedforms_postedform_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.postedforms_postedform_id_seq TO jcmsuser;


--
-- Name: TABLE settings; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.settings FROM PUBLIC;
REVOKE ALL ON TABLE public.settings FROM jcms;
GRANT ALL ON TABLE public.settings TO jcms;
GRANT ALL ON TABLE public.settings TO jcmsadmin;
GRANT SELECT ON TABLE public.settings TO jcmsuser;


--
-- Name: TABLE sidebarextensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.sidebarextensions FROM PUBLIC;
REVOKE ALL ON TABLE public.sidebarextensions FROM jcms;
GRANT ALL ON TABLE public.sidebarextensions TO jcms;
GRANT ALL ON TABLE public.sidebarextensions TO jcmsadmin;
GRANT SELECT ON TABLE public.sidebarextensions TO jcmsuser;


--
-- Name: SEQUENCE sidebarextensions_sidebarextension_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.sidebarextensions_sidebarextension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.sidebarextensions_sidebarextension_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.sidebarextensions_sidebarextension_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.sidebarextensions_sidebarextension_id_seq TO jcmsadmin;


--
-- Name: TABLE stylesheet; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.stylesheet FROM PUBLIC;
REVOKE ALL ON TABLE public.stylesheet FROM jcms;
GRANT ALL ON TABLE public.stylesheet TO jcms;
GRANT ALL ON TABLE public.stylesheet TO jcmsadmin;
GRANT SELECT ON TABLE public.stylesheet TO jcmsuser;


--
-- Name: SEQUENCE stylesheet_class_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.stylesheet_class_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.stylesheet_class_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.stylesheet_class_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.stylesheet_class_id_seq TO jcmsadmin;


--
-- Name: TABLE stylesheetcategories; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.stylesheetcategories FROM PUBLIC;
REVOKE ALL ON TABLE public.stylesheetcategories FROM jcms;
GRANT ALL ON TABLE public.stylesheetcategories TO jcms;
GRANT SELECT ON TABLE public.stylesheetcategories TO jcmsadmin;


--
-- Name: TABLE updatelog; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.updatelog FROM PUBLIC;
REVOKE ALL ON TABLE public.updatelog FROM jcms;
GRANT ALL ON TABLE public.updatelog TO jcms;
GRANT SELECT ON TABLE public.updatelog TO jcmsadmin;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.users FROM PUBLIC;
REVOKE ALL ON TABLE public.users FROM jcms;
GRANT ALL ON TABLE public.users TO jcms;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO jcmsadmin;


--
-- Name: TABLE users_extensions; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.users_extensions FROM PUBLIC;
REVOKE ALL ON TABLE public.users_extensions FROM jcms;
GRANT ALL ON TABLE public.users_extensions TO jcms;
GRANT ALL ON TABLE public.users_extensions TO jcmsadmin;


--
-- Name: TABLE users_extras; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.users_extras FROM PUBLIC;
REVOKE ALL ON TABLE public.users_extras FROM jcms;
GRANT ALL ON TABLE public.users_extras TO jcms;
GRANT ALL ON TABLE public.users_extras TO jcmsadmin;


--
-- Name: TABLE users_nodes; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.users_nodes FROM PUBLIC;
REVOKE ALL ON TABLE public.users_nodes FROM jcms;
GRANT ALL ON TABLE public.users_nodes TO jcms;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users_nodes TO jcmsadmin;


--
-- Name: SEQUENCE users_uid_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.users_uid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.users_uid_seq FROM jcms;
GRANT ALL ON SEQUENCE public.users_uid_seq TO jcms;
GRANT ALL ON SEQUENCE public.users_uid_seq TO jcmsadmin;


--
-- Name: TABLE utilitycontent; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON TABLE public.utilitycontent FROM PUBLIC;
REVOKE ALL ON TABLE public.utilitycontent FROM jcms;
GRANT ALL ON TABLE public.utilitycontent TO jcms;
GRANT ALL ON TABLE public.utilitycontent TO jcmsadmin;
GRANT SELECT ON TABLE public.utilitycontent TO jcmsuser;


--
-- Name: SEQUENCE utilitycontent_utilitycontent_id_seq; Type: ACL; Schema: public; Owner: jcms
--

REVOKE ALL ON SEQUENCE public.utilitycontent_utilitycontent_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.utilitycontent_utilitycontent_id_seq FROM jcms;
GRANT ALL ON SEQUENCE public.utilitycontent_utilitycontent_id_seq TO jcms;
GRANT ALL ON SEQUENCE public.utilitycontent_utilitycontent_id_seq TO jcmsadmin;


--
-- PostgreSQL database dump complete
--

