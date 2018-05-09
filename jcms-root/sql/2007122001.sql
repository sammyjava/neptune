--
-- Add subheader_date_homeonly option
--

UPDATE appinfo SET appinfo_value='2007122001' WHERE appinfo_name='db_version';


INSERT INTO settings VALUES (203, 'subheader_date_homeonly', 'false', 'Show date in subheader only on root: true/false.');
