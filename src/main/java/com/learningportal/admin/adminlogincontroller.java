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

/**
 * Servlet implementation class adminlogincontroller
 */
@WebServlet("/adminlogincontroller")
public class adminlogincontroller extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public adminlogincontroller() {
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
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		ResultSet rs=null;
		HttpSession session = request.getSession();
		
		 Connection con = null;
		 try {
			 Class.forName("org.postgresql.Driver");  
			 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
			 
			 PreparedStatement pst = con.prepareStatement("select * from admin where email=? and password=?");
			 pst.setString(1, email);
			pst.setString(2, password);

			 rs = pst.executeQuery();
			
			 System.out.println(rs);
			 if(rs.next())
			 {
				 session.setAttribute("adminname",rs.getString("name") );
				 //request.setAttribute("name", rs.getString("name"));
				 RequestDispatcher view = request.getRequestDispatcher("adminallcourses.jsp");
				 view.forward(request,response);
				 
			 }
			 else {
				request.setAttribute("status", "failed");
				 RequestDispatcher view = request.getRequestDispatcher("adminlogin.jsp");
				 view.forward(request,response);
			 }
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
