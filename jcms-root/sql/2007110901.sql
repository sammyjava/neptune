--
-- Breadcrumbs addition.
--

UPDATE appinfo SET appinfo_value='2007110901' WHERE appinfo_name='db_version';

INSERT INTO settings VALUES (340, 'breadcrumbs_disable', 'true', 'Show breadcrumb links above page title: true/false.');
INSERT INTO settings VALUES (341, 'breadcrumbs_separator', ':', 'Separator character between breadcrumbs links.');


INSERT INTO stylesheet VALUES (410, 'div#breadcrumbs', '', 4, true, 0, 0, 8);
INSERT INTO stylesheet VALUES (411, 'a.breadcrumbs:link', '', 5, true, 0, 0, 8);
INSERT INTO stylesheet VALUES (412, 'a.breadcrumbs:visited', '', 5, true, 0, 0, 8);
INSERT INTO stylesheet VALUES (413, 'a.breadcrumbs:hover', '', 5, true, 0, 0, 8);
INSERT INTO stylesheet VALUES (414, 'a.breadcrumbs.active', '', 5, true, 0, 0, 8);

