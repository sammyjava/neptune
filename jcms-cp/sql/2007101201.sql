--
-- add utilitylinks.openwindow for new checkbox option
--

UPDATE appinfo SET appinfo_value='2007101201' WHERE appinfo_name='db_version';

ALTER TABLE utilitylinks ADD COLUMN openwindow boolean NOT NULL DEFAULT false;
