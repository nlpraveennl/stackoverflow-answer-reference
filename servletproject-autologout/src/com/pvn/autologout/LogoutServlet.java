package com.pvn.autologout;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class LogoutServlet extends HttpServlet
{
	private static final long serialVersionUID = 2272344124841811904L;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		HttpSession session = req.getSession(false);
		if(session != null)
		{
			session.invalidate();
		}
		
		req.setAttribute("msg", "Logout successfull");
		req.getRequestDispatcher("login.jsp").forward(req, resp);
	}
}
