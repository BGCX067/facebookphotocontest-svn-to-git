<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="com.socialjava.TinyFBClient"%> 
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.text.DecimalFormat" %>
<%@page import="org.fb_photocontest.*"%>
<%@page import="java.lang.Exception"%>
<%@page import="javax.jdo.JDOHelper"%>
<%@page import="javax.jdo.PersistenceManager" %>
<%@page import="javax.jdo.PersistenceManagerFactory" %>
<%@page import="net.sf.json.*"%>
<style type="text/css">
span.green 
{
	color:#ffffff;
	font-weight:bold;
	background-color:green;
}

span.red
{
	color:#ffffff;
	font-weight:bold;
	background-color:red;
}
</style>
<%
	IPhotoContestApp pca = PhotoContestApp.getInstance();
	TFBCWrapper tfbcWrapper = new TFBCWrapper(request);
	PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
	DecimalFormat df = new DecimalFormat("#.#");

	/* Setup Categories 

	ContestCategory animalCategory = new ContestCategory("Animals");
	pm.makePersistent(animalCategory);
	ContestCategory comedyCategory = new ContestCategory("Comedy");
	pm.makePersistent(comedyCategory);
	pm.makePersistent(new ContestCategory("Art"));
	pm.makePersistent(new ContestCategory("General"));
	pm.makePersistent(new ContestCategory("Scenery"));
	pm.makePersistent(new ContestCategory("Models"));
	pm.makePersistent(new ContestCategory("Babies"));
	*/
	
	/* Setup Photo Contest Host */
	// James
	String jamesUID = "506130858";
	
	/* Setup Photo Competitors */
	// Jackie
	String jackieUID = "21007038";
	// Karen
	String karenUID = "21008177";
	// Alex
	String alexUID = "754788444";
	// Ray
	String rayUID = "514583918";
		
	/* Setup Photo Contests Voters */
	// Albert
	String albertUID = "572740397";
	// Mavis
	String mavisUID = "506018904";
	// Bill
	String billUID = "506748061";
	// Alice
	String aliceUID = "508549785";

	
	// get a list of categories
	List<ContestCategory> categories = pca.getCategories();
	
	// Common Variables
	boolean isPublic = true;
	//boolean hasJudges = yes;
	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm a");
	//IPhotoContestApp.ScoringType scoringType = IPhotoContestApp.ScoringType.VOTING;
	
	/* First Test Contest 
	Setup: This is a contest that currently has only 3 contestant, and registration has ended and contest has started.
		
	Host = Alex
	Contestants = Jackie, Karen, James (Accepted)
	Category = Others
	RegDeadline = 11/20/2009 12:01
	startScoreDate = 11/20/2009 12:02
	endScoreDate = 11/30/2009 11:59
	
	==================================================================================================================================
	*/
	String contestName1 = "James' Test Contest #1";
	String description1 = "This Test Contest is used for testing.";
	String hostStr = jamesUID;
	String contestMsg1 = "Testing Testing!";

	Collection<String> contestTags1 = new ArrayList<String>();
	contestTags1.add("James");
	contestTags1.add("Contest");
	contestTags1.add("First");
	contestTags1.add("Score");
	contestTags1.add("Test");
	
	IPhotoContestApp.ScoringType scoringType = IPhotoContestApp.ScoringType.RATING;
	
	Date eRegDate = dateFormat.parse("11/15/2009 06:00 pm");
	Date sScoreDate = dateFormat.parse("11/19/2009 09:30 am");
	Date eScoreDate = dateFormat.parse("11/25/2009 11:59 pm");
	
	Collection<Long> contestJudgesList1 = new ArrayList<Long>();
	contestJudgesList1.add(Long.parseLong(albertUID));
	contestJudgesList1.add(Long.parseLong(mavisUID));
	contestJudgesList1.add(Long.parseLong(billUID));
	contestJudgesList1.add(Long.parseLong(aliceUID));
	
	IContest contest1 = pca.createContest(contestName1, description1, categories.get(0),
			scoringType, isPublic, eRegDate, sScoreDate, 
			eScoreDate, contestJudgesList1, contestTags1, contestMsg1, Long.parseLong(jamesUID));	

	/* Start Adding Photo Contestants James, Jackie, Karen */
	IContestant james1 = (IContestant) contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 2173815482609187157L, 2173815482606543505L, "James' Test Pic", "Some Picture from James Cheng");
		}
	}, jamesUID );
	
	IContestant jackie1 = (IContestant) contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 90224541236747310L, 90224541198130993L, "Canada Flag?", "I think this picture is the Canada Flag one");
		}
	}, jackieUID );
	
	IContestant karen1 = (IContestant) contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			// Need to setup with proper photo info.
			return writer.addContestant(Long.parseLong(uid), 90229433204552731L, 90229433165882863L, "Karen's Test Picture", "Karen's Picture.. yay!");
		}
	}, karenUID );
	
	IContestant ray1 = (IContestant) contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 2173815482609187157L, 2173815482606543505L, "Ray Pic", "Some Picture Ray stole from James Cheng");
		}
	}, rayUID );
	
	/* Contestants are accepted for the Photo Contest */
	contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, james1);
	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, jackie1);
	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, karen1);
	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, ray1);
	/* End Adding Photo Contestants James, Jackie, Karen */
	
	out.print("Photo Contest Voting Score Test Setup Summary <br />");
	out.print("=================================== <br />");
	out.print("Photo Contest Name:" + contest1.getContestTitle() + "<br />");
	out.print("Photo Contest Description:" + contest1.getContestDescription() + "<br />");
	out.print("Photo Contest Scoring Type:" + contest1.getScoringType().toString() + "<br />");
	out.print("Number of Photo Contestants: 3 <br />");
	out.print("Photo Contestant #1: James <br />");
	out.print("Photo Contestant #2: Jackie <br />");
	out.print("Photo Contestant #3: Karen <br />");
	out.print("Photo Contestant #4: Ray <br />");
	out.print("Number of Photo Contest Judges: 5 <br />");
	out.print("Photo Contest Judge #1: Albert <br />");	
	out.print("Photo Contest Judge #2: Mavis <br />");	
	out.print("Photo Contest Judge #3: Bill <br />");	
	out.print("Photo Contest Judge #4: Alice <br />");	

	
	out.print("<br />");
	
	out.print("<b>Photo Contest Testing #1 - Checking the initial vote counts; Checking the score average from the votes</b><br />");
	out.print("------ Initial # of votes initially is 0 for each photo ------ <br />");
	out.print("=================================== <br />");	
	out.print("Number of Votes for James' Photo Contest: " + james1.getNumScores() + " - ");
	if(james1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (james1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for James' Photo Contest: " + james1.getScore() + " - ");
	if(james1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (james1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getScore()==0.0) + "</span><br />");
	}	
	out.print("Number of Votes for Jackie's Photo Contest: " + jackie1.getNumScores() + " - ");
	if(jackie1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (jackie1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Jackie's Photo Contest: " + jackie1.getScore() + " - ");
	if(jackie1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (jackie1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getScore()==0.0) + "</span><br />");
	}
	out.print("Number of Votes for Karen's Photo Contest: " + karen1.getNumScores() + " - ");	
	if(karen1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Karen's Photo Contest: " + karen1.getScore() + " - ");
	if(karen1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	out.print("Number of Votes for Ray's Photo Contest: " + ray1.getNumScores() + " - ");	
	if(ray1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Ray's Photo Contest: " + ray1.getScore() + " - ");
	if(ray1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	
	out.print("<br />");
	
	out.print("<b>Photo Contest Testing #2 - Checking the vote counts after a single vote occured; Checking the score average from the photo after a single vote occured</b><br />");
	out.print("------ Albert scores 5 for James' Photo ------ <br />");
	out.print("=================================== <br />");	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)572740397;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,5);
			return null;
		}
	}, james1);
	out.print("Number of Votes for James' Photo Contest: " + james1.getNumScores() + " - ");
	if(james1.getNumScores()==1)
	{
		out.print("<span class='green'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	out.print("Scoring Average of Votes for James' Photo Contest: " + james1.getScore() + " - ");
	if(james1.getScore() == 5.0)
	{
		out.print("<span class='green'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}	
	out.print("Number of Votes for Jackie's Photo Contest: " + jackie1.getNumScores() + " - ");
	if(jackie1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (jackie1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getNumScores()==0) + "</span><br />");
	}
	out.print("Scoring Average of Votes for Jackie's Photo Contest: " + jackie1.getScore() + " - ");
	if(jackie1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (jackie1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getScore()==0.0) + "</span><br />");
	}
	out.print("Number of Votes for Karen's Photo Contest: " + karen1.getNumScores() + " - ");	
	if(karen1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Karen's Photo Contest: " + karen1.getScore() + " - ");
	if(karen1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	out.print("Number of Votes for Ray's Photo Contest: " + ray1.getNumScores() + " - ");	
	if(ray1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Ray's Photo Contest: " + ray1.getScore() + " - ");
	if(ray1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	
	out.print("<br />");
	
	out.print("<b>Photo Contest Testing #3 - Checking the vote counts after multiple votes occured; Checking the score average of photos after a multiple votes occured</b><br />");
	out.print("------ Alice scores 3 for Jackie's Photo ------ <br />");
	out.print("------ Mavis scores 4 for Jackie's Photo ------ <br />");
	out.print("=================================== <br />");	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)508549785; 
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,3);
			return null;
		}
	}, jackie1);
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)506018904;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,4);
			return null;
		}
	}, jackie1);
	out.print("Number of Votes for James' Photo Contest: " + james1.getNumScores() + " - ");
	if(james1.getNumScores()==1)
	{
		out.print("<span class='green'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	out.print("Scoring Average of Votes for James' Photo Contest: " + james1.getScore() + " - ");
	if(james1.getScore() == 5.0)
	{
		out.print("<span class='green'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}	
	out.print("Number of Votes for Jackie's Photo Contest: " + jackie1.getNumScores() + " - ");
	if(jackie1.getNumScores()==2)
	{
		out.print("<span class='green'>Test: " + (jackie1.getNumScores()==2) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getNumScores()==2) + "</span><br />");
	}
	out.print("Scoring Average of Votes for Jackie's Photo Contest: " + jackie1.getScore() + " - ");
	if(jackie1.getScore() == 3.5)
	{
		out.print("<span class='green'>Test: " + (jackie1.getScore()==3.5) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getScore()==3.5) + "</span><br />");
	}
	out.print("Number of Votes for Karen's Photo Contest: " + karen1.getNumScores() + " - ");	
	if(karen1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Karen's Photo Contest: " + karen1.getScore() + " - ");
	if(karen1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	out.print("Number of Votes for Ray's Photo Contest: " + ray1.getNumScores() + " - ");	
	if(ray1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Ray's Photo Contest: " + ray1.getScore() + " - ");
	if(ray1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	
	out.print("<br />");
	
	out.print("<b>Photo Contest Testing #4 - Checking the vote counts after adding an exisiting vote to a photo again</b><br />");
	out.print("------ Albert somehow scores 3 for James' Photo again (Albert's original voting score will remain unchanged,ie 5) ------ <br />");
	out.print("=================================== <br />");	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)572740397;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,3);
			return null;
		}
	}, james1);
	out.print("Number of Votes for James' Photo Contest: " + james1.getNumScores() + " - ");
	if(james1.getNumScores()==1)
	{
		out.print("<span class='green'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	out.print("Scoring Average of Votes for James' Photo Contest: " + james1.getScore() + " - ");
	if(james1.getScore() == 5.0)
	{
		out.print("<span class='green'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}	
	out.print("Number of Votes for Jackie's Photo Contest: " + jackie1.getNumScores() + " - ");
	if(jackie1.getNumScores()==2)
	{
		out.print("<span class='green'>Test: " + (jackie1.getNumScores()==2) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getNumScores()==2) + "</span><br />");
	}
	out.print("Scoring Average of Votes for Jackie's Photo Contest: " + jackie1.getScore() + " - ");
	if(jackie1.getScore() == 3.5)
	{
		out.print("<span class='green'>Test: " + (jackie1.getScore()==3.5) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getScore()==3.5) + "</span><br />");
	}
	out.print("Number of Votes for Karen's Photo Contest: " + karen1.getNumScores() + " - ");	
	if(karen1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Karen's Photo Contest: " + karen1.getScore() + " - ");
	if(karen1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getScore()==0.0) + "</span><br />");
	}
	out.print("Number of Votes for Ray's Photo Contest: " + ray1.getNumScores() + " - ");	
	if(ray1.getNumScores()==0)
	{
		out.print("<span class='green'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getNumScores()==0) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Ray's Photo Contest: " + ray1.getScore() + " - ");
	if(ray1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	
	out.print("<br />");
	
	out.print("<b>Photo Contest Testing #5 - Checking the vote counts after adding a vote for each photos from a single voter</b><br />");
	out.print("------ Albert somehow scores 3 for James' Photo again (Albert's original voting score will remain unchanged,ie 5) ------ <br />");
	out.print("------ Albert scores 4 for Jackie's Photo ------ <br />");
	out.print("------ Albert scores 2 for Karen's Photo cuz he didn't the photo was good enough ------ <br />");
	out.print("------ Albert scores 0 for Ray's Photo cuz he hates him) ------ <br />");
	out.print("=================================== <br />");
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)572740397;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,3);
			return null;
		}
	}, james1);	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)572740397;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,4);
			return null;
		}
	}, jackie1);
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)572740397;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,2);
			return null;
		}
	}, karen1);
	contest1.setValues(new ContestSetter(){
		public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
		{
			Long voter = (long)572740397;
			IContestant contestant = (IContestant)parameters;
			writer.addScoreToContestant(contestant,voter,0);
			return null;
		}
	}, ray1);
	out.print("Number of Votes for James' Photo Contest: " + james1.getNumScores() + " - ");
	if(james1.getNumScores()==1)
	{
		out.print("<span class='green'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getNumScores()==1) + "</span><br />");
	}
	out.print("Scoring Average of Votes for James' Photo Contest: " + james1.getScore() + " - ");
	if(james1.getScore() == 5.0)
	{
		out.print("<span class='green'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (james1.getScore()==5.0) + "</span><br />");
	}	
	out.print("Number of Votes for Jackie's Photo Contest: " + jackie1.getNumScores() + " - ");
	if(jackie1.getNumScores()==3)
	{
		out.print("<span class='green'>Test: " + (jackie1.getNumScores()==3) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (jackie1.getNumScores()==3) + "</span><br />");
	}
	out.print("Scoring Average of Votes for Jackie's Photo Contest: " + Double.parseDouble(df.format(jackie1.getScore())) + " - ");
	if(Double.parseDouble(df.format(jackie1.getScore())) == 3.7)
	{
		out.print("<span class='green'>Test: " + (Double.parseDouble(df.format(jackie1.getScore())) == 3.7) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (Double.parseDouble(df.format(jackie1.getScore())) == 3.7) + "</span><br />");
	}
	out.print("Number of Votes for Karen's Photo Contest: " + karen1.getNumScores() + " - ");	
	if(karen1.getNumScores()==1)
	{
		out.print("<span class='green'>Test: " + (karen1.getNumScores()==1) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getNumScores()==1) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Karen's Photo Contest: " + karen1.getScore() + " - ");
	if(karen1.getScore() == 2.0)
	{
		out.print("<span class='green'>Test: " + (karen1.getScore()==2.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (karen1.getScore()==2.0) + "</span><br />");
	}
	out.print("Number of Votes for Ray's Photo Contest: " + ray1.getNumScores() + " - ");	
	if(ray1.getNumScores()==1)
	{
		out.print("<span class='green'>Test: " + (ray1.getNumScores()==1) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getNumScores()==1) + "</span><br />");
	}	
	out.print("Scoring Average of Votes for Ray's Photo Contest: " + ray1.getScore() + " - ");
	if(ray1.getScore() == 0.0)
	{
		out.print("<span class='green'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	else
	{
		out.print("<span class='red'>Test: " + (ray1.getScore()==0.0) + "</span><br />");
	}
	
	/* Delete the testing photo contests */
	pm.deletePersistent(contest1);
%>