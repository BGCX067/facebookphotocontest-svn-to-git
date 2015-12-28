<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="com.socialjava.TinyFBClient"%> 
<%@page import="java.util.Date"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Exception"%>
<%@page import="javax.jdo.JDOHelper"%>
<%@page import="org.fb_photocontest.TFBCWrapper"%>
<%@page import="net.sf.json.*"%>

<%
	/*
		This set of tests must run inside of Facebook, while logged on.
	*/
	String sessionKey = request.getParameter("fb_sig_session_key"); // Session Key passed as request parameter
	String currentUserName = "";
	String currentUserID = "";
	String currentUserNameFirst = "";
	String currentUserNameLast = "";
	String imgURL = "";		

	// If there is not session key, they user not logged in or this is in the profile tab
	//if (!tfbcWrapper.userhasExtendedPermissions("photo_upload")) 
	if (sessionKey == null)
	{
%>
		<p><b>Before you can use Photo Contests! You must grant special permissions.</b></p>
		<br/>
		<form promptpermission="read_stream,publish_stream">
			<input type=submit value='Click to Grant Permissions' />
		</form>
<%
 	} 
 	else
 	{ 
 		TFBCWrapper tfbcWrapper = new TFBCWrapper(request);
 		
 		/* Test1: Get current User Facebook ID */
 		currentUserID = tfbcWrapper.getCurUserFBID();
 		out.println("Test1: Current User's Facebook ID = " + currentUserID + "<br /><br />");
 	 	
 		/* Test2: Get current User Full Name */
 	 	currentUserName = tfbcWrapper.getCurUserFullName();
 	 	out.println("Test2: Current User's Full Name = " + currentUserID + "<br /><br />");
 		
 		/* Test3: Get curent User First Name */
 	 	currentUserNameFirst = tfbcWrapper.getCurUserFirstName();
 	 	out.println("Test3: Current User's First Name = " + currentUserID + "<br /><br />");
 		
 		/* Test4: Get current User Last Name */
 	 	currentUserNameLast = tfbcWrapper.getCurUserLastName();
 	 	out.println("Test4: Current User's Last Name = " + currentUserID + "<br /><br />");
 	 	
 	 	/* Test5: TFBCWrapper.fqlQuery(...) - get user Full Name */
 	 	out.println("Test5: Testing TFBCWrapper's fqlQuery(...) <br />");
 	 	out.println("------------------------------------------ <br />");
 	 	JSONArray queryRespArr = tfbcWrapper.fqlQuery("SELECT name FROM user WHERE uid=21007038");
 	 	String name = "";
 	 	if (queryRespArr !=  null)
 	 	 	name = queryRespArr.getJSONObject(0).getString("name");
 	 	
 	 	out.println("  Last name from fqlQuery = " + name + "<br /><br />");
 	 	
 	 	/* Test6: getPhotoURLs(...) - 3 pictures */
 	 	ArrayList<Long> photoLongs = new ArrayList<Long>();
 	 	photoLongs.add(90224541236732396L);
 	 	photoLongs.add(90224541236747209L);
 	 	photoLongs.add(90224541236747310L);
 	 	
 	 	Collection<String> photoURLs = tfbcWrapper.getPhotoURLs(photoLongs);
 	 	
 	 	if (photoURLs == null)
 	 	{
 	 		out.print("Test6: FAILED!! <br /><br />");
 	 	}
 	 	else
 	 	{
 	 	 	for (String i : photoURLs)
 	 	 	{
 	 	 		out.print("Test6: Testing getPhotoURLs(...) - 3 Pictures<br />");
 	 	 	 	out.print("<img src=\"" + i + "\" /><br />");
 	 	 	 	out.print(i + "<br /><br />");
 	 	 	}	
 	 	}
 	 	
		/* Test7: createPhotoAlbum(...) - Create a test album. */
 	 	String albumID = tfbcWrapper.createPhotoAlbum("TestPhotoContestAlbum", "TESTING TESTING! 123 TESTING");
 	 	
 	 	if (albumID == null)
 	 	{
 	 		out.println("Test7: FAILED! AlbumID = " + albumID + "<br /><br />");
 	 	}
 	 	else
 	 	{
 	 		out.println("Test7: PASSED! AlbumID = " + albumID + "<br /><br />");
 	 	}
 	 	
 	 	/* Test8: getPhotoInfo(...) - getting the width of the picture */
 	 	
 	 	String info = tfbcWrapper.getPhotoInfo(90224541236747310L, "src_big_width");
 	 	
 	 	out.println("Test8: Testing getPhotoInfo(...) - width of src <br />");
 	 	out.println("------------------------------------------------");
 	 	out.println("Size of pic = " + info + "<br /><br />");
 	 	
 	 	/* Test9: getPhotoAlbumID(...) - get the album ID by name */
 	 	out.println("Test9: getPhotoAlbumID(...) - Should be same as above. <br />");
 	 	out.println("-------------------------------------------------------<br />");
 	 	out.println("AlbumID = " + tfbcWrapper.getPhotoAlbumID("TestPhotoContestAlbum", Long.parseLong(currentUserID)) + "<br /><br/>");
 	 	
 	 	
 	 	/* Test10: getInfoFromUsers(...) - get the Birthdays from users. */
 	 	Collection<Long> ids = new ArrayList<Long>();
 	 	ids.add(21007038L);
 	 	ids.add(21006273L);
		Collection<String> birthdays = tfbcWrapper.getInfoFromUsers(ids, "birthday_date");
		
		out.println("Test10: getInfoFromUsers(...) - Birthdays from 2 users <br />");
		out.println("-------------------------------------------------------<br />");
		out.println(" First User B-Day: " + birthdays.toArray()[0] + "<br />");
		out.println(" Second User B-Day: " + birthdays.toArray()[1] + "<br /><br />");
 	 	
 	 	/* Test11: getCurUserTimeZone(...) - get the timezone offset from GMT of current user */
 	 	out.println("Test11: Print the timezone of current user (offset from GMT) ==> " + tfbcWrapper.getCurUserTimeZone() + "<br />");
 	 	
 	 }
%>