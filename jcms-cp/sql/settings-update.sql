--
-- Update Settings to handle toggles (booleans) and display checkboxes rather than typing in true/false, with associated methods.
--

ALTER TABLE settings ADD COLUMN toggle boolean NOT NULL DEFAULT false;

UPDATE settings SET toggle=true WHERE setting_value='true' OR setting_value='false';

--
-- fix bad descriptions from switch to disable to enable logic way back
--

UPDATE settings SET description='Enable DHTML primary nav dropdowns.'                            WHERE setting_id=        301;
UPDATE settings SET description='Enable primary nav level 1 links (requires navpri_dhtml=true).' WHERE setting_id=        303;
UPDATE settings SET description='Enable quaternary navigation.'                                  WHERE setting_id=        330;
UPDATE settings SET description='Enable page title.'                                             WHERE setting_id=        350;
UPDATE settings SET description='Enable footer on root node.'                                    WHERE setting_id=         34;
UPDATE settings SET description='Enable header on root node.'                                    WHERE setting_id=         30;
UPDATE settings SET description='Enable primary nav on root node.'                               WHERE setting_id=         31;
UPDATE settings SET description='Enable section header on root node.'                            WHERE setting_id=         32;
UPDATE settings SET description='Enable subheader on root node.'                                 WHERE setting_id=         33;
UPDATE settings SET description='Enable section header.'                                         WHERE setting_id=        321;
UPDATE settings SET description='Enable sidebar.'                                                WHERE setting_id=        360;
UPDATE settings SET description='Enable header.'                                                 WHERE setting_id=        100;
UPDATE settings SET description='Enable subheader.'                                              WHERE setting_id=        200;
UPDATE settings SET description='Enable footer.'                                                 WHERE setting_id=        400;
