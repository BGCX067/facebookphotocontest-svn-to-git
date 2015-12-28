
<%
try
{
%>

<%@include file="header.jsp"%>

<div id="maincontent" class="fbgreybox">
	<h1>Welcome to Photo Contests!</h1> 
	<br /><br />
	<h2><a href="viewphotocontests.jsp?f=all" >View All the Photo Contests!</a></h2>
	<br />
	<h2><a href="makephotocontest.jsp" > Make a new Photo Contest! </a></h2>
</div>

<%@include file="footer.jsp"%>
<%
}
catch (Exception e)
{
	// out.println(e.toString()); // This is for debugging only.
	
	// Use below instead, if not debugging.
	%> 
	<jsp:forward page="error.jsp">
		<jsp:param value="general" name="error_type"/>
	</jsp:forward>
	<%
}
%>