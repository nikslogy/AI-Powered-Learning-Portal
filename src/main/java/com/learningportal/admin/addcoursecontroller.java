package com.learningportal.admin;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Servlet implementation class addcoursecontroller
 */

@WebServlet("/addcoursecontroller")
@MultipartConfig
public class addcoursecontroller extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addcoursecontroller() {
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
		int i =0;
		PrintWriter pw = response.getWriter();
		Part file = request.getPart("image");
		String imageFileName = file.getSubmittedFileName();
		HttpSession session = request.getSession();
		String uploadPath = "C:/Users/nikit/eclipse-workspace/LearningPortal/src/main/webapp/" + imageFileName;
		try {
		    InputStream is = file.getInputStream();
		    FileOutputStream fos = new FileOutputStream(uploadPath);
		    byte[] buffer = new byte[1024]; // 1KB buffer (you can adjust this as needed)
		    int bytesRead;
		    while ((bytesRead = is.read(buffer)) != -1) {
		        fos.write(buffer, 0, bytesRead);
		    }
		    fos.close();
		    is.close();
		} catch (IOException e) {
		    e.printStackTrace();
		}
		
		pw.println("Hello");
		String title = request.getParameter("title");
		String description = request.getParameter("description");
		
		 Connection con = null;
		 try {
			 Class.forName("org.postgresql.Driver");  
			 con=DriverManager.getConnection("jdbc:postgresql://localhost/lp","postgres", "nikit");
			 
			 PreparedStatement pst = con.prepareStatement("insert into courses(course_name,description,image) values (?,?,?)");
			 pst.setString(1, title);
			 pst.setString(2, description);
			 pst.setString(3, imageFileName);
			 i=pst.executeUpdate();
			
			 if(i>0)
			 {
				 session.setAttribute("addcourse","success");
				 response.sendRedirect("adminallcourses.jsp");
//				 RequestDispatcher view = request.getRequestDispatcher("adminallcourses.jsp");
//				 view.forward(request,response);
			
			 }
			 else {
//				request.setAttribute("status", "failed");
//				 RequestDispatcher view = request.getRequestDispatcher("addcourse.jsp");
//				 view.forward(request,response);
				 session.setAttribute("addcourse","failed");
				 response.sendRedirect("adminallcourses.jsp");
			 }
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 

	}

}
