<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.lang.Exception"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="org.fb_photocontest.*"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%
try
{
	
%>
<%@include file="header.jsp" %>
<%@include file="calendar.jsp" %>
<%
	// IPhotoContestApp pca = PhotoContestApp.getInstance(); -- found in header.jsp	
	// TFBCWrapper tfbcWrapper = new TFBCWrapper(request); found in header.jsp
	
	// if contest id is null, then redirect to the error page
	String cid = request.getParameter("cid");
	if (cid == null)
	{
		%>
			<jsp:forward page="error.jsp">
				<jsp:param name="error_type" value="no_contest"/>
			</jsp:forward>
		<%
	}
	
	int contestID = Integer.parseInt(request.getParameter("cid"));
	
	IContest contest = pca.getContest(contestID);
	
	// if contest retrieved from contest id is null, then redirect to the error page
	if (contest == null)
	{
		%>
			<jsp:forward page="error.jsp">
				<jsp:param name="error_type" value="invalid_contest"/>
			</jsp:forward>
		<%
	}
	
	// if contest host id is not equal to the current user, then redirect to the error page
	if (contest.getHostID() != Long.parseLong(tfbcWrapper.getCurUserFBID()))
	{
		%>
		<jsp:forward  page="error.jsp">
			<jsp:param value="error_type" name="not_host"/>
		</jsp:forward>
		<%
	}
	
	// set the date format
	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
	Date currDate = new Date();
%>
		<div id="maincontent" class="fbgreybox">
<%
	// display any errors from modifying the photo contest
	// check if there was an error message from processing some function
	if(request.getParameter("error_msg") != null)
	{
		// date logic error + missing required inputs
		if(request.getParameter("error_msg").equals("datetexterror"))
		{
			out.print("<fb:error>"+
						"<fb:message>");
			out.print("Failed: Photo Contest dates are incorrect.<br />"+
						"Please make sure all dates are valid.<br />"+
						"Please make sure the Registration End Date is one day after today's day.<br />"+
						"Please make sure the Registration End Date is before the Contest Start Date.<br />"+
						"Please make sure the Contest Start Date is before the Contest End Date.<br />" +
						"Please make sure all the required input text fields are filled in.<br />");
			out.print("</fb:message>"+
						"</fb:error>");			
		}
		// date logic error
		else if(request.getParameter("error_msg").equals("dateerror"))
		{
			out.print("<fb:error>"+
						"<fb:message>");
			out.print("Failed: Photo Contest dates are incorrect.<br />"+
						"Please make sure all dates are valid.<br />"+
						"Please make sure the Registration End Date is one day after today's day.<br />"+
						"Please make sure the Registration End Date is before the Contest Start Date.<br />"+
						"Please make sure the Contest Start Date is before the Contest End Date.<br />");
			out.print("</fb:message>"+
						"</fb:error>");			
		}
		// missing required inputs
		else if(request.getParameter("error_msg").equals("texterror"))
		{
			out.print("<fb:error>"+
						"<fb:message>");
			out.print("Failed: Please make sure all the required input text fields are filled in.<br />");
			out.print("</fb:message>"+
						"</fb:error>");			
		}		
	}
%>		

		<fb:editor action="savemodifiedphotocontest.jsp" width="600">			
		<input type="hidden" name="cid" value="<%= contestID %>" />			
		<table id="middlecontenttable">			
			<tr>
				<th><p>Photo Contest Title</p></th>
				<th><p>Category</p></th>
				<th><p>Public</p></th>
				<th><p>Uses Judges</p></th>
				<th><p>Scoring Type</p></th>
				<th><p>Tags</p></th>
			</tr>
			<tr>
				<td><p><%= contest.getContestTitle() %></p></td>
				<td><p><%= contest.getCategory().getCategoryName() %></p></td>
				<td><p><%= contest.isContestOpenToPublic() %></p></td>
				<td><p><%= contest.getHasJudges() %></p></td>
				<td><p><%= contest.getScoringType().name() %></p></td>
				<td><p>
<% 
	// iterate through all the tags
	List<String> listTags = contest.getTags(); 
	Iterator<String> tagsItr = listTags.iterator();
	
	while(tagsItr.hasNext())
	{
		out.print(tagsItr.next() + ", ");
	}
%>					
				</p></td>
			</tr>
<%
// check if the current date is after the registeration date
// if so, we need to display registeration, contest start, contest end,
// description
if(currDate.after(contest.getContestRegistrationDeadline()))
{
%>			
			<tr>
				<th><p>Registration Date & Time</p></th>
				<th><p>Contest Start Date & Time</p></th>
				<th><p>Contest End Date & Time</p></th>
				<th><p>Description</p></th>
				<th><p>Judges</p></th>
				<th><p>
<%
// check if the current date is after the contest end date
// if so, we need to display the note
if(currDate.after(contest.getContestEndDate()))
{
%>
				Note
<%
}
%>									</p></th>
			</tr>
			<tr>
				<td><p><%= contest.getContestRegistrationDeadline().toString() %></p></td>
				<td><p><%= contest.getContestStartDate().toString() %></p></td>
				<td><p><%= contest.getContestEndDate().toString() %></p></td>
				<td><p><%= contest.getContestDescription() %></p></td>
				<td><p>
<% 
// if contest has judges, iterate through them and print out their names
if (contest.getHasJudges())
{
	List<Long> listJudges = contest.getJudges(); 
	if(listJudges != null && !listJudges.isEmpty())
	{
		Iterator<Long> judgesItr = listJudges.iterator();
		while(judgesItr.hasNext())
		{
			out.print(tfbcWrapper.getInfoFromUser(judgesItr.next(),"name")  + "<br />");
		}
	}
}
else
{
	out.print("NO JUDGES");
}
%>					
				</p></td>
				<td><p>
<%
if(currDate.after(contest.getContestEndDate()))
{
%>
				<%= contest.getMessage() %>
<%
}
%>						
				</p></td>
			</tr>
<%
}
%>	
		</table>
		<br /><br />			
		<table>

<%
//check if the current date is after the registeration date
//if so, we need to allow judges, registeration, contest start, contest end,
//description editing
if(currDate.before(contest.getContestRegistrationDeadline()))
{
%>

<%
	// show the judge's textbox only if there is judges for the photo contest
	if(contest.getHasJudges())
	{
%>								
			<tr>	
				<td>
					<p style="color:#666666; font-weight:bold; padding:0px;">Judges:</p>
				</td>
				<td>
					<fb:multi-friend-input name="contest_judges" width="250px" border_color="#8496ba" 
<%
		//prefill_ids of the judges
		List<Long> contestJudgesList = contest.getJudges();
		if(contestJudgesList != null && !contestJudgesList.isEmpty())
		{
			
			out.print("prefill_ids=\"");
			Iterator judgesItr = contestJudgesList.iterator();
			while(judgesItr.hasNext())
			{
				out.print(judgesItr.next().toString() + ",");
			}
			out.print("\"");
		}				
%>
					/>				
				</td>
			</tr>
<%
	}
	// get the registeration time
	Calendar now = Calendar.getInstance();
	Date registEndDate = contest.getContestRegistrationDeadline();
	now.setTime(registEndDate);
%>
			<tr>
				<td>
					<b style="color:#666666;">* Registration End Date: </b>
				</td>
				<td>
					<div>
					<select name="register_end_month" id="register_end_Month" class="monthselect">
					    <option value="1" <% if(now.get(Calendar.MONTH)==0){ out.print("selected");} %>>01</option>
					    <option value="2" <% if(now.get(Calendar.MONTH)==1){ out.print("selected");} %>>02</option>
					    <option value="3" <% if(now.get(Calendar.MONTH)==2){ out.print("selected");} %>>03</option>
					    <option value="4" <% if(now.get(Calendar.MONTH)==3){ out.print("selected");} %>>04</option>
					    <option value="5" <% if(now.get(Calendar.MONTH)==4){ out.print("selected");} %>>05</option>
					    <option value="6" <% if(now.get(Calendar.MONTH)==5){ out.print("selected");} %>>06</option>
					    <option value="7" <% if(now.get(Calendar.MONTH)==6){ out.print("selected");} %>>07</option>
					    <option value="8" <% if(now.get(Calendar.MONTH)==7){ out.print("selected");} %>>08</option>
					    <option value="9" <% if(now.get(Calendar.MONTH)==8){ out.print("selected");} %>>09</option>
					    <option value="10" <% if(now.get(Calendar.MONTH)==9){ out.print("selected");} %>>10</option>
					    <option value="11" <% if(now.get(Calendar.MONTH)==10){ out.print("selected");} %>>11</option>
					    <option value="12" <% if(now.get(Calendar.MONTH)==11){ out.print("selected");} %>>12</option>
					</select>
					<select name="register_end_day" id="register_end_Day" class="dayselect" >
					    <option value="1" <% if(now.get(Calendar.DAY_OF_MONTH)==1){ out.print("selected");} %>>01</option>
					    <option value="2" <% if(now.get(Calendar.DAY_OF_MONTH)==2){ out.print("selected");} %>>02</option>
					    <option value="3" <% if(now.get(Calendar.DAY_OF_MONTH)==3){ out.print("selected");} %>>03</option>
					    <option value="4" <% if(now.get(Calendar.DAY_OF_MONTH)==4){ out.print("selected");} %>>04</option>
					    <option value="5" <% if(now.get(Calendar.DAY_OF_MONTH)==5){ out.print("selected");} %>>05</option>
					    <option value="6" <% if(now.get(Calendar.DAY_OF_MONTH)==6){ out.print("selected");} %>>06</option>
					    <option value="7" <% if(now.get(Calendar.DAY_OF_MONTH)==7){ out.print("selected");} %>>07</option>
					    <option value="8" <% if(now.get(Calendar.DAY_OF_MONTH)==8){ out.print("selected");} %>>08</option>
					    <option value="9" <% if(now.get(Calendar.DAY_OF_MONTH)==9){ out.print("selected");} %>>09</option>
					    <option value="10" <% if(now.get(Calendar.DAY_OF_MONTH)==10){ out.print("selected");} %>>10</option>
					    <option value="11" <% if(now.get(Calendar.DAY_OF_MONTH)==11){ out.print("selected");} %>>11</option>
					    <option value="12" <% if(now.get(Calendar.DAY_OF_MONTH)==12){ out.print("selected");} %>>12</option>
					    <option value="13" <% if(now.get(Calendar.DAY_OF_MONTH)==13){ out.print("selected");} %>>13</option>
					    <option value="14" <% if(now.get(Calendar.DAY_OF_MONTH)==14){ out.print("selected");} %>>14</option>
					    <option value="15" <% if(now.get(Calendar.DAY_OF_MONTH)==15){ out.print("selected");} %>>15</option>
					    <option value="16" <% if(now.get(Calendar.DAY_OF_MONTH)==16){ out.print("selected");} %>>16</option>
					    <option value="17" <% if(now.get(Calendar.DAY_OF_MONTH)==17){ out.print("selected");} %>>17</option>
					    <option value="18" <% if(now.get(Calendar.DAY_OF_MONTH)==18){ out.print("selected");} %>>18</option>
					    <option value="19" <% if(now.get(Calendar.DAY_OF_MONTH)==19){ out.print("selected");} %>>19</option>
					    <option value="20" <% if(now.get(Calendar.DAY_OF_MONTH)==20){ out.print("selected");} %>>20</option>
					    <option value="21" <% if(now.get(Calendar.DAY_OF_MONTH)==21){ out.print("selected");} %>>21</option>
					    <option value="22" <% if(now.get(Calendar.DAY_OF_MONTH)==22){ out.print("selected");} %>>22</option>
					    <option value="23" <% if(now.get(Calendar.DAY_OF_MONTH)==23){ out.print("selected");} %>>23</option>
					    <option value="24" <% if(now.get(Calendar.DAY_OF_MONTH)==24){ out.print("selected");} %>>24</option>
					    <option value="25" <% if(now.get(Calendar.DAY_OF_MONTH)==25){ out.print("selected");} %>>25</option>
					    <option value="26" <% if(now.get(Calendar.DAY_OF_MONTH)==26){ out.print("selected");} %>>26</option>
					    <option value="27" <% if(now.get(Calendar.DAY_OF_MONTH)==27){ out.print("selected");} %>>27</option>
					    <option value="28" <% if(now.get(Calendar.DAY_OF_MONTH)==28){ out.print("selected");} %>>28</option>
					    <option value="29" <% if(now.get(Calendar.DAY_OF_MONTH)==29){ out.print("selected");} %>>29</option>
					    <option value="30" <% if(now.get(Calendar.DAY_OF_MONTH)==30){ out.print("selected");} %>>30</option>
					    <option value="31" <% if(now.get(Calendar.DAY_OF_MONTH)==31){ out.print("selected");} %>>31</option>
					</select>						
					<select name="register_end_year" id="register_end_Year" class="yearselect">
					    <option value="2009" <% if(now.get(Calendar.YEAR)==2009){ out.print("selected");} %>>2009</option>
					    <option value="2010" <% if(now.get(Calendar.YEAR)==2010){ out.print("selected");} %>>2010</option>
					    <option value="2011" <% if(now.get(Calendar.YEAR)==2011){ out.print("selected");} %>>2011</option> 
						<option value="2012" <% if(now.get(Calendar.YEAR)==2012){ out.print("selected");} %>>2012</option>
					</select>
					<img src="http://cs410-facebookphotocontest.appspot.com/images/calender.gif" onclick="var Cal = startCal(true); Cal.show(this,'register_end_'); return true;" id="StartDate" style="cursor: pointer;" />
					</div>											
				</td>
			</tr>			
			<tr>
				<td colspan="2">
					<fb:editor-time label="*Registration End Time" name="register_end_time" value="<%  

	Long registEndLong = new Long(registEndDate.getTime()/1000);
	out.print(registEndLong.intValue());
%>" />
				</td>
			</tr>				
<%  
	//get the contest start time
	Date contStartDate = contest.getContestStartDate();
	now.setTime(contStartDate);
%>
			<tr>
				<td>
					<b style="color:#666666;">* Start Contest Date: </b>
				</td>
				<td>
					<div>
					<select name="start_contest_month" id="start_contest_Month" class="monthselect">
					    <option value="1" <% if(now.get(Calendar.MONTH)==0){ out.print("selected");} %>>01</option>
					    <option value="2" <% if(now.get(Calendar.MONTH)==1){ out.print("selected");} %>>02</option>
					    <option value="3" <% if(now.get(Calendar.MONTH)==2){ out.print("selected");} %>>03</option>
					    <option value="4" <% if(now.get(Calendar.MONTH)==3){ out.print("selected");} %>>04</option>
					    <option value="5" <% if(now.get(Calendar.MONTH)==4){ out.print("selected");} %>>05</option>
					    <option value="6" <% if(now.get(Calendar.MONTH)==5){ out.print("selected");} %>>06</option>
					    <option value="7" <% if(now.get(Calendar.MONTH)==6){ out.print("selected");} %>>07</option>
					    <option value="8" <% if(now.get(Calendar.MONTH)==7){ out.print("selected");} %>>08</option>
					    <option value="9" <% if(now.get(Calendar.MONTH)==8){ out.print("selected");} %>>09</option>
					    <option value="10" <% if(now.get(Calendar.MONTH)==9){ out.print("selected");} %>>10</option>
					    <option value="11" <% if(now.get(Calendar.MONTH)==10){ out.print("selected");} %>>11</option>
					    <option value="12" <% if(now.get(Calendar.MONTH)==11){ out.print("selected");} %>>12</option>
					</select>
					<select name="start_contest_day" id="start_contest_Day" class="dayselect" >
					    <option value="1" <% if(now.get(Calendar.DAY_OF_MONTH)==1){ out.print("selected");} %>>01</option>
					    <option value="2" <% if(now.get(Calendar.DAY_OF_MONTH)==2){ out.print("selected");} %>>02</option>
					    <option value="3" <% if(now.get(Calendar.DAY_OF_MONTH)==3){ out.print("selected");} %>>03</option>
					    <option value="4" <% if(now.get(Calendar.DAY_OF_MONTH)==4){ out.print("selected");} %>>04</option>
					    <option value="5" <% if(now.get(Calendar.DAY_OF_MONTH)==5){ out.print("selected");} %>>05</option>
					    <option value="6" <% if(now.get(Calendar.DAY_OF_MONTH)==6){ out.print("selected");} %>>06</option>
					    <option value="7" <% if(now.get(Calendar.DAY_OF_MONTH)==7){ out.print("selected");} %>>07</option>
					    <option value="8" <% if(now.get(Calendar.DAY_OF_MONTH)==8){ out.print("selected");} %>>08</option>
					    <option value="9" <% if(now.get(Calendar.DAY_OF_MONTH)==9){ out.print("selected");} %>>09</option>
					    <option value="10" <% if(now.get(Calendar.DAY_OF_MONTH)==10){ out.print("selected");} %>>10</option>
					    <option value="11" <% if(now.get(Calendar.DAY_OF_MONTH)==11){ out.print("selected");} %>>11</option>
					    <option value="12" <% if(now.get(Calendar.DAY_OF_MONTH)==12){ out.print("selected");} %>>12</option>
					    <option value="13" <% if(now.get(Calendar.DAY_OF_MONTH)==13){ out.print("selected");} %>>13</option>
					    <option value="14" <% if(now.get(Calendar.DAY_OF_MONTH)==14){ out.print("selected");} %>>14</option>
					    <option value="15" <% if(now.get(Calendar.DAY_OF_MONTH)==15){ out.print("selected");} %>>15</option>
					    <option value="16" <% if(now.get(Calendar.DAY_OF_MONTH)==16){ out.print("selected");} %>>16</option>
					    <option value="17" <% if(now.get(Calendar.DAY_OF_MONTH)==17){ out.print("selected");} %>>17</option>
					    <option value="18" <% if(now.get(Calendar.DAY_OF_MONTH)==18){ out.print("selected");} %>>18</option>
					    <option value="19" <% if(now.get(Calendar.DAY_OF_MONTH)==19){ out.print("selected");} %>>19</option>
					    <option value="20" <% if(now.get(Calendar.DAY_OF_MONTH)==20){ out.print("selected");} %>>20</option>
					    <option value="21" <% if(now.get(Calendar.DAY_OF_MONTH)==21){ out.print("selected");} %>>21</option>
					    <option value="22" <% if(now.get(Calendar.DAY_OF_MONTH)==22){ out.print("selected");} %>>22</option>
					    <option value="23" <% if(now.get(Calendar.DAY_OF_MONTH)==23){ out.print("selected");} %>>23</option>
					    <option value="24" <% if(now.get(Calendar.DAY_OF_MONTH)==24){ out.print("selected");} %>>24</option>
					    <option value="25" <% if(now.get(Calendar.DAY_OF_MONTH)==25){ out.print("selected");} %>>25</option>
					    <option value="26" <% if(now.get(Calendar.DAY_OF_MONTH)==26){ out.print("selected");} %>>26</option>
					    <option value="27" <% if(now.get(Calendar.DAY_OF_MONTH)==27){ out.print("selected");} %>>27</option>
					    <option value="28" <% if(now.get(Calendar.DAY_OF_MONTH)==28){ out.print("selected");} %>>28</option>
					    <option value="29" <% if(now.get(Calendar.DAY_OF_MONTH)==29){ out.print("selected");} %>>29</option>
					    <option value="30" <% if(now.get(Calendar.DAY_OF_MONTH)==30){ out.print("selected");} %>>30</option>
					    <option value="31" <% if(now.get(Calendar.DAY_OF_MONTH)==31){ out.print("selected");} %>>31</option>
					</select>						
					<select name="start_contest_year" id="start_contest_Year" class="yearselect">
					    <option value="2009" <% if(now.get(Calendar.YEAR)==2009){ out.print("selected");} %>>2009</option>
					    <option value="2010" <% if(now.get(Calendar.YEAR)==2010){ out.print("selected");} %>>2010</option>
					    <option value="2011" <% if(now.get(Calendar.YEAR)==2011){ out.print("selected");} %>>2011</option> 
						<option value="2012" <% if(now.get(Calendar.YEAR)==2012){ out.print("selected");} %>>2012</option>
					</select>
					<img src="http://cs410-facebookphotocontest.appspot.com/images/calender.gif" onclick="var Cal = startCal(true); Cal.show(this,'start_contest_'); return true;" id="StartDate" style="cursor: pointer;" />
					</div>											
				</td>				
			</tr>
			<tr>
				<td colspan="2">
					<fb:editor-time label="*Photo Contest Start Time" name="contest_start_time" value="<%  
	Long contStartLong = new Long(contStartDate.getTime()/1000);
	out.print(contStartLong.intValue());	
%>" />
				</td>
			</tr>				
<%  
	//get the contest end time
	Date contEndDate = contest.getContestEndDate();
	now.setTime(contEndDate);
%>
			<tr>
				<td>
					<b style="color:#666666;">* End Contest Date: </b>
				</td>
				<td>
					<div>
					<select name="end_contest_month" id="end_contest_Month" class="monthselect">
					    <option value="1" <% if(now.get(Calendar.MONTH)==0){ out.print("selected");} %>>01</option>
					    <option value="2" <% if(now.get(Calendar.MONTH)==1){ out.print("selected");} %>>02</option>
					    <option value="3" <% if(now.get(Calendar.MONTH)==2){ out.print("selected");} %>>03</option>
					    <option value="4" <% if(now.get(Calendar.MONTH)==3){ out.print("selected");} %>>04</option>
					    <option value="5" <% if(now.get(Calendar.MONTH)==4){ out.print("selected");} %>>05</option>
					    <option value="6" <% if(now.get(Calendar.MONTH)==5){ out.print("selected");} %>>06</option>
					    <option value="7" <% if(now.get(Calendar.MONTH)==6){ out.print("selected");} %>>07</option>
					    <option value="8" <% if(now.get(Calendar.MONTH)==7){ out.print("selected");} %>>08</option>
					    <option value="9" <% if(now.get(Calendar.MONTH)==8){ out.print("selected");} %>>09</option>
					    <option value="10" <% if(now.get(Calendar.MONTH)==9){ out.print("selected");} %>>10</option>
					    <option value="11" <% if(now.get(Calendar.MONTH)==10){ out.print("selected");} %>>11</option>
					    <option value="12" <% if(now.get(Calendar.MONTH)==11){ out.print("selected");} %>>12</option>
					</select>
					<select name="end_contest_day" id="end_contest_Day" class="dayselect" >
					    <option value="1" <% if(now.get(Calendar.DAY_OF_MONTH)==1){ out.print("selected");} %>>01</option>
					    <option value="2" <% if(now.get(Calendar.DAY_OF_MONTH)==2){ out.print("selected");} %>>02</option>
					    <option value="3" <% if(now.get(Calendar.DAY_OF_MONTH)==3){ out.print("selected");} %>>03</option>
					    <option value="4" <% if(now.get(Calendar.DAY_OF_MONTH)==4){ out.print("selected");} %>>04</option>
					    <option value="5" <% if(now.get(Calendar.DAY_OF_MONTH)==5){ out.print("selected");} %>>05</option>
					    <option value="6" <% if(now.get(Calendar.DAY_OF_MONTH)==6){ out.print("selected");} %>>06</option>
					    <option value="7" <% if(now.get(Calendar.DAY_OF_MONTH)==7){ out.print("selected");} %>>07</option>
					    <option value="8" <% if(now.get(Calendar.DAY_OF_MONTH)==8){ out.print("selected");} %>>08</option>
					    <option value="9" <% if(now.get(Calendar.DAY_OF_MONTH)==9){ out.print("selected");} %>>09</option>
					    <option value="10" <% if(now.get(Calendar.DAY_OF_MONTH)==10){ out.print("selected");} %>>10</option>
					    <option value="11" <% if(now.get(Calendar.DAY_OF_MONTH)==11){ out.print("selected");} %>>11</option>
					    <option value="12" <% if(now.get(Calendar.DAY_OF_MONTH)==12){ out.print("selected");} %>>12</option>
					    <option value="13" <% if(now.get(Calendar.DAY_OF_MONTH)==13){ out.print("selected");} %>>13</option>
					    <option value="14" <% if(now.get(Calendar.DAY_OF_MONTH)==14){ out.print("selected");} %>>14</option>
					    <option value="15" <% if(now.get(Calendar.DAY_OF_MONTH)==15){ out.print("selected");} %>>15</option>
					    <option value="16" <% if(now.get(Calendar.DAY_OF_MONTH)==16){ out.print("selected");} %>>16</option>
					    <option value="17" <% if(now.get(Calendar.DAY_OF_MONTH)==17){ out.print("selected");} %>>17</option>
					    <option value="18" <% if(now.get(Calendar.DAY_OF_MONTH)==18){ out.print("selected");} %>>18</option>
					    <option value="19" <% if(now.get(Calendar.DAY_OF_MONTH)==19){ out.print("selected");} %>>19</option>
					    <option value="20" <% if(now.get(Calendar.DAY_OF_MONTH)==20){ out.print("selected");} %>>20</option>
					    <option value="21" <% if(now.get(Calendar.DAY_OF_MONTH)==21){ out.print("selected");} %>>21</option>
					    <option value="22" <% if(now.get(Calendar.DAY_OF_MONTH)==22){ out.print("selected");} %>>22</option>
					    <option value="23" <% if(now.get(Calendar.DAY_OF_MONTH)==23){ out.print("selected");} %>>23</option>
					    <option value="24" <% if(now.get(Calendar.DAY_OF_MONTH)==24){ out.print("selected");} %>>24</option>
					    <option value="25" <% if(now.get(Calendar.DAY_OF_MONTH)==25){ out.print("selected");} %>>25</option>
					    <option value="26" <% if(now.get(Calendar.DAY_OF_MONTH)==26){ out.print("selected");} %>>26</option>
					    <option value="27" <% if(now.get(Calendar.DAY_OF_MONTH)==27){ out.print("selected");} %>>27</option>
					    <option value="28" <% if(now.get(Calendar.DAY_OF_MONTH)==28){ out.print("selected");} %>>28</option>
					    <option value="29" <% if(now.get(Calendar.DAY_OF_MONTH)==29){ out.print("selected");} %>>29</option>
					    <option value="30" <% if(now.get(Calendar.DAY_OF_MONTH)==30){ out.print("selected");} %>>30</option>
					    <option value="31" <% if(now.get(Calendar.DAY_OF_MONTH)==31){ out.print("selected");} %>>31</option>
					</select>						
					<select name="end_contest_year" id="end_contest_Year" class="yearselect">
					    <option value="2009" <% if(now.get(Calendar.YEAR)==2009){ out.print("selected");} %>>2009</option>
					    <option value="2010" <% if(now.get(Calendar.YEAR)==2010){ out.print("selected");} %>>2010</option>
					    <option value="2011" <% if(now.get(Calendar.YEAR)==2011){ out.print("selected");} %>>2011</option> 
						<option value="2012" <% if(now.get(Calendar.YEAR)==2012){ out.print("selected");} %>>2012</option>
					</select>
					<img src="http://cs410-facebookphotocontest.appspot.com/images/calender.gif" onclick="var Cal = startCal(true); Cal.show(this,'end_contest_'); return true;" id="StartDate" style="cursor: pointer;" />
					</div>											
				</td>					
			</tr>
			<tr>
				<td colspan="2">
					<fb:editor-time label="*Photo Contest End Time" name="contest_end_time" value="<%  
	Long contEndLong = new Long(contEndDate.getTime()/1000);
	out.print(contEndLong.intValue());
%>" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<fb:editor-textarea label="*Description" name="contest_description" rows="6"><%= contest.getContestDescription() %></fb:editor-textarea>  
				</td>
			</tr>				
<%
}
%>							
<%
// if current date is before contest end date, we can change the note
if(currDate.before(contest.getContestEndDate()))
{
%>					
			<tr>
				<td colspan="2">
					<fb:editor-text label="Note" name="contest_msg" value="<%= contest.getMessage() %>" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<fb:editor-buttonset>  
						<fb:editor-button value="Modify"/>
					</fb:editor-buttonset> 
				</td>
			</tr>					
<%
}
%>				

		</table>
		<br />
		<table width="600px">
			<tr>
				<th><p>Contestant Name</p></th>
				<th><p>Image</p></th>
				<th><p>Photo Title</p></th>
				<th><p>Photo Description</p></th>
				<th><p>
<%
// if current date is before start date, we can accept all user
if(currDate.before(contest.getContestStartDate()))
{
%>					
				<a href="acceptallcontestants.jsp?cid=<%= contestID %>">Accept All</a>
<%
}
%>
				</p></th>						
			</tr>
<%
	// get the list of contestants
	List<Contestant> contestantList = contest.getContestants();
	IContestant contestant;
	
	Iterator contestantsItr = contestantList.iterator();
	while(contestantsItr.hasNext())
	{
	
		contestant = (Contestant)contestantsItr.next();
		String URL = tfbcWrapper.getPhotoURL(contestant.getPhotoid(), "src_small");
		Collection<Long> uids = new ArrayList<Long>();
		uids.add(contestant.getFacebookuserid());
		Collection<String> names = tfbcWrapper.getInfoFromUsers(uids, "name");
		String name = names.toArray()[0].toString();	
	
		out.println("<tr>");
		out.println("<td><p>" + name + "</p></td>");
		out.println("<td><p><img src=\"" + URL + "\" name=\"" + contestant.getPhotoTitle() + "\"></img></p></td>");
		out.println("<td><p>" + contestant.getPhotoTitle() + "</p></td>");
		out.println("<td><p>" + contestant.getDescription() + "</p></td>");
		
		// if current date is before start date, we can accept/unaccept users
		if(currDate.after(contest.getContestStartDate()))
		{
			if(contestant.getAccepted())
			{
				out.println("<td><p>Accepted</p></td>");		
			}
			else
			{
				out.println("<td><p>Unaccepted</p></td>");
			}				
		}
		else
		{
			if(contestant.getAccepted())
			{
				out.println("<td><p>Accepted / <a href=\"acceptsinglecontestant.jsp?fid=" + contestant.getFacebookuserid() + "&accept=0&cid=" + contestID + "\">Unaccept</a></p></td>");		
			}
			else
			{
				out.println("<td><p><a href=\"acceptsinglecontestant.jsp?fid=" + contestant.getFacebookuserid() + "&accept=1&cid=" + contestID + "\">Accept</a></p></td>");
			}					
		}

		out.println("</tr>");	
	}
%>				
		</table>				
		</fb:editor>	
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