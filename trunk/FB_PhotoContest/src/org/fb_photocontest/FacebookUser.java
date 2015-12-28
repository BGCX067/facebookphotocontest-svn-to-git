package org.fb_photocontest;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@PersistenceCapable(identityType = IdentityType.APPLICATION, detachable="true")
class FacebookUser  {

	@PrimaryKey 
	@Persistent
	public Key key;
	
	@Persistent
	public Integer points = 0;
	
	public FacebookUser(Long fbID)
	{
		this.key = KeyFactory.createKey(FacebookUser.class.getSimpleName(), fbID);
		this.points = 0;
		
	}
	public FacebookUser(){};
	

	public Long getFacebookUserID() {
		return key.getId();
	}


	public Integer getPoints() {
		if(points == null)
			points = 0;
		
		return points;
	}
	public void setPoints(Integer points) {
		this.points = points;
		
	}
	
	public void addPoints(Integer points){
		this.points += points;
	}

}
