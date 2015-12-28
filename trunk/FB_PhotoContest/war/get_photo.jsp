<%@page import="org.fb_photocontest.TFBCWrapper" %>

<%
	TFBCWrapper tfbcWrapper = new TFBCWrapper(request);

	String pid = request.getParameter("pid");
	
	out.println("<fb:photo pid=\"" + pid + "\" size=\"thumb\"></fb:photo>");
%>