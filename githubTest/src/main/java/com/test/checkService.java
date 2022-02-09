package com.test;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.checkDAO;

@WebServlet("/test/checkService")
public class checkService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("utf-8");
		String Email = request.getParameter("userEmail");
		//String nick = request.getParameter("userNick");
		
		PrintWriter out = response.getWriter();
		
		checkDAO dao = new checkDAO();
		
		int checkE = dao.checkEmail(Email);
		//int checkN = dao.checkNick(nick);
		
		if(checkE == 0) {
			System.out.println("이미 존재하는 이메일");
		} else {
			System.out.println("사용 가능한 이메일");
		}
		
		/*
		 * if(checkN == 0) { System.out.println("이미 존재하는 닉네임"); } else {
		 * System.out.println("사용 가능한 닉네임"); }
		 */
		
		out.write(checkE + " " );
	}

}
