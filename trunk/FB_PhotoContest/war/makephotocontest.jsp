<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.lang.Exception"%>
<%@page import="java.util.List"%>
<%@page import="org.fb_photocontest.*"%>
<%
try
{
%>

<%@include file="header.jsp" %>
<%@include file="calendar.jsp" %>

		<div id="maincontent" class="fbgreybox">
<%
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
			<fb:editor action="savenewphotocontest.jsp" width="600">			
			<table>
				<tr>
					<td colspan="2"><p><b>Make a Photo Contest</b></p></fb:header></td>
				</tr>
				<tr>
					<td colspan="2" style="color:#FF0000;"><small>* are required</small></td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-text label="*Photo Contest Name" name="contest_name" value="" maxlength="24" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
					<fb:editor-custom label="*Category">  
						<select name="category"> 
<%
	// get the list of categories from photo contest app
	List<ContestCategory> cats = pca.getCategories();
	Integer counter = 0;
	for (ContestCategory cat: cats) 
	{
%>
		<option value="<%= counter %>"><%= cat.getCategoryName() %></option>
<% 
		counter++;
	}	
%>							 
						</select>  
					</fb:editor-custom> 
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-custom label="*Scoring Option">  
							<select name="scoring_type">  
								<option value="voting">Voting</option>
								<option value="rating">Rating</option>
							</select>  
						</fb:editor-custom>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-custom label="*Public or Private">  
							<select name="contest_type">  
								<option value="public">Public</option>
								<option value="private">Private</option>
							</select>  
						</fb:editor-custom>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-custom label="*Judging">  
							<select name="contest_has_judge" onChange="showdiv('multi_friend_input');">  
								<option value="hasjudge">Judges</option>
								<option value="nojudge" selected>No Judges</option>
							</select>  
						</fb:editor-custom> 
					</td>
				</tr>
				<tr>	
					<td colspan="2">
						<table id="multi_friend_input" style="display: none">
							<tr>
								<td style="text-align:right;">
									<fb:multi-friend-input name="contest_judges" width="450px" border_color="#8496ba" />					
								</td>
							</tr>
						</table>
					</td>
				</tr>
<%
	// get the date
	Calendar now = Calendar.getInstance();
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
						<fb:editor-time label="*Registration End Time" name="register_end_time" value="<%= (now.getTimeInMillis() / 1000) %>"/>
					</td>
				</tr>				
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
						<fb:editor-time label="*Photo Contest Start Time" name="contest_start_time" value="<%= (now.getTimeInMillis() / 1000) %>"/>
					</td>
				</tr>				
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
						<fb:editor-time label="*Photo Contest End Time" name="contest_end_time" value="<%= (now.getTimeInMillis() / 1000) %>"/>
					</td>
				</tr>												
				<tr>
					<td colspan="2">
						<fb:editor-text label="Note" name="contest_msg" value="" maxlength="24"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-text label="Tags" name="contest_tags" value="" maxlength="24"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-textarea label="*Description" name="contest_description" rows="6"/>  
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<fb:editor-buttonset>  
							<fb:editor-button value="Submit"/>
						</fb:editor-buttonset> 
					</td>
				</tr>	
			</table>				
			</fb:editor>
		</div>	
<%@include file="footer.jsp" %>
<%
}
catch(Exception e)
{
	//out.println(e.toString()); // This is for debugging purposes.
	
	// Use below instead, if not debugging.
	%> 
	<jsp:forward page="error.jsp">
		<jsp:param value="general" name="error_type"/>
	</jsp:forward>
	<%
}
%>	