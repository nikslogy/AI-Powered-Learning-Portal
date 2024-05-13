package com.learningportal.model;

import java.util.Date;

public class TestResult {
    private int resultId;
    private int userId;
    private int courseId;
    private int score;
    private int timeTaken;
    private Date testDate;
    private String feedback; 

    // Constructor
    public TestResult(int resultId, int userId, int courseId, int score, int timeTaken, Date testDate, String feedback) {
        this.resultId = resultId;
        this.userId = userId;
        this.courseId = courseId;
        this.score = score;
        this.timeTaken = timeTaken;
        this.testDate = testDate;
        this.feedback = feedback;
    }

    // Getters and setters
    public int getResultId() {
        return resultId;
    }

    public void setResultId(int resultId) {
        this.resultId = resultId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public int getTimeTaken() {
        return timeTaken;
    }

    public void setTimeTaken(int timeTaken) {
        this.timeTaken = timeTaken;
    }

    public Date getTestDate() {
        return testDate;
    }

    public void setTestDate(Date testDate) {
        this.testDate = testDate;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }
    

   
}


