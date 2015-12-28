package org.fb_photocontest;

import com.socialjava.TinyFBClient;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.lang.Exception;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpServletRequest;

import org.fb_photocontest.tools.MD5;

import net.sf.json.*;

/**
 * This is a TinyFBClient wrapper class to simplify some of the work on the front-end.
 * 
 * This Simple wrapper should be used when the session key is not specified, in other words
 * when the user hasn't authorized our application.
 * 
 * @author JH
 *
 */
public class TFBCWrapper {

	private TinyFBClient fbClient;
	private String sessionKey;
	final private String albumName = "Photo Contests! Photo Album";
	final private String albumDesc = "A public album for the Photo Contests! Application. " +
									 "Upload your photos to this folder if you want to apply " +
									 "to a Photo Contest.";
	// A JSON representation of the user's (firstName, lastName, and fullName).
	private String nameInfo;
	
	/*
	 * This cache is for retrieving the same info several times.
	 * 
	 * keys:
	 * 	"userID" - Represents the User's Facebook ID.
	 *  "firstN" - Represents the User's First Name on Facebook.
	 *  "lastN"  - Represents the User's Last Name on Facebook.
	 *  "fullN"  - Represents the User's Full Name on Facebook.
	 *  "hasExtPerm" - Represents the User's Permission level.
	 *  "photo"+<PID> - Represents a String of a JSONObject of the photo info of PID.
	 *  <uid>+<field> - Represents an User's (by uid) info, specified by field.
	 * 
	 */
	private Map<String, String> cache;

	/**
	 * The Constructor
	 * 
	 * @param request An HTTP Request to our server. (this should be coming from Facebook)
	 */
	public TFBCWrapper(HttpServletRequest request)
	{
		cache = new HashMap<String, String>();
		sessionKey = request.getParameter("fb_sig_session_key");
		fbClient = new TinyFBClient(
				"00d5bcd88a76c3f671aa58e1c1856d6d",
				"0af16a8098cec9dd8516675f40cdf994",
				sessionKey);
		request.setAttribute("tinyFBClient", fbClient); //must be included!
	}
	
	/**
	 * Gets the user's name information, and save it.
	 */
	private void getCurUserNameInfo()
	{	
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "users.getInfo");
		tm.put("uids", this.getCurUserFBID());
		tm.put("fields", "first_name, last_name, name");
		nameInfo = fbClient.call(tm);
	}
	
	
	
	private String getUserInfo(Collection<String> uids, String field)
	{
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "users.getInfo");
		
		String uidsStr = "";
		for (String uid : uids)
		{			
			uidsStr += uid + ", ";
		}
		
		tm.put("uids", uidsStr);
		tm.put("fields", field);
		String results = fbClient.call(tm);
		
		return results;
	}
	
	private String getPhotoInfo(Collection<String> pids)
	{

		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "fql.query");
		Iterator<String> pIter = pids.iterator();
		
		String pidsStr = "(";
		
		while(pIter.hasNext())
		{
			pidsStr += pIter.next();
			
			if (pIter.hasNext())
			{
				pidsStr += ", ";
			}
			else
			{
				pidsStr += ")";
				break;
			}
		}
		
		String qry = "SELECT pid, src_small, src_big, src, src_big_width, src_small_width, src_width" +
		 " FROM photo" +
		 " WHERE pid IN " + pidsStr;
		
		tm.put("query", qry);
		String results = fbClient.call(tm);
		
		return results;
	}
	
	/**
	 * Returns the value associated by key, inside the jsonArrayString that should contain only
	 * one JSONObject, as it will grab the value from the first JSONObject in the array.
	 * 
	 * @param jsonArrayString - String in the format of a JSONArray.
	 * @param key - The key that's associated with the value that you want.
	 * @return The value requested, null if n/a
	 */
	private String getJSONObjValue(String jsonArrayString, String key)
	{
		try
		{
			JSONObject obj = JSONArray.fromObject(jsonArrayString).getJSONObject(0);
			return obj.getString(key);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * Gets the Facebook ID of the currently logged in user.
	 * 
	 * @return The user's Facebook ID in String format.
	 */
	public String getCurUserFBID()
	{
		if (cache.containsKey("userID"))
		{
			return cache.get("userID");
		}
		else
		{
			String currentUserID;

			TreeMap<String, String> tm = new TreeMap<String, String>();
			tm.put("method", "users.getLoggedInUser");
			currentUserID = fbClient.call(tm);	

			cache.put("userID", currentUserID);
			return currentUserID;
		}
	}
	
	
	public String getAlbumName()
	{
		return this.albumName;
	}
	
	public String getAlbumDesc()
	{
		return this.albumDesc;
		
	}
	
	
	/**
	 * Gets the First Name of the currently logged in User.
	 * 
	 * @return The user's First Name on Facebook, null on error.
	 */
	public String getCurUserFirstName()
	{
		if (cache.containsKey("firstN"))
		{
			return cache.get("firstN");
		}
		else
		{
			if (nameInfo == null)
			{
				getCurUserNameInfo();
			}
			String firstName = getJSONObjValue(nameInfo, "first_name");
			
			if (firstName == null)
			{
				return null;
			}
			else
			{
				cache.put("firstN", firstName);
				return firstName;
			}
		}
	}
	
	/**
	 * Gets the Last Name of the currently logged in User.
	 * 
	 * @return The user's Last Name on Facebook.
	 */
	public String getCurUserLastName()
	{
		if (cache.containsKey("lastN"))
		{
			return cache.get("lastN");
		}
		else
		{
			if (nameInfo == null)
			{
				getCurUserNameInfo();
			}
			
			String lastName = getJSONObjValue(nameInfo, "last_name");
			
			if (lastName == null)
			{
				return null;
			}
			else
			{
				cache.put("lastN", lastName);
				return lastName;
			}
		}
	}
	
	/**
	 * Gets the Full Name of the currently logged in User.
	 * 
	 * @return The user's Full Name on Facebook.
	 */
	public String getCurUserFullName()
	{
		if (cache.containsKey("fullN"))
		{
			return cache.get("fullN");
		}
		else
		{
			if (nameInfo == null)
			{
				getCurUserNameInfo();
			}
			
			String fullName = getJSONObjValue(nameInfo, "name");
			
			if (fullName == null)
			{
				return null;
			}
			else
			{
				cache.put("fullN", fullName);
				return fullName;
			}
		}
	}
	
	/**
	 * This gets the time zone (offset of GMT) of the currently logged in user.
	 * 
	 * @return a String regarding the time offset relative to GMT.
	 */
	public String getCurUserTimeZone()
	{
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "users.getStandardInfo");
		tm.put("uids", this.getCurUserFBID());
		tm.put("fields", "timezone");
		String results = fbClient.call(tm);
		
		return this.getJSONObjValue(results, "timezone");
	}
	
	public String getSessionKey()
	{
		return this.sessionKey;
	}
	
	/**
	 * Checks whether or not the current user has given extended permissions of a particular
	 * type (specified by type) to our app.
	 * 
	 * @param type - The type of extended permission to check for
	 * @return True if user has given permission, False otherwise.
	 */
	public boolean userHasExtendedPermissions(String type)
	{
		if (cache.containsKey("hasExtPerm"+type))
		{
			String val = cache.get("hasExtPerm"+type);
			if (val.equalsIgnoreCase("true"))
				return true;
			else if (val.equalsIgnoreCase("false"))
				return false;
		}
		
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "users.hasAppPermission");
		tm.put("uid", this.getCurUserFBID());
		tm.put("ext_perm", type);
		String results = fbClient.call(tm);
		
		if (Integer.parseInt(results) == 1)
		{
			cache.put("hasExtPerm"+type, "true");
			return true;
		}
		else
		{
			cache.put("hasExtPerm"+type, "false");
			return false;
		}
	}
	
	/**
	 * This should return the value corresponding to the infoField specified for the collection of uids
	 * specified. 
	 * 
	 * For a list of possible infoFields, go to:
	 * http://wiki.developers.facebook.com/index.php/Users.getInfo
	 * 
	 * @param uids - A collection of all the uids, in Long format.
	 * @param infoField - A field of information to be requested.
	 * @return - A collection of the values requested.
	 */
	public Collection<String> getInfoFromUsers(Collection<Long> uids, String infoField)
	{
		Map<String, String> uidsInfoMap = new TreeMap<String, String>();
		Collection<String> stillNeeduids = new ArrayList<String>();
		Iterator<Long> uidsIter = uids.iterator();
		
		while (uidsIter.hasNext())
		{
			String uid = uidsIter.next().toString();
			uidsInfoMap.put(uid, null);
			String cacheKey = uid + infoField;
			
			if (cache.containsKey(cacheKey))
			{
				uidsInfoMap.put(uid, cache.get(cacheKey));
			}
			else
			{
				stillNeeduids.add(uid);
			}
		}
		
		if (stillNeeduids.isEmpty())
			return uidsInfoMap.values();
		
		String results = this.getUserInfo(stillNeeduids, infoField);
		JSONArray resArr = JSONArray.fromObject(results);
		for (int i=0; i<resArr.size(); i++)
		{
			JSONObject obj = resArr.getJSONObject(i);
			String uid = obj.getString("uid");
			String cacheKey = uid + infoField;
			String value = obj.getString(infoField);
			cache.put(cacheKey, value);
			uidsInfoMap.put(uid, value);
		}
		
		return uidsInfoMap.values();
	}
	
	/**
	 * This is the same as getInfoFromUsers but only gets info for a single user.
	 * @param uid
	 * @param infoField
	 * @return
	 */
	public String getInfoFromUser(Long uid, String infoField)
	{
		Collection<String> userid = new ArrayList<String>();
		userid.add(uid.toString());
		
		String results = this.getUserInfo(userid, infoField);
		JSONArray resArr = JSONArray.fromObject(results);

		JSONObject obj = resArr.getJSONObject(0);
		String uidStr = obj.getString("uid");
		String cacheKey = uidStr + infoField;
		String value = obj.getString(infoField);
		cache.put(cacheKey, value);
		
		return value;
	}
	
	/**
	 * Use this to get the URL of a photo, represented by photoFBID.
	 *
	 * 	The following size constraints on photos returned:
     * 		src - URL of photo, with max width 130px and max height 130px. May be blank.
     * 		src_big - URL of photo, with max width 604px and max height 604px. May be blank.
     * 		src_small - URL of photo, with with max width 75px and max height 225px. May be blank. 
     * 
	 * @param photoFBID - The Facebook photoID of the photo you want the URL for.
	 * @param size - The size of the picture you want.
	 * @return The URL of the picture requested.
	 */
	public String getPhotoURL(Long photoFBID, String size)
	{
		String results;
		if (cache.containsKey("photo"+photoFBID))
		{
			results = cache.get("photo"+photoFBID);
		}
		else
		{
			ArrayList<String> myPID = new ArrayList<String>();
			myPID.add(photoFBID.toString());
			results = getPhotoInfo(myPID);
			if (results != null)
			{
				cache.put("photo"+photoFBID, results);
			}
		}
		return getJSONObjValue(results, size);
	}
	
	/**
	 * Use this to get the URL of a photo with default size ("src")
	 * 
	 * @param photoFBID - The Facebook photoID of the photo you want the URL for.
	 * @return The URL of the picture requested.
	 */
	public String getPhotoURL(Long photoFBID)
	{
		return getPhotoURL(photoFBID, "src");
	}
	
	/**
	 * A more generalized query for photo information, which includes the URLs (as if it was from getPhotoURL()).
	 * 
	 * See http://wiki.developers.facebook.com/index.php/Photo_%28FQL%29 for more infomation.
	 * 
	 * @param photoFBID - The Facebook photoID of the photo you want the URL for.
	 * @param info - The kind of info requested.
	 * @return The info of the picture requested.
	 */
	public String getPhotoInfo(Long photoFBID, String info)
	{
		String results;
		if (cache.containsKey("photo"+photoFBID))
		{
			results = cache.get("photo"+photoFBID);
		}
		else
		{
			ArrayList<String> myPID = new ArrayList<String>();
			myPID.add(photoFBID.toString());
			results = getPhotoInfo(myPID);
			if (results != null)
			{
				cache.put("photo"+photoFBID, results);
			}
		}
		return getJSONObjValue(results, info);
	}
	
	/**
	 * APPEARS TO BE NOT WORKING, DON'T USE RIGHT NOW!!!
	 * 
	 * Use this to get a collection of URLs of photos. This is the more efficient way of getting a set of photo URLs
	 * compared to calling getPhotoURL multiple times. 
	 * 
	 * 	The following size constraints on photos returned:
     * 		src - URL of photo, with max width 130px and max height 130px. May be blank.
     * 		src_big - URL of photo, with max width 604px and max height 604px. May be blank.
     * 		src_small - URL of photo, with with max width 75px and max height 225px. May be blank. 
	 * 
	 * Note: Order may not necessary be the same as how you've provided the photoFBIDs. But if you want it to be in
	 * that order, clear the cache first using clearCache(), the call this method.
	 * 
	 * @param photoFBIDs - A collection of photoFBIDs as a Long Integer.
	 * @param size - The size of the photos you want
	 * @return A collection of URLs of the photos requested.
	 */
	public Collection<String> getPhotoURLs(Collection<Long> photoFBIDs, String size)
	{
		Map<String, String> pidsInfoMap = new TreeMap<String, String>();
		//Collection<String> photoURLs = new ArrayList<String>();
		ArrayList<String> stillNeedPIDs = new ArrayList<String>();
		
		Iterator<Long> pidIter = photoFBIDs.iterator();
		
		while (pidIter.hasNext())
		{
			String photoID = pidIter.next().toString();
			pidsInfoMap.put(photoID, null);
			
			if (cache.containsKey("photo"+photoID))
			{
				String photoInfo = cache.get("photo"+photoID);
				pidsInfoMap.put(photoID, getJSONObjValue(photoInfo, size));
			}
			else
			{
				stillNeedPIDs.add(photoID);
			}
		}
		
		if (stillNeedPIDs.isEmpty())
			return pidsInfoMap.values();
		
		String results = getPhotoInfo(stillNeedPIDs);
		
		JSONArray resArr;
		try
		{
			 resArr = JSONArray.fromObject(results);
		}
		catch(Exception e)
		{
			Collection<String> eS = new ArrayList<String>();
			eS.add(e.toString());
			return eS;
		}
		
		for (int i=0; i<resArr.size(); i++)
		{
			JSONObject obj = resArr.getJSONObject(i);
			String pid = obj.getString("pid");
			String value = "[" + obj.toString() + "]";
			cache.put("photo"+i, value);
			pidsInfoMap.put(pid, obj.getString(size));
		}

		return pidsInfoMap.values();
	}
	
	/**
	 * Use this to get the URL of photos with default size ("src")
	 * 
	 * @param photoFBIDs - A collection of photoFBIDs as a Long Integer.
	 * @return A collection of URLs of the photos requested.
	 */
	public Collection<String> getPhotoURLs(Collection<Long> photoFBIDs)
	{
		return getPhotoURLs(photoFBIDs, "src");
	}
	
	/**
	 * This creates a Photo Album in Facebook for the currently logged in user, 
	 * with the provided name and description.
	 * 
	 * @param name - The name of the Photo Album to create.
	 * @param description - The description for the Photo Album to create.
	 * @return The AID (AlbumID) of the created Photo Album as a String.
	 */
	public String createPhotoAlbum(String name, String description)
	{
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "photos.createAlbum");
		tm.put("name", name);
		tm.put("description", description);
		String results = fbClient.call(tm);
		
		String arr = "[" + results + "]"; // hack workaround
		
		String aid = getJSONObjValue(arr, "aid");
		
		if (aid == null)
		{
			return null;
		}
		else
		{
			return aid;
		}
	}
	
	
	/**
	 * Gets the ID of the photo album with name albumName from the user specified b albumOwnerID.
	 * 
	 * @param albumName - Name of the album
	 * @param albumOwnerID - a Long representation of the users facebook ID
	 * @return The Album ID as a string.
	 */
	public String getPhotoAlbumID(String albumName, Long albumOwnerID)
	{
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "fql_query");
		
		String uid = albumOwnerID.toString();
		
		String qry = "SELECT aid FROM album WHERE owner=\'" + uid + "\' AND name=\'" + albumName + "\'";
		
		tm.put("query", qry);
		String results = fbClient.call(tm);
		
		String aid = getJSONObjValue(results, "aid");
		
		if (aid == null)
		{
			return null;
		}
		else
		{
			return aid;
		}
	}
	
	/**
	 * Same as createPhotoAlbum above. 
	 * 
	 * Except a Long representation of the aid is returned instead.
	 * 
	 * @param name - The name of the Photo Album to create.
	 * @param description - The description for the Photo Album to create.
	 * @return The AID (AlbumID) of the created Photo Album as a Long.
	 */
	public Long createPhotoAlbumLong(String name, String description)
	{
		String aid = this.createPhotoAlbum(name, description);
		Long aidAsLong = Long.parseLong(aid);
		return aidAsLong;
	}
	
	/**
	 * At the moment, this returns a JSONArray of whatever your query asks for, you'll need to parse 
	 * the array to get exactly what you want. Use the net.sf.json.* library for help with parsing.
	 * 
	 * See http://wiki.developers.facebook.com/index.php/Fql.query for more info
	 * 
	 * @param query - A properly formatted FQL query as a String.
	 * @return A JSONArray with the results of the query, if query returns nothing, null is returned.
	 */
	public JSONArray fqlQuery(String query)
	{
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("method", "fql.query");
		tm.put("query", query);
		String results = fbClient.call(tm);
		if (results.equalsIgnoreCase("{}"))
			return null;
		else
		{
			JSONArray resultJArray = JSONArray.fromObject(results);
			return resultJArray;
		}
	}
	
	public String makeSig(String requestString, String secretKey)
	{
		
		 requestString = requestString+secretKey;
		 StringBuilder result = new StringBuilder();
		 try {
		 MessageDigest md = MessageDigest.getInstance("MD5");
		 for (byte b : md.digest(requestString.toString().getBytes())) {
		 result.append(Integer.toHexString((b & 0xf0) >>> 4));
		 result.append(Integer.toHexString(b & 0x0f));
		 }
		 return(result.toString());
		 } catch (NoSuchAlgorithmException e) {
		 return("Error: no MD5 ");
		 }
		
	}
	
	public String makeSig(String callId, String rawData, String albumID){
		StringBuilder builder = new StringBuilder("api_key=00d5bcd88a76c3f671aa58e1c1856d6d");
		builder = builder.append("aid=");
		builder = builder.append(albumID);
		builder = builder.append("call_id=");
		builder = builder.append(callId);
		builder = builder.append("session_key=");
		builder = builder.append(this.sessionKey);
		builder = builder.append("v=1.0");
		builder = builder.append(rawData);
		
		builder = builder.append("0af16a8098cec9dd8516675f40cdf994");
		MD5 md;
		String returnString = null;
		try {
			md = MD5.getInstance();
			returnString = md.hashData(builder.toString().getBytes());
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return returnString;
	}
	
	/**
	 * --ALPHA-- NOT WORKING YET
	 * 
	 * @param image
	 * @return
	 */
	public String uploadPhoto(String imageRawData, String fileName, String albumID) // is the RawData a String?
	{
		TreeMap<String, String> tm = new TreeMap<String, String>();
		tm.put("",imageRawData);
		tm.put("aid",albumID);
		String results = "no results";
		try {
		results = fbClient.call("photos.upload",tm);
		}
		catch (Exception ex)
		{
			return ex.getMessage();
		}
		/*ClientHttpRequest fbRequest;
		try {
			fbRequest = new ClientHttpRequest("http://api.facebook.com/restserver.php");
			fbRequest.setParameter("api_key","00d5bcd88a76c3f671aa58e1c1856d6d");
			String call_id = String.valueOf(System.currentTimeMillis());
			fbRequest.setParameter("call_id",call_id);
			fbRequest.setParameter("sig",makeSig(call_id,imageRawData,albumID));
			fbRequest.setParameter("v","1.0");
			fbRequest.setParameter("session_key",this.sessionKey);
			fbRequest.setParameter("aid", albumID);
			fbRequest.setParameter(fileName,imageRawData);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		
		return results;
	}
	
	/**
	 * For clearing the local cache for in this TFBCWrapper. If it's causing problems.
	 * 
	 */
	public void clearCache()
	{
		cache.clear();
	}
	
	/* this is for testing purposes only, you shouldn't need to get the Cache for anything. */
	public String getCache()
	{
		return cache.toString();
	}
}
