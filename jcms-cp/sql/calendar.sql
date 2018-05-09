--
-- Calendar extra
--

\connect - jcms

-- INSERT INTO updatelog (name,value) VALUES ('db_version','20100226');

-- Extras

INSERT INTO extras VALUES (13, NULL, 'Calendar', 'calendar.jsp', 'doc-calendar.jsp');


-- Settings

INSERT INTO settings VALUES (130, 'calendar_date_format', 'EEE, MMMM d', 'java.text.SimpleDateFormat for Calendar event date', false, false);
INSERT INTO settings VALUES (131, 'calendar_monthyear_format', 'MMMM yyyy', 'java.text.SimpleDateFormat for Calendar month/year display', false, false);
INSERT INTO settings VALUES (132, 'calendar_weekstartsmonday', 'false', 'calendar week starts on Monday (true/false)', false, true);
INSERT INTO settings VALUES (133, 'calendar_shortdaynames', 'false', 'calendar displays short day names (Sun, Mon, etc.): (true/false)', false, true);

INSERT INTO settings VALUES (134, 'calendar_eventwindow_left', '300', 'offset from left of calendar event window (int)', false, false);
INSERT INTO settings VALUES (135, 'calendar_eventwindow_top', '300', 'offset from top of calendar event window (int)', false, false);
INSERT INTO settings VALUES (136, 'calendar_eventwindow_width', '500', 'width of calendar event window (int)', false, false);
INSERT INTO settings VALUES (137, 'calendar_eventwindow_height', '50', 'height of calendar event window (int)', false, false);
INSERT INTO settings VALUES (138, 'calendar_eventwindow_theme', 'plain', 'name or path to theme of calendar event window', false, false);

-- Stylesheet

INSERT INTO stylesheetcategories VALUES (23, 'calendar', 23);

INSERT INTO stylesheet VALUES (600, 'div.cal', '', 1, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (601, 'table.cal', '', 2, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (602, 'td.cal-prev', '', 3, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (603, 'td.cal-next', '', 4, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (604, 'td.cal-month', '', 5, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (605, 'td.cal-day', '', 6, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (606, 'td.cal-date', '', 7, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (607, 'td.cal-emptydate', '', 8, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (608, 'td.cal-today', '', 9, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (609, 'td.cal-eventdate', '', 10, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (610, 'td.cal-weekend', '', 11, true, 0, 0, 23);

INSERT INTO stylesheet VALUES (620, 'div.event', '', 20, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (621, 'div.event-title', '', 21, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (622, 'div.event-time', '', 22, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (623, 'div.event-description', '', 23, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (624, 'a.event:link', '', 24, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (625, 'a.event:visited', '', 25, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (626, 'a.event:hover', '', 26, true, 0, 0, 23);
INSERT INTO stylesheet VALUES (627, 'a.event:active', '', 27, true, 0, 0, 23);


