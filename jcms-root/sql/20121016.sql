--
-- Text settings for Payments extra
--

\connect - jcms

INSERT INTO updatelog (name,value) VALUES ('db_version','20121016');


INSERT INTO settings VALUES (160, 'payments_optionsheading', 'Payment options.', 'Heading above list of payment options.', false, false);
INSERT INTO settings VALUES (161, 'payments_contactheading', 'Contact information.', 'Heading above contact info section.', false, false);
INSERT INTO settings VALUES (164, 'payments_paypalheading', 'Pay with your PayPal account.', 'Heading above PayPal checkout button.', false, false);
INSERT INTO settings VALUES (165, 'payments_creditcardheading', 'Pay with your credit card.', 'Heading above credit card checkout section.', false, false);
INSERT INTO settings VALUES (166, 'payments_creditcardbutton', 'https://merchant.paypal.com/cms_content/US/en_US/images/merchant/scr_buynow_94x30.gif', 'URL for credit card payment button.', false, false);
