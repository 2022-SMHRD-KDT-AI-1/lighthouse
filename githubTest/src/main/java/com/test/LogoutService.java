package com.test;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/test/LogoutService")
public class LogoutService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
			System.out.println("[LogoutService]");
			
			// �α׾ƿ� ��� �����
			// �α׾ƿ� = session�� ����� �α��� ������ ���� -> session����
			HttpSession session = request.getSession();
			
			session.removeAttribute("info"); // ���ϴ� ���Ǹ� ����
			// session.invalidate(); --> ��� ���� ����
			
			System.out.println("�α׾ƿ� ����");
			response.sendRedirect("ajaxTest.jsp");
		

	}

}
