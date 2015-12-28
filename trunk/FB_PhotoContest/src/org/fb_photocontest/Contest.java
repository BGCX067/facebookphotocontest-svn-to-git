package org.fb_photocontest;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.jdo.PersistenceManager;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.NotPersistent;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import java.lang.*;

import org.fb_photocontest.IPhotoContestApp.PointSystem;
import org.fb_photocontest.IPhotoContestApp.ScoringType;

import com.google.appengine.api.datastore.Key;


@PersistenceCapable(identityType = IdentityType.APPLICATION, detachable="true")
public class Contest implements IContestWriter{

	private static final int MAX_NUM_RATINGS = 5;

	@PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Key key;

	@Persistent
	private List<Contestant> contestants;
	
	
	@Persistent
	private Date contestEndDate;
	
	@Persistent
	private Date registrationDeadline;
	
	@Persistent
	private Date contestStartDate;
	
	@Persistent
	private String contestTitle;
	
	@Persistent
	private int maxNumRatings;
	
	@Persistent
	private ScoringType scoringType;
	
	@Persistent
	private Boolean contestOpenToPublic;

	@Persistent
	private String contestDescription;

	@Persistent
	private Boolean hasJudges;
	
	@Persistent 
	private String message;
	
	@Persistent(defaultFetchGroup="true")
	private Key categoryKey;
	
	@Persistent
	private List<String> tags = new ArrayList<String>();
	
	@Persistent
	private List<Long> judges = new ArrayList<Long>();
	
	@Persistent
	private Long HostFBID;
	
	@Persistent
	private PointSystem pointSystem;
	
	@Persistent
	private Integer pointFirst;
	
	@Persistent
	private Integer pointSecond;
	
	@Persistent
	private Integer pointThird;

	@NotPersistent
	private List<Contestant> acceptedContestants = null;
	
	@Persistent
	private Integer numAccepted;
	
	@Persistent
	private Boolean hasAppliedPoints;
	
	@Persistent
	private Long firstWinner;

	@Persistent
	private Long secondWinner;

	@Persistent
	private Long thirdWinner;
	
/*	@Persistent
	private Set<Long> voters;*/
	

	@Override
	public void setValues(ContestSetter setter) {
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
	
		try{
			setter.SetValues(this);	
			
			pm.makePersistent(this);
		}
		finally{
			pm.close();
		}
		
	}

	@Override
	public Object setValues(ContestSetter setter, Object parameters) {
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		Object retVal = null;
		
		try{
			retVal = setter.SetValues(this,parameters);	
			
			pm.makePersistent(this);
		}
		finally{
			pm.close();
		}
		
		return retVal;
	}

	/**
	 * Creates a new contest with Judges.  If your contest does not use judges,
	 * use the other constructor.  Or if you don't want to put in the judges now,
	 * use the other constructor.
	 */
	public Contest(String ContestTitle, String Description, ContestCategory category,
			ScoringType ScoringType, Boolean OpenToPublic,
			Date RegistrationDeadline, Date ContestStartDate,
			Date ContestEndDate, Collection<Long> Judges, Collection<String> Tags,
			String Message, Long ContestHostID, PointSystem pointSystem)
	{
		createContest(ContestTitle, Description, category, ScoringType,
				OpenToPublic, RegistrationDeadline, ContestStartDate,
				ContestEndDate, Judges, Tags, Message, ContestHostID, pointSystem);
	}
	public Contest(String ContestTitle, String Description, ContestCategory category,
			ScoringType scoringType, Boolean OpenToPublic,
			Date RegistrationDeadline, Date ContestStartDate,
			Date ContestEndDate, Boolean HasJudges, Collection<String> Tags,
			String Message, Long ContestHostID, PointSystem pointSystem)
	{
		createContest(ContestTitle, Description, category,
				scoringType, OpenToPublic, RegistrationDeadline, ContestStartDate,
				ContestEndDate, new ArrayList<Long>(), Tags, Message, ContestHostID, pointSystem);
		
		hasJudges  = HasJudges;
	}
	

	private void createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate, Collection<Long> Judges,
			Collection<String> Tags, String Message, Long ContestHostID, PointSystem pointSystem) {
		contestTitle = ContestTitle;
		contestDescription = Description;
		registrationDeadline = RegistrationDeadline;
		contestStartDate = ContestStartDate;
		contestEndDate = ContestEndDate;
		scoringType = ScoringType;
		contestOpenToPublic = OpenToPublic;
		categoryKey = category.getKey();
		hasJudges = true;
		message = Message;
		maxNumRatings = MAX_NUM_RATINGS;
		HostFBID = ContestHostID;
		hasAppliedPoints = false;
		numAccepted = 0;
		firstWinner = null;
		secondWinner = null;
		thirdWinner = null;
		acceptedContestants = null;
		//acceptedContestants = new ArrayList<Contestant>();
		
		this.pointSystem = pointSystem;
		
		if(pointSystem == PointSystem.CUSTOM)
		{
			pointFirst = 1000;
			pointSecond = 500;
			pointThird = 100;
		}
		
		if(Tags != null)
			tags = new ArrayList<String>(Tags);
		
		
		if(Judges != null)
		{
			for(Long l : Judges);
			judges = new ArrayList<Long>(Judges);
		}
	}


	/**
	 * Empty constructor for persistence purposes
	 */
	public Contest() {}



	/* ================================================================================
	 * ================================================================================
	 * ================================================================================
	 * SETTERS AND GETTERS
	 * ================================================================================
	 * ================================================================================
	 */
	
	@Override
	public void acceptContestant(IContestant contestant, Boolean isAccepted) {
		if(contestants.contains(contestant))
		{
			((Contestant)contestant).setAccepted(isAccepted);
		
			acceptedContestants = null;
/*			if(isAccepted && !getAcceptedContestants().contains(contestant))
			{
				
				//getAcceptedContestants().add((Contestant)contestant);
				numAccepted = getNumAccepted() + 1;
			}
			if(!isAccepted && getAcceptedContestants().contains(contestant))
			{
				//getAcceptedContestants().remove(contestant);
				numAccepted = getNumAccepted() - 1;
			}*/
		}
	}

	@Override
	public void blockContestant(IContestant contestant, Boolean isDenied) {
		if(contestants.contains(contestant))
			((Contestant)contestant).setDenied(isDenied);
		
	}

	@Override
	public ContestCategory getCategory() {
		return PhotoContestApp.getInstance().getCategoryFromKey(categoryKey);
	}

	@Override
	public IContestant addContestant(Long fbuserid, Long photoid, Long albumid,
			String title, String description) {
		if (contestants == null)
			contestants = new ArrayList<Contestant>();
		
		
		// Add the contestant if they have not applied
		for( IContestant c : contestants)
		{
			if(c.getFacebookuserid().equals(fbuserid))
				return null;
		}
		
		IContestant newContestant = new Contestant(fbuserid, photoid, albumid, title, description, this);
	
		contestants.add((Contestant) newContestant);
	
		return newContestant;
		
	}

	@Override
	public List<Contestant> getContestants() {
		if (contestants == null)
			contestants = new ArrayList<Contestant>();
		
		return contestants;
	}

	@Override
	public String getContestDescription() {
		return contestDescription;
	}

	@Override
	public Date getContestEndDate() {
		return contestEndDate;
	}

	@Override
	public Date getContestRegistrationDeadline() {
		return registrationDeadline;
	}

	@Override
	public Date getContestStartDate() {
		return contestStartDate;
	}

	@Override
	public String getContestTitle() {
		return contestTitle;
	}

	@Override
	public int getMaxNumRatings() {
		return maxNumRatings;
	}

	@Override
	public ScoringType getScoringType() {
		return scoringType;
	}

	@Override 
	public Boolean isContestOpenToPublic() {
		return contestOpenToPublic;
	}

	@Override
	public Boolean getHasJudges() {
		return hasJudges;
	}

	@Override
	public String getMessage()
	{
		return message;
	}

	@Override
	@Deprecated
	public Key getKey() {
		throw new NoSuchMethodError("This method is deprecated");
		//return key;
	}
	@Override
	public Long getContestID() {
		return key.getId();
	}

	@Override
	public void addJudge(Long facebookUserID) {
		if (hasJudges == false)
			throw new IllegalStateException("This contest does not allow judges");
		
		if(judges == null)
			judges = new ArrayList<Long>();
		
		judges.add(facebookUserID);	
	}
	
	@Override
	public List<Long> getJudges() {
		
		if (hasJudges == false)
			throw new IllegalStateException("This contest does not allow judges");
		
		if(judges == null)
			 judges = new ArrayList<Long>();
		
		return judges;
	}

	@Override
	public void setContestDescription(String Description) {
		contestDescription = Description;
	}

	@Override
	public void setContestEndDate(Date EndDate) {
		contestEndDate = EndDate;
		
	}

	@Override
	public void setContestStartDate(Date StartDate) {
		contestStartDate = StartDate;
	}

	@Override
	public void setMessage(String Message) {
		message = Message;
	}

	@Override
	public void setRegistrationDeadline(Date RegDeadline) {
		registrationDeadline = RegDeadline;
		
	}

	@Override
	public List<String> getTags() {
		if(tags == null)
			tags = new ArrayList<String>();
		
		return tags;
	}

	@Override
	public Boolean addTag(String tag) {
		if(tags == null)
			tags = new ArrayList<String>();
		
		if(tags.contains(tag))
			return false;
	
		tags.add(tag);
		
		return true;
	}

	@Override
	public Boolean removeTag(String tag) {
		if(tags == null)
			tags = new ArrayList<String>();
		
		if(!tags.contains(tag))
			return false;
		
		tags.remove(tags);
		return true;

			
			
	}

	@Override
	public Long getHostID() {
		if (HostFBID == null)
			HostFBID = 0L;
		
		return HostFBID;
	}

	@Override
	public Contestant getContestantFromID(Long userID) {

		for(Contestant c : contestants)
			if (c.getFacebookuserid().equals(userID))
				return c;
		
		return null;
	}

	@Override
	public void setJudges(List<Long> judges) {
		this.judges = new ArrayList<Long>(judges);
		
	}

	@Override
	@Deprecated
	public void addScoreToContestant(IContestant contestant, Integer score) {
		throw new NoSuchMethodError("This method is deprecated");
/*		if (contestants.contains(contestant))
			((Contestant)contestant).addScore(score,0L);*/
	}

	@Override
	public boolean addScoreToContestant(IContestant contestant, Long voterID,
			Integer score) {
		if (contestants.contains(contestant))
		{
			return ((Contestant)contestant).addScore(score, voterID);
			
		}
		
		return false;

	}

	public void iterateLists()
	{
		for(Contestant r :getContestants())
			r.iterateLists();
		if(getHasJudges())
			for(Long l :getJudges());
		for(String s : getTags());
		for(Contestant r : getAcceptedContestants())
			r.iterateLists();
		
	}

	@Override
	public PointSystem getPointSystem() {
		return pointSystem;
	}

	@Override
	public int[] getPointValues() {
		int[] val = null;
		if(pointSystem == PointSystem.CUSTOM)
			val = new int[] {pointFirst, pointSecond, pointThird};
		else
		{
			int N = getNumAccepted();
			
			if (N >= 2 && N <=10)
				val = new int[] {10*N, 4*N, N};
			else if(N >=11 && N <= 20)
				val = new int[] {9*N, 3*N,N};
			else if(N >=21 && N <= 30)
				val = new int[] {8*N, 2*N,N};
			else if(N >=31 && N <= 40)
				val = new int[] {7*N, 2*N,N};
			else if(N >=41 && N <= 50)
				val = new int[] {6*N, 2*N,N};
			else
				val = new int[] {0, 0, 0};
			
		}
		
		return val;
	}
	
	@Override
	public void setCustomScores(int firstPlace, int secondPlace, int thirdPlace) {
		pointFirst = firstPlace;
		pointSecond = secondPlace;
		pointThird = thirdPlace;
	}

	@Override
	public Integer getNumAccepted() {

		return getAcceptedContestants().size();
	}
	
	@Override
	public List<Contestant> getAcceptedContestants()
	{
		if(acceptedContestants == null)
		{
			acceptedContestants = new ArrayList<Contestant>();
			for(Contestant c : contestants)
			{
				if(c.getAccepted())
					acceptedContestants.add(c);
			}
		}
		return acceptedContestants;
		
	}
/*	@Override
	public boolean getHasUserVoted(Long fbUser) {
		if(voters == null)
			voters = new HashSet<Long>();
		
		if(voters.contains(fbUser))
			return true;
		
		return false;
	}

*/

	@Override
	public Boolean hasAppliedPoints() {
		return hasAppliedPoints;
	}

	@Override
	public void setHasAppliedPoints(boolean applied) {
		hasAppliedPoints = applied;
	}
	
	@Override
	public HashMap<String, Long> getWinners() {
		HashMap<String, Long> winners = new HashMap<String, Long>();
		winners.put("FirstPlace", firstWinner);
		winners.put("SecondPlace", secondWinner);
		winners.put("ThirdPlace", thirdWinner);
		return winners;
	}
	
	@Override
	public void setWinners(Long first, Long second, Long third){
		firstWinner = first;
		secondWinner = second;
		thirdWinner = third;
	}
	
}
