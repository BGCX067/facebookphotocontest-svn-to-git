package org.fb_photocontest;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;

import com.google.appengine.api.datastore.Key;
import javax.jdo.Query;
import java.lang.NoSuchMethodException;
import org.datanucleus.exceptions.NucleusObjectNotFoundException;
import org.fb_photocontest.IPhotoContestApp.PointSystem;
import org.fb_photocontest.IPhotoContestApp.ScoringType;
 

public class PhotoContestApp implements IPhotoContestApp {

	
	private static PhotoContestApp pca = new PhotoContestApp();
	
	private PhotoContestApp()
	{}
	
	/**
	 * Retrieves an instance of this class
	 * @return PhotoContestApp
	 */
	public static PhotoContestApp getInstance()
	{
		return pca;
	}

	@Override
	public IContest createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate, Boolean HasJudges,
			Collection<String> Tags, String Message, Long ContestHostID,
			PointSystem pointSystem) {
		
		IContest contest = new Contest(ContestTitle, Description, category,
				ScoringType, OpenToPublic, RegistrationDeadline, ContestStartDate,
				ContestEndDate, HasJudges, Tags, Message, ContestHostID, pointSystem);

		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		
		try{
			contest = pm.makePersistent(contest);
			contest = pm.detachCopy(contest);
		}
		finally
		{
			pm.close();
		}
		
		return contest;
	}

	@Override
	public IContest createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate,
			Collection<Long> Judges, Collection<String> Tags, String Message,
			Long ContestHostID, PointSystem pointSystem) {
		
		IContest contest = new Contest(ContestTitle, Description, category,
				ScoringType, OpenToPublic, RegistrationDeadline, ContestStartDate,
				ContestEndDate, Judges, Tags, Message, ContestHostID, pointSystem);

		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		
		try{
			contest = pm.makePersistent(contest);
			contest = pm.detachCopy(contest);
		}
		finally
		{
			pm.close();
		}
		
		return contest;
	}

	@Override
	@Deprecated
	public IContest createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate, Boolean HasJudges,
			Collection<String> Tags, String Message, Long ContestHostID) {

		return createContest(ContestTitle, Description, category, ScoringType, OpenToPublic, RegistrationDeadline, ContestStartDate, ContestEndDate, HasJudges, Tags, Message, ContestHostID, PointSystem.STANDARD);
	}

	@Override
	@Deprecated
	public IContest createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate,
			Collection<Long> Judges, Collection<String> Tags, String Message,
			Long ContestHostID) {
		
		return createContest(ContestTitle, Description, category, ScoringType, OpenToPublic, RegistrationDeadline, ContestStartDate, ContestEndDate, 
				true, Tags, Message, ContestHostID, PointSystem.STANDARD);
	}


	public List<ContestCategory> getCategories()
	{
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

		List<ContestCategory> categories = null;
		
		try{
			categories = (List<ContestCategory> )pm.newQuery(ContestCategory.class).execute();
			for(ContestCategory c :categories);
		}
		catch(Exception e)
		{
			categories = null;
		}
		finally{
			pm.close();
		}
		
		return categories;

	}
	
	public ContestCategory getCategoryFromKey(Key key)
	{
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

		ContestCategory category;
		
		try{
			category = pm.getObjectById(ContestCategory.class, key.getId());
		}
		finally
		{
			pm.close();
		}
		
		return category;
	}
	@Override
	public IContest getContest(int contestID) {
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		
		Contest contest = null;
		
		try{
			contest = pm.getObjectById(Contest.class, contestID);
			contest.iterateLists();
		} 
		catch(Exception e )
		{
			contest = null;
		}
		finally
		{
			pm.close();
		}
		
		return contest;
	}

	@Override
	public List<IContest> getContests() {
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		List<IContest> contests =  new ArrayList<IContest>();
		try{
			Extent<Contest> e = pm.getExtent(Contest.class, false);
			
			for(Contest c : e)
			{
				c.iterateLists();
				contests.add(c);
			}
			e.closeAll();
		
		}
		finally
		{
			pm.close();
		}
	
		return contests;
	}

	@Override
	public List<IContest> getScorableContests(Date since, int numberOfResults)
	{
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

		List<IContest> results = new ArrayList<IContest>();
		try{
			Query q = pm.newQuery(Contest.class);
			
			q.setOrdering("contestEndDate desc");

			List<Contest> res = null;
			
			Date today = new Date();
			
			if (since == null)
			{
				q.declareParameters("java.util.Date today");
				q.setFilter("this.contestEndDate >= today");
				res = (List<Contest>)q.execute(today);
			}
			else
			{
				q.declareParameters("java.util.Date today, java.util.Date endhigh");
				q.setFilter("this.contestEndDate >= today && this.contestEndDate > endhigh");
				res= (List<Contest>)q.execute(today, since);
			}

			//q.setRange(arg0, arg1)
			
			if (res.iterator().hasNext())
			{
				for(Contest contest : res)
				{
					if (contest.getContestStartDate().compareTo(today) < 0)
					{
						contest.iterateLists();
						results.add(contest);
						

						if(results.size() == numberOfResults)
							break;
					}
				}
			}
			

		}
		finally
		{
			pm.close();
			
		}
		//return null;
		Collections.reverse(results);
		return results;
	}
	
	@Override
	public List<IContest> getOpenContests(Date since, int numberOfResults) {
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

		List<IContest> results = new ArrayList<IContest>();
		try{
			Query q = pm.newQuery(Contest.class);
			
			q.setOrdering("registrationDeadline asc");
			q.setRange(0, numberOfResults);
			List<Contest> res = null;
			
			Date today = new Date();
			
			if (since == null)
			{
				q.declareParameters("java.util.Date today");
				q.setFilter("registrationDeadline >= today");
				res= (List<Contest>)q.execute(today);
			}
			else
			{
				q.declareParameters("java.util.Date today, java.util.Date endhigh");
				q.setFilter("registrationDeadline >= today && registrationDeadline > endhigh");
				res= (List<Contest>)q.execute(today, since);
			}

			if (res.iterator().hasNext())
			{
				for(Contest contest : res)
				{
					contest.iterateLists();
					results.add(contest);
				
					if(results.size() == numberOfResults)
						break;
				}
			}
			

		}
		finally
		{
			pm.close();
			
		}

		return results;
	}

	@Override
	public void addUserPoints(Long facebookID, int pointsToAdd) {
		FacebookUser user = getFacebookUser(facebookID);
		
		if(user == null)
		{
			user = new FacebookUser(facebookID);
		}
		user.addPoints(pointsToAdd);
		
		saveFacebookUser(user);
	}

	@Override
	public int getUserPoints(Long facebookID) {
		FacebookUser user = getFacebookUser(facebookID);
		
		if(user == null)
			return 0;
		
		return user.getPoints();
		
	}

	@Override
	public void setUserPoints(Long facebookID, int points) {
		FacebookUser user = getFacebookUser(facebookID);
		
		if(user == null)
		{
			user = new FacebookUser(facebookID);
		}
		
		user.setPoints(points);
		
		saveFacebookUser(user);
	}
	
	/**
	 * This is a private function, so you guys won't be using it anyways.
	 * 
	 * @param facebookUser
	 * @return
	 */
	private FacebookUser getFacebookUser(Long facebookUser)
	{
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		
		FacebookUser user = null;
		
		try{
			user = pm.getObjectById(FacebookUser.class, facebookUser);
			user = pm.detachCopy(user);
		}
		catch(Exception e )
		{
			user = null;
		}
		finally
		{
			pm.close();
		}
		
		return user;
	}
    /**
	 * This is a private function, so you guys won't be using it anyways.
	 * 
	 * @param facebookUser
	 * @return
	 */
	private void saveFacebookUser(FacebookUser user)
	{
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();
		
		try{
			pm.makePersistent(user);
		}
		finally{
			pm.close();
		}
	}

	@Override
	public IContest createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate,
			Collection<Long> Judges, Collection<String> Tags, String Message) {
		throw new NoSuchMethodError("This method is deprecated.");
	}

	@Override
	public IContest createContest(String ContestTitle, String Description,
			ContestCategory category, ScoringType ScoringType,
			Boolean OpenToPublic, Date RegistrationDeadline,
			Date ContestStartDate, Date ContestEndDate, Boolean HasJudges,
			Collection<String> Tags, String Message) {
		// TODO Auto-generated method stub
		throw new NoSuchMethodError("This method is deprecated.");
	}

	@Override
	public List<IContest> getEndedContests() {
		PersistenceManager pm = PersistenceManagerFac.getInstance().getPersistenceManager();

		List<IContest> results = new ArrayList<IContest>();
		try{
			Query q = pm.newQuery(Contest.class);
			
			q.declareParameters("java.util.Date today");
			q.setOrdering("contestEndDate desc");
			q.setFilter("hasAppliedPoints == false && contestEndDate < today");
			
			List<Contest> res = null;

			res = (List<Contest>)q.execute(new Date());

			for(Contest c: res)
			{
				c.iterateLists();
				results.add(c);
			}
		
			

		}
		finally
		{
			pm.close();
			
		}
		//return null;
		//Collections.reverse(results);
		return results;
	}
}
