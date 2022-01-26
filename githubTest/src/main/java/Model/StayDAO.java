package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class StayDAO {

	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;

	StayDTO dto = null;

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

	// DB close ¸Þ¼Òµå
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

	public ArrayList<StayDTO> selectStay(String gu) {

		ArrayList<StayDTO> list = new ArrayList<StayDTO>();

		try {
			DBconn();

			String sql = "select * from tbl_stay where stay_gu = ?";

			psmt = conn.prepareStatement(sql);

			psmt.setString(1, gu);

			rs = psmt.executeQuery();

			while (rs.next()) {

				int stay_seq = rs.getInt(1);
				String stay_name = rs.getString(2);
				String stay_gu = rs.getString(3);
				String stay_addr = rs.getString(4);
				float stay_latitude = rs.getFloat(5);
				float stay_longitude = rs.getFloat(6);
				String stay_tel = rs.getString(7);
				String stay_approach = rs.getString(8);
				String stay_parking = rs.getString(9);
				String stay_height_diff = rs.getString(10);
				String stay_elev = rs.getString(11);
				String stay_toilet = rs.getString(12);

				dto = new StayDTO(stay_seq, stay_name, stay_addr, stay_gu, stay_tel, stay_approach, stay_height_diff, stay_parking, stay_elev, stay_toilet, stay_latitude, stay_longitude);
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
