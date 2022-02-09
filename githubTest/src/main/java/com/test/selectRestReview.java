package com.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;


import Model.ConvAvg1DTO;
import Model.ConvAvg2DTO;
import Model.ConvAvg3DTO;
import Model.ConvAvg4DTO;
import Model.ConvAvg5DTO;
import Model.ConvRvDAO;
import Model.ConvRvDTO;
import Model.RestAvg1DTO;
import Model.RestAvg2DTO;
import Model.RestAvg3DTO;
import Model.RestAvg4DTO;
import Model.RestAvg5DTO;
import Model.RestRvDAO;
import Model.RestRvDTO;
import Model.StayAvg1DTO;
import Model.StayAvg2DTO;
import Model.StayAvg3DTO;
import Model.StayAvg4DTO;
import Model.StayAvg5DTO;
import Model.StayRvDAO;
import Model.StayRvDTO;
import Model.jsonConvVO;
import Model.jsonRestVO;
import Model.jsonStayVO;
@WebServlet("/test/selectRestReview")
public class selectRestReview extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("selectRestReview 서블릿");
		response.setCharacterEncoding("utf-8");
		
		PrintWriter out = response.getWriter();
		
		String seq = request.getParameter("changeSeq");
		String kind = request.getParameter("kind");
		
		
		
		System.out.println(seq);
		System.out.println(kind);
		
		RestRvDAO rest_rv_dao = new RestRvDAO();
		ConvRvDAO conv_rv_dao = new ConvRvDAO();
		StayRvDAO stay_rv_dao = new StayRvDAO();
		
		Gson gson = new Gson();
		String jsonString = null;
		jsonRestVO Rjvo = null;
		jsonConvVO Cjvo = null;
		jsonStayVO Sjvo = null;
		
		if(kind.equals("음식점")) {
			ArrayList<RestRvDTO> rest_rv_select = rest_rv_dao.selectReview(seq);
			RestAvg1DTO avg1 = rest_rv_dao.selectAvgs1(seq);
			RestAvg2DTO avg2 = rest_rv_dao.selectAvgs2(seq);
			RestAvg3DTO avg3 = rest_rv_dao.selectAvgs3(seq);
			RestAvg4DTO avg4 = rest_rv_dao.selectAvgs4(seq);
			RestAvg5DTO avg5 = rest_rv_dao.selectAvgs5(seq);
			Rjvo = new jsonRestVO(rest_rv_select, avg1, avg2, avg3, avg4, avg5);
			jsonString = gson.toJson(Rjvo);
		}else if(kind.equals("편의시설")) {
			ArrayList<ConvRvDTO> conv_rv_select = conv_rv_dao.selectReview(seq);
			ConvAvg1DTO avg1 = conv_rv_dao.selectAvgs1(seq);
			ConvAvg2DTO avg2 = conv_rv_dao.selectAvgs2(seq);
			ConvAvg3DTO avg3 = conv_rv_dao.selectAvgs3(seq);
			ConvAvg4DTO avg4 = conv_rv_dao.selectAvgs4(seq);
			ConvAvg5DTO avg5 = conv_rv_dao.selectAvgs5(seq);
			Cjvo = new jsonConvVO(conv_rv_select, avg1, avg2, avg3, avg4, avg5);
			jsonString = gson.toJson(Cjvo);
		}else if(kind.equals("숙박시설")) {
			ArrayList<StayRvDTO> stay_rv_select = stay_rv_dao.selectReview(seq);
			StayAvg1DTO avg1 = stay_rv_dao.selectAvgs1(seq);
			StayAvg2DTO avg2 = stay_rv_dao.selectAvgs2(seq);
			StayAvg3DTO avg3 = stay_rv_dao.selectAvgs3(seq);
			StayAvg4DTO avg4 = stay_rv_dao.selectAvgs4(seq);
			StayAvg5DTO avg5 = stay_rv_dao.selectAvgs5(seq);
			Sjvo = new jsonStayVO(stay_rv_select, avg1, avg2, avg3, avg4, avg5);
			jsonString = gson.toJson(Sjvo);
		}

		System.out.println("selectRestReview : " + jsonString);
		out.print(jsonString);
	}

}
