--
-- add/rename some search td styles
--

UPDATE appinfo SET appinfo_value='2007102401' WHERE appinfo_name='db_version';

UPDATE stylesheet SET class_name='td.search-input',num=4 WHERE class_name='td.search';
INSERT INTO stylesheet VALUES (482, 'td.search-word', ' ', 2, true, 0, 0, 12);


