<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.learningportal.dao.TestResultDAO, com.learningportal.model.TestResult"%>
<%@ page import="java.util.Map, java.util.HashMap" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Performance</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
    	.myclass1{
    		font-size:33px;
    	}
    </style>
</head>
<body>
<%@ include file="navbar.jsp"%>
<%
	Integer userId = (Integer) session.getAttribute("userId");
	List<TestResult> testResults = TestResultDAO.getTestResultsByUserId(userId);
	int totalCoursesExplored = TestResultDAO.getTotalCoursesExplored(userId);
	String bestPerformanceCourse = TestResultDAO.getBestPerformanceCourse(userId);
	double overallScore = TestResultDAO.getOverallAverageScore(userId);
%>
<div class="container mt-5">
    <h1 class="text-center mb-4">My Performance Dashboard</h1>
    <div class="row text-center mb-4">
        <div class="col-lg-2 mb-3">
            <div class="card bg-info text-white h-100">
                <div class="card-body">
                    <h2 class="card-title">Total Courses</h2>
                    <p class="display-4"><%= totalCoursesExplored %></p>
                    <p class="card-text">Courses Explored</p>
                </div>
            </div>
        </div>
        <div class="col-lg-3 mb-3">
            <div class="card bg-success text-white h-100">
                <div class="card-body">
                    <h2 class="card-title">Best Performance</h2>
                    <p class="myclass1"><%= bestPerformanceCourse %></p>
                    <!-- Best score can be placed here -->
                </div>
            </div>
        </div>
        <div class="col-lg-2 mb-3">
            <div class="card bg-warning text-white h-100">
                <div class="card-body">
                    <h2 class="card-title">Overall Score</h2>
                    <p class="myclass1"><%= String.format("%.2f", overallScore) %> %</p>
                    <!-- Overall score can be calculated and placed here -->
                </div>
            </div>
        </div>

        <div class="col-lg-5 mb-3">
  			<div class="card bg-white h-100">
    			<div class="card-body">
      				<h2 class="card-title">Performance Metrics</h2>
      				<canvas id="scoreChart"></canvas>
    			</div>
  			</div>
		</div>
<!-- 		<div class="col-lg-4 mb-3">
  <canvas id="overallScoreChart" width="400" height="400"></canvas>
</div> -->
		

    </div>
    <!-- Detailed Results -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="thead-dark">
                <tr>
                    <th>Test Date</th>
                    <th>Course</th>
                    <th>Score</th>
                    <th>Time Taken (sec)</th>
                    <th>⭐ 🅰️ℹ️ Feedback ⭐</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    for(TestResult result : testResults) {
                    	String courseName = TestResultDAO.getCourseName(result.getCourseId());
                %>
                <tr>
                    <td><%= result.getTestDate() %></td>
                    <td><%= courseName %></td>
                    <td><%= result.getScore() %></td>
                    <td><%= result.getTimeTaken() %></td>
                    <td>
                        <button class="btn btn-primary" data-toggle="modal" data-target="#feedbackModal<%= result.getResultId() %>">Read</button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% 
        // Modals for AI feedback
        for(TestResult result : testResults) {
    %>
        <div class="modal fade" id="feedbackModal<%= result.getResultId() %>" tabindex="-1" role="dialog" aria-labelledby="feedbackModalTitle<%= result.getResultId() %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="feedbackModalTitle<%= result.getResultId() %>">⭐AI Feedback⭐</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <%= result.getFeedback() %>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    <% } %>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%
// Initialize a map to store total scores and counts for each course
Map<String, Double> totalScores = new HashMap<>();
Map<String, Integer> totalCounts = new HashMap<>();

// Calculate the total scores and counts
for(TestResult result : testResults) {
    String courseName = TestResultDAO.getCourseName(result.getCourseId());
    double score = result.getScore() * 10; // Convert score to percentage
    totalScores.put(courseName, totalScores.getOrDefault(courseName, 0.0) + score);
    totalCounts.put(courseName, totalCounts.getOrDefault(courseName, 0) + 1);
}

// Prepare data for the chart
StringBuilder labels = new StringBuilder("[");
StringBuilder data = new StringBuilder("[");
for(Map.Entry<String, Double> entry : totalScores.entrySet()) {
    String courseName = entry.getKey();
    double averageScore = entry.getValue() / totalCounts.get(courseName);
    labels.append("\"").append(courseName).append("\",");
    data.append(averageScore).append(",");
}
if(labels.length() > 1) labels.setLength(labels.length() - 1); // Remove trailing comma
if(data.length() > 1) data.setLength(data.length() - 1); // Remove trailing comma
labels.append("]");
data.append("]");
%>



<script>
  var ctx = document.getElementById('scoreChart').getContext('2d');
  var courseNames = <%= labels.toString() %>;
  var courseAverageScores = <%= data.toString() %>;

  var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: courseNames,
      datasets: [{
        label: 'Average Score',
        data: courseAverageScores,
        backgroundColor: 'rgba(0, 225, 108, 0.8)',
        borderColor: 'rgba(0, 0, 66, 0.8)',
        borderWidth: 1
      }]
    },
    options: {
      maintainAspectRatio: true,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) {
              return value.toFixed(2) + "%";
            }
          }
        }
      }
    }
  });
</script>


<%-- <script>
  var ctx = document.getElementById('overallScoreChart').getContext('2d');
  var overallScore = <%= String.format("%.2f", overallScore) %>; // Your overall score
  var remainingScore = 100 - overallScore; // Calculate the remaining score

  var myPieChart = new Chart(ctx, {
    type: 'pie',
    data: {
      labels: ['Overall Score', 'Remaining'],
      datasets: [{
        data: [overallScore, remainingScore],
        backgroundColor: ['#FF6384', '#DDDDDD'],
        hoverBackgroundColor: ['#FF6384', '#CCCCCC']
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      title: {
        display: true,
        text: 'Overall Score Distribution'
      }
    }
  });
</script> --%>



</body>
</html>
 