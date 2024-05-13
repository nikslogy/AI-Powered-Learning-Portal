package com.learningportal.dao;
import com.learningportal.model.TestResult;
import com.learningportal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestResultDAO {

    public static List<TestResult> getTestResultsByUserId(int userId) {
        List<TestResult> testResults = new ArrayList<>();
        String sql = "SELECT * FROM user_test_results WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
          
            while (rs.next()) {
                TestResult result = new TestResult(
                    rs.getInt("result_id"),
                    userId,
                    rs.getInt("course_id"),
                    rs.getInt("score"),
                    rs.getInt("time_taken"),
                    rs.getTimestamp("test_date"),
                    rs.getString("feedback") 
                );
                testResults.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            
        }

        return testResults;
    }
    
    public static int getTotalCoursesExplored(int userId) {
        String sql = "SELECT COUNT(DISTINCT course_id) FROM user_test_results WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1); // The count is in the first column
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    
    public static String getBestPerformanceCourse(int userId) {
        String sql = "SELECT course_id, AVG(score) as avg_score FROM user_test_results WHERE user_id = ? GROUP BY course_id ORDER BY avg_score DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int bestCourseId = rs.getInt("course_id");
                return getCourseName(bestCourseId);
            }
        } catch (SQLException e) {
        e.printStackTrace();
        }
        return "N/A"; 
        }
    
    
    public static double getOverallAverageScore(int userId) {
        String sql = "SELECT AVG(score) FROM user_test_results WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1)*10; // The average score is in the first column
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public static String getCourseName(int courseId) {
        String sql = "SELECT course_name FROM courses WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("course_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown Course";
    }


  
}
