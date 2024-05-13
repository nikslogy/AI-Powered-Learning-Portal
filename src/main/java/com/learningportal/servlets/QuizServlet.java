package com.learningportal.servlets;

import com.learningportal.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpClient.Version;
import java.time.Duration;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;


@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.print(userId);
        session.setAttribute("userId", userId);
        String course = request.getParameter("course").replace("_", " ");
        session.setAttribute("course_name", course);

        session.removeAttribute("questions");
        session.removeAttribute("currentQuestionIndex");

        if (course != null && !course.isEmpty()) {
            if (loadQuestionsForCourse(course, session)) {
                response.sendRedirect("question.jsp");
            } else {
                session.setAttribute("error", "No questions found for the selected course.");
                response.sendRedirect("index.jsp");
            }
        } else {
        	session.setAttribute("error", "No questions found for the selected course.");
            response.sendRedirect("index.jsp");
        }
    }
    
    private boolean loadQuestionsForCourse(String course, HttpSession session) {
        List<Question> questions = new ArrayList<>();
        int courseId = getCourseId(course);

        if (courseId == -1) return false;

        String query = "SELECT * FROM questions WHERE course_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                questions.add(new Question(
                    rs.getInt("question_id"),
                    rs.getString("question_text"),
                    rs.getString("option_a"),
                    rs.getString("option_b"),
                    rs.getString("option_c"),
                    rs.getString("option_d"),
                    rs.getString("correct_option")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        if (questions.isEmpty()) return false;

        session.setAttribute("questions", questions);
        session.setAttribute("currentQuestionIndex", 0);
        return true;
    }

    private int getCourseId(String courseName) {
        int courseId = -1;
        String sql = "SELECT course_id FROM courses WHERE lower(course_name) = lower(?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, courseName);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                courseId = rs.getInt("course_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courseId;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
        List<String> userResponses = (List<String>) session.getAttribute("userResponses");
        List<Integer> timeSpentOnQuestions = (List<Integer>) session.getAttribute("timeSpentOnQuestions");


        // Initialize lists 
        if (userResponses == null) {
            userResponses = new ArrayList<>();
            session.setAttribute("userResponses", userResponses);
        }
        if (timeSpentOnQuestions == null) {
            timeSpentOnQuestions = new ArrayList<>();
            session.setAttribute("timeSpentOnQuestions", timeSpentOnQuestions);
        }

        // Handling the response and timing for the current question
        String selectedOption = request.getParameter("option");
        String timeSpent = request.getParameter("timeSpent");

        System.out.println("Selected Option: " + selectedOption);	
        System.out.println("Time Spent: " + timeSpent);
        
        if (selectedOption != null && !selectedOption.trim().isEmpty()) {
            userResponses.add(selectedOption);
        }else {
            userResponses.add("");
        }
        if (timeSpent != null) {
            try {
                timeSpentOnQuestions.add(Integer.parseInt(timeSpent));
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        if (currentQuestionIndex == null) {
            currentQuestionIndex = 0;
        } else {
            currentQuestionIndex++;
        }
        session.setAttribute("currentQuestionIndex", currentQuestionIndex);

        List<Question> questions = (List<Question>) session.getAttribute("questions");
        if (questions != null && currentQuestionIndex < questions.size()) {
            Question currentQuestion = questions.get(currentQuestionIndex);
            request.setAttribute("currentQuestion", currentQuestion);
            request.getRequestDispatcher("/question.jsp").forward(request, response);
        } else {
            
            
            
            //openai_logic
        	String courseName = (String) session.getAttribute("course_name");
        	String usrName = (String) session.getAttribute("name");
            StringBuilder promptBuilder = new StringBuilder();
            promptBuilder.append(String.format("You are a AI feedback assistant of Learning Portal and you will be giving feedback to user. Your work is 1. congratulate user: %s for completing test(MCQ) of topic %s on LearningPortal 2. analyse the user's responses and give appropriate detailed analysis of his test with scorecard and a small feedback on it. 3. Design your all response with appropriate html tags, with appropriate bold, italic, coloured text (whenever necessary), next line, etc. (for heading, use only h4 in all cases)\n\n",usrName,courseName));

            int totalQuestions = questions.size();
            int correctAnswersCount = calculateCorrectAnswersCount(questions, userResponses);
            List<Integer> correctQuestions = new ArrayList<>();
            List<Integer> wrongQuestions = new ArrayList<>();
            int courseId = getCourseId(courseName);

            for (int i = 0; i < questions.size(); i++) {
                if (userResponses.get(i).equals(questions.get(i).getCorrectOption())) {
                    correctQuestions.add(i + 1);
                } else {
                    wrongQuestions.add(i + 1);
                }
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
        	int score = calculateScore(questions, userResponses);
            int totalTimeSpent = 0;
            if (timeSpentOnQuestions != null) {
            	System.out.println("Time Spent on Questions: " + timeSpentOnQuestions);
                totalTimeSpent = timeSpentOnQuestions.stream().mapToInt(Integer::intValue).sum();
            }

            promptBuilder.append(String.format("So, the user has attempted a total of %d questions and out of %d, he gets %d correct. The correct answers he gave are of questions %s.\n", totalQuestions, totalQuestions, correctAnswersCount, correctQuestions.toString()));

            promptBuilder.append("Here are the questions with the time consumed (out of 30sec) in seconds for each:\n");
            for (int i = 0; i < questions.size(); i++) {
                promptBuilder.append(String.format("%d. %s (Time taken: %d sec),\n", i + 1, questions.get(i).getQuestionText(), timeSpentOnQuestions.get(i)));
            }

            promptBuilder.append("Now, According to this data, analyze the user's score, time and overall performance and tell him in which area he is good and which needs improvement. Also, for each wrong question, explain that concept in short and tell him how can he remember that concept forever with some real-life example.\n");
            //promptBuilder.append(String.format("Provide feedback directly to the user, using 'You' or %s instead of 'the user'.\n",usrName.toString()));

            
            String finalPrompt = promptBuilder.toString().replace("\"", "\\\"");

            
            String aiFeedback = "";
            try {         	
            	aiFeedback = callOpenAI(finalPrompt);
            	//saveResultsToDatabase(userId, score, totalTimeSpent, aiFeedback);
            	session.setAttribute("aiFeedback", aiFeedback);
            }catch(Exception e) {
            	System.out.print(e);            
            }
            
        	
            if (userId != null) {
                saveResultsToDatabase(userId, courseId, score, totalTimeSpent,aiFeedback);
            } else {
                response.sendRedirect("index.jsp");
                return;
            }
          

            
            session.removeAttribute("currentQuestionIndex");
            session.removeAttribute("questions");
            session.removeAttribute("userResponses");
            session.removeAttribute("timeSpentOnQuestions");
            session.setAttribute("totalTimeSpent", totalTimeSpent);
            session.setAttribute("score", score);
            request.getRequestDispatcher("/quiz-results.jsp").forward(request, response);
        }
    }


    private void saveResultsToDatabase(int userId, int courseId, int score, int totalTimeSpent, String feedback) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO user_test_results (user_id, course_id, score, time_taken, test_date, feedback) VALUES (?, ?, ?, ?, NOW(),?)")) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.setInt(3, score);
            ps.setInt(4, totalTimeSpent);
            ps.setString(5, feedback);
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            
        }
    }

    private int calculateScore(List<Question> questions, List<String> userResponses) {
        int score = 0;
        for (int i = 0; i < questions.size(); i++) {
            Question question = questions.get(i);
            String correctOption = question.getCorrectOption();
            String userResponse = userResponses.size() > i ? userResponses.get(i) : "";
            
            if (correctOption.equalsIgnoreCase(userResponse)) {
                score++;
            }
        }
        System.out.println(score);
        return score;
    }
    
    
    
    private int calculateCorrectAnswersCount(List<Question> questions, List<String> userResponses) {
        int correctCount = 0;
        for (int i = 0; i < questions.size(); i++) {
            if (userResponses.get(i).equalsIgnoreCase(questions.get(i).getCorrectOption())) {
                correctCount++;
            }
        }
        return correctCount;
    }

    
    

    
    private String callOpenAI(String prompt) throws JSONException {
        String apiKey = System.getenv("OPENAI_API_KEY"); 
        System.out.println(apiKey); 

        HttpClient client = HttpClient.newHttpClient();

        JSONObject json = new JSONObject();
        json.put("model", "gpt-3.5-turbo-instruct");
        json.put("prompt", prompt);
        json.put("max_tokens", 1024);
        json.put("temperature", 0.7);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/completions"))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(json.toString()))
                .build();

        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            JSONObject jsonResponse = new JSONObject(response.body());
            System.out.println(response.body());
            JSONArray choices = jsonResponse.getJSONArray("choices");
            String aiTextResponse = choices.getJSONObject(0).getString("text").trim(); 
            System.out.println(aiTextResponse);
            return aiTextResponse;
            //return response.body();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return "Failed to get feedback from AI."; 
        }
    }

}
