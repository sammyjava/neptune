<?xml version="1.0" encoding="UTF-8" ?>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, java.util.*, java.io.*" %>
<urlset
      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
<%
    // use UTC for W3C datetime format
    java.text.SimpleDateFormat w3c = new java.text.SimpleDateFormat("yyyy-MM-dd");
    java.sql.Timestamp lastModified = null;
    
    // only show nodes that public (default access user) can see
    AccessUser au = Util.getDefaultAccessUser(application);

    // disable access calls if not in use
    boolean accessEnabled = AccessRole.nodeCount(application)>0;
    
    // need SSL host for SSL pages
    String sslHost = Setting.getString(application,"site_sslhost");
    
    // level 0
    Node root = new Node(application, 0);
    String url = root.url;
    NodeLink nl = root.getCurrentNodeLink(application);
    if (nl!=null && nl.isPage()) {
      lastModified = nl.getPage(application).lastModified(application);
%>
  <url>
    <loc>http://<%=request.getServerName()%><%=application.getContextPath()%>/</loc>
    <% if (lastModified!=null) { %><lastmod><%=w3c.format(lastModified)%></lastmod><% } %>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
<%
  }
  // level 1
  NodeListIterator rootIterator = root.getNodeListIterator(application);
  while (rootIterator.hasNext()) {
    Node l1 = rootIterator.nextNode();
    if (l1.isVisible() && (!accessEnabled || au.mayAccess(application,l1))) {
      if (l1.url.length()>4 && l1.url.substring(0,4).toLowerCase().equals("http")) {
        url = l1.url;
      } else if (l1.ssl) {
        url = "https://"+sslHost+application.getContextPath()+l1.url;
      } else {
        url = "http://"+request.getServerName()+application.getContextPath()+l1.url;
      }
      nl = l1.getCurrentNodeLink(application);
      if (nl!=null && nl.isPage()) {
        lastModified = nl.getPage(application).lastModified(application);
%>
  <url>
    <loc><%=url%></loc>
    <% if (lastModified!=null) { %><lastmod><%=w3c.format(lastModified)%></lastmod><% } %>
    <changefreq>daily</changefreq>
    <priority>0.9</priority>
  </url>
<%
  }
  // level 2
  NodeListIterator l1Iterator = l1.getNodeListIterator(application);
  while (l1Iterator.hasNext()) {
    Node l2 = l1Iterator.nextNode();
    if (l2.isVisible() && (!accessEnabled || au.mayAccess(application,l2))) {
      if (l2.url.length()>4 && l2.url.substring(0,4).toLowerCase().equals("http")) {
        url = l2.url;
      } else if (l2.ssl) {
        url = "https://"+sslHost+application.getContextPath()+l2.url;
      } else {
        url = "http://"+request.getServerName()+application.getContextPath()+l2.url;
      }
      nl = l2.getCurrentNodeLink(application);
      if (nl!=null && nl.isPage()) {
        lastModified = nl.getPage(application).lastModified(application);
%>
  <url>
    <loc><%=url%></loc>
    <% if (lastModified!=null) { %><lastmod><%=w3c.format(lastModified)%></lastmod><% } %>
    <changefreq>daily</changefreq>
    <priority>0.8</priority>
  </url>
<%
  }
  // level 3
  NodeListIterator l2Iterator = l2.getNodeListIterator(application);
  while (l2Iterator.hasNext()) {
    Node l3 = l2Iterator.nextNode();
    if (l3.isVisible() && (!accessEnabled || au.mayAccess(application,l3))) {
      if (l3.url.length()>4 && l3.url.substring(0,4).toLowerCase().equals("http")) {
        url = l3.url;
      } else if (l3.ssl) {
        url = "https://"+sslHost+application.getContextPath()+l3.url;
      } else {
        url = "http://"+request.getServerName()+application.getContextPath()+l3.url;
      }
      nl = l3.getCurrentNodeLink(application);
      if (nl!=null && nl.isPage()) {
        lastModified = nl.getPage(application).lastModified(application);
%>
  <url>
    <loc><%=url%></loc>
    <% if (lastModified!=null) { %><lastmod><%=w3c.format(lastModified)%></lastmod><% } %>
    <changefreq>daily</changefreq>
    <priority>0.7</priority>
  </url>
<%
  }
  // level 4
  NodeListIterator l3Iterator = l3.getNodeListIterator(application);
  while (l3Iterator.hasNext()) {
    Node l4 = l3Iterator.nextNode();
    if (l4.isVisible() && (!accessEnabled || au.mayAccess(application,l4))) {
      if (l4.url.length()>4 && l4.url.substring(0,4).toLowerCase().equals("http")) {
        url = l4.url;
      } else if (l4.ssl) {
	url = "https://"+sslHost+application.getContextPath()+l4.url;
      } else {
	url = "http://"+request.getServerName()+application.getContextPath()+l4.url;
      }
      nl = l4.getCurrentNodeLink(application);
      if (nl!=null && nl.isPage()) {
        lastModified = nl.getPage(application).lastModified(application);
%>
  <url>
    <loc><%=url%></loc>
    <% if (lastModified!=null) { %><lastmod><%=w3c.format(lastModified)%></lastmod><% } %>
    <changefreq>daily</changefreq>
    <priority>0.6</priority>
  </url>
<%
    }
  } // if l4 public
} // level 4
} // if level 3 public
} // level 3
} // if level 2 public
} // level 2
} // if level 1 public
} // level 1
%>
</urlset>
