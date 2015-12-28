package org.fb_photocontest;

/**
 * A Utilties class that contains few useful static functions/attributes that can be used by all objects and jsp files.
 *
 */
public class FB_PhotoContestUtils {
	
	/**
	 * These are the types of errors that error.jsp can handle.
	 *
	 */
	public static enum ErrType { 	not_logged_in,
									no_permission, 
									no_contest, 
									invalid_contest, 
									not_host, 
									under_construction,
									invalid_photo,
									general }
	
	/**
	 * This function is to remove all non-digit characters from the string.
	 * @param badString - The contaminated string.
	 * 
	 * @return String - The string with all non-digits removed.
	 */
	public static String cleanNumString(String badString)
	{
		String goodStr = badString.replaceAll("\\D", "");
		return goodStr;
	}
	
}
