<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="com.socialjava.TinyFBClient"%> 
<%@page import="java.util.Date"%>
<%@page import="java.util.TimeZone" %>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>

<%@page import="java.text.SimpleDateFormat" %>

<%@page import="org.fb_photocontest.*"%>
<%@page import="java.lang.Exception"%>
<%@page import="javax.jdo.JDOHelper"%>
<%@page import="javax.jdo.PersistenceManager" %>
<%@page import="javax.jdo.PersistenceManagerFactory" %>
<%@page import="net.sf.json.*"%>

<%

	IPhotoContestApp pca = PhotoContestApp.getInstance();

	PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

	/* Setup Categories */
	ContestCategory animalCategory = new ContestCategory("Animals");
	pm.makePersistent(animalCategory);
	ContestCategory comedyCategory = new ContestCategory("Comedy");
	pm.makePersistent(comedyCategory);
	pm.makePersistent(new ContestCategory("Art"));
	pm.makePersistent(new ContestCategory("General"));
	pm.makePersistent(new ContestCategory("Scenery"));
	pm.makePersistent(new ContestCategory("Models"));
	pm.makePersistent(new ContestCategory("Babies"));
	
	/* Setup Test Users */
	// Jackie
	String jackieUID = "21007038";
	Long jackieUIDLong = 21007038L;
	
	// James
	String jamesUID = "506130858";
	Long jamesUIDLong = 506130858L;
	
	// Karen
	String karenUID = "21008177";
	Long karenUIDLong = 21008177L;
	
	// Alex
	String alexUID = "754788444";
	Long alexUIDLong = 754788444L;
	
	
	// Common Variables
	boolean isPublic = true;
	boolean hasJudges = false;
	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	dateFormat.setTimeZone(TimeZone.getTimeZone("PST"));
	IPhotoContestApp.ScoringType vType = IPhotoContestApp.ScoringType.VOTING;
	IPhotoContestApp.ScoringType rType = IPhotoContestApp.ScoringType.RATING;
	
	/* First Test Contest 
	Setup: This is a contest that currently has only 1 contestant, and registration is still active.
		
	Host = Jackie (Not Set)
	Contestants = Jackie (Accepted)
	Category = Animals
	RegDeadline = 12/21/2009 12:01
	startScoreDate = 12/21/2009 12:02
	endScoreDate = 12/31/2009 11:59
	
	==================================================================================================================================
	*/
	String contestName1 = "Jackie's Contest";
	String description1 = "This is my first contest. Please give it a try!";
	String hostStr = jackieUID;
	String contestMsg1 = "Testing Testing!";

	Collection<String> contestTags1 = new ArrayList<String>();
	contestTags1.add("Jackie");
	contestTags1.add("Contest");
	contestTags1.add("First");
	contestTags1.add("Animal");
	
	Date eRegDate = dateFormat.parse("12/21/2009 12:01");
	Date sScoreDate = dateFormat.parse("12/21/2009 12:02");
	Date eScoreDate = dateFormat.parse("12/31/2009 11:59");
	
	IContest contest1 = pca.createContest(contestName1, description1, animalCategory,
			vType, isPublic, eRegDate, sScoreDate, 
			eScoreDate, hasJudges, contestTags1, contestMsg1, jackieUIDLong, IPhotoContestApp.PointSystem.STANDARD);
	
	IContestant jackie = (IContestant) contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 90224541236732396L, 90224541198130993L, "Flower", "A Flower Picture on My Mac");
		}
	}, jackieUID );
	
	contest1.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, jackie);

	/* Second Test Contest 
	Setup: Scoring is not available yet, but registration has ended. This has 2 contestants, but only 1 accepted. 
		
	Host = James
	Contestants = James (Accepted), Jackie (Not Accepted)
	Category = Comedy
	RegDeadline = 11/19/2009 12:01
	startScoreDate = 12/25/2009 12:02
	endScoreDate = 12/31/2009 11:59
	==================================================================================================================================
	*/
	
	String contestName2 = "Second Test Contest";
	String description2 = "Description for second contest! host: James";
	String contestMsg2 = "Testing 2 Testing again!!";
	Collection<String> contestTags2 = new ArrayList<String>();
	contestTags2.add("Two");
	contestTags2.add("Contest");
	contestTags2.add("Second");
	contestTags2.add("Comedy");

	Date eRegDate2 = null;
	Date sScoreDate2 = null;
	Date eScoreDate2 = null;
	
	eRegDate2 = dateFormat.parse("11/29/2009 12:01");
	sScoreDate2 = dateFormat.parse("12/25/2009 12:02");
	eScoreDate2 = dateFormat.parse("12/31/2009 11:59");
	
	IContest contest2 = pca.createContest(contestName2, description2, comedyCategory,
			vType, isPublic, eRegDate2, sScoreDate2, 
			eScoreDate2, hasJudges, contestTags2, contestMsg2, jamesUIDLong, IPhotoContestApp.PointSystem.STANDARD);
	
	IContestant james2 = (IContestant) contest2.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 2173815482609187157L, 2173815482606543505L, "James' Test Pic", "Some Picture from James Cheng");
		}
	}, jamesUID );
	
	IContestant jackie2 = (IContestant) contest2.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 90224541236747310L, 90224541198130993L, "Canada Flag?", "I think this picture is the Canada Flag one");
		}
	}, jackieUID );
	
	contest2.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, james2);
	
	/* Third Test Contest 
	Setup: Scoring has started for this contest, with a total of 3 contestants. (Rating)
		
	Host = Karen
	Contestants = James (Accepted), Jackie (Accepted), Karen (Accepted)
	Category = Comedy
	RegDeadline = 11/10/2009 12:01 (Note: Expired)
	startScoreDate = 11/11/2009 12:02 (Expired)
	endScoreDate = 12/30/2009 11:59
	==================================================================================================================================
	*/
	
	String contestName3 = "3rd Test Contest";
	String description3 = "Description for 3rd contest! Host: Karen";
	String contestMsg3 = "Testing, One Two 3!";
	Collection<String> contestTags3 = new ArrayList<String>();
	contestTags3.add("Three");
	contestTags3.add("Contest");
	contestTags3.add("Third");
	contestTags3.add("Comedy");

	Date eRegDate3 = dateFormat.parse("11/10/2009 12:01");
	Date sScoreDate3 = dateFormat.parse("11/11/2009 12:02");
	Date eScoreDate3 = dateFormat.parse("12/30/2009 11:59");
	
	IContest contest3 = pca.createContest(contestName3, description3, comedyCategory,
			rType, isPublic, eRegDate3, sScoreDate3, 
			eScoreDate3, hasJudges, contestTags3, contestMsg3, karenUIDLong, IPhotoContestApp.PointSystem.STANDARD);
	
	IContestant james3 = (IContestant) contest3.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 2173815482609187157L, 2173815482606543505L, "James' Test Pic", "Some Picture from James Cheng");
		}
	}, jamesUID );
	
	IContestant jackie3 = (IContestant) contest3.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 90224541236747310L, 90224541198130993L, "Canada Flag?", "I think this picture is the Canada Flag one");
		}
	}, jackieUID );
	
	IContestant karen3 = (IContestant) contest3.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			// Need to setup with proper photo info.
			return writer.addContestant(Long.parseLong(uid), 90229433204552731L, 90229433165882863L, "Karen's Test Picture", "Karen's Picture.. yay!");
		}
	}, karenUID );
	
	contest3.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, james3);
	
	contest3.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, jackie3);
	
	contest3.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			IContestant c = (IContestant) parameter;
			writer.acceptContestant(c, true);
			return null;
		}
	}, karen3);
	
	/* Fourth Test Contest 
	Setup: Scoring has started for this contest, with a total of 3 contestants. (Voting)
		
	Host = Alex
	Contestants = James (Accepted), Jackie (Not Accepted), Karen (Accepted)
	Category = Animals
	RegDeadline = 11/10/2009 12:01 (Note: Expired)
	startScoreDate = 11/10/2009 12:02 (expired)
	endScoreDate = 11/30/2009 11:59
	==================================================================================================================================
	*/
	
	String contestName4 = "Fourth (4th) Test Contest";
	String description4 = "Description for 4 contest! host: Alex";
	String contestMsg4 = "Testing, One Two three FOUR 4444 !";
	Collection<String> contestTags4 = new ArrayList<String>();
	contestTags4.add("Four!");
	contestTags4.add("4");
	contestTags4.add("Fourth");
	contestTags4.add("Contest");
	contestTags4.add("Animals");

	Date eRegDate4 = dateFormat.parse("11/10/2009 12:01");
	Date sScoreDate4 = dateFormat.parse("11/10/2009 12:02");
	Date eScoreDate4 = dateFormat.parse("11/30/2009 11:59");
	
	IContest contest4 = pca.createContest(contestName4, description4, animalCategory,
			vType, isPublic, eRegDate4, sScoreDate4, 
			eScoreDate4, hasJudges, contestTags4, contestMsg4, alexUIDLong, IPhotoContestApp.PointSystem.STANDARD);
	
	IContestant james4 = (IContestant) contest4.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 2173815482609187157L, 2173815482606543505L, "James' Test Pic", "Some Picture from James Cheng");
		}
	}, jamesUID );
	
	IContestant jackie4 = (IContestant) contest4.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 90224541236747310L, 90224541198130993L, "Canada Flag?", "I think this picture is the Canada Flag one");
		}
	}, jackieUID );
	
	IContestant karen4 = (IContestant) contest4.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			// Need to setup with proper photo info.
			return writer.addContestant(Long.parseLong(uid), 90229433204552731L, 90229433165882863L, "Karen's Test Picture", "Karen's Picture.. yay!");
		}
	}, karenUID );
	
	Collection<IContestant> conts = new ArrayList<IContestant>();
	
	conts.add(james4);
	//conts.add(jackie4); Jackie Not Accepted
	conts.add(karen4);
	
	contest4.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			Collection<IContestant> conts = (Collection<IContestant>) parameter;
			for (IContestant c : conts)
			{
				writer.acceptContestant(c, true);
			}
			return null;
		}
	}, conts);
	
	/* Fourth Test Contest 
	Setup: Scoring has started for this contest, with a total of 3 contestants. (Voting)
		
	Host = Jackie
	Contestants = James (Not Accepted), Alex [with jackie's picture] (Accepted), Karen (Accepted)
	Category = Animals
	RegDeadline = 11/10/2009 12:01 (Note: Expired)
	startScoreDate = 11/30/2009 12:02 (Expired)
	endScoreDate = 12/31/2009 11:59
	
	Points = 2000 (1st), 500 (2nd), 100 (3rd)
	==================================================================================================================================
	*/
	
	String contestName5 = "Fifth (5th) Test Contest";
	String description5 = "Jackie's Fifth Contest! Host: Jackie";
	String contestMsg5 = "Five Alive!";
	Collection<String> contestTags5 = new ArrayList<String>();
	contestTags5.add("Five!");
	contestTags5.add("5");
	contestTags5.add("Fifth");
	contestTags5.add("Contest");
	contestTags5.add("Animals");

	Date eRegDate5 = dateFormat.parse("11/10/2009 12:01");
	Date sScoreDate5 = dateFormat.parse("11/30/2009 12:02");
	Date eScoreDate5 = dateFormat.parse("12/31/2009 11:59");
	
	IContest contest5 = pca.createContest(contestName5, description5, animalCategory,
			vType, isPublic, eRegDate5, sScoreDate5, 
			eScoreDate5, hasJudges, contestTags5, contestMsg5, jackieUIDLong, IPhotoContestApp.PointSystem.CUSTOM);
	
	contest5.setValues(new ContestSetter(){
		public void SetValues(IContestWriter writer)
		{
			writer.setCustomScores(2000, 500, 100);
		}
	});
	
	IContestant james5 = (IContestant) contest5.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			return writer.addContestant(Long.parseLong(uid), 2173815482609187157L, 2173815482606543505L, "James' Test Pic", "Some Picture from James Cheng");
		}
	}, jamesUID );
	
	IContestant alex5 = (IContestant) contest5.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			// Alex using Jackie's Picture
			return writer.addContestant(Long.parseLong(uid), 90224541236747310L, 90224541198130993L, "Canada Flag?", "I think this picture is the Canada Flag one");
		}
	}, alexUID );
	
	IContestant karen5 = (IContestant) contest5.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			String uid = (String) parameter;
			// Need to setup with proper photo info.
			return writer.addContestant(Long.parseLong(uid), 90229433204552731L, 90229433165882863L, "Karen's Test Picture", "Karen's Picture.. yay!");
		}
	}, karenUID );
	
	Collection<IContestant> conts2 = new ArrayList<IContestant>();
	
	//conts2.add(james5);
	conts2.add(alex5);
	conts2.add(karen5);
	
	contest5.setValues(new ContestSetter(){
		public Object SetValues(IContestWriter writer, Object parameter)
		{
			Collection<IContestant> con = (Collection<IContestant>) parameter;
			for (IContestant c : con)
			{
				writer.acceptContestant(c, true);
			}
			return null;
		}
	}, conts2);
	
	out.println("Done!");
%>