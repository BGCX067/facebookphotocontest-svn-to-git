<%@page import="org.fb_photocontest.*"%>
<%@page import="java.lang.Exception"%>
<%@page import="javax.jdo.JDOHelper"%>
<%@page import="javax.jdo.PersistenceManager" %>
<%@page import="javax.jdo.PersistenceManagerFactory" %>

<%
try
{
	int contestID = 28004;
	
	IPhotoContestApp pca = PhotoContestApp.getInstance();
	PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
	
	IContest contest = pca.getContest(contestID);
	
	out.println(contest.getContestTitle());
	
	//pm.deletePersistent(contest);
	
	out.println("Deleted!");

}
catch (Exception e)
{
	out.println(e.toString());
}

%>