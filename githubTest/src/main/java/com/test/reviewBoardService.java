package com.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;


import Model.MemberDTO;
import Model.reviewBoardDAO;
import Model.reviewBoardDTO;


@WebServlet("/test/reviewBoardService")
public class reviewBoardService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println(" 후기 열람 서블릿 도착");
		
		// 항상 PrintWriter 쓸 때 response 한글설정 먼저 해주기
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		request.setCharacterEncoding("utf-8");
		
		String kind = request.getParameter("kind");
		
		System.out.println(kind);
		reviewBoardDAO dao = new reviewBoardDAO();
		
		ArrayList<reviewBoardDTO> list = new ArrayList<reviewBoardDTO>();
		
		
		
		
		Gson gson = new Gson();
		String jsonString = null;
		
		if(kind.equals("전체")) {
			list = dao.selectAll();
		}else if(kind.equals("음식점")) {
			list = dao.selectRest();
		}else if(kind.equals("편의시설")) {
			list = dao.selectConv();
		}else if(kind.equals("숙박시설")) {
			list = dao.selectStay();
		}
		
		jsonString = gson.toJson(list);
		
		System.out.println(jsonString);
		out.print(jsonString);
		
	}

}
