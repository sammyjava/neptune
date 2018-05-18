--
-- Mobile version settings, etc.
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120105');


INSERT INTO settings VALUES (120, 'mobile_enable', false, 'Enables mobile stylesheet if mobile device detected', false, true);

INSERT INTO settings VALUES (121, 'mobile_toggle_desktop', 'switch to desktop version', 'Text displayed on link that toggles to desktop version on mobile device', false, false);
INSERT INTO settings VALUES (122, 'mobile_toggle_mobile', 'switch to mobile version', 'Text displayed on link that toggles back to mobile version on mobile device', false, false);

ALTER TABLE utilitycontent ADD COLUMN showmobile boolean NOT NULL DEFAULT false;


 

