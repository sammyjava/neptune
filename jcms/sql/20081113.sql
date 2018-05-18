--
-- Photo Sets extra tables, PLUS new Extra class and tables for separation from Extensions
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20081113');


CREATE TABLE photosets (
	photoset_id	serial	PRIMARY KEY,
	title		varchar UNIQUE NOT NULL,
	created		timestamp(0)	NOT NULL DEFAULT now(),
	description	varchar,
	shootdate	varchar,
	credit		varchar
);

GRANT ALL ON photosets TO jcmsadmin;
GRANT SELECT ON photosets TO jcmsuser;

GRANT ALL ON photosets_photoset_id_seq TO jcmsadmin;

CREATE TABLE photos (
	photo_id	serial	PRIMARY KEY,
	photoset_id	int	REFERENCES photosets,
	num		int	NOT NULL DEFAULT 1,
	timeposted	timestamp(0)	NOT NULL DEFAULT now(),
	imagefile	varchar	UNIQUE NOT NULL,
	imagewidth	int	NOT NULL,
	imageheight	int	NOT NULL,
	imagealt	varchar,
	caption		varchar,
	thumbnail	varchar
);

GRANT ALL ON photos TO jcmsadmin;
GRANT SELECT ON photos TO jcmsuser;

GRANT ALL ON photos_photo_id_seq TO jcmsadmin;


-- SETTINGS

INSERT INTO settings VALUES (550, 'photos_dir', '/home/java/jcms/uploads/photos/', 'Photos directory, with trailing slash.', false);
INSERT INTO settings VALUES (551, 'photos_folder', '/photos', 'Photos folder, without trailing slash.', false);
INSERT INTO settings VALUES (552, 'photos_max_memory', '10000000', 'Max memory used by photo uploader, bytes.', false);
INSERT INTO settings VALUES (553, 'photos_max_request', '20000000', 'Max request size for photo uploader, bytes.', false);
INSERT INTO settings VALUES (554, 'photos_max_chunk', '500000', 'Max chunk size used by photo uploader, bytes.', false);
INSERT INTO settings VALUES (555, 'photos_max_width', '1024', 'Max allowed width of an uploaded photo.', false);
INSERT INTO settings VALUES (556, 'photos_max_height', '1024', 'Max allowed height of an uploaded photo.', false);
INSERT INTO settings VALUES (557, 'photos_thumbnail_width', '100', 'Width of thumbnail images.', false);

-- STYLESHEET

INSERT INTO stylesheetcategories VALUES (20, 'photosets', 20);

INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (350,'table.photoset','',1,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (351,'td.photoset-header','',2,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (352,'div.photoset-title','',3,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (353,'div.photoset-description','',4,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (354,'div.photoset-shootdate','',5,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (355,'div.photoset-credit','',6,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (356,'td.thumbnail','',7,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (357,'img.thumbnail','',8,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (358,'div.photo','',9,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (359,'img.photo','',10,true,0,0,20);
INSERT INTO stylesheet (class_id,class_name,class_value,num,required,level,level_num,stylesheetcategory_id) VALUES (360,'div.photo-caption','',11,true,0,0,20);


--
-- Extras tables to separate extras from extensions
--

CREATE TABLE extras (
	extra_id	serial	PRIMARY KEY,
	parent_extra_id	int	REFERENCES extras,
	name		varchar	UNIQUE NOT NULL,
	cpurl		varchar	NOT NULL,
	docurl		varchar
);

GRANT SELECT ON extras TO jcmsadmin;


CREATE TABLE users_extras (
	uid		int	NOT NULL REFERENCES users,
	extra_id	int	NOT NULL REFERENCES extras
);

GRANT ALL ON users_extras TO jcmsadmin;


INSERT INTO extras VALUES (DEFAULT, NULL, 'Comments', 'comments.jsp', 'doc-comments.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'Contact Forms', 'forms.jsp', 'doc-forms.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'Image Rotator', 'imagerotator.jsp', 'doc-imagerotator.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'Photo Sets', 'photosets.jsp', 'doc-photosets.jsp');
INSERT INTO extras VALUES (DEFAULT, NULL, 'SearchBlox', 'searchblox.jsp', 'doc-searchblox.jsp');
INSERT INTO extras VALUES (DEFAULT, 5, 'CSS Editor', 'searchblox-css.jsp', NULL);
INSERT INTO extras VALUES (DEFAULT, 5, 'XSL Editor', 'searchblox-xsl.jsp', NULL);

--
-- delete extras that are loaded as extensions
--

DELETE FROM users_extensions WHERE extid IN (SELECT extid FROM extensions WHERE cpurl IN (SELECT '/'||cpurl FROM extras));
DELETE FROM extensions WHERE cpurl IN (SELECT '/'||cpurl FROM extras);
