<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%> 
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="org.fb_photocontest.*" %>
<%
	IPhotoContestApp pca = PhotoContestApp.getInstance();
	
	TFBCWrapper tfbcWrapper = new TFBCWrapper(request);
 	String currentUserID = tfbcWrapper.getCurUserFBID();
 	
 	Date currDate = new Date();
 	Boolean textError = false;
 	Boolean dateError = false;
 	
	//photo contest name
	String contestName = "";
	if(request.getParameter("contest_name").trim().equals(""))
	{
		textError = true;
	}
	else
	{
		contestName = request.getParameter("contest_name").trim();
	}
	
	// photo category
	String categoryString = request.getParameter("category");
	Integer catIndex = Integer.parseInt(categoryString);
	ContestCategory contestCat = pca.getCategories().get(catIndex);
	
	// photo scoring type
	IPhotoContestApp.ScoringType scoringType;
	if (request.getParameter("scoring_type").equalsIgnoreCase("voting"))
	{
		scoringType = IPhotoContestApp.ScoringType.VOTING;
	}
	else
	{
		scoringType = IPhotoContestApp.ScoringType.RATING;
	}
	
	// photo public or private
	Boolean isPublic;
	if (request.getParameter("contest_type").equalsIgnoreCase("public"))
	{
		isPublic = true;
	}
	else
	{
		isPublic = false;
	}
	
	// photo contest allow judges or no
	Boolean hasJudge;
	if (request.getParameter("contest_has_judge").equalsIgnoreCase("hasjudge"))
	{
		hasJudge = true;
	}
	else
	{
		hasJudge = false;
	}	
	
	// convert judges to ArrayList<Long> to store
	Collection<Long> contestJudgesList = new ArrayList<Long>();
	if(request.getParameterValues("contest_judges[]") != null)
	{
		String[] contestJudges = request.getParameterValues("contest_judges[]");
		for(int i=0;i < contestJudges.length;i++)
		{
			contestJudgesList.add(Long.parseLong(contestJudges[i]));
		}	
	}
	
	// photo contest registration end date
	String tzOffsetStr = tfbcWrapper.getCurUserTimeZone();
	int tzOffsetInt = Integer.parseInt(tzOffsetStr);
	
	// photo contest registration end date
	String endRegDay = request.getParameter("register_end_day");
	String endRegMonth = request.getParameter("register_end_month");
	String endRegYear = request.getParameter("register_end_year");
	String endRegDate = endRegMonth + "/" + endRegDay + "/" + endRegYear;
	String endRegTimeHour = request.getParameter("register_end_time_hour");
	String endRegTimeMin = request.getParameter("register_end_time_min");
	String endRegTimeAMPM = request.getParameter("register_end_time_ampm");
	String endRegTimeStr = endRegDate + " " + endRegTimeHour + ":" + endRegTimeMin + " " + endRegTimeAMPM;
	//out.print(endRegTimeStr);
	
	// photo contest start date
	String startConDay = request.getParameter("start_contest_day");
	String startConMonth = request.getParameter("start_contest_month");
	String startConYear = request.getParameter("start_contest_year");
	String startConDate = startConMonth + "/" + startConDay + "/" + startConYear;	
	String startConTimeHour = request.getParameter("contest_start_time_hour");
	String startConTimeMin = request.getParameter("contest_start_time_min");
	String startConTimeAMPM = request.getParameter("contest_start_time_ampm");
	String startConTimeStr = startConDate + " " + startConTimeHour + ":" + startConTimeMin + " " + startConTimeAMPM; 
	//out.print(startConTimeStr);
	
	// photo contest end date
	String endConDay = request.getParameter("end_contest_day");
	String endConMonth = request.getParameter("end_contest_month");
	String endConYear = request.getParameter("end_contest_year");
	String endConDate = endConMonth + "/" + endConDay + "/" + endConYear;		
	String endConTimeHour = request.getParameter("contest_end_time_hour");
	String endConTimeMin = request.getParameter("contest_end_time_min");
	String endConTimeAMPM = request.getParameter("contest_end_time_ampm");
	String endConTimeStr = endConDate + " " + endConTimeHour + ":" + endConTimeMin + " " + endConTimeAMPM; 	
	//out.print(endConTimeStr);
	
	// parse the string dates into Date objects
	Date endRegDateObj = null;
	Date startConObj = null;
	Date endConObj = null;
	SimpleDateFormat dateFormat = new SimpleDateFormat("M/d/yyyy hh:mm a");

	try
	{
		endRegDateObj = dateFormat.parse(endRegTimeStr);
		int endRegDayInt = endRegDateObj.getDate();
		endRegDateObj = new Date((long)(endRegDateObj.getTime()-(tzOffsetInt)*3600000));
		endRegDateObj.setDate(endRegDayInt);
		
		startConObj = dateFormat.parse(startConTimeStr);
		int startConDayInt = startConObj.getDate();
		startConObj = new Date((long)(startConObj.getTime()-(tzOffsetInt)*3600000));
		startConObj.setDate(startConDayInt);
		
		endConObj = dateFormat.parse(endConTimeStr);
		int endConDayInt = endConObj.getDate();
		endConObj = new Date((long)(endConObj.getTime()-(tzOffsetInt)*3600000));
		endConObj.setDate(endConDayInt);
	}
    catch(Exception e) {
    	dateError = true;
        out.println("ERROR! Cannot Parse Dates, please check format. (MM/dd/yyyy HH:mm) <br><br>");
    }
	
 	// check if the logic for the registeration/contest start/contest end dates make sense
    // first is to check if the current date is after the end registration date
    // second is to check if the end registration date is after the starting contest date
    // third is to check if the end registration date is after the ending contest date
    // fourth is to check if the starting contest date is after ending contest date
    // rest are to check if they actually equal, which shouldn't be the case
    // if any of the above are true, then there is a logic problem with the date
    // and none of the date fields will be update, an error message will display in savemodifiedphotocontest
    if(currDate.after(endRegDateObj) || endRegDateObj.after(startConObj) 
    		|| endRegDateObj.after(endConObj) || startConObj.after(endConObj)
    		|| endRegDateObj.equals(startConObj) || endRegDateObj.equals(endConObj)
    		|| startConObj.equals(endConObj))
    {
    	dateError = true;	    	
    }    
 	
    // welcome message 
	String contestMsg = request.getParameter("contest_msg");
	
	// photo contest tags - need to make them into Array of Strings later
	String contestTags = request.getParameter("contest_tags");
	// convert photo contest tags to ArrayList<String> to store
	Collection<String> contestTagsList = Arrays.asList(contestTags.split(","));
	
	// photo contest description
	String description = "";
	if(request.getParameter("contest_description").trim().equals(""))
	{
		textError = true;
	}
	else
	{
		description = request.getParameter("contest_description").trim();
	}
	
    if(!dateError && !textError)
    {		
    	IContest contest;
    	// only if there is judges selected, we should use the list of judges constructor
    	if(hasJudge)
    	{
			contest = pca.createContest(contestName, description, contestCat,
					scoringType, isPublic, endRegDateObj, startConObj, 
					endConObj, contestJudgesList, contestTagsList, contestMsg, Long.parseLong(currentUserID), IPhotoContestApp.PointSystem.STANDARD);	
    	}
    	// otherwise we should use the boolean of hasJudge constructor
    	else
    	{
    		contest = pca.createContest(contestName, description, contestCat,
					scoringType, isPublic, endRegDateObj, startConObj, 
					endConObj, hasJudge, contestTagsList, contestMsg, Long.parseLong(currentUserID), IPhotoContestApp.PointSystem.STANDARD);	    		
    	}
%>
	<fb:redirect url="viewsinglephotocontest.jsp?cid=<%= contest.getContestID() %>"></fb:redirect>	
<%
	}
    else
    {
    	// generate the message to be sent back
    	String error_msg = "";
    	if(dateError && textError)
    	{
    		error_msg = "datetexterror";	
    	}
    	else if(dateError)
    	{
    		error_msg = "dateerror";
    	}
    	else if(textError)
    	{
    		error_msg = "texterror";
    	}
%>
<fb:redirect url="makephotocontest.jsp?error_msg=<%= error_msg %>" />
<%
    }
%>