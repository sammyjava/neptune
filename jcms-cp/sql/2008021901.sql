--
-- create unique index on pages_content, should have been there from start
--

UPDATE appinfo SET appinfo_value='2008021901' WHERE appinfo_name='db_version';

CREATE UNIQUE INDEX pages_content_unique ON pages_content(pid,cid,pane);
