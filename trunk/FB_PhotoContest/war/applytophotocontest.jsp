<%@page contentType="text/html; charset=UTF-8"%>
<%@page session="false" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
<%@page import="javax.servlet.http.*" %>
<%@page import="java.io.*" %>
<%@page import="org.fb_photocontest.IPhotoContestApp" %>
<%@page import="org.fb_photocontest.PhotoContestApp" %>
<%@page import="org.fb_photocontest.IContest" %>
<%@page import="org.fb_photocontest.ContestSetter" %>
<%@page import="org.fb_photocontest.TFBCWrapper" %>
<%@page import="org.fb_photocontest.tools.ClientHttpRequest" %>
<%@page import="java.security.MessageDigest" %>
<%@page import="java.io.ByteArrayInputStream" %>
<%@page import="com.socialjava.TinyFBClient" %>
<%@page import="org.fb_photocontest.*" %>
<%@page import="java.net.URL" %>
<%@page import="java.net.URLConnection" %>



<%
	try {
		TFBCWrapper wrapper = new TFBCWrapper(request);
		String uid = request.getParameter("uid");
		String sessionKey= request.getParameter("session");
		String contestIDParam = request.getParameter("cid");
		String pid = request.getParameter("pid");
		String aid = request.getParameter("aid");
		String description = request.getParameter("description");
		String title = request.getParameter("title");
		
		
		String albumName = wrapper.getAlbumName();
		String albumDesc = wrapper.getAlbumDesc();
		String albumId = wrapper.getPhotoAlbumID(albumName, Long.parseLong(uid));
		if (albumId == null)
		{
			albumId = wrapper.createPhotoAlbum(albumName,albumDesc);
		}
		String photoInfo = wrapper.getPhotoInfo(Long.parseLong(pid),"pid");
		if (photoInfo == null)
		{
			%>
			<jsp:forward page="error.jsp">
				<jsp:param name="error_type" value="invalid_photo" />
			</jsp:forward>
			<%
		}
		int contestID = 0;
		try {
			contestID = Integer.parseInt(contestIDParam);
		} catch (NumberFormatException ex) {
			out.println("NumberFormatException: " + ex.getMessage());
		}
		
		if (contestID != 0) {
			IPhotoContestApp pca = PhotoContestApp.getInstance();
			IContest contest = pca.getContest(contestID);
			List<Contestant> contestantList = contest.getContestants();
			
			IContestant contestant = new Contestant(Long.parseLong(uid),Long.parseLong(pid),Long.parseLong(albumId),title,description,contest);
			
			contest.setValues(new ContestSetter()
			{
					public Object SetValues(org.fb_photocontest.IContestWriter writer, Object parameters)
					{
						IContestant contestant = (IContestant)parameters;
						writer.addContestant(contestant.getFacebookuserid(),contestant.getPhotoid(),contestant.getAlbumid(),contestant.getPhotoTitle(),contestant.getDescription()); 
						return null;
					}
			}
			, contestant);
			
			/*
			
			String contentType = request.getContentType();
			//here we are checking the content type is not equal to Null and  as well as the passed data from mulitpart/form-data is greater than or equal to 0
			if ((contentType != null)
					&& (contentType.indexOf("multipart/form-data") >= 0)) {

				DataInputStream in = new DataInputStream(request
						.getInputStream());
				//we are taking the length of Content type data
				int formDataLength = request.getContentLength();
				byte dataBytes[] = new byte[formDataLength];
				int byteRead = 0;
				int totalBytesRead = 0;
				//this loop converting the uploaded file into byte code
				while (totalBytesRead < formDataLength) {
					byteRead = in.read(dataBytes, totalBytesRead,
							formDataLength);
					totalBytesRead += byteRead;
				}

				String file = new String(dataBytes);

				//out.println(file);

				int imageStart = file
						.indexOf("Content-Type: image/jpeg");
				String preImage = file.substring(imageStart + 24);
				int imageEnd = preImage.indexOf("-----------------------------");
				String image = preImage.substring(0, imageEnd);
				byte[] imageData = image.getBytes();
				
				int filenameStart = file.indexOf("filename=");
				String preFilename = file.substring(filenameStart + 10);
				int filenameEnd = preFilename.indexOf("Content-Type: image/jpeg");
				String filename = preFilename.substring(0,filenameEnd - 3);
				String albumId = "90229433165882863";
				/*try {
				albumId = wrapper.createPhotoAlbum("Photo Contest Album","A description of the photo album");
				} catch (Exception ex)
				{
					out.println("create album exception: "+ex.getMessage());
				}*/

				//out.println("sigParms="+sigParms);
				/*try {
					TinyFBClient fbClient = new TinyFBClient();
					TreeMap<String, String> tm = new TreeMap<String, String>();
					tm.put("method", "photos.upload");
					tm.put("api_key", "00d5bcd88a76c3f671aa58e1c1856d6d");
					String call_id = String.valueOf(System.currentTimeMillis());
					tm.put("call_id", call_id);
					//tm.put("format", "XML");
					//tm.put("session_key",sessionKey );
					tm.put("v", "1.0");
					//tm.put("aid", albumId);
					


					
					String currentKey, currentValue, sigParms = "", encodedParm;

					Collection<String> c = tm.keySet();
					Iterator<String> itr = c.iterator();
					while (itr.hasNext()) {
						currentKey = (String) itr.next();
						currentValue = tm.get(currentKey);
						sigParms = sigParms + currentKey + "=" + currentValue;
					}

					
					String fbcSig = fbClient.generateSignature(sigParms,"0af16a8098cec9dd8516675f40cdf994");
					
					ClientHttpRequest fbRequest = new ClientHttpRequest("http://api.facebook.com/restserver.php?method=photos.upload");
					fbRequest.setParameter("method","photos.upload");
					fbRequest.setParameter("api_key","00d5bcd88a76c3f671aa58e1c1856d6d");
					//fbRequest.setParameter("session_key",sessionKey);
					fbRequest.setParameter("call_id",call_id);
					//fbRequest.setParameter("format", "XML");
					fbRequest.setParameter("v","1.0");
					//fbRequest.setParameter("aid", albumId);
					fbRequest.setParameter("sig",fbcSig);
					
					//URL url = new URL(photoUrl);
					//URLConnection conn = url.openConnection();
					//InputStream connInput = conn.getInputStream();
					
					//fbRequest.setParameter("",filename, connInput);
					fbRequest.setParameter("",filename, new ByteArrayInputStream(imageData));
					
					InputStream input = fbRequest.post();
					
					final char[] buffer = new char[0x10000];
					StringBuilder output = new StringBuilder();
					Reader readIn = new InputStreamReader(input,"UTF-8");
					int read;
					do {
						read = readIn.read(buffer, 0, buffer.length);
						if (read > 0) {
							output.append(buffer, 0, read);
						}
					} while (read > 0);

					out.println(output.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					out.println("IOException: " + e.getMessage());
				}

			}*/
		}%><%
		response.sendRedirect("http://apps.facebook.com/photo_contests/viewsinglephotocontest.jsp?cid="+contestIDParam);
	} catch (Exception ex) {

		out.println("Overall Exception: " + ex.getMessage());
	}
%>
