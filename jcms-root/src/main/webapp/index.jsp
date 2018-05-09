<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/init.inc" %>
<% if (request.getParameter("printable")!=null) { %>
<%@ include file="/WEB-INF/include/head-printable.jhtml" %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header-printable.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader-printable.jhtml" %><% } %>
<%@ include file="/WEB-INF/include/main-printable.jhtml" %>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer-printable.jhtml" %><% } %>
<% } else { %>
<%@ include file="/WEB-INF/include/head.jhtml" %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header.jhtml" %><% } %>
<% if (showNavPrimary) { %><%@ include file="/WEB-INF/include/nav-primary.jhtml" %><% } %>
<% if (showNavPrimaryDhtml) { %><%@ include file="/WEB-INF/include/dhtml.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader.jhtml" %><% } %>
<%@ include file="/WEB-INF/include/main.jhtml" %>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer.jhtml" %><% } %>
<% } %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/foot.jhtml" %>
