--
-- Add support for alternate layout panes for mobile site option
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120830');

-- legacy, not used
ALTER TABLE layouts DROP COLUMN cols;
ALTER TABLE layouts DROP COLUMN rows;


ALTER TABLE layoutpanes ADD COLUMN mobile boolean NOT NULL DEFAULT false;

-- prevent dupes
ALTER TABLE layoutpanes ADD CONSTRAINT layoutpanes_unique UNIQUE (layout_id,pane,mobile);

-- duplicate panes for mobile
INSERT INTO layoutpanes (layout_id,pane,vposition,hposition,colspan,rowspan,mobile) SELECT layout_id,pane,vposition,hposition,colspan,rowspan,true FROM layoutpanes;
