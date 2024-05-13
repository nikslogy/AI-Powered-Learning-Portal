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
      <input type="hidden" id="addcourse" value=<%=session.getAttribute("addcourse")%>>
      
      <%
      session.setAttribute("addcourse","s");
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
            
            		<ul class="list-group col-9 mb-3 border border-3">
                    <li class="list-group-item d-flex justify-content-between align-items-start">
                      <div class="ms-2 me-auto">
                        <div class="fw-bold"><%=rs.getString("course_name") %></div>
                        <%=rs.getString("description") %>
                      </div>
                      <span class=""><button type="button" class="btn btn-lg btn-info">Info</button></span>
                    </li>
                  </ul>
   	
                
                  <%} %>
            </div>
        </div>
    </div>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
        
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
	<script>
      	var addcoursestatus=document.getElementById("addcourse").value;
      	if(addcoursestatus=="success")
      		{
      		swal("Congratulations!","Course added succeccfully","success");
      		}
      	else if(addcoursestatus=="failed")
      		{
      		swal("Sorry!","Course not added","error");
      		}
      </script>
  </body>
</html>