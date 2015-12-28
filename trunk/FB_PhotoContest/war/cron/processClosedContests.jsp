<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="org.fb_photocontest.*" %>

<%
IPhotoContestApp pca = PhotoContestApp.getInstance();

List<IContest> notProcContests = pca.getEndedContests();

for (IContest contest : notProcContests)
{
	// This would help the top three winners
	HashMap<String, Long> contWinners = new HashMap<String, Long>();
	
	/*
	Loop through all the accepted contestants and determine who the top three winners are by comparing their scores.
	*/
	for (int i=0; i<contest.getAcceptedContestants().size(); i++)
	{
		IContestant c = contest.getAcceptedContestants().get(i);
		Long tempFirstUserID, tempSecondUserID, tempThirdUserID;
		
		if (contWinners.containsKey("FirstPlace"))
			tempFirstUserID = contWinners.get("FirstPlace");
		else
			tempFirstUserID = null;
		
		if (contWinners.containsKey("SecondPlace"))
			tempSecondUserID = contWinners.get("SecondPlace");
		else
			tempSecondUserID = null;
		
		if (contWinners.containsKey("ThirdPlace"))
			tempThirdUserID = contWinners.get("ThirdPlace");
		else
			tempThirdUserID = null;
		
		Double tempFirstScore = -1.0, tempSecondScore = -1.0, tempThirdScore = -1.0;
		
		Double curContScore = c.getScore();
		Long curContUserID = c.getFacebookuserid();

		if (tempFirstUserID != null)
			tempFirstScore = contest.getContestantFromID(tempFirstUserID).getScore();
		
		if (tempSecondUserID != null)
			tempSecondScore = contest.getContestantFromID(tempSecondUserID).getScore();
		
		if (tempThirdUserID != null)
			tempThirdScore = contest.getContestantFromID(tempThirdUserID).getScore();
		
		if (curContScore > tempFirstScore) // Current Contestant > First
		{
			contWinners.put("FirstPlace", curContUserID);
			contWinners.put("SecondPlace", tempFirstUserID);
			contWinners.put("ThirdPlace", tempSecondUserID);
		}
		else if (curContScore > tempSecondScore) // First > Current Contestant > Second
		{
			contWinners.put("SecondPlace", curContUserID);
			contWinners.put("ThirdPlace", tempSecondUserID);
		}
		else if (curContScore > tempThirdScore) // Second > Current Contestant > Third
		{
			contWinners.put("ThirdPlace", curContUserID);
		}
		else
		{
			// Do Nothing
		}
	}
	
	Long firstUserID = contWinners.get("FirstPlace");
	Long secondUserID = contWinners.get("SecondPlace");
	Long thirdUserID = contWinners.get("ThirdPlace");
	
	// Add the appropriate points.
	if (firstUserID != null)
		pca.addUserPoints(firstUserID, contest.getPointValues()[0]);
	if (secondUserID != null)
		pca.addUserPoints(secondUserID, contest.getPointValues()[1]);
	if (thirdUserID != null)
		pca.addUserPoints(thirdUserID, contest.getPointValues()[2]);
	
	// Set the winners to the contest in the database.
	contest.setValues(new ContestSetter()
	{
		public Object SetValues(IContestWriter writer, Object param)
		{
			HashMap<String, Long> winners = (HashMap<String, Long>) param;
			writer.setWinners(winners.get("FirstPlace"), winners.get("SecondPlace"), winners.get("ThirdPlace"));
			writer.setHasAppliedPoints(true);
			return true;
		}
	}, contWinners);
}

%>