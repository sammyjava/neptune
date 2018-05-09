<%
// form the extra secondary navigation
  if (extra_id!=0) {
    Extra e = new Extra(application, extra_id);
    pageTitle = e.name;
    int parent_id = 0;
    if (e.isPrimary()) {
      parent_id = e.extra_id;
      pageHeading = e.name;
      docUrl = e.docurl;
    } else {
      Extra parent = new Extra(application, e.parent_extra_id);
      parent_id = parent.extra_id;
      pageHeading = "<a href=\""+parent.cpurl+"\">"+parent.name+"</a>";
      docUrl = parent.docurl;
    }
    Extra[] children = Extra.getSecondary(application, parent_id);
    for (int i=0; i<children.length; i++) {
      if (cpuser.hasPermission(application, children[i])) {
	if (e.extra_id==children[i].extra_id) {
	  pageHeading += " | "+children[i].name;
	} else {
	  pageHeading += " | <a href=\""+children[i].cpurl+"\">"+children[i].name+"</a>";
	}
      }
    }
  }
%>
