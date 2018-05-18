--
-- Add FK constraint to nodelinks to enforce cleanup
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120710');

ALTER TABLE nodelinks ADD CONSTRAINT nodelinks_nid_fkey FOREIGN KEY (nid) REFERENCES nodes (nid);


