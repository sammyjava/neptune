--
-- switch to negative logic on DHTML option - default is to have DHTML, DISABLE with setting
--

UPDATE appinfo SET appinfo_value='2007121401' WHERE appinfo_name='db_version';

UPDATE settings SET setting_name = 'navpri_dhtml_disable', description='Disable DHTML primary nav dropdowns: true/false.' WHERE setting_name = 'navpri_dhtml';
UPDATE settings SET setting_value = 'xxxx' WHERE setting_name='navpri_dhtml_disable' AND setting_value='false';
UPDATE settings SET setting_value = 'false' WHERE setting_name='navpri_dhtml_disable' AND setting_value='true';
UPDATE settings SET setting_value = 'true' WHERE setting_name='navpri_dhtml_disable' AND setting_value='xxxx';
