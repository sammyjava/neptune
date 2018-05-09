--
-- comments module style classes and settings
--

UPDATE appinfo SET appinfo_value='2008012901' WHERE appinfo_name='db_version';


UPDATE stylesheetcategories SET num=99 where stylesheetcategory_id=1;

INSERT INTO stylesheetcategories VALUES (16, 'comments', 16);

INSERT INTO stylesheet VALUES (250, 'div#commentform', '', 1, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (251, 'form#commentform', '', 2, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (252, 'table#commentform', '', 3, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (253, 'td.commentform', '', 4, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (254, 'input.commentfield', '', 5, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (255, 'textarea.commentfield', '', 6, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (256, 'input.commentbutton', '', 7, true, 0, 0, 16);

INSERT INTO stylesheet VALUES (260, 'div.comments', '', 8, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (261, 'table.comment', '', 9, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (262, 'td.commentheading', '', 10, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (263, 'td.commenttime', '', 11, true, 0, 0, 16);
INSERT INTO stylesheet VALUES (264, 'td.comment', '', 12, true, 0, 0, 16);


CREATE TABLE comments (
	comment_id	serial	PRIMARY KEY,
	cid		int	NOT NULL REFERENCES content,
	timeposted	timestamp(0) with time zone	NOT NULL DEFAULT current_timestamp(0),
	name		varchar	NOT NULL,
	email		varchar	NOT NULL,
	comment		varchar	NOT NULL
);

GRANT SELECT,INSERT ON comments TO jcmsuser;
GRANT ALL ON comments TO jcmsadmin;

GRANT ALL ON comments_comment_id_seq TO jcmsuser;
GRANT ALL ON comments_comment_id_seq TO jcmsadmin;


INSERT INTO SETTINGS VALUES (540, 'comments_dateformat', 'yyyy-MM-dd HH:mm', 'Format (java.text.SimpleDateFormat) for the comment posted date/time.');
INSERT INTO SETTINGS VALUES (541, 'comments_inputsize', 32, 'Size of text input fields on comment posting form.');
INSERT INTO SETTINGS VALUES (542, 'comments_textcols', 32, 'Number of columns in comment textarea.');
INSERT INTO SETTINGS VALUES (543, 'comments_textrows', 5, 'Number of rows in comment textarea.');
INSERT INTO SETTINGS VALUES (544, 'comments_buttontext', 'POST', 'Label on comment posting button.');

