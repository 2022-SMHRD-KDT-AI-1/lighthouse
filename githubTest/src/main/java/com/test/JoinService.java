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


@WebServlet("/test/JoinService")
public class JoinService extends HttpServlet {
	private static final long serialVersionUID = 1L;
	


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		String email =request.getParameter("email");
		String pw =request.getParameter("pw");
		
		
		MemberDTO dto = new MemberDTO(email, pw);
		
		System.out.println("email :"+ email);
		System.out.println("pw :"+ pw);
		
		MemberDAO dao=new MemberDAO();
		int cnt=dao.join(dto);
		
		if(cnt>0) {
			System.out.println("회원가입 성공");
			HttpSession session=request.getSession();
			session.setAttribute("email", dto.getEmail());
		
			response.sendRedirect("signin.jsp");
		}else {
			System.out.println("회원가입 실패");
			response.sendRedirect("singup.jsp");
		}
	}

}
