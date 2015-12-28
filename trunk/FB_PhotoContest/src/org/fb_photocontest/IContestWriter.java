package org.fb_photocontest;

import java.util.Date;
import java.util.List;

public interface IContestWriter extends IContest {

	/**
	 * Modifies the description of the contest
	 */
	public void setContestDescription(String Description);
	
	/**
	 * Modifies the end date of the contest
	 * @param EndDate
	 */
	public void setContestEndDate(Date EndDate);
	
	/**
	 * Modifies the start date of the contest
	 * @param StartDate The start date must not be after the end date.
	 */
	public void setContestStartDate(Date StartDate);
	
	/**
	 * Modifies the end of the registration date.  This must be before the contest
	 * start date 
	 * @param RegDeadline
	 */
	public void setRegistrationDeadline(Date RegDeadline);
	
	/**
	 * Adds a judge to the competition in the form
	 * of a user ID
	 * @param facebookUserID
	 */
	public void addJudge(Long facebookUserID);
	
	/**
	 * Modifies the message that is displayed below the description
	 * on the contest landing page.
	 * @param Message
	 */
	public void setMessage(String Message);
	
	/**
	 * Replaces the list of judges for this contest.
	 * @param judges A list of Longs, which represents the IDs of the judges
	 */
	public void setJudges(List<Long> judges);
	
	/**
	 * Adds a contestant to a contest
	 * @param fbuserid The facebook user id of the contestant
	 * @param photoid The facebook photo id
	 * @param albumid The facebook album id
	 * @param title The title of the photo
	 * @param description The description of the photo
	 * @return
	 */
	public IContestant addContestant(Long fbuserid, Long photoid, Long albumid, String title, String description);
	
	/**
	 * Adds a tag to the contest
	 * @param tag
	 * @return True if the tag was added, False if the tag already exists
	 */
	public Boolean addTag(String tag);
	
	/**
	 * Removes a tag from the contest
	 * @param tag
	 * @return True if the tag was removed, false if the tag does not exist
	 */
	public Boolean removeTag(String tag);
	/**
	 * Modifies whether the contestant is actually in the contest. A user cannot
	 * be accepted if they are denied from the contest
	 */
	public void acceptContestant(IContestant contestant, Boolean isAccepted);

	/**
	 * If a user is denied, then they are not shown in the list
	 * of users that can be accepted.  A user cannot be denied if the
	 * user is accepted in the contest.
	 */
	public void blockContestant(IContestant contestant, Boolean isDenied);


	/**
	 * Adds score to a participant
	 * @param contestant The contestant that exists on the contest
	 * @param voterID The facebook ID of the voter
	 * @param score The score to add
	 * @return True if the voter hasn't voted, False otherwise
	 */
	public boolean addScoreToContestant(IContestant contestant, Long voterID, Integer score);

	
	/**
	 * Adds a score to the contestant.
	 * If the contest type is RATING, then the score is
	 * n, where n < maxNumRatings.  If the contest type
	 * is VOTING, then score is 1.
	 * @param contestant The contestant that belongs to this contest
	 * @param score The score to add.
	 * @deprecated Use addScoreToContestant(IContestant, voter, score)
	 */
	@Deprecated
	public void addScoreToContestant(IContestant contestant, Integer score);
	
	/**
	 * Allows you to set the custom point distribution if you are using the 
	 * CUSTOM point system
	 * @param firstPlace
	 * @param secondPlace
	 * @param thirdPlace
	 */
	public void setCustomScores(int firstPlace, int secondPlace, int thirdPlace);
	
	/**
	 * Sets whether points have been applied to first
	 * second and third place.
	 * @param applied
	 */
	public void setHasAppliedPoints(boolean applied);
	
	// Jackie Testing
	public void setWinners(Long first, Long second, Long third);
}
