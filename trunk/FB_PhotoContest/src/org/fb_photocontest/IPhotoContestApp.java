package org.fb_photocontest;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import com.google.appengine.api.datastore.Key;

public interface IPhotoContestApp {
	/**
	 * The scoring type is how a contest is voted.
	 * RATING: A user will rate each picture from 1 to 5 stars
	 * VOTING: A user will have a certain number of votes to distribute amongst the photos
	 * @author Alex
	 *
	 */
	public static enum ScoringType {RATING, VOTING}
	
	/**
	 * The point system is how the points are given out when the contest is over.
	 * STANDARD: an algorithm according to how many contestans there are
	 * CUSTOM: 3 numbers that determine what 1st, 2nd, and 3rd place gets
	 * @author Alex
	 *
	 */
	public static enum PointSystem {STANDARD, CUSTOM}
	/**
	 * Retrieves a contest from its ID
	 * @param contestID The ID of the contest
	 * @return A Contest object
	 */
	public IContest getContest(int contestID);
	
	/**
	 * 
	 * This will create a new contest and insert it into the database.
	 * @param ContestTitle The title of the contest
	 * @param Description The description of the contest
	 * @param ScoringType Determines how the contest is scored (ie, by votes or by ratings)
	 * @param OpenToPublic If true, then anyone can be an applicant.  If false, one those invited can be an applicant.
	 * @param RegistrationDeadline The date and time that registration ends
	 * @param ContestStartDate The date that the contest starts
	 * @param ContestEndDate The date that the contest ends
	 * @param HasJudges If true, then the only people who can score the contest are assigned judges.  If false, then anyone can score a contest.
	 * @param Tags Tags are things that a user can use to find a contest (specific words)
	 * @param Message A message is something that is shown on the contest landing page that can be updated by the creator.
	 * @param ContestHostID Facebook user ID of the host (creator of contest)
	 * @param pointSystem How the points are given out when the contest is over.  Default for CUSTOM is 1000,500,100 for 1st, 2nd and 3rd.
	 * @return
	 */
	public IContest createContest(String ContestTitle, 
			  String Description,
			  ContestCategory category,
			  ScoringType ScoringType, 
			  Boolean OpenToPublic,
			  Date RegistrationDeadline,
			  Date ContestStartDate,
			  Date ContestEndDate,
			  Boolean HasJudges,
			  Collection<String> Tags,
			  String Message, 
			  Long ContestHostID,
			  PointSystem pointSystem
			  
			  );

	/**
	 * Use this constructor if you need to specify the list of judges.  This method
	 * assumes that you need judges.  To be safe, you can use the OTHER constructor,
	 * specify you need judges, then add them later.
	 * @param ContestTitle
	 * @param Description
	 * @param category
	 * @param ScoringType
	 * @param OpenToPublic
	 * @param RegistrationDeadline
	 * @param ContestStartDate
	 * @param ContestEndDate
	 * @param Judges
	 * @param Tags
	 * @param Message
	 * @param ContestHostID
	 * @return
	 */
	public IContest createContest(String ContestTitle, String Description, ContestCategory category,
			ScoringType ScoringType, Boolean OpenToPublic,
			Date RegistrationDeadline, Date ContestStartDate,
			Date ContestEndDate, Collection<Long> Judges, Collection<String> Tags,
			String Message,
			Long ContestHostID,PointSystem pointSystem);

	/**
	 * @deprecated Use the one that allows you to specify a PointSystem
	 * This will create a new contest and insert it into the database.
	 * @param ContestTitle The title of the contest
	 * @param Description The description of the contest
	 * @param ScoringType Determines how the contest is scored (ie, by votes or by ratings)
	 * @param OpenToPublic If true, then anyone can be an applicant.  If false, one those invited can be an applicant.
	 * @param RegistrationDeadline The date and time that registration ends
	 * @param ContestStartDate The date that the contest starts
	 * @param ContestEndDate The date that the contest ends
	 * @param HasJudges If true, then the only people who can score the contest are assigned judges.  If false, then anyone can score a contest.
	 * @param Tags Tags are things that a user can use to find a contest (specific words)
	 * @param Message A message is something that is shown on the contest landing page that can be updated by the creator.
	 * @param ContestHostID Facebook user ID of the host (creator of contest)
 	 * @return
 	 * @deprecated Use the one that allows you to specify a PointSystem
	 */
	@Deprecated
	public IContest createContest(String ContestTitle, 
			  String Description,
			  ContestCategory category,
			  ScoringType ScoringType, 
			  Boolean OpenToPublic,
			  Date RegistrationDeadline,
			  Date ContestStartDate,
			  Date ContestEndDate,
			  Boolean HasJudges,
			  Collection<String> Tags,
			  String Message, 
			  Long ContestHostID
			  );

	/**
	 * 
	 * Use this constructor if you need to specify the list of judges.  This method
	 * assumes that you need judges.  To be safe, you can use the OTHER constructor,
	 * specify you need judges, then add them later.
	 * @param ContestTitle
	 * @param Description
	 * @param category
	 * @param ScoringType
	 * @param OpenToPublic
	 * @param RegistrationDeadline
	 * @param ContestStartDate
	 * @param ContestEndDate
	 * @param Judges
	 * @param Tags
	 * @param Message
	 * @param ContestHostID
	 * @return
	 * @deprecated Use the one that allows you to specify a PointSystem
	 */
	@Deprecated
	public IContest createContest(String ContestTitle, String Description, ContestCategory category,
			ScoringType ScoringType, Boolean OpenToPublic,
			Date RegistrationDeadline, Date ContestStartDate,
			Date ContestEndDate, Collection<Long> Judges, Collection<String> Tags,
			String Message,
			Long ContestHostID);
	
	@Deprecated
	public IContest createContest(String ContestTitle, String Description, ContestCategory category,
			ScoringType ScoringType, Boolean OpenToPublic,
			Date RegistrationDeadline, Date ContestStartDate,
			Date ContestEndDate, Collection<Long> Judges, Collection<String> Tags,
			String Message);
	@Deprecated
	public IContest createContest(String ContestTitle, 
			  String Description,
			  ContestCategory category,
			  ScoringType ScoringType, 
			  Boolean OpenToPublic,
			  Date RegistrationDeadline,
			  Date ContestStartDate,
			  Date ContestEndDate,
			  Boolean HasJudges,
			  Collection<String> Tags,
			  String Message
			  );
	/**
	 * You could use this... but it is not recommended.
	 * @return
	 */
	public List<IContest> getContests();
	
	/**
	 * Retrieves a list of the possible categories
	 * @return
	 */
	public List<ContestCategory> getCategories();
	
	/**
	 * Retrieves a category from a Key (as returned from a contest)
	 * @param id
	 * @return
	 */
	public ContestCategory getCategoryFromKey(Key key);
	
	/**
	 * Retrieves a list of contests that are able to be registered
	 * (that is, registration deadline is not passed)
	 * The list will be sorted by registration deadline closest to ending.
	 * @return
	 */
	public List<IContest> getOpenContests(Date since, int numberOfResults);
	
	/**
	 * Retrieves a list of contests that have started but not ended.
	 * This will return a certain number of results in the order of
	 * contest deadline.  That is, contests that will end scoring soon
	 * will appear in front.
	 * @param since The contest enddate to search from.
	 * @return
	 */
	public List<IContest> getScorableContests(Date since, int numberOfResults);
	

	/**
	 * Retrieves the number of points a facebook user has.  If the id is not 
	 * recognized as someone who has received points, the return value is 0
	 */
	public int getUserPoints(Long facebookID);
	
	/**
	 * sets the values of points to a facebook user. 
	 * @param facebookID
	 * @param points
	 */
	public void setUserPoints(Long facebookID, int points);
	/**
	 * Adds the specified number of points to the user
	 * @param facebookID
	 * @param pointsToAdd If this is negative, then it will remove points (even to negative points).
	 */
	public void addUserPoints(Long facebookID, int pointsToAdd);
	
	/**
	 * Returns all contests that have ENDED, but not CLOSED.  This means
	 * points have not been applied yet.  Call this function if you want
	 * to get contests that need to have points applied.
	 * @return A list of contests
	 */
	public List<IContest> getEndedContests();
}
