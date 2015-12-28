<%@page import="org.fb_photocontest.TFBCWrapper"%>
<%@page import="org.fb_photocontest.IPhotoContestApp"%>
<%@page import="org.fb_photocontest.PhotoContestApp"%>

<link rel="stylesheet" type="text/css" media="screen" href="http://cs410-facebookphotocontest.appspot.com/css/general.css?v=1.2" />
<script src="http://cs410-facebookphotocontest.appspot.com/javascript/ajax.js?v=3.0"></script>

<%
	String sessionKey = request.getParameter("fb_sig_session_key"); // Session Key passed as request parameter
	String currentUserID = "";

	// If there is not session key, they user not logged in or this is in the profile tab
	if (sessionKey == null)
	{
		%>
		<jsp:forward page="error.jsp">
			<jsp:param name="error_type" value="not_logged_in"/>
		</jsp:forward>
		<%
 	}
	
	TFBCWrapper tfbcWrapper = new TFBCWrapper(request);
	if (!tfbcWrapper.userHasExtendedPermissions("photo_upload"))
	{
		%>
		<jsp:forward page="error.jsp" >
			<jsp:param name="error_type" value="no_permission"/>
		</jsp:forward> 
		<%
	}
	currentUserID = tfbcWrapper.getCurUserFBID();
	
	IPhotoContestApp pca = PhotoContestApp.getInstance();

%>

<div style="width:760px;">
	<div id="header" class="fb_bluebg">
		<h1> Photo Contests! &lt;BETA&gt;</h1>
	</div>
	<div id="fbtabs">
		<fb:tabs>
			<fb:tab-item href='index.jsp' title='Home'/>
			<fb:tab-item href='viewphotocontests.jsp?f=all' title='View All Contests' />  
			<fb:tab-item href='viewphotocontests.jsp?f=score' title='View Active Contests' />
			<fb:tab-item href='viewphotocontests.jsp?f=join' title='Join Contests' />
			<fb:tab-item href='makephotocontest.jsp' title='Create a New Contest' />
			<fb:tab-item href='profile.jsp' title='View Profile' />
			<fb:tab-item href='help.jsp' title='How to Compete'/>
		</fb:tabs>
	</div>

	<div style="width:760px; height:600px; overflow:auto;">
		<div id="leftcontent" class="floatleft" style="width:160px; height:600px; overflow-y:auto;">
			<p>
			<input type="text" class="search"/><br />
			Search Photo Contest!<br /><br /><br />
			Welcome, <fb:name uid="<%= currentUserID %>" useyou="false" linked="false"></fb:name><br /><br />
			You have accumulated <%= pca.getUserPoints(Long.parseLong(currentUserID)) %> Points!
			</p>
		</div>