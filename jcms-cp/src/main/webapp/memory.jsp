<%@ page import="java.lang.management.ManagementFactory,java.lang.management.MemoryPoolMXBean" %>
<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "JVM Memory Monitor"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

    <table>
      <tr>
        <td colspan="2" align="center"><h3>Memory MXBean</h3></td>
      </tr>
      <tr>
        <td width="200">Heap Memory Usage</td>
        <td><%=ManagementFactory.getMemoryMXBean().getHeapMemoryUsage()%></td>
      </tr>
      <tr>
        <td>Non-Heap Memory Usage</td>
        <td><%=ManagementFactory.getMemoryMXBean().getNonHeapMemoryUsage()%></td>
      </tr>
      <tr>
        <td colspan="2" align="center"><h3>Memory Pool MXBeans</h3></td>
      </tr>
      <%
        Iterator iter = ManagementFactory.getMemoryPoolMXBeans().iterator();
        while (iter.hasNext()) {
          MemoryPoolMXBean item = (MemoryPoolMXBean) iter.next();
      %>
      <tr>
        <td colspan="2">
          <table class="borders" width="100%">
            <tr>
              <td colspan="2" align="center"><b><%=item.getName()%></b></td>
            </tr>
            <tr>
              <td width="200">Type</td>
              <td><%=item.getType()%></td>
            </tr>
            <tr>
              <td>Usage</td><td><%=item.getUsage()%></td>
            </tr>
            <tr>
              <td>Peak Usage</td><td><%=item.getPeakUsage()%></td>
            </tr>
            <tr>
              <td>Collection Usage</td><td><%=item.getCollectionUsage()%></td>
            </tr>
          </table>
        </td>
      </tr>
      <%
      }
      %>
    </table>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
