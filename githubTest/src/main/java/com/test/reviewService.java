package com.test;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.RestRvDAO;

@WebServlet("/test/reviewService")
public class reviewService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		/* 음식점 review Test */
		System.out.println("리뷰 서블릿 도착");
		response.setCharacterEncoding("utf-8");
		request.setCharacterEncoding("utf-8");
		
		String kind = request.getParameter("chkind");
		int seq =  Integer.parseInt(request.getParameter("Rselect"));
		int s1 =  Integer.parseInt(request.getParameter("q1"));
		int s2 =  Integer.parseInt(request.getParameter("q2"));
		int s3 =  Integer.parseInt(request.getParameter("q3"));
		String text = request.getParameter("text");
		
		System.out.println("서블릿 kind : " + kind);
		System.out.println("서블릿 seq : " + seq);
		System.out.println("서블릿 s1 : " + s1);
		System.out.println("서블릿 s2 : " + s2);
		System.out.println("서블릿 s3 : " + s3);
		System.out.println("서블릿 text : " + text);
		
		RestRvDAO dao = new RestRvDAO();
		int cnt = 0;
		
		/* 일단 음식점만 해보기 */
		if(kind.equals("음식점")) {
			cnt = dao.insertReview(seq, s1, s2, s3, text);
			if(cnt > 0) {
				System.out.println("음식점 리뷰 제출 성공");
				
			}else {
				System.out.println("리뷰 제출 실패");
			}

		}

		response.sendRedirect("ajaxTest.jsp");
	}

}
