--
-- 2007022801
--
-- Add a couple required classes to stylesheet
--

INSERT INTO stylesheet VALUES (DEFAULT, 'table.form', 'border: 1px solid black;', 1, true, 0, 0, 1);
INSERT INTO stylesheet VALUES (DEFAULT, 'div.error', 'color: red;', 2, true, 0, 0, 1);
INSERT INTO stylesheet VALUES (DEFAULT, 'div.message', 'color: green;', 3, true, 0, 0, 1);
UPDATE stylesheet SET class_name='div.debug',num=99 WHERE class_name='.debug';

