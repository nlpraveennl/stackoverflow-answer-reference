package com.pvn.autologout;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class LoginServlet extends HttpServlet
{
	private static final long serialVersionUID = 2272344124841811904L;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		if(req.getSession(false) != null && req.getSession(false).getAttribute("loggedInUser_userName") != null)
		{
			resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
		}
		else
		{
			req.setAttribute("error", "Session expired");
			req.getRequestDispatcher("login.jsp").forward(req, resp);
		}
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		String userName = req.getParameter("userName");
		String password = req.getParameter("password");
		
		if(userName != null && password != null && userName.equals("praveen") && password.equals("praveen@123#"))
		{
			System.out.println("Login success");
			HttpSession session = req.getSession(true);
			session.setMaxInactiveInterval(60);
			//autologout configuration starts
			session.setAttribute("timeOutTimeInSeconds", 60);
			session.setAttribute("showTimerTimeInSeconds", 50);
			//autologout configuration ends
			
			session.setAttribute("loggedInUser_userName", userName);
			req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
		}
		else
		{
			req.setAttribute("error", "Invalid Credentials");
			req.getRequestDispatcher("login.jsp").forward(req, resp);
		}
	}
}
