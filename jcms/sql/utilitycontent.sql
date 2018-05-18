--
-- replaces utilitylinks and sidebarextensions
--

\connect - jcms

CREATE TABLE utilitycontent (
	utilitycontent_id	serial		PRIMARY KEY,
	location		character(1)	NOT NULL,
	num			int		NOT NULL DEFAULT 1,
	copy			varchar,
	created	timestamp(0) with time zone	NOT NULL DEFAULT now(),
	updated	timestamp(0) with time zone,
	modulecontext		varchar,
	moduleurl		varchar,
	moduleabove		boolean		NOT NULL DEFAULT false,
	showhome		boolean		NOT NULL DEFAULT false,
	showinside		boolean		NOT NULL DEFAULT false
);

CREATE UNIQUE INDEX utilitycontent_unique ON utilitycontent(location,num);

GRANT ALL ON utilitycontent TO jcmsadmin;
GRANT ALL ON utilitycontent_utilitycontent_id_seq TO jcmsadmin;

GRANT SELECT ON utilitycontent TO jcmsuser;
	
