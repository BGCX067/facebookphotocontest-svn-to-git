package org.fb_photocontest;

import com.google.appengine.api.datastore.Key;

/**
 * This is storing the contestant or applicant that has applied to the competition.
 * @author Alex
 *
 */
public interface IContestant {

	/**
	 * Retrieves the facebook user id of the contestant
	 * @return
	 */
	public Long getFacebookuserid();

	/**
	 * A description of the picture
	 * @return
	 */
	public String getDescription();

	/**
	 * The title of the picture
	 * @return
	 */
	public String getPhotoTitle();

	/**
	 * The photo id on facebook of the picture
	 * @return
	 */
	public Long getPhotoid();

	/**
	 * The album id on facebook of the picture
	 * @return
	 */
	public Long getAlbumid();

	/**
	 * A unique value that identifies a contestant
	 * @return
	 */
	public Key getKey();

	/**
	 * Determines whether the contested has been accepted into the comepetition.
	 * @return
	 */
	public Boolean getAccepted();
	
	/**
	 * Determines whether the user is denied from being a
	 * contestant
	 * @return
	 */
	public Boolean getDenied();

	/**
	 * It gets the score of the contestent.
	 * If the score is RATING, then the score is 
	 * the sum of all ratings divided by the number
	 * of ratings.<br />If the score is VOTING,
	 * then the score is the number of votes.
	 * @return
	 */
	public Double getScore();
	
	/**
	 * Returns how many times this photo has been
	 * scored.  IE, how many times it has been rated or
	 * how many times it has been voted on.
	 * @return
	 */
	public Integer getNumScores();
	//public List<Integer> getScoringHistory();

	/**
	 * Determines whether the user with the given
	 * facebook id has voted
	 * @param fbUser
	 * @return True if the user has voted, false otherwise.
	 */
	public boolean getHasUserVoted(Long fbUser);
	
}