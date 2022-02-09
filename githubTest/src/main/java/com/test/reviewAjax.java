package com.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import Model.ConvRvDAO;
import Model.MemberDTO;
import Model.RestRvDAO;
import Model.StayRvDAO;
import Model.reviewBoardDTO;

@WebServlet("/test/reviewAjax")
public class reviewAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
		/* 음식점 review submit Test */
		System.out.println("리뷰 서블릿 도착");
		
		PrintWriter out = response.getWriter();
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		HttpSession session = request.getSession();
		MemberDTO info = (MemberDTO)session.getAttribute("info");
		System.out.println(info);
		
		String kind = request.getParameter("kind");
		int seq =  Integer.parseInt(request.getParameter("seq"));
		int s1 =  Integer.parseInt(request.getParameter("s1"));
		int s2 =  Integer.parseInt(request.getParameter("s2"));
		int s3 =  Integer.parseInt(request.getParameter("s3"));
		int s4 =  Integer.parseInt(request.getParameter("s4"));
		int s5 =  Integer.parseInt(request.getParameter("s5"));
		String text = request.getParameter("text");
		String name = request.getParameter("name");
		
		System.out.println("서블릿 kind : " + kind);
		System.out.println("서블릿 seq : " + seq);
		System.out.println("서블릿 s1 : " + s1);
		System.out.println("서블릿 s2 : " + s2);
		System.out.println("서블릿 s3 : " + s3);
		System.out.println("서블릿 s4 : " + s4);
		System.out.println("서블릿 s5 : " + s5);
		System.out.println("서블릿 text : " + text);
		System.out.println("서블릿 name : " + name);
		
		
		RestRvDAO rdao = new RestRvDAO();
		StayRvDAO sdao = new StayRvDAO();
		ConvRvDAO cdao = new ConvRvDAO();
		int cnt = 0;
		
		System.out.println(info.getEmail());
		
		
		
		/* 일단 음식점만 해보기 */
		if(kind.equals("음식점")) {
			cnt = rdao.insertReview(seq, info.getEmail(), s1, s2, s3,s4,s5, text,name);
			if(cnt > 0) {
				System.out.println("음식점 리뷰 제출 성공");
				
			}else {
				System.out.println("리뷰 제출 실패");
			}
			
		}else if(kind.equals("편의시설")) {
			cnt = cdao.insertReview(seq, info.getEmail(), s1, s2, s3,s4,s5, text,name);
			if(cnt > 0) {
				System.out.println("편의시설 리뷰 제출 성공");
			}else {
				System.out.println("리뷰 제출 실패");
			}
			
		}else if(kind.equals("숙박시설")) {
			cnt = sdao.insertReview(seq, info.getEmail(), s1, s2, s3,s4,s5, text,name);
			if(cnt > 0) {
				System.out.println("숙박시설 리뷰 제출 성공");
			}else {
				System.out.println("리뷰 제출 실패");
			}
		}

		out.print(cnt);
		

	}

}
