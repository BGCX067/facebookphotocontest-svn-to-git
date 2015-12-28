
<%@page import="org.fb_photocontest.Contest"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="javax.jdo.Query"%>
<%@page import="org.fb_photocontest.IContestant"%>
<%@page import="org.fb_photocontest.ContestSetter"%>
<%@page import="org.fb_photocontest.IContest"%>
<%@page import="org.fb_photocontest.PersistenceManagerFac"%>
<%@page import="javax.jdo.PersistenceManager"%>
<%@page import="java.util.List"%>
<%@page import="org.fb_photocontest.PhotoContestApp"%>
<%@page import="org.fb_photocontest.IPhotoContestApp"%>
<%@page import="java.util.Date"%>
<p>open contests</p>
<%
try{
IPhotoContestApp app = PhotoContestApp.getInstance();

Date ed = new Date();

ed.setDate(14);

List<IContest> results = app.getOpenContests(ed, 20);
/*		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

		List<IContest> results = new ArrayList<IContest>();
		try{

			
			Calendar now = Calendar.getInstance();
			Calendar pageDate = Calendar.getInstance();

			Query q = pm.newQuery(Contest.class);
			
			q.declareParameters("java.util.Date endlow, java.util.Date endhigh");
			q.setFilter("this.contestEndDate >= endlow && this.contestEndDate > endhigh");
			q.setOrdering("this.contestEndDate desc");

			//q.setRange(arg0, arg1)
			List<IContest> res= (List<IContest>)q.execute(new Date(), new Date());
			if (res.iterator().hasNext())
			{
				for(IContest contest : res)
				{
					if (contest.getContestEndDate().compareTo(new Date()) > 0)
					{
						for(IContestant c :contest.getContestants());
						if(contest.getHasJudges())
							for(Long l :contest.getJudges());
						for(String s : contest.getTags());
						results.add(contest);
						

						if(results.size() == 999)
							break;
					}
				}
			}
			

		}
		finally
		{
			pm.close();
			
		}*/

		
for(IContest contest : results)
{
%>

<%=contest.getContestTitle() %>
<%=contest.getContestRegistrationDeadline() %>
<%=contest.getContestStartDate() %>
<%=contest.getContestEndDate() %>

<br />
<% } %>
<p>all contests</p>
<%for(IContest contest : app.getContests())
{
%>
<%=contest.getContestTitle() %>
<%=contest.getContestRegistrationDeadline() %>
<%=contest.getContestStartDate() %>
<%=contest.getContestEndDate() %>

<br />
<% } %>
<p>scorable contests</p>
<%
Date d = new Date();

d.setDate(19);
for(IContest contest : app.getScorableContests(null,3))
{
%>
<%=contest.getContestTitle() %>
<%=contest.getContestRegistrationDeadline() %>
<%=contest.getContestStartDate() %>
<%=contest.getContestEndDate() %>

<br />
<% } } catch(Exception e)
{
	e.printStackTrace(System.err);
}%>