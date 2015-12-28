
<%@page import="org.fb_photocontest.IPhotoContestApp.PointSystem"%>
<%@page import="org.fb_photocontest.IPhotoContestApp"%>
<%@page import="java.util.ArrayList"%><%
/*
This is just a kind of unit test.  We need to figure out a real way to do this.
Right now, everything should print true to the page.
*/
try{
%> 
<%@page import="org.fb_photocontest.IContestant"%>
<%@page import="org.fb_photocontest.IPhotoContestApp.ScoringType"%>
<%@page import="org.fb_photocontest.ContestCategory"%>
<%@page import="java.util.List"%>
<%@page import="org.fb_photocontest.ContestSetter"%>
<%@page import="org.fb_photocontest.IContest"%>
<%@page import="java.util.Date"%>
<%@page import="org.fb_photocontest.PhotoContestApp"%><%
IPhotoContestApp pca = PhotoContestApp.getInstance();

// get a list of categories
List<ContestCategory> cats = pca.getCategories();

// create a contest
IContest contest = pca.createContest("Contest title", "Descrpition",cats.get(0), PhotoContestApp.ScoringType.VOTING, true,new Date(), new Date(), new Date(),true, new ArrayList<String>(), "message", 0L,IPhotoContestApp.PointSystem.CUSTOM);

// save the id
int contestID = contest.getContestID().intValue();

// write the id out to the page
response.getWriter().println(contest.getContestID());

response.getWriter().println("<br />");

// try to retrieve the same contest again
contest = pca.getContest(contestID);

// see if the parameters are the same
response.getWriter().println(contest.getContestTitle().equals("Contest title"));
response.getWriter().println(contest.getContestDescription().equals("Descrpition"));
response.getWriter().println(contest.getMessage().equals("message"));
response.getWriter().println(contest.getCategory().getCategoryName().equals(cats.get(0).getCategoryName()));

// change the description and message, and add a contestant, and a judge
contest.setValues(new ContestSetter(){
	
	public void SetValues(org.fb_photocontest.IContestWriter writer)
	{
		writer.setContestDescription("New Description");
		writer.setMessage("New Message");
		IContestant contestant = writer.addContestant(1L,2L,3L,"Title","Description");
		writer.setCustomScores(500,300,100);
		writer.acceptContestant(contestant, true); 
		
		writer.addScoreToContestant(contestant, 2L, 2);
		writer.addJudge(123L);
	}
});

// change the description that is passed in.  this shows how values
// can be sent in and returned
response.getWriter().println(((String)contest.setValues(new ContestSetter(){
	public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
	{
		String s = (String)parameters;
		
		writer.setContestDescription(s);
		
		return "hello";
	}
}, "New Des")).equals("hello"));

// see if our changes worked.
response.getWriter().println(contest.getContestDescription() == "New Des");
response.getWriter().println(contest.getMessage() == "New Message");

response.getWriter().println(contest.getContestants().size() == 1);

// get our contestant
IContestant cts = contest.getContestants().get(0);

// see if the contestant is the same one we created
response.getWriter().println(cts.getDescription() == "Description");
response.getWriter().println(cts.getPhotoTitle() == "Title");
response.getWriter().println(cts.getPhotoid() == 2);
response.getWriter().println(cts.getFacebookuserid() == 1);
response.getWriter().println(cts.getAlbumid() == 3);
response.getWriter().println(cts.getAccepted());
response.getWriter().println(cts.getNumScores() == 1);
response.getWriter().println(cts.getScore() == 1);
response.getWriter().println("<br />");


// now... retrieve the contest once more and see if it's the same
contest = pca.getContest(contestID);
response.getWriter().println(contest.getContestTitle().equals("Contest title"));
response.getWriter().println(!contest.getContestDescription().equals("Descrpition"));
response.getWriter().println(!contest.getMessage().equals("message"));
response.getWriter().println(contest.getCategory().getCategoryName().equals(cats.get(0).getCategoryName()));
//see if our changes worked.
response.getWriter().println(contest.getContestDescription().equals("New Des"));
response.getWriter().println(contest.getMessage().equals("New Message"));
response.getWriter().println(contest.getJudges().size() == 1);
response.getWriter().println(contest.getJudges().get(0).equals(123L));
response.getWriter().println(contest.getContestants().size() == 1);

// get our contestant
cts = contest.getContestants().get(0);
// see if the contestant is the same one we created
response.getWriter().println(cts.getDescription().equals("Description"));
response.getWriter().println(cts.getPhotoTitle().equals("Title"));
response.getWriter().println(cts.getPhotoid() == 2);
response.getWriter().println(cts.getFacebookuserid() == 1);
response.getWriter().println(cts.getAlbumid() == 3);
response.getWriter().println(cts.getAccepted());
response.getWriter().println(cts.getNumScores() == 1);
response.getWriter().println(cts.getScore() == 1);

int[] vals = contest.getPointValues();

out.println(vals[0] == 500 && vals[1] == 300 && vals[2] == 100);

contest.setValues(new ContestSetter(){
	public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
	{
		IContestant contestant = (IContestant)parameters;
		
		writer.addScoreToContestant(contestant, 0L,4);

		writer.addScoreToContestant(contestant, 0L,4);
		return null;
	}
}, cts);

out.println(cts.getHasUserVoted(0L));
out.println(!cts.getHasUserVoted(1L));
response.getWriter().println(cts.getNumScores() == 2);
response.getWriter().println(cts.getScore()==2);

pca.setUserPoints(5L,100);

out.println(pca.getUserPoints(5L) ==100);

pca.addUserPoints(5L, 10);

out.println(pca.getUserPoints(5L) ==110);
}
catch(Exception e)
{
	//out.println(e);
}
%>