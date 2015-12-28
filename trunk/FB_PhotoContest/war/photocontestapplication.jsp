<%@page contentType="text/html; charset=UTF-8"%>

<%@page import="java.util.Date"%>
<%@page import="java.lang.Exception"%>
<%@page import="org.fb_photocontest.IPhotoContestApp" %>
<%@page import="org.fb_photocontest.PhotoContestApp" %>
<%@page import="org.fb_photocontest.IContest" %>
<%@page import="org.fb_photocontest.FB_PhotoContestUtils" %>
<%@page import="org.fb_photocontest.TFBCWrapper" %>

<%@page import="net.sf.json.*" %>

<%
	String contestIDParam = request.getParameter("cid");
	int contestID = Integer.parseInt(contestIDParam);
	TFBCWrapper wrapper = new TFBCWrapper(request);
	IPhotoContestApp pp = PhotoContestApp.getInstance();
	IContest contest = pp.getContest(contestID);
	
	String uid = wrapper.getCurUserFBID();
	
	// Check to see if user has an album, if not create one and give error.
	String albumName = wrapper.getAlbumName();
	String albumDesc = wrapper.getAlbumDesc();
	String albumId = wrapper.getPhotoAlbumID(albumName, Long.parseLong(uid));
	if (albumId == null)
	{
		albumId = wrapper.createPhotoAlbum(albumName,albumDesc);
	}
%>

<%@include file="header.jsp" %>

<%
if (contestID == 0)	
{
	out.println("No Contest!");
}
else
{%>
	<div class="fbgreybox" style="width:600px; height:500px;">
	<!--<form enctype="multipart/form-data" name="contest_info" action="http://api.facebook.com/restserver.php" method="POST" > enctype="multipart/form-data" -->	
	<form id="apply_form" name="contest_info" action="http://cs410-facebookphotocontest.appspot.com/applytophotocontest.jsp?cid=<%= contestIDParam %>&uid=<%= uid %>&session=<%= wrapper.getSessionKey() %>" method="POST" >
			
	<table id="middlecontenttable">
		<tr>
			<td id="middlecontenttitle" colspan="2"><h1>Apply to a Photo Contest</h1></td>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Contest Name:</h2></td>
			<td class="middlecontentinput"><P><%= contest.getContestTitle() %></P></td>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Number of Contestants:</h2></td>
			<td class="middlecontentinput"><p><%= contest.getContestants().size() %></p></td>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Photo Contest Category:</h2></td>
			<td class="middlecontentinput"><p><%= contest.getCategory().getCategoryName() %></p>
			</td>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Contest Scoring Options:</h2></td>
			<td class="middlecontentinput"><p><%= contest.getScoringType() %></p></td>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Registration Deadline:</h2></td>
			<td class="middlecontentinput"><fb:date t="<%= (contest.getContestRegistrationDeadline().getTime() / 1000) %>" format="monthname_year_time" /></td>
		</tr>	
		<tr>
			<td class="middlecontestfields"><h2>Photo Contest Start Date/Time:</h2></td>
			<td class="middlecontentinput"><fb:date t="<%= (contest.getContestStartDate().getTime() / 1000) %>" format="monthname_year_time" /></td>
		</tr>		
		<tr>
			<td class="middlecontestfields"><h2>Photo Contest End Date/Time:</h2></td>

			<td class="middlecontentinput"><fb:date t="<%= (contest.getContestEndDate().getTime() / 1000) %>" format="monthname_year_time" /></td>
		</tr>
		<tr>
			<div id="picdisplay"></div>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Choose a photo (Enter PID):</h2></td>
			<td class="middlecontentinput">
				<select id="pid_drop" name="pid" onchange="return display_photo('picdisplay', 'apply_form');">
				<% 
				
				try {	
					JSONArray array = wrapper.fqlQuery("SELECT pid FROM photo WHERE aid="+albumId);
					int count = array.size();
					
					for (int i = 0; i < count; i++)
					{
						JSONObject object = array.getJSONObject(i);
						String pid = object.getString("pid");
						
						out.println("<option value=\""+pid+"\">"+pid+"</option>");
					}
				} catch (Exception ex)
				{
					
					out.println("Exception: "+ex.getMessage());
				}
				%>
					
				</select>
			</td>
		</tr>					
		<tr>
			<td class="middlecontestfields"><h2>Title</h2></td>
			<td class="middlecontentinput"><input name="title" type="text" size=30 value=""/></td>
		</tr>
		<tr>
			<td class="middlecontestfields"><h2>Description</h2></td>
			<td class="middlecontentinput"><input name="description" type="text" size=50 value=""/></td>
		</tr>
		<tr>
			<td id="middlesubmitphoto" colspan="2">
				<input type="submit" name="Submit" value="Submit"/>
			</td>
		</tr>
	</table>
	</form>
	
</div>	
<% }%>

<%@include file="footer.jsp"%>