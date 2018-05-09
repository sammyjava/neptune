<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=5; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<a href="SearchBloxUserGuideV4.pdf"><b>User Guide</b></a><br/>
<iframe src="/searchblox/admin/main.jsp" width="850" height="600"></iframe>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
