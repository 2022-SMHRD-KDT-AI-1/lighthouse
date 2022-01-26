package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class RestDAO {
	
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;
	
	RestDTO dto = null;
	
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
	
	// 선택한 시설분야가 음식점이고, 구를 선택했을 때 그에 해당하는 음식점 리스트
	public ArrayList<RestDTO> selectRest(String gu) {
		
		ArrayList<RestDTO> list = new ArrayList<RestDTO>();

		try {
			DBconn();

			String sql = "select * from tbl_restaurant where rest_gu = ?";

			psmt = conn.prepareStatement(sql);
			
			psmt.setString(1, gu);
			
			rs = psmt.executeQuery();

			while (rs.next()) {
				
				int rest_seq = rs.getInt(1);
				String rest_name = rs.getString(2);
				String rest_gu = rs.getString(3);
				String rest_addr = rs.getString(4);
				float rest_latitude = rs.getFloat(5);
				float rest_longitude = rs.getFloat(6);
				String rest_tel = rs.getString(7);
				String rest_approach = rs.getString(8);
				String rest_parking = rs.getString(9);
				String rest_height_diff = rs.getString(10);
				String rest_elev = rs.getString(11);
				String rest_toilet = rs.getString(12);
				
				dto = new RestDTO(rest_seq, rest_name, rest_addr, rest_gu, rest_tel, rest_approach, rest_height_diff, rest_parking, rest_elev, rest_toilet, rest_latitude, rest_longitude);
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
