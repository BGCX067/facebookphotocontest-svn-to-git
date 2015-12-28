package org.fb_photocontest;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.fb_photocontest.IPhotoContestApp.PointSystem;
import org.fb_photocontest.IPhotoContestApp.ScoringType;

import com.google.appengine.api.datastore.Key;

public interface IContest {

	/**
	 * Name of the Contest
	 * @return
	 */
	public String getContestTitle();
	
	/**
	 * Description of the contest
	 * @return 
	 */
	public String getContestDescription();
	
	/**
	 * How the contest is scored (voting or rating)
	 * @return
	 */
	public ScoringType getScoringType();
	
	/**
	 * Determines whether anyone can apply, or only those invited can apply
	 * @return
	 */
	public Boolean isContestOpenToPublic();
	
	/**
	 * The date the contest ends
	 * @return
	 */
	public Date getContestEndDate();
	
	/**
	 * Retrieves the Facebook ID of the host that created the contest
	 * @return
	 */
	public Long getHostID();
	/**
	 * The date the contest starts
	 * @return
	 */
	public Date getContestStartDate();
	
	/**
	 * The date that registration ends
	 * @return
	 */
	public Date getContestRegistrationDeadline();
	
	/**
	 * This determines what each picture can be rated out of.
	 * This is only use if the scoring type is by rating
	 * @return
	 */
	public int getMaxNumRatings();
	
/*	*//**
	 * Determines whether the user with the given
	 * facebook id has voted
	 * @param fbUser
	 * @return True if the user has voted, false otherwise.
	 *//*
	public boolean getHasUserVoted(Long fbUser);*/
	/**
	 * Determines whether the contest uses judges to score the contest or 
	 * whether it is publicly scored
	 * @return
	 */
	public Boolean getHasJudges();
	
	/**
	 * Gets the message that can be updated by the user
	 * @return
	 */
	public String getMessage();
	
	/**
	 * Gets a list of judges.  If getHasJudges() is false, this returns null.
	 * @return A list of judges, or null if it does not apply.
	 */
	public List<Long> getJudges();
	
	/**
	 * Gets key
	 * @return
	 * @deprecated use getContestID() instead
	 */
	@Deprecated
	public Key getKey();
	
	/**
	 * Retrieves the unique id that identifies a Contest
	 * @return
	 */
	public Long getContestID();
	
	/**
	 * Returns the category
	 * @return
	 */
	public ContestCategory getCategory();
	/**
	 * This is used to modify the parameters of a contest.  
	 * @param setter A class that implements ContestSetter.  The method ContestSetter.SetValue(...) is called, 
	 * and within that, the parameters of the contest can be set.
	 */
	public void setValues(ContestSetter setter);
	
	/**
	 * This is used to modify parameters of a contest.  Parameters may be passed in,
	 * and a return value may be returned.  To use this, you must override ContestSetter.SetValue(ContestWriter, Object).
	 * @param setter A class that implements ContestSetter.  The method ContestSetter.SetValue(...) is called, 
	 * and within that, the parameters of the contest can be set.
	 * @param parameters An object parameter.  This can be a List, if more than one object is required.
	 * @return An object that you return from the implemented ContestSetter.
	 */
	public Object setValues(ContestSetter setter, Object parameters);
	/**
	 * Gets a list of contestants and applicants within a contest
	 * @return
	 */
	public List<Contestant> getContestants();

	/**
	 * A list of tags
	 * @return
	 */
	public List<String> getTags();
	
	/**
	 * Retrieves a contestant in this contest from the facebook id
	 * @param userID The user id to get
	 * @return A contestant, if it exists.  Otherwise, null
	 */
	public Contestant getContestantFromID(Long userID);
	
	/**
	 * Returns an array with 3 items.  A[0] = first place, A[1] = second place, A[2] = third place
	 * <br />
	 * Depending on the point system:<br />
	 * STANDARD: the values in the array are multipliers of # of contestants <br/>
	 * CUSTOM: the values in the array are points
	 * @return
	 */
	public int[] getPointValues();
	
	/**
	 * The point system is whether it is standard of negative
	 * @return
	 */
	public PointSystem getPointSystem();
	
	/**
	 * Get the number of accepted contestants
	 * @return
	 */
	public Integer getNumAccepted();
	
	/**
	 * Gets the list of accepted contestants
	 * @return
	 */
	public List<Contestant> getAcceptedContestants();
	
	/*
	 * Returns whether points have been applied to the first 
	 * second and third place
	 */
	public Boolean hasAppliedPoints();
	
	public HashMap<String, Long> getWinners();
}