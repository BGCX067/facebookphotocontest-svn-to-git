<%@page import="org.fb_photocontest.*" %>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%
	// get the photo contest
	IPhotoContestApp pca = PhotoContestApp.getInstance();
	String contestID = request.getParameter("cid");
	
	// check if all the required parameters are specified
	if(request.getParameter("fid") != null && request.getParameter("accept") != null
			&& request.getParameter("cid") != null)
	{
		// get the contestant id specified in the url
		IContest contest = pca.getContest(Integer.parseInt(contestID));
		List<Contestant> contestantList = contest.getContestants();
		IContestant contestant = contest.getContestantFromID(Long.parseLong(request.getParameter("fid")));
		
		// accept the user if parameters for accept is 1
		if(Integer.parseInt(request.getParameter("accept")) == 1)
		{
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
		// unaccept the user if parameters for accept other than 1
		else
		{
			contest.setValues(new ContestSetter()
			{
					public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
					{
						IContestant acceptedContestant = (IContestant)parameters;
						writer.acceptContestant(acceptedContestant, false); 
						return null;
					}
			}
			, contestant);			
		}
	}
	// redirect back to the photo contest modifying page
%>
<fb:redirect url="modifyphotocontest.jsp?cid=<%= contestID %>&success=acceptcontestant" />
