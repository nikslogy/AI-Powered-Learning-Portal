<!DOCTYPE html>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="tinymce/js/tinymce/tinymce.min.js"></script>
  </head>
  <body>
    <%@ include file="adminnavbar.jsp" %>
            <div class="col-1">

            </div>
            <%
            Connection con = null;
        	ResultSet rs=null;
        	int topicid = Integer.parseInt(request.getParameter("topicid"));
       		 try {
			 		Class.forName("org.postgresql.Driver");  
			 		con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
			 
					 PreparedStatement pst = con.prepareStatement("select * from learningdata where id=?");
					pst.setInt(1,topicid);
					 rs = pst.executeQuery();
			
			 
			} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
				e.printStackTrace();
			}	 
            %>
            
            <% while(rs.next()){ %>
            <div class="col-7 py-3">
            <form action="editcoursetopiccontroller" method="post">
            	<div class="mb-3">
                   <h2> <label for="exampleFormControlInput1" class="form-label">Title</label></h2>
                    <textarea class="form-control" id="exampleFormControlTextarea1" name="title" rows="3"><%=rs.getString("title")%></textarea>
                  </div>
                  <div class="mb-3">
                    <h2><label for="exampleFormControlTextarea1" class="form-label">Description</label></h2>
                    <textarea class="form-control" id="exampleFormControlTextarea1" name="description" rows="3"><%=rs.getString("description")%></textarea>
                  </div>
                  <input type="hidden" value=<%=rs.getInt("id")%> name="id">
                  <button type="submit" class="btn btn-primary">Update</button>
             </form>
            </div>
            <%} %>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
    <script>
  tinymce.init({
    selector: 'textarea#exampleFormControlTextarea1', // Use the correct ID
    // Add more TinyMCE options as needed
  });
</script>
  </body>
</html>