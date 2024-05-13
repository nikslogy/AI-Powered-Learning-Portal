package com.learningportal.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deletecourseController")
public class deletecourseController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deletecourseController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
        int id = Integer.parseInt(request.getParameter("title"));
        int i = 0;

        HttpSession session = request.getSession();

        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://localhost/lp", "postgres", "nikit");
            con.setAutoCommit(false); // Start transaction

            // Delete related records from `questions` table
            PreparedStatement pstQuestions = con.prepareStatement("DELETE FROM questions WHERE course_id=?");
            pstQuestions.setInt(1, id);
            pstQuestions.executeUpdate();

            // Delete related records from `user_test_results` table
            PreparedStatement pstTestResults = con.prepareStatement("DELETE FROM user_test_results WHERE course_id=?");
            pstTestResults.setInt(1, id);
            pstTestResults.executeUpdate();

            // Delete related records from `learningdata` table
            PreparedStatement pstLearningData = con.prepareStatement("DELETE FROM learningdata WHERE course_id=?");
            pstLearningData.setInt(1, id);
            pstLearningData.executeUpdate();

            // Now, delete the course
            PreparedStatement pstCourses = con.prepareStatement("DELETE FROM courses WHERE course_id=?");
            pstCourses.setInt(1, id);
            i = pstCourses.executeUpdate();

            con.commit(); // Commit the transaction if everything is successful

            if (i > 0) {
                session.setAttribute("deletecourse", "success");
                response.sendRedirect("admindeletecourse.jsp");
            } else {
                session.setAttribute("deletecourse", "failed");
                response.sendRedirect("admindeletecourse.jsp");
            }
        } catch (ClassNotFoundException | SQLException e) {
            if (con != null) {
                try {
                    con.rollback(); // Rollback the transaction in case of any error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true); // End transaction
                    con.close(); // Close the connection
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
