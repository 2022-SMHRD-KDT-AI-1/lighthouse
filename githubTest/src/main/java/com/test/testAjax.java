package com.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.Inet4Address;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import Model.ConvDAO;
import Model.ConvDTO;
import Model.RehabDAO;
import Model.RehabDTO;
import Model.RestDAO;
import Model.RestDTO;
import Model.RestRvDAO;
import Model.RestRvDTO;
import Model.StayDAO;
import Model.StayDTO;
import Model.jsonRestVO;
import Model.testDAO;
import Model.testDTO;

@WebServlet("/test/testAjax")
public class testAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setCharacterEncoding("utf-8");
		request.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		
		
		// 수업때랑 똑같이 name으로 값 받음, 안받아도 되면 생략가능
		String kind = request.getParameter("kind");
		String gu = request.getParameter("gu");
		
		
		
		// 난 dao, dto 소환해야함 
		// kind, gu값에 따라 값이 달라기지때문.. 
		RestDAO rest_dao = new RestDAO();
		ConvDAO conv_dao = new ConvDAO();
		StayDAO stay_dao = new StayDAO();
		RehabDAO rehab_dao = new RehabDAO();
		RestRvDAO rest_rv_dao = new RestRvDAO();
		
		ArrayList<RestDTO> rest_dto = null;
		ArrayList<ConvDTO> conv_dto = null;
		ArrayList<StayDTO> stay_dto = null;
		ArrayList<RehabDTO> rehab_dto = null;
		ArrayList<RestRvDTO> rest_rv_select = null;
		
		
		
		// Gson : 객체를 json형태로 변환시켜줌
		// 변환시켜주고 난 jsonString에 담아줬다..
		Gson gson = new Gson();
		String jsonString = null;
		
		if(kind.equals("음식점")) {
			rest_dto =  rest_dao.selectRest(gu);
			jsonString = gson.toJson(rest_dto);
			
		}
		else if(kind.equals("편의시설")) {
			conv_dto = conv_dao.selectConv(gu);
			jsonString = gson.toJson(conv_dto);
		}else if(kind.equals("숙박시설")) {
			stay_dto = stay_dao.selectStay(gu);
			jsonString = gson.toJson(stay_dto);
		}else if(kind.equals("직업재활시설")) {
			//rehab_dto = rehab_dao.selectRehab(gu);
			//jsonString = gson.toJson(rest_dto);
		}
		
		// 그리고 out.print 해주면 된다는데
		// 이걸로... 보내지나봄..?!!!
		System.out.println(jsonString);
		out.print(jsonString);
	}

}
