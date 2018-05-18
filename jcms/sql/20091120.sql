--
-- Softslate stylesheet category and enable toggle
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20091120');

-- Settings

INSERT INTO settings VALUES (561, 'softslate_enable', 'false', 'Enable SoftSlate stylesheet, etc: true/false.', false, true);

-- STYLESHEET

INSERT INTO stylesheetcategories VALUES (22, 'softslate', 22);
