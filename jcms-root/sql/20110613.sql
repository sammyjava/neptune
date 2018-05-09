--
-- New classes for flat listing of monthly events
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20110613');

INSERT INTO stylesheet VALUES (630, 'td.event-date-heading', '', 31, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (631, 'td.event-time-heading', '', 31, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (632, 'td.event-copy-heading', '', 31, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (633, 'td.event-date', '', 32, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (634, 'td.event-time', '', 32, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (635, 'td.event-copy', '', 32, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (636, '.event-title', '', 33, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (637, '.event-description', '', 33, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (638, 'tr.event', '', 32, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (639, 'table#events', '', 30, true, 0, 0, 23);

INSERT INTO stylesheet VALUES (640, 'table#event-selector', '', 29, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (641, 'td.event-month-selector', '', 29, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (642, 'td.event-year-selector', '', 29, true, 0, 0, 23);



