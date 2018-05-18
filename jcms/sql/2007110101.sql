--
-- More settings options
--

UPDATE appinfo SET appinfo_value='2007110101' WHERE appinfo_name='db_version';

-- don't link level 1 pages; must have DHTML to set this option true!
INSERT INTO settings VALUES (303, 'navpri_level1_disable', 'false', 'Disable primary nav level 1 links (requires navpri_dhtml=true): true/false.');




