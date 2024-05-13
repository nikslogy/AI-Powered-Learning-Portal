<!doctype html>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  </head>
  <body>
    <%@ include file="adminnavbar.jsp" %>
     <input type="hidden" id="deletecourse" value=<%=session.getAttribute("deletecourse")%>>
     
      <%
      session.setAttribute("deletecourse","s");
      %>
            <div class="col-2">

            </div>
            <div class="col py-3">
            	<%
            	Connection con = null;
            	ResultSet rs=null;
            try {
    			 Class.forName("org.postgresql.Driver");  
    			 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
    			 
    			 PreparedStatement pst = con.prepareStatement("select * from courses");
    		
    			 rs = pst.executeQuery();
    			
    			 
    		} catch (ClassNotFoundException | SQLException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}	 
            	%>
            	
            	<% while(rs.next()){ %>
            		<form action="deletecourseController">
            		<ul class="list-group col-9 mb-3 border border-3">
                    <li class="list-group-item d-flex justify-content-between align-items-start">
                      <div class="ms-2 me-auto">
                        <div class="fw-bold"><%=rs.getString("course_name") %></div>
                        <%=rs.getString("description") %>
                      </div>
                      <input type="hidden" value=<%=rs.getString("course_id")%> name="title">
                      <span class=""><button type="submit" class="btn btn-lg btn-info">Delete</button></span>
                    </li>
                  </ul>
   				</form>
                
                  <%} %>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
 	 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
  	 <script>
      	var deletecourse=document.getElementById("deletecourse").value;
      	if(deletecourse=="success")
      		{
      		swal("Congratulations!","Course deleted successfully","success");
      		}
      	else if(deletecourse=="failed")
      		{
      		swal("error!","Unable to delete course","error");
      		}
      </script>
  </body>
</html>