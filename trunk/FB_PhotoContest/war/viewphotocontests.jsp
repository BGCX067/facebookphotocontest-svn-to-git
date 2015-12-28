<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="org.fb_photocontest.IContest"%>

<%
try
{
%>
<%@include file="header.jsp" %>
<%
	final int NUM_RESULTS_PER_PAGE = 50;

	// IPhotoContestApp pca = PhotoContestApp.getInstance(); -- found in Header.jsp
	List<IContest> contests = null;
	
	
	/*
	Determine which set of contests the user wants to view.
		filter = all => show all contests, including closed ones.
		filter = join => show contests that are joinable (i.e. registration is active)
		filter = score => show contests that are open for scoring.
	*/
	String filter;
	try
	{
		filter = request.getParameter("f");
		if (filter == null)
			filter = "all";
	}
	catch(Exception e)
	{
		filter = "all";
	}
	
	if (filter.equalsIgnoreCase("join"))
	{
		contests = pca.getOpenContests(null, NUM_RESULTS_PER_PAGE);
	}
	else if (filter.equalsIgnoreCase("score"))
	{
		contests = pca.getScorableContests(null, NUM_RESULTS_PER_PAGE);
	}
	else
	{
		contests = pca.getContests();
	}

%>
		<div id="maincontent" class="fbgreybox">
			<!-- start middle main content -->
			<table id="middlecontenttable">
				<tr>
					<td id="middlecontenttitle" colspan="7"><h1>Photo Contests</h1></td>
				</tr>				
				
				<tr>
					<th><p>Photo Contest Title</p></th>
					<th><p>Category</p></th>
					<th><p>Number of Contestants</p></th>
					<th><p>Scoring Type</p></th>
					<th><p>Registration Start Date</p></th>
					<th><p>Photo Contest Start Date</p></th>
					<th><p>Photo Contest End Date</p></th>
				</tr>
				<!-- start append your photo contest here -->
<%
	/*
	Loop through the set of contests and display it to the user.
	*/
	for (IContest contest: contests) 
	{
%>
				<tr>
					<td><a href=<%= "\"viewsinglephotocontest.jsp?cid=" + contest.getContestID().toString() + "\"" %>><p><%= contest.getContestTitle() %></p></a></td>
					<td><p><%= contest.getCategory().getCategoryName() %></p></td>
					<td><p><%= contest.getNumAccepted() %></p></td>
					<td><p><%= contest.getScoringType().name() %></p></td>
					<td><p><fb:date t="<%= (contest.getContestRegistrationDeadline().getTime() / 1000) %>" format="monthname_year_time" /></p></td>
					<td><p><fb:date t="<%= (contest.getContestStartDate().getTime() / 1000) %>" format="monthname_year_time" /></p></td>
					<td><p><fb:date t="<%= (contest.getContestEndDate().getTime() / 1000) %>" format="monthname_year_time" /></p></td>
				</tr>
<% 
	}	
%>	
				<!-- end append your photo contest here -->
			</table>
		</div>
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
<%@include file="footer.jsp" %>