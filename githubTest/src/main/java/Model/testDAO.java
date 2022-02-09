package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class testDAO {

	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;

	testDTO dto = null;

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

	public ArrayList<testDTO> selectRest(String gu) {

		ArrayList<testDTO> list = new ArrayList<testDTO>();

		try {
			DBconn();

			String sql = "select * from tbl_test where gu = ?";

			psmt = conn.prepareStatement(sql);

			psmt.setString(1, gu);

			rs = psmt.executeQuery();

			while (rs.next()) {

				String kind = rs.getString(1);
				int seq = rs.getInt(2);
				String name = rs.getString(3);
				String gus = rs.getString(4);
				String addr = rs.getString(5);
				float lat = rs.getFloat(6);
				float lng = rs.getFloat(7);
				String tel = rs.getString(8);
				String approach = rs.getString(9);
				String parking = rs.getString(10);
				String h_diff = rs.getString(11);
				String elev = rs.getString(12);
				String toilet = rs.getString(13);
				

				testDTO dto = new testDTO(kind, seq, name, gus, addr, lat, lng, tel, approach, parking, h_diff, elev, toilet);
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
