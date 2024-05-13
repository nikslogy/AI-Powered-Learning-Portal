<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	int topicid = Integer.parseInt(request.getParameter("topicid"));
	int i =0;
	Connection con = null;

	try {
	 Class.forName("org.postgresql.Driver");  
	 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
	 
	 PreparedStatement pst = con.prepareStatement("delete from learningdata where id = ?");
	pst.setInt(1,topicid);
	 i=pst.executeUpdate();
	
	 if(i>0)
	 {
		 
		session.setAttribute("deletecoursetopic","success");
		response.sendRedirect("adminedit.jsp");
	 }
	 else {
		 session.setAttribute("deletecoursetopic","failed");
		 response.sendRedirect("adminedit.jsp");
	 }
} catch (ClassNotFoundException | SQLException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}

%>
</body>
</html>