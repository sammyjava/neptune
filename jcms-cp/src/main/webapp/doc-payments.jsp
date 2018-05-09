<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Payments"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Payments</b> extra allows you to build payment forms using your <a target="_blank" href="https://www.paypal.com/webapps/mpp/website-payments-pro">PayPal Website Payments Pro</a> account.  (The credentials for your
  PayPal Website Payments Pro account must be entered into your site's web.xml file.)
</p>

<p>
  Payment forms are built using the <b>Payments</b> tool, and have the following fields:
</p>

<ul>
  <li><b>Payment Title</b> - the overall title of the payment form, like "Contribute to our Capital Campaign!"</li>
  <li><b>Notification Recipient Name</b> - the person at your office that will receive an email notification of payments</li>
  <li><b>Notification Recipient Email</b></li>
  <li><b>Payment Instructions Text</b> - shown above the payment form, e.g. "Please select a payment option below that fits into your budget."</li>
  <li><b>Payment Thank-You Text</b> - shown on the screen after the payment is complete, above a summary of the payment.  It is also included in the notification email to the customer.</li>
</ul>

<p>
  After entering the payment data and creating the basic payment form, you must add payment options.  Each payment option has:
</p>

<ul>
  <li><b>Num</b> - a sorting number</li>
  <li><b>Amount</b> - a preset payment amount, or 0.00 if you want the amount to be entered by the customer</li>
  <li><b>Name</b> - the short name of the payment option, e.g. "Bronze Sponsorship"</li>
  <li><b>Description</b> - a longer description of the payment option, e.g. "Entitles you to a full year subscription to our monthly magazine, and discounts at our gift shop."</li>
</ul>

<p>
  Once you have created a payment form, you schedule it on a node by entering its URL in the URL field.  A payment form must be accessed by URL because of the way PayPal handles
  "Express Checkout", which authenticates the user on the PayPal site, and then redirects the user back to your site.  (Credit card payments remain on your site and are processed with one click.)
</p>

<p>
  Needless to say, you should have "SSL" checked on a node that contains a payment.
</p>

<p>
  If you wish to try out the Payments extra before investing in a PayPal Website Payments Pro account, IMS can install our "sandbox" PayPal account on your site, does not require that you
  have an SSL certificate.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

