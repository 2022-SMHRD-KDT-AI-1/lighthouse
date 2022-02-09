package com.test;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.MemberDAO;
import Model.MemberDTO;


@WebServlet("/test/LoginService")
public class LoginService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("[LoginService]");
		
		response.setCharacterEncoding("UTF-8");
		
		String email =request.getParameter("email");
		String pw =request.getParameter("pw");
		
		System.out.println("email :"+ email);
		System.out.println("pw : "+ pw);
		
		MemberDAO dao = new MemberDAO();
		MemberDTO dto = new MemberDTO(email, pw);
		
		MemberDTO info = dao.login(dto);
		
		if(info !=null) {
			System.out.println("로그인 성공");
			HttpSession session = request.getSession();
			session.setAttribute("info", info);
			response.sendRedirect("ajaxTest.jsp");
			
			
			}else {
			System.out.println("로그인 실패");
			response.sendRedirect("signin.jsp");
		}
		
	}

}
