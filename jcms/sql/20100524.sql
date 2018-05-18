--
-- Add headlines_showhidden setting
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20100524');

INSERT INTO settings VALUES (143, 'headlines_showhidden', 'false', 'Include hidden node headlines (true/false).', false, true);



