--
-- paymentoptions table, stores payment selections
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20120214');

INSERT INTO extras VALUES (15, NULL, 'Payments', 'payments.jsp', 'doc-payments.jsp');

INSERT INTO settings VALUES (162, 'payments_netsol', 'true', 'Show Network Solutions SSL seal on Payments form', false, true);
INSERT INTO settings VALUES (163, 'payments_enable', 'false', 'Enable Payments extra, requires PayPal info in web.xml', false, true);


CREATE TABLE payments (
	payment_id	serial	PRIMARY KEY,
	title		varchar	NOT NULL,
	instructions	varchar	NOT NULL,
	thankyou	varchar	NOT NULL,
	recipientemail	varchar	NOT NULL,
	recipientname	varchar	NOT NULL
);

GRANT SELECT ON payments TO jcmsuser;
GRANT ALL ON payments TO jcmsadmin;
GRANT ALL ON payments_payment_id_seq TO jcmsadmin;

CREATE TABLE paymentoptions (
	paymentoption_id	serial	PRIMARY KEY,
	payment_id		int	NOT NULL REFERENCES payments,
	num			int	NOT NULL,
	amount			numeric(10,2)	NOT NULL DEFAULT 0.00,
	name			varchar	NOT NULL,
	description		varchar
);

GRANT SELECT ON paymentoptions TO jcmsuser;
GRANT ALL ON paymentoptions TO jcmsadmin;
GRANT ALL ON paymentoptions_paymentoption_id_seq TO jcmsadmin;



INSERT INTO stylesheetcategories VALUES (25, 'payments', 25);

INSERT INTO stylesheet VALUES (230, 'div.payments', '', 1, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (238, 'div.payment-summary', '', 2, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (239, 'div.payment-confirmation', '', 3, true, 0, 0, 25);

INSERT INTO stylesheet VALUES (231, 'table.payments', '', 4, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (232, 'td.payment-option', '', 5, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (233, 'td.payment-amount', '', 6, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (234, 'td.payment-description', '', 7, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (235, '.payment-name', '', 8, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (236, 'table.creditcard', '', 9, true, 0, 0, 25);
INSERT INTO stylesheet VALUES (237, 'td.creditcard', '', 10, true, 0, 0, 25);


DELETE FROM stylesheet WHERE class_name='.error';
DELETE FROM stylesheet WHERE class_id=531;
INSERT INTO stylesheet VALUES (531, '.error', 'color:red', 1, true, 0, 0, 1);


