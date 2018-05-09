--
-- jcms-bootstrap bsgrids and bspanes
--

\connect - jcms

DROP TABLE bspanes CASCADE;
DROP TABLE bsgrids CASCADE;
DROP TABLE bspages CASCADE;
DROP TABLE bspages_content CASCADE;

CREATE TABLE bsgrids (
       bsgrid_id	serial	PRIMARY KEY,
       bspane_id	integer,
       label		varchar	UNIQUE NOT NULL,
       nrows		integer	NOT NULL DEFAULT 1
);

CREATE TABLE bspanes (
       bspane_id				serial	PRIMARY KEY,
       bsgrid_id				integer	NOT NULL REFERENCES bsgrids (bsgrid_id) DEFAULT 1, 
	   contained_bsgrid_id		integer REFERENCES bsgrids (bsgrid_id),
       label					varchar	UNIQUE NOT NULL,
       num   					integer	NOT NULL,  
       span						integer	NOT NULL DEFAULT 12
);
ALTER TABLE bspanes ADD UNIQUE (bsgrid_id,num);


-- this has to come after both bsgrids and bspanes declared
ALTER TABLE bsgrids ADD CONSTRAINT bspane_fk FOREIGN KEY (bspane_id) REFERENCES bspanes(bspane_id) MATCH FULL;

CREATE TABLE bspages (
	   pid				serial PRIMARY KEY,
	   bsgrid_id		integer NOT NULL REFERENCES bsgrids (bsgrid_id) DEFAULT 1,
	   label			character varying UNIQUE NOT NULL DEFAULT round(extract(epoch from now())),
 	   metadescription	character varying,
	   headtitle       	character varying,
	   title			character varying,
	   created			timestamp(0) with time zone not null default now(),
	   updated			timestamp(0) with time zone,
	   othermeta		character varying
);

CREATE TABLE bspages_content (
	   pid	 		integer	 NOT NULL REFERENCES bspages (pid),
	   cid   		integer	 NOT NULL REFERENCES content (cid),
	   bspane_id 	integer	 NOT NULL REFERENCES bspanes (bspane_id)
);


GRANT ALL ON bsgrids TO jcmsadmin;
GRANT ALL ON bsgrids_bsgrid_id_seq TO jcmsadmin;
GRANT SELECT ON bsgrids TO jcmsuser;

GRANT ALL ON bspanes TO jcmsadmin;
GRANT ALL ON bspanes_bspane_id_seq TO jcmsadmin;
GRANT SELECT ON bspanes TO jcmsuser;

GRANT ALL ON bspages TO jcmsadmin;
GRANT ALL ON bspages_pid_seq TO jcmsadmin;
GRANT SELECT ON bspages TO jcmsuser;

GRANT ALL ON bspages_content TO jcmsadmin;
GRANT SELECT ON bspages_content TO jcmsuser;

-- insert the default layout, which may not be deleted
INSERT INTO bsgrids (label) VALUES ('default');
INSERT INTO bspanes (bsgrid_id,label,num) VALUES (1,'default-1',1);

-- alter some standard jcms tables

DELETE FROM content WHERE label IS NULL;
ALTER TABLE content ALTER COLUMN label SET NOT NULL;
ALTER TABLE content ALTER COLUMN label SET DEFAULT round(date_part('epoch'::text, now()));
