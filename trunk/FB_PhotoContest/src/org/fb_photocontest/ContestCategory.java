package org.fb_photocontest;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
 
@PersistenceCapable(identityType = IdentityType.APPLICATION, detachable="true")
public class ContestCategory {
	@Persistent
	private String CategoryName;
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	public ContestCategory(){}
	public ContestCategory(String name)
	{
		setCategoryName(name);
	}
	public void setCategoryName(String categoryName) {
		CategoryName = categoryName;
	}
	public String getCategoryName() {
		return CategoryName;
	}

	/**
	 * Returns the unique id for this category
	 * @return
	 */
	public Long getID()
	{
		return key.getId();
	}
	/**
	 * use getID()
	 * @return
	 */
	public Key getKey() {
		return key;
	}
}
