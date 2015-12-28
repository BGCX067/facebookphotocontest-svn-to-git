package org.fb_photocontest;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.fb_photocontest.IPhotoContestApp.ScoringType;

import com.google.appengine.api.datastore.Key;

@PersistenceCapable(identityType = IdentityType.APPLICATION, detachable = "true")
public class Contestant implements IContestant {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private Long fbuserid;
	
	@Persistent
	private String description;
	
	@Persistent
	private String title;
	
	@Persistent
	private Long photoid;
	
	@Persistent
	private Long albumid;

	@Persistent
	private Boolean accepted;
	
	@Persistent
	private Boolean denied;
	
	@Persistent
	private List<Integer> scoring;
	
	@Persistent
	private Integer sumScores;
	
	@Persistent
	private Integer numScores;
	
	@Persistent
	private ScoringType scoringType;
	
	@Persistent
	private Double Score;
	
	@Persistent
	private Set<Long> voters = new HashSet<Long>();
	
	public Contestant(){}
	
	public Contestant(Long fbuserid, Long photoid, Long albumid, String title, String description, IContest contest)
	{
		this.fbuserid = fbuserid;
		this.photoid = photoid;
		this.albumid = albumid;
		this.description = description;
		this.title = title;
		this.accepted = false;
		this.scoringType = contest.getScoringType();
		this.Score = 0.0;
		
	}


	public Long getFacebookuserid() {
		return fbuserid;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	public void setPhotoTitle(String title) {
		this.title = title;
	}

	public String getPhotoTitle() {
		return title;
	}


	public Long getPhotoid() {
		return photoid;
	}

	public Long getAlbumid() {
		return albumid;
	}


	public Key getKey() {
		return key;
	}
	

	public Boolean getAccepted()
	{
		return accepted;
	}
	
	public void setAccepted(Boolean isAccepted)
	{
		accepted = isAccepted;
	}

	public void setDenied(Boolean isDenied) 
	{
		denied = isDenied;
		
	}

	public boolean addScore(int score, Long voterFBID)
	{
		if(voters == null)
			voters = new HashSet<Long>();
		
		if(voters.contains(voterFBID))
			return false;
		
		voters.add(voterFBID);
		
		if(sumScores == null)
			sumScores = 0;
		
		sumScores += score;
		numScores = getNumScores() + 1;
		
		if (scoringType == ScoringType.VOTING)
			Score = getScore() + 1;
		else
			Score = ((double)sumScores) / numScores;
		
		return true;
	}
	@Override
	public Boolean getDenied() {
		return denied;
	}

	@Override
	public Integer getNumScores() {
		if(numScores == null)
			numScores = 0;
		
		return numScores;
	}

	@Override
	public Double getScore() {
		if(Score == null)
			Score = 0.0;
		
		return Score;
	}

	@Override
	public boolean getHasUserVoted(Long fbUser) {
		if(voters == null)
			voters = new HashSet<Long>();
		
		return voters.contains(fbUser);
		
	}
	
	public void iterateLists()
	{
		if(voters == null)
			voters = new HashSet<Long>();
		for(Long l : voters);
		
			
	}
	
//	@Override
//	public int hashCode() {
//		// TODO Auto-generated method stub
//		return key.hashCode();
//	}
//	
//	@Override
//	public boolean equals(Object obj) {
//		IContestant contestant = (IContestant)obj;
//		
//		return contestant.getFacebookuserid() == getFacebookuserid();
//			
//	}
}
