<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.learningportal.servlets.Question"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz Page</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>



<div class="container mt-4">
    <div id="timer" class="alert alert-warning text-center" role="alert">
        Timer placeholder
    </div>
    <%
        List<Question> questions = (List<Question>) session.getAttribute("questions");
        Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");

        if (questions != null && !questions.isEmpty() && currentQuestionIndex != null && currentQuestionIndex < questions.size()) {
            Question currentQuestion = questions.get(currentQuestionIndex);
    %>
    <form id="questionForm" action="QuizServlet" method="post" class="mb-4">
        <div class="card">
            <div class="card-header">
                Question <%= currentQuestionIndex + 1 %> of <%= questions.size() %>
            </div>
            <div class="card-body">
                <h5 class="card-title"><%= currentQuestion.getQuestionText() %></h5>
                <% String[] options = {currentQuestion.getOptionA(), currentQuestion.getOptionB(), currentQuestion.getOptionC(), currentQuestion.getOptionD()};
                   char[] optionLabels = {'A', 'B', 'C', 'D'};
                   for(int i = 0; i < options.length; i++) { %>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="option" id="option<%= optionLabels[i] %>" value="<%= String.valueOf(optionLabels[i]) %>">
                    <label class="form-check-label" for="option<%= optionLabels[i] %>">
                        <%= options[i] %>
                    </label>
                </div>
                <% } %>
            </div>
        </div>
        <input type="hidden" name="timeSpent" id="timeSpent" value="30">
        <button type="submit" class="btn btn-primary btn-block mt-3">Submit Answer</button>
    </form>
    <% } else { %>
    <div class="alert alert-danger" role="alert">
        There was an error loading the question. Please try again or contact support.
    </div>
    <% } %>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>


<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js" defer></script>

<script>
// Define global variables for the timer interval and time limit
window.timerInterval = null;
window.timeLimit = 30;

function updateTimerDisplay() {
    const timerElement = document.getElementById('timer');
    if (timerElement) {
        timerElement.textContent = '⏰Time Remaining: ' + window.timeLimit;
    }
}

function startTimer() {
    // Reset the time limit for each question
    window.timeLimit = 30;
    updateTimerDisplay();

    // Clear any existing interval to prevent multiple timers from running
    clearInterval(window.timerInterval);

    // Start a new interval for the timer countdown
    window.timerInterval = setInterval(function() {
        window.timeLimit--;
        updateTimerDisplay();

        // Automatically submit the form when time runs out
        if (window.timeLimit <= 0) {
            clearInterval(window.timerInterval);
            document.getElementById('questionForm').submit();
        }
    }, 1000);
}

document.addEventListener("DOMContentLoaded", function() {
    startTimer(); // Start the timer when the page is fully loaded

    const form = document.getElementById('questionForm');
    form.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent the default form submission behavior
        clearInterval(window.timerInterval); // Stop the timer

        // Directly set the hidden input's value to the calculated time spent
        document.getElementById('timeSpent').value = 30 - window.timeLimit;

        // Submit the form
        this.submit();
    });
});
</script>

</body>
</html>
