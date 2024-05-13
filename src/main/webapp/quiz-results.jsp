<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz Results</title>
    <!-- Bootstrap CSS for responsive layout and styling -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card border-0 shadow">
                    <!-- Gradient background for card header -->
                    <div class="card-header text-dark text-center py-3" style="background: linear-gradient(to top, #fbc2eb 0%, #a6c1ee 100%);">
                        <h2>Congratulations, here are your results:</h2>
                    </div>
                    <div class="card-body text-center">
                        <% System.out.println("Score from session: " + session.getAttribute("score")); %>
                        <h3 class="card-title mb-3">Your Score: <%= session.getAttribute("score") %></h3>
                        <% System.out.println("Total Time Spent from session: " + session.getAttribute("totalTimeSpent")); %>
                        <p class="card-text mb-4">Total Time Spent: <%= session.getAttribute("totalTimeSpent") %> seconds</p>
                        <a href="index.jsp" class="btn btn-lg btn-outline-dark">Take Another Quiz</a>
                    </div>
                    <!-- AI Feedback Section with a well-designed text and background -->
<div class="card-footer text-center" style="background: white;">
    <h1 class="mb-2" style="display: inline-block; font-size: 2.5rem; background: linear-gradient(45deg, #00dbde, #fc00ff); -webkit-background-clip: text; color: transparent;">⭐Feedback from AI:⭐</h1>
    <hr style="border-top: 1px solid #8c8b8b; width: 50%; margin: auto; margin-bottom: 30px;"> <!-- Horizontal line -->
    <div class="feedback-text px-3 text-left" style="background-color: white;"> <!-- Align feedback text to the left -->
        <%
        String aiFeedback = (String)session.getAttribute("aiFeedback");
        System.out.println("AI Feedback: " + aiFeedback);
        if(aiFeedback != null && !aiFeedback.isEmpty()) {
            out.println(aiFeedback); // Directly output the HTML formatted feedback
        } else {
            out.println("No feedback available.");
        }
        %>
    </div>
</div>
	
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS for interactive components -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
