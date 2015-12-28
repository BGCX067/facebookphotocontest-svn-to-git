<%@page import="org.fb_photocontest.*" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List" %>

<%
IPhotoContestApp pca = PhotoContestApp.getInstance();

TFBCWrapper tfbcWrapper = new TFBCWrapper(request);

int contestID = Integer.parseInt(request.getParameter("contestID"));

int rating = 0;

if (request.getParameter("rating") != null)
	rating = Integer.parseInt(request.getParameter("rating"));

Long voterID = Long.parseLong(tfbcWrapper.getCurUserFBID());

IContest contest = pca.getContest(contestID);

IPhotoContestApp.ScoringType contType = contest.getScoringType();

Long contestantID = Long.parseLong(request.getParameter("contestantsID"));

IContestant theChosenOne = contest.getContestantFromID(contestantID);

if ( (contType == IPhotoContestApp.ScoringType.RATING) && (rating == 0))
{
	out.println("<fb:error>" +
					"<fb:message> No Rating Error </fb:message>" +
					"You have not selected a rating" +
				"</fb:error>");
}
else if (theChosenOne.getHasUserVoted(voterID))
{
	if (contType == IPhotoContestApp.ScoringType.VOTING)
	{
		out.println("<fb:error>" +
						"<fb:message> Error: Already Voted! </fb:message>" +
						"You have already voted for this picture. " +
					"</fb:error>");
	}
	else
	{
		out.println("<fb:error>" +
						"<fb:message> Error: Rating Already Submitted! </fb:message>" +
						"You have already submitted a rating for this picture. " +
					"</fb:error>");
	}
}
// Future: Check if user has already voted MAX times.
else
{
	
	List<Object> params = new ArrayList<Object>();

	params.add(0, theChosenOne);
	params.add(1, rating);
	params.add(2, voterID);
	
	IContestant ret = (IContestant) contest.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameters)
		{
			List<Object> p = (List<Object>) parameters;
			
			IContestant c = (IContestant) p.get(0);
			Integer rating = (Integer) p.get(1);
			Long vID = (Long) p.get(2);
			
			if (writer.addScoreToContestant(c, vID, rating))
				return c;
			else
				return null;
		}
	}, params);
	
	if (ret != null)
	{
		if (contType == IPhotoContestApp.ScoringType.VOTING)
		{
			out.println("<fb:success>" +
							"<fb:message> Vote Submitted! </fb:message>" +
							"Thanks for Voting for <fb:name uid=\"" + ret.getFacebookuserid() + "\" useyou=\"false\"/> !" +
						"</fb:success>");
		}
		else
		{
			out.println("<fb:success>" +
							"<fb:message> Rating Submitted! </fb:message>" +
							"Thanks for Submitting a Rating for <fb:name uid=\"" + ret.getFacebookuserid() + "\" useyou=\"false\" /> !" +
						"</fb:success>");
		}
		pca.addUserPoints(voterID, 1); // Add one Point to voter
	}
	else
	{
		out.println("<fb:error>" +
						"<fb:message> Error! </fb:message>" +
						"There was an error processing your vote/rating. Please try again later." +
					"</fb:error>");
	}
}
%>