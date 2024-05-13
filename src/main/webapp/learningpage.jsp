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
    <title>Learning Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
    
    .quiz-link:hover {
    cursor: pointer;
  }
      .content {
    margin-top: 50px;
    padding: 20px;
  }
  
  .navigation-buttons {
        position: fixed;
        bottom: 0;
        width: 100%;
        padding: 10px 0; 
        background-color: #f8f9fa; 
    }
    .prev-button {
        float: left;
        margin-left: 10px; 
    }
    .next-button {
        float: right;
        margin-right: 10px;
    }
    </style>
    
<script>
      var isSpeaking = false;
      var msg = new SpeechSynthesisUtterance();
      var textToSpeak = '';

      // Initialize the speech synthesis utterance
      window.onload = function() {
        textToSpeak = document.querySelector('.content').innerText;
        msg.text = textToSpeak;
        msg.onend = function(event) {
          console.log('Finished in ' + event.elapsedTime + ' seconds.');
          isSpeaking = false;
          updateButton();
        };
      }

      function toggleSpeech() {
        if (!isSpeaking) {
          window.speechSynthesis.speak(msg);
        } else {
          window.speechSynthesis.cancel();
        }
        isSpeaking = !isSpeaking;
        updateButton();
      }

      function updateButton() {
        var button = document.getElementById('speakButton');
        if (isSpeaking) {
          button.innerText = 'Pause';
        } else {
          button.innerText = 'Read Content';
        }
      }
      
    </script>
    
  </head>
  <body>
    <div>

    
    <nav class="navbar navbar-dark bg-dark fixed-top">
      <div class="container-fluid">
        <a class="navbar-brand" href="#"><%=request.getParameter("coursename") %></a>
        <div class="ms-auto p-1">
                <button id="speakButton" class="btn btn-danger btn-rounded" data-mdb-ripple-init onclick="toggleSpeech()">Read Content</button>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasDarkNavbar" aria-controls="offcanvasDarkNavbar" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="offcanvas offcanvas-end text-bg-dark" tabindex="-1" id="offcanvasDarkNavbar" aria-labelledby="offcanvasDarkNavbarLabel">
          <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasDarkNavbarLabel"><%=request.getParameter("coursename") %></h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
          </div>
          <div class="offcanvas-body">
            <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
            
            <%
    		int courseid = Integer.parseInt(request.getParameter("courseid"));
        	Connection con = null;
        	ResultSet rs=null;
      
        	String courseName=null;
        try {
			 Class.forName("org.postgresql.Driver");  
			 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
			 
			 PreparedStatement pst = con.prepareStatement("select * from learningdata where course_id=?");
			 
			 pst.setInt(1,courseid);
			
			 rs = pst.executeQuery();
			
			 
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	 
        
        %>
        
       	<%
       	
       		while(rs.next())
       		{
       		
       	%>
               <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="./learningpage.jsp?id=<%=rs.getInt("id") %>&courseid=<%=courseid %>&coursename=<%=request.getParameter("coursename") %>"><%=rs.getString("title") %></a>
                
              </li>
           <%} %> 
           <li class="nav-item">
                <%-- <a class="nav-link active" aria-current="page" href="QuizServlet?course=<%=request.getParameter("coursename") %>&courseid=<%=courseid %>" >Quiz</a> --%>
                <a class="nav-link active quiz-link" data-bs-toggle="modal" data-bs-target="#quizInstructionsModal">Quiz</a>
            </li>   
          </div>
        </div>
      </div>
    </nav>
    
    
   		<% 
   		
   	
    	ResultSet result=null;
    try {
    		
		 int id = Integer.parseInt(request.getParameter("id"));
		 PreparedStatement pstt = con.prepareStatement("SELECT * FROM learningdata WHERE id=?");
		 pstt.setInt(1, id);
		 System.out.println(id);
		 result = pstt.executeQuery();
		
		 
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}	 
    	%>
    	
    	
<%
    // Assume 'currentTopicId' is the ID of the current topic
    int currentTopicId = Integer.parseInt(request.getParameter("id"));
    int nextTopicId = -1;
    int prevTopicId = -1;

    String nextQuery = "SELECT id FROM learningdata WHERE course_id = ? AND id > ? ORDER BY id ASC LIMIT 1";
    PreparedStatement nextPst = con.prepareStatement(nextQuery);
    nextPst.setInt(1, courseid);
    nextPst.setInt(2, currentTopicId);
    ResultSet nextRs = nextPst.executeQuery();
    if(nextRs.next()) {
        nextTopicId = nextRs.getInt("id");
    }

    String prevQuery = "SELECT id FROM learningdata WHERE course_id = ? AND id < ? ORDER BY id DESC LIMIT 1";
    PreparedStatement prevPst = con.prepareStatement(prevQuery);
    prevPst.setInt(1, courseid);
    prevPst.setInt(2, currentTopicId);
    ResultSet prevRs = prevPst.executeQuery();
    if(prevRs.next()) {
        prevTopicId = prevRs.getInt("id");
    }
%>
    	

  </div>
  
<div class="content">
  <% while(result.next()){ %>
  <div>
    <h5><%= result.getString("title") %></h5>
    <%= result.getString("description") %> <!-- This will render the HTML content -->
  </div>
  <% } %>
</div>

    
    <!-- Modal structure -->
<div class="modal fade" id="quizInstructionsModal" tabindex="-1" aria-labelledby="quizInstructionsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="quizInstructionsModalLabel">Quiz Instructions</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <h3 style="color:red">Before You Begin, Please Read the Following Instructions Carefully:</h3>
  			<ol>
    			<li>There are a total of 10 questions.</li>
    			<li>You will have 30 seconds to answer each question.</li>
    			<li>Read each question thoroughly, focus, and avoid distractions.</li>
    			<li>Ensure your internet connection is stable to receive AI feedback promptly.</li>
  			</ol>
  		<h2>Wishing You the Best of Luck!</h2>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <!-- Direct link to start the quiz -->
        <a href="QuizServlet?course=<%=request.getParameter("coursename") %>&courseid=<%=courseid %>" class="btn btn-primary">Start Quiz</a>
      </div>
    </div>
  </div>
</div>
    
    
<div class="navigation-buttons">
    <% if(prevTopicId != -1) { %>
        <a href="./learningpage.jsp?id=<%=prevTopicId%>&courseid=<%=courseid%>&coursename=<%=request.getParameter("coursename")%>" class="btn btn-primary prev-button">Previous</a>
    <% } %>
    <% if(nextTopicId != -1) { %>
        <a href="./learningpage.jsp?id=<%=nextTopicId%>&courseid=<%=courseid%>&coursename=<%=request.getParameter("coursename")%>" class="btn btn-primary next-button">Next</a>
    <% } %>
</div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>