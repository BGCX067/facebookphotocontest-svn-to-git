<%@page import="org.fb_photocontest.*" %>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%
	// get the photo contest
	IPhotoContestApp pca = PhotoContestApp.getInstance();
	int contestID = Integer.parseInt(request.getParameter("cid"));
	IContest contest = pca.getContest(contestID);
	
	// get the list of photo contestants for this photo contest
	List<Contestant> contestantList = contest.getContestants();
	IContestant contestant = new Contestant();
	
	// iterate through all the contestants
	Iterator itr = contestantList.iterator();
	while(itr.hasNext())
	{
		contestant = (IContestant)itr.next();
		// set the contestant's status to be accepted
		contest.setValues(new ContestSetter()
		{
				public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
				{
					IContestant acceptedContestant = (IContestant)parameters;
					writer.acceptContestant(acceptedContestant, true); 
					return null;
				}
		}
		, contestant);
	}
	// redirect back to the photo contest modifying page
%>
<fb:redirect url="modifyphotocontest.jsp?cid=<%= contestID %>&success=acceptallcontestants" />
