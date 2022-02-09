package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class reviewBoardDAO {

	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;
	int cnt = 0;
	reviewBoardDTO dto = null;

	public void DBconn() {

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String url = "jdbc:oracle:thin:@project-db-stu.ddns.net:1524:xe";
			String dbid = "campus_e_5_0115";
			String dbpw = "smhrd5";

			conn = DriverManager.getConnection(url, dbid, dbpw);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// DB close 메소드
	public void DBclose() {
		try {
			if (rs != null) {
				rs.close();
			}
			if (psmt != null) {
				psmt.close();
			}
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// 게시판에서 리뷰 전체보기(음식점 + 편의시설 + 숙박시설)
	public ArrayList<reviewBoardDTO> selectAll() {

		ArrayList<reviewBoardDTO> list = new ArrayList<reviewBoardDTO>();
		try {
			DBconn();

			String sql = "select * from tbl_rest_review UNION ALL select * from tbl_conv_review UNION ALL select * from tbl_stay_review";

			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();

			while (rs.next()) {
				int sequence = rs.getInt(1);
				String id = rs.getString(2);
				int sc1 = rs.getInt(3);
				int sc2 = rs.getInt(4);
				int sc3 = rs.getInt(5);
				int sc4 = rs.getInt(6);
				int sc5 = rs.getInt(7);
				String date = rs.getString(8);
				String text = rs.getString(9);
				String name = rs.getString(10);
				
				dto = new reviewBoardDTO(sequence, id, sc1, sc2, sc3, sc4, sc5, date, text, name);
				list.add(dto);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return list;
	}
	
	
	// 음식점 리뷰
	public ArrayList<reviewBoardDTO> selectRest() {

		ArrayList<reviewBoardDTO> list = new ArrayList<reviewBoardDTO>();
		try {
			DBconn();

			String sql = "select * from tbl_rest_review order by rv_date desc";

			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();

			while (rs.next()) {
				int sequence = rs.getInt(1);
				String id = rs.getString(2);
				int sc1 = rs.getInt(3);
				int sc2 = rs.getInt(4);
				int sc3 = rs.getInt(5);
				int sc4 = rs.getInt(6);
				int sc5 = rs.getInt(7);
				String date = rs.getString(8);
				String text = rs.getString(9);
				String name = rs.getString(10);
				

				dto = new reviewBoardDTO(sequence, id, sc1, sc2, sc3, sc4, sc5, date, text, name);
				list.add(dto);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return list;
	}
	
	// 편의시설 리뷰
	public ArrayList<reviewBoardDTO> selectConv() {

		ArrayList<reviewBoardDTO> list = new ArrayList<reviewBoardDTO>();
		try {
			DBconn();

			String sql = "select * from tbl_conv_review order by rv_date desc";
					

			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();

			while (rs.next()) {
				int sequence = rs.getInt(1);
				String id = rs.getString(2);
				int sc1 = rs.getInt(3);
				int sc2 = rs.getInt(4);
				int sc3 = rs.getInt(5);
				int sc4 = rs.getInt(6);
				int sc5 = rs.getInt(7);
				String date = rs.getString(8);
				String text = rs.getString(9);
				String name = rs.getString(10);
				
				dto = new reviewBoardDTO(sequence, id, sc1, sc2, sc3, sc4, sc5, date, text, name);
				list.add(dto);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return list;
	}
	
	// 숙박시설 리뷰
	public ArrayList<reviewBoardDTO> selectStay() {

		ArrayList<reviewBoardDTO> list = new ArrayList<reviewBoardDTO>();
		try {
			DBconn();

			String sql = "select * from tbl_stay_review order by rv_date desc";

			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();

			while (rs.next()) {
				int sequence = rs.getInt(1);
				String id = rs.getString(2);
				int sc1 = rs.getInt(3);
				int sc2 = rs.getInt(4);
				int sc3 = rs.getInt(5);
				int sc4 = rs.getInt(6);
				int sc5 = rs.getInt(7);
				String date = rs.getString(8);
				String text = rs.getString(9);
				String name = rs.getString(10);
				
				dto = new reviewBoardDTO(sequence, id, sc1, sc2, sc3, sc4, sc5, date, text, name);
				list.add(dto);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return list;
	}
	
	

}
