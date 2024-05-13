package com.learningportal.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class editcoursetopiccontroller
 */
@WebServlet("/editcoursetopiccontroller")
public class editcoursetopiccontroller extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editcoursetopiccontroller() {
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
		int id = Integer.parseInt(request.getParameter("id"));
		String title = request.getParameter("title");
		String description = request.getParameter("description");
		HttpSession session = request.getSession();
		int i=0;
		Connection con = null;
    try {
		 Class.forName("org.postgresql.Driver");  
		 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
		 PrintWriter pw = response.getWriter();
		 PreparedStatement pst = con.prepareStatement("update learningdata set title=? ,description=? where id=?");
		 pst.setString(1, title);
		 pst.setString(2, description);
		 pst.setInt(3, id);
		 pw.println(id);
		 i = pst.executeUpdate();
		
		 pw.println("hello2");
		 if(i>0)
		 {
			 session.setAttribute("coursetopicedit","success");
			 response.sendRedirect("adminedit.jsp");
		 }
		 else {
			 session.setAttribute("coursetopicedit","failed");
			 response.sendRedirect("adminedit.jsp");
		 }
		
		 
	} catch (ClassNotFoundException | SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	}

}
