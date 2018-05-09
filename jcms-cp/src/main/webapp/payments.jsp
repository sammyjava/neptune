<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=15; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // money format
  NumberFormat mf = NumberFormat.getInstance();
  mf.setMaximumFractionDigits(2);
  mf.setMinimumFractionDigits(2);

  boolean insertpayment = request.getParameter("insertpayment")!=null;
  boolean updatepayment = request.getParameter("updatepayment")!=null;
  boolean deletepayment = request.getParameter("deletepayment")!=null;

  boolean insertoption = request.getParameter("insertoption")!=null;
  boolean updateoption = request.getParameter("updateoption")!=null;
  boolean deleteoption = request.getParameter("deleteoption")!=null;

  Payment payment = new Payment(application, Util.getInt(request,"payment_id"));

  try {
    
    if (insertpayment || updatepayment) {
      payment.title = Util.getString(request, "title");
      payment.instructions = Util.getString(request, "instructions");
      payment.thankyou = Util.getString(request, "thankyou");
      payment.recipientname = Util.getString(request, "recipientname");
      payment.recipientemail = Util.getString(request, "recipientemail");
      if (insertpayment) {
        payment.insert(request);
        message = "Added new payment <b>"+payment.title+"</b>.";
      } else if (updatepayment) {
        payment.update(request);
        message = "Updated payment <b>"+payment.title+"</b>."; 
      }
    }

    if (deletepayment) {
      boolean confirmed = Util.getBoolean(request, "confirmed");
      if (confirmed) {
        String title = payment.title;
        payment.delete(request);
        message = "Deleted payment: <b>"+title+"</b>.";
      } else {
        error = "You must check the box to confirm deletion of a payment.";
      }
    }
    
    if (insertoption || updateoption) {
      PaymentOption p = new PaymentOption();
      if (insertoption) {
        p.payment_id = payment.payment_id;
      } else {
        p = new PaymentOption(application, Util.getInt(request, "paymentoption_id"));
      }
      p.num = Util.getInt(request, "num");
      p.amount = Util.getDouble(request, "amount");
      p.name = Util.getString(request, "name");
      p.description = Util.getString(request, "description");
      if (insertoption) {
        p.insert(request);
        message = "New payment option <b>"+p.name+"</b> inserted.";
      } else if (updateoption) {
        p.update(request);
        message = "Payment option <b>"+p.name+"</b> updated.";
      }
    }

    if (deleteoption) {
      boolean confirmed = Util.getBoolean(request, "confirmed");
      if (confirmed) {
        PaymentOption p = new PaymentOption(application, Util.getInt(request, "paymentoption_id"));
        String name = p.name;
        p.delete(request);
        message = "Deleted payment option <b>"+name+"</b>.";
      } else {
        error = "You must check the box to confirm deletion of a payment option.";
      }
    }
    
  } catch (Exception ex) {
    error = ex.getMessage();
    // reset payment
    payment = new Payment(application, Util.getInt(request,"payment_id"));
  }

  Payment[] payments = Payment.getAll(application);
%>

<form method="post">
  <select name="payment_id" onChange="submit()">
    <option value="0">--- create new payment form ---</option>
    <% for (int i=0; i<payments.length; i++) { %>
      <option <% if (payments[i].equals(payment)) out.print("selected"); %>  value="<%=payments[i].payment_id%>"><%=payments[i].title%></option>
      <% } %>
  </select>
  <% if (!payment.isDefault()) { %>
  URL: <a target="_blank" href="/payment.jsp?payment_id=<%=payment.payment_id%>">/payment.jsp?payment_id=<%=payment.payment_id%></a>
  <% } %>
</form>

<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<form method="post">
  <input type="hidden" name="payment_id" value="<%=payment.payment_id%>"/>
  <table>
    <tr>
      <td class="required">Payment Title<br/><textarea name="title" rows="1" cols="120"><%=Util.blankIfNull(payment.title)%></textarea></td>
    </tr>
    <tr>
      <td>
        <table>
          <tr>
            <td class="required">Notification Recipient Name<br/><input type="text" name="recipientname" size="48" value="<%=Util.blankIfNull(payment.recipientname)%>"/></td>
            <td class="required">Notification Recipient Email<br/><input type="text" name="recipientemail" size="48" value="<%=Util.blankIfNull(payment.recipientemail)%>"/></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="required">Payment Instructions Text<br/><textarea name="instructions" rows="8" cols="120"><%=Util.blankIfNull(payment.instructions)%></textarea></td>
    </tr>
    <tr>
      <td class="required">Payment Thank-You Text<br/><textarea name="thankyou" rows="8" cols="120"><%=Util.blankIfNull(payment.thankyou)%></textarea></td>
    </tr>
    <tr>
      <td align="center">
        <% if (payment.isDefault()) { %>
        <input type="submit" class="insert" name="insertpayment" value="Create New Payment Form"/>
        <% } else { %>
        <input type="submit" class="update" name="updatepayment" value="Update Payment"/>
        <input type="checkbox" name="confirmed" value="true"/>
        <input type="submit" class="delete" name="deletepayment" value="Delete Payment"/>
        <% } %>
      </td>
    </tr>
  </table>
</form>

<% 
  if (!payment.isDefault()) {

    PaymentOption[] paymentOptions = payment.getOptions(application);
    int numMax = paymentOptions.length + 1;
%>
<form method="post">
  <input type="hidden" name="payment_id" value="<%=payment.payment_id%>"/>
  <table cellspacing="0">
    <tr>
      <td valign="top" class="required">Num<br/><input type="text" size="2" name="num" value="<%=numMax%>"/></td>
      <td valign="top" class="required">Amount*<br/><input type="text" size="8" name="amount" value="0.00"/></td>
      <td valign="top" class="required">Name<br/><textarea name="name" rows="3" cols="50"></textarea></td>
      <td valign="top">Description<br/><textarea name="description" rows="3" cols="60"></textarea></td>
      <td><input type="submit" class="insert" name="insertoption" value="Insert"/></td>
    </tr>
  </table>
</form>

<hr/>

<% for (int i=0; i<paymentOptions.length; i++) { %>
  <form method="post">
    <input type="hidden" name="payment_id" value="<%=payment.payment_id%>"/>
    <input type="hidden" name="paymentoption_id" value="<%=paymentOptions[i].paymentoption_id%>"/>
    <table cellspacing="0">
      <tr>
        <td valign="top"><input type="text" size="2" name="num" value="<%=paymentOptions[i].num%>"/></td>
        <td valign="top"><input type="text" size="8" name="amount" value="<%=mf.format(paymentOptions[i].amount)%>"/></td>
        <td valign="top"><textarea name="name" rows="3" cols="50"><%=paymentOptions[i].name%></textarea></td>
        <td valign="top"><textarea name="description" rows="3" cols="60"><%=Util.blankIfNull(paymentOptions[i].description)%></textarea></td>
        <td>
          <input type="submit" class="update" name="updateoption" value="Update"/>
          <input type="checkbox" name="confirmed" value="true"/>
          <input type="submit" class="delete" name="deleteoption" value="Delete"/>
        </td>
      </tr>
    </table>
  </form>
  <% } %>

  <p>
    *Leave amount=0.00 to create a fill-in-amount option.
  </p>

  <%
  }
  %>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
