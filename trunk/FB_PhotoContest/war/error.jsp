<%@page import="org.fb_photocontest.FB_PhotoContestUtils" %>

<%
String type = request.getParameter("error_type");

FB_PhotoContestUtils.ErrType err;

try
{
	err = FB_PhotoContestUtils.ErrType.valueOf(type);
}
catch (Exception e)
{
	err = FB_PhotoContestUtils.ErrType.general;
}

switch (err){
	case not_logged_in:
		out.println("<fb:error message=\"You must be logged in to use Photo Contests!\" />");
		break;

	case no_permission:
		out.println("<fb:error message=\"Before you can use Photo Contests! You must grant the proper permissions\" />" + 
					"<br /><br />" + 
					"<form promptpermission=\"read_stream,publish_stream\">" +
						"<input type=\"submit\" value=\"Click to Grant Permissions\" />" +
					"</form>");
		break;
		
	case no_contest:
		out.println("<fb:error>" +
						"<fb:message> Error: No Contest! </fb:message>" +
						"No Contest Selected, <a href=\"viewphotocontests.jsp\"> Click Here to View All Contests... </a>" +
					"</fb:error>");
		break;
		
	case invalid_contest:
		out.println("<fb:error>" +
						"<fb:message> Error: Invalid Contest! </fb:message>" +
						"Uh oh! That contest doesn't exist. <a href=\"viewphotocontests.jsp\"> Click Here to View All Contests... </a>" +
					"</fb:error>");
		break;
		
	case not_host:
		out.println("<fb:error message=\"" + "Cannot Modify Contest, You're not the Host of this Contest" + "\" />");
		break;
		
	case under_construction:
		out.println("<fb:error>" +
						"<fb:message> Sorry, Page is Under Construction! </fb:message>" +
						"<a href=\"index.jsp\"> Go to Homepage... </a>" +
					"</fb:error>");
		break;
		
	case invalid_photo:
		out.println("<fb:error>" +
						"<fb:message> Error: You entered an invalid photo. </fb:message>" +
						"<a href=\"index.jsp\"> Go to Homepage... </a>" +
					"</fb:error>");
		break;
		
	default:
		out.println("<fb:error>" +
						"<fb:message> ERROR! </fb:message>" +
						"Sorry, an error has occured, please try again later!" +
					"</fb:error>");
}

return;
%>