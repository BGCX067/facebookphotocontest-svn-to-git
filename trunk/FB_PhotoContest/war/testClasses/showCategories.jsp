
<%@page import="org.fb_photocontest.PhotoContestApp"%>
<%@page import="org.fb_photocontest.IPhotoContestApp"%>
<%@page import="org.fb_photocontest.ContestCategory"%>
<%@page import="java.util.List"%>
<%@page import="org.fb_photocontest.PersistenceManagerFac"%>
<%@page import="javax.jdo.PersistenceManager"%><%
IPhotoContestApp pca = PhotoContestApp.getInstance();

List<ContestCategory> categories = pca.getCategories();

for(ContestCategory c : categories)
{
response.getWriter().println(c.getCategoryName());
}
%>