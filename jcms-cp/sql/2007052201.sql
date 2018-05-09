--
-- 2007052201
-- add sequence, num to layouts to enable management on control panel
--

\connect - jcms

UPDATE appinfo SET appinfo_value='2007052201' WHERE appinfo_name='db_version';

CREATE SEQUENCE layouts_layout_id_seq;
GRANT ALL ON layouts_layout_id_seq TO jcmsadmin;

ALTER TABLE layouts ALTER COLUMN layout_id SET DEFAULT nextval('layouts_layout_id_seq'::regclass);

ALTER TABLE layouts ADD COLUMN num integer;
UPDATE layouts SET num = layout_id;
ALTER TABLE layouts ALTER COLUMN num SET NOT NULL;
ALTER TABLE layouts ADD CONSTRAINT layouts_num_key UNIQUE (num);

ALTER TABLE layouts ALTER COLUMN cols SET NOT NULL;
ALTER TABLE layouts ALTER COLUMN rows SET NOT NULL;

GRANT ALL ON layoutpanes TO jcmsadmin;
GRANT ALL ON layouts TO jcmsadmin;
