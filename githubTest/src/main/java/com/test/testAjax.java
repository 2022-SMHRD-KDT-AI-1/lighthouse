package com.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import Model.ConvDAO;
import Model.ConvDTO;
import Model.RehabDAO;
import Model.RehabDTO;
import Model.RestDAO;
import Model.RestDTO;
import Model.StayDAO;
import Model.StayDTO;

@WebServlet("/testAjax")
public class testAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setCharacterEncoding("utf-8");
		
		PrintWriter out = response.getWriter();
		
		String kind = request.getParameter("kind");
		String gu = request.getParameter("gu");
		
		RestDAO rest_dao = new RestDAO();
		ConvDAO conv_dao = new ConvDAO();
		StayDAO stay_dao = new StayDAO();
		RehabDAO rehab_dao = new RehabDAO();
		
		ArrayList<RestDTO> rest_dto = null;
		ArrayList<ConvDTO> conv_dto = null;
		ArrayList<StayDTO> stay_dto = null;
		ArrayList<RehabDTO> rehab_dto = null;
		
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
		
		System.out.println(jsonString);
		out.print(jsonString);
		
	}

}
