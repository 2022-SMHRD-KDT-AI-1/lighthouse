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
		
		
		
		// �������� �Ȱ��� name���� �� ����, �ȹ޾Ƶ� �Ǹ� ��������
		String kind = request.getParameter("kind");
		String gu = request.getParameter("gu");
		
		
		
		// �� dao, dto ��ȯ�ؾ��� 
		// kind, gu���� ���� ���� �޶��������.. 
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
		
		
		
		// Gson : ��ü�� json���·� ��ȯ������
		// ��ȯ�����ְ� �� jsonString�� ������..
		Gson gson = new Gson();
		String jsonString = null;
		
		if(kind.equals("������")) {
			rest_dto =  rest_dao.selectRest(gu);
			jsonString = gson.toJson(rest_dto);
			
		}
		else if(kind.equals("���ǽü�")) {
			conv_dto = conv_dao.selectConv(gu);
			jsonString = gson.toJson(conv_dto);
		}else if(kind.equals("���ڽü�")) {
			stay_dto = stay_dao.selectStay(gu);
			jsonString = gson.toJson(stay_dto);
		}else if(kind.equals("������Ȱ�ü�")) {
			//rehab_dto = rehab_dao.selectRehab(gu);
			//jsonString = gson.toJson(rest_dto);
		}
		
		// �׸��� out.print ���ָ� �ȴٴµ�
		// �̰ɷ�... ����������..?!!!
		System.out.println(jsonString);
		out.print(jsonString);
	}

}
