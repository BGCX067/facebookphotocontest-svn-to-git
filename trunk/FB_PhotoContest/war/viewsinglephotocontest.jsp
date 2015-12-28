<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="org.fb_photocontest.*" %>

<%@include file="header.jsp" %>

<%
try
{
	// IPhotoContestApp pca = PhotoContestApp.getInstance(); -- Found in header.jsp
	// TFBCWrapper tfbcWrapper = new TFBCWrapper(request); -- Found in header.jsp
	
	String cid = request.getParameter("cid");
	
	if (cid == null)
	{
		%>
		<jsp:forward page="error.jsp">
			<jsp:param name="error_type" value="no_contest" />
		</jsp:forward>
		<%
	}
	
	int contestID = Integer.parseInt(cid);
	
	IContest contest = pca.getContest(contestID);
	
	if (contest == null)
	{
		%>
		<jsp:forward page="error.jsp">
			<jsp:param name="error_type" value="invalid_contest" />
		</jsp:forward>
		<%
	}

	Long hostID = contest.getHostID();
	
	String contestTitle = contest.getContestTitle();
	Date regDate = contest.getContestRegistrationDeadline();
	Date sScoreDate = contest.getContestStartDate();
	Date eScoreDate = contest.getContestEndDate();
	
	int pValues[] = contest.getPointValues();
	
	HashMap<String, Long> winners = null;
	Long firstUserID = null, secondUserID = null, thirdUserID = null;
	Double firstUserScore = 0.0, secondUserScore = 0.0, thirdUserScore = 0.0;
	Date now = new Date();
	boolean canScore = false;
	boolean contEnded = false;
	if (now.after(regDate) && now.before(eScoreDate))
		canScore = true;
	if (now.after(eScoreDate))
	{
		contEnded = true;
		winners = contest.getWinners();
	}
	
	if (winners != null)
	{
		firstUserID = winners.get("FirstPlace");
		secondUserID = winners.get("SecondPlace");
		thirdUserID = winners.get("ThirdPlace");
	}
	
	if (firstUserID == null)
		firstUserID = 0L;
	else
		firstUserScore = contest.getContestantFromID(firstUserID).getScore();

	if (secondUserID == null)
		secondUserID = 0L;
	else
		secondUserScore = contest.getContestantFromID(secondUserID).getScore();
	
	if (thirdUserID == null)
		thirdUserID = 0L;
	else
		thirdUserScore = contest.getContestantFromID(thirdUserID).getScore();
%>
	<div id="maincontent" class="fbgreybox">
		<div id="status_div"></div>
		<!-- start middle main content --> 
		<table id="middlecontenttable">
			<tr>
				<td id="middlecontenttitle" colspan="3">
					<h1><%= contestTitle %></h1>
					Hosted By:<fb:name uid="<%= hostID %>" ifcantsee="A Facebook User"></fb:name> 
					<br /><br />
					Prize Points: 1st - <%= pValues[0] %>pts.  2nd - <%= pValues[1] %>pts.  3rd - <%= pValues[2] %>pts.
				</td>
				<td id="action_buttons" colspan="1">
					<div style="float:right;">
						<fb:if-is-user uid="<%= hostID %>">
							<a href="modifyphotocontest.jsp?cid=<%= contestID %>"><input type="button" value="Modify Contest"></input></a>
						</fb:if-is-user>
						<%
							if (contest.getContestantFromID(Long.parseLong(tfbcWrapper.getCurUserFBID())) == null)
							{
								%><a href="photocontestapplication.jsp?cid=<%= contestID %>"><input type="button" value="Apply to Contest"></input></a><%
							}
						%>
					</div>
					<div style="float:right;">

					</div>
					<div style="clear:both;"></div>
				</td>
			</tr>
			<%
				if (contEnded && contest.hasAppliedPoints())
				{
			%>
					<tr>
						<td colspan="4">
							<h2>--This Contest has Ended--</h2>
							<h3>Congratulations to:</h3>
							<%
							if (contest.getScoringType() == IPhotoContestApp.ScoringType.RATING)
							{
							%>
								<b>&nbsp;&nbsp;&nbsp;1st - <fb:name uid="<%= firstUserID.toString() %>" ifcantsee="N/A"></fb:name> Final Rating: <%= firstUserScore %></b>
								<b>&nbsp;&nbsp;&nbsp;2nd - <fb:name uid="<%= secondUserID.toString() %>" ifcantsee="N/A"></fb:name> Final Rating: <%= secondUserScore %></b>
								<b>&nbsp;&nbsp;&nbsp;3rd - <fb:name uid="<%= thirdUserID.toString() %>" ifcantsee="N/A"></fb:name> Final Rating: <%= thirdUserScore %></b>
							<%
							}
							else
							{
							%>
								<b>&nbsp;&nbsp;&nbsp;1st - <fb:name uid="<%= firstUserID.toString() %>" ifcantsee="N/A"></fb:name> Total Votes: <%= firstUserScore.intValue() %></b>
								<b>&nbsp;&nbsp;&nbsp;2nd - <fb:name uid="<%= secondUserID.toString() %>" ifcantsee="N/A"></fb:name> Total Votes: <%= secondUserScore.intValue() %></b>
								<b>&nbsp;&nbsp;&nbsp;3rd - <fb:name uid="<%= thirdUserID.toString() %>" ifcantsee="N/A"></fb:name> Total Votes: <%= thirdUserScore.intValue() %></b>
							<%
							}
							%>
						</td>
					</tr>
					<br />
			<%
				}
			%>
			<tr>
				<th><p>Photo Contest Title</p></th>
				<th><p>Category</p></th>
				<th><p>Public</p></th>
				<th><p>Scoring Type</p></th>
			</tr>
			<tr>
				<td><p><%= contestTitle %></p></td>
				<td><p><%= contest.getCategory().getCategoryName() %></p></td>
				<td><p><%= contest.isContestOpenToPublic() %></p></td>
				<td><p><%= contest.getScoringType().name() %></p></td>

			</tr>					
			<tr>
				<th><p>Judges</p></th>
				<th><p>Registration Deadline</p></th>
				<th><p>Photo Contest Start Date</p></th>
				<th><p>Photo Contest End Date</p></th>
			</tr>
			<tr>
				<td><p>
				<% 
				if (contest.getHasJudges())
				{
					//out.print(contest.getJudges());
					List<Long> contestJudgesList = contest.getJudges();
					if(contestJudgesList != null && !contestJudgesList.isEmpty())
					{
						Iterator<Long> judgesItr = contestJudgesList.iterator();
						while(judgesItr.hasNext())
						{
							out.print(tfbcWrapper.getInfoFromUser(judgesItr.next(),"name")  + "<br />");
						}
					}						
				}
				else
				{
					out.print("None");
				}
				 %>
				</p></td>
				<td><p><fb:date t="<%= (regDate.getTime() / 1000) %>" format="monthname_year_time" /></p></td>
				<td><p><fb:date t="<%= (sScoreDate.getTime() / 1000) %>" format="monthname_year_time" /></p></td>
				<td><p><fb:date t="<%= (eScoreDate.getTime() / 1000) %>" format="monthname_year_time" /></p></td>					
			</tr>
			<tr>
				<th><p>Contest Message</p></th>
				<th><p>Tags</p></th>
				<th colspan="2"><p>Description</p></th>
			</tr>
			<tr>
				<td><p><%= contest.getMessage() %></p></td>
				<td><p><%= contest.getTags() %></p></td>
				<td colspan="2"><p><%= contest.getContestDescription() %></p></td>				
			</tr>					
						
		</table>
		
		<br /><b><u>Contestants</u></b><br /><br />	
		
		<table>
			<tr>
				<%
					for(int i=0; i<contest.getContestants().size(); i++)
					{
						IContestant cont = contest.getContestants().get(i);
						
						if (!cont.getAccepted())
							continue; // Not Accepted? Don't display this user's picture.
						
						Long pid = cont.getPhotoid();
						Long userID = cont.getFacebookuserid();
						Collection<Long> uids = new ArrayList<Long>();
						uids.add(userID);
						
						String URL = tfbcWrapper.getPhotoURL(pid, "src");
						Collection<String> names = tfbcWrapper.getInfoFromUsers(uids, "name");
						String name = names.toArray()[0].toString();
						
						String ePicTitle = cont.getPhotoTitle();
						String ePicDesc = cont.getDescription();
						String eBigURL = tfbcWrapper.getPhotoURL(pid, "src_big");
						String bigWidth = tfbcWrapper.getPhotoInfo(pid, "src_big_width");
						
						String type = "none";
						
						out.println("<fb:js-string var=\"picture_dialog.id" + i + "\">");
						out.println("	<div id=\"pic" + i + "\">");
						out.println("		<img name=\"" + ePicTitle + "\" src=\"" + eBigURL + "\"></img><br />");
						out.println("		<p><span id=\"pic_desc\">" + ePicDesc + "</span></p>");
						out.println("		<p><b><span id=\"user_name\">" + name + "</span></b></p>");
						out.println("	</div>");
						out.println("	<div id=\"score_form" + i + "\">");
						out.println("		<form id=\"sForm" + i + "\">");
						out.println("			<input type=\"hidden\" id=\"uid\" name=\"contestantsID\" value=\"" + userID + "\"/>");
						out.println("			<input type=\"hidden\" id=\"cid\" name=\"contestID\" value=\"" + contestID + "\"/>");
						
						if (canScore)
						{
							if (contest.getScoringType() == IPhotoContestApp.ScoringType.VOTING)
							{
								out.println("			<input type=\"hidden\" id=\"fake_rating\" name=\"rating\" value=\"1\"/>");
								type = "vote";
							}
							else
							{
								out.println("		 <div id=\"container\">" +
													"<div style=\"float:right; width:25px;\"><input type=\"radio\" name=\"rating\" value=\"5\"/><br/> 5</div>" +
													"<div style=\"float:right; width:25px;\"><input type=\"radio\" name=\"rating\" value=\"4\"/><br/> 4</div>" +
													"<div style=\"float:right; width:25px;\"><input type=\"radio\" name=\"rating\" value=\"3\"/><br/> 3</div>" +
													"<div style=\"float:right; width:25px;\"><input type=\"radio\" name=\"rating\" value=\"2\"/><br/> 2</div>" +
													"<div style=\"float:right; width:25px;\"><input type=\"radio\" name=\"rating\" value=\"1\"/><br/> 1</div>" +
													"<div style=\"clear:both;\"></div>" +
													"</div>");
								type = "rate";
							}
						}
						else
						{
							if (contEnded)
							{
								out.println("<div style=\"float:right;\"> **Note: Contest has ended. </div>");
							}
							else
							{
								out.println("<div style=\"float:right;\"> **Note: Rating/Voting period hasn't started. </div>");	
							}
							type = "none";
						}
						
						out.println("		</form>");
						out.println("	</div>");
						out.println("</fb:js-string>");
						
						String jsSafePicTitle = ePicTitle.replaceAll("'", "\\\\\\\'");
						String jsSafeName = name.replaceAll("'", "\\\\\\\'");
						
						out.println("<td align=\"center\" valign=\"baseline\">");
						out.println("<center><b>" + name + "</b><br/>");
						out.println("<a href=\"#\" onclick=\"return show_dialog(\'" + i + "\', \'"
																			 + jsSafeName + "\', \'"
																			 + bigWidth + "\', \'"
																			 + jsSafePicTitle + "\', \'"
																			 + type + "\', \'"
																			 + "sForm" + i + "\', \'"
																			 + "status_div" + "\')"
																			 + "\"><img src=\"" + URL + "\" name=\"" + ePicTitle + "\"></img></a></center>");
						if (contEnded)
						{
							out.println("<center><b>Score: " + cont.getScore() + "</b></center>");
						}
						out.println("</td>");
						
						if (i+1 % 5 == 0)
						{
							out.println("</tr>\n<tr>");
						}
						
					}
				%>
			</tr>
		</table>
	</div>	
<%
}
catch (Exception e)
{
	//out.println(e.toString()); // This is for debugging only.
	
	// Use below instead, if not debugging.
	%> 
	<jsp:forward page="error.jsp">
		<jsp:param value="general" name="error_type"/>
	</jsp:forward>
	<%
}
%>

<%@include file="footer.jsp" %>