--
-- 2007-01-09
-- Add redirectnid to nodelinks table
--

ALTER TABLE nodelinks ADD COLUMN redirectnid int REFERENCES nodes(nid);
