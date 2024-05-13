package com.learningportal.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class addtopiccontroller
 */
@WebServlet("/addtopiccontroller")
public class addtopiccontroller extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addtopiccontroller() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		PrintWriter pw = response.getWriter();
		int i = 0;
		
		int courseid= Integer.parseInt(request.getParameter("courseid"));
		String title = request.getParameter("title");
		String description = request.getParameter("description");
		pw.println("hello");
		HttpSession session = request.getSession();
		 Connection con = null;
		 try {
			 Class.forName("org.postgresql.Driver");  
			 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
			 
			 PreparedStatement pst = con.prepareStatement("insert into learningdata (course_id,title,description) values(?,?,?)");
			 pst.setInt(1, courseid);
			 pst.setString(2, title);
			 pst.setString(3, description);
			 pw.println("hello2");
			 i=pst.executeUpdate();
			 
			 if(i>0)
			 {
				 
				session.setAttribute("addtopic","success");
				response.sendRedirect("adminedit.jsp");
			
			 }
			 else {
				 session.setAttribute("addtopic","failed");
				 response.sendRedirect("adminedit.jsp");
			 }
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
