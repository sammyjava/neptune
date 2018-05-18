--
-- Forms extra tables
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20081027');

DROP TABLE postedformfields;
DROP TABLE postedforms;
DROP TABLE formfieldoptions;
DROP TABLE formfields;
DROP TABLE formlyrislists;
DROP TABLE forms;

CREATE TABLE forms (
	form_id		serial	PRIMARY KEY,
	title		varchar	NOT NULL,
	recipientname	varchar	NOT NULL,
	recipientemail	varchar	NOT NULL,
	sendername	varchar NOT NULL,
	senderemail	varchar NOT NULL,
	instructions	varchar	NOT NULL,
	thankyou	varchar	NOT NULL,
	confirmationmessage varchar,
	signupinstructions varchar
);
GRANT ALL ON forms TO jcmsadmin;
GRANT SELECT ON forms TO jcmsuser;
GRANT ALL ON forms_form_id_seq TO jcmsadmin;

CREATE UNIQUE INDEX forms_unique_title ON forms(title);

CREATE TABLE formfields (
	formfield_id	serial	PRIMARY KEY,
	form_id		int	NOT NULL REFERENCES forms,
	fieldname	varchar	NOT NULL,
	num		int	NOT NULL DEFAULT 1,
	heading		varchar	NOT NULL,
	required	boolean	NOT NULL DEFAULT false,
	textinput	boolean	NOT NULL DEFAULT false,
	radio		boolean	NOT NULL DEFAULT false,
	checkbox	boolean	NOT NULL DEFAULT false,
	textarea	boolean	NOT NULL DEFAULT false,
	selectmenu	boolean	NOT NULL DEFAULT false,
	columns		int	NOT NULL DEFAULT 1,
	size		int	NOT NULL DEFAULT 20,
	rows		int	NOT NULL DEFAULT 3,
	cols		int	NOT NULL DEFAULT 20
);
GRANT ALL ON formfields TO jcmsadmin;
GRANT SELECT ON formfields TO jcmsuser;
GRANT ALL ON formfields_formfield_id_seq TO jcmsadmin;

CREATE UNIQUE INDEX formfields_unique_name ON formfields(form_id,fieldname);
CREATE UNIQUE INDEX formfields_unique_num ON formfields(form_id,num);

CREATE TABLE formlyrislists (
	formlyrislist_id serial	PRIMARY KEY,
	form_id		int	NOT NULL REFERENCES forms,
	listname	varchar	NOT NULL,
	num		int	NOT NULL DEFAULT 1,
	description	varchar	NOT NULL
);
GRANT ALL ON formlyrislists TO jcmsadmin;
GRANT SELECT ON formlyrislists TO jcmsuser;
GRANT ALL ON formlyrislists_formlyrislist_id_seq TO jcmsadmin;

CREATE UNIQUE INDEX formlyrislists_unique ON formlyrislists(form_id,listname);


CREATE TABLE formfieldoptions (
	formfieldoption_id	serial	PRIMARY KEY,
	formfield_id 	int	NOT NULL REFERENCES formfields,
	num		int 	NOT NULL DEFAULT 1,
	value		varchar	NOT NULL,
	selected	boolean NOT NULL DEFAULT false
);
GRANT ALL ON formfieldoptions TO jcmsadmin;
GRANT SELECT ON formfieldoptions TO jcmsuser;
GRANT ALL ON formfieldoptions_formfieldoption_id_seq TO jcmsadmin;

CREATE UNIQUE INDEX formfieldoptions_unique_value ON formfieldoptions(formfield_id,value);
CREATE UNIQUE INDEX formfieldoptions_unique_num ON formfieldoptions(formfield_id,num);


CREATE TABLE postedforms (
	postedform_id	serial	PRIMARY KEY,
	form_id		int	NOT NULL REFERENCES forms,
	timeposted	timestamp(0)	NOT NULL DEFAULT now()
);
GRANT SELECT ON postedforms TO jcmsadmin;
GRANT INSERT,SELECT ON postedforms TO jcmsuser;
GRANT ALL ON postedforms_postedform_id_seq TO jcmsuser;

CREATE TABLE postedformfields (
	postedform_id	int	NOT NULL REFERENCES postedforms,
	fieldname	varchar	NOT NULL,
	num		int	NOT NULL,
	value		varchar
);
GRANT SELECT ON postedformfields TO jcmsadmin;
GRANT INSERT,SELECT ON postedformfields TO jcmsuser;
