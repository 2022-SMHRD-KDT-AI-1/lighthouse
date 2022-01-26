package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ConvDAO {

	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;

	ConvDTO dto = null;

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

	public ArrayList<ConvDTO> selectConv(String gu) {

		ArrayList<ConvDTO> list = new ArrayList<ConvDTO>();

		try {
			DBconn();

			String sql = "select * from tbl_convenience where conv_gu = ?";

			psmt = conn.prepareStatement(sql);

			psmt.setString(1, gu);

			rs = psmt.executeQuery();

			while (rs.next()) {

				int conv_seq = rs.getInt(1);
				String conv_name = rs.getString(2);
				String conv_gu = rs.getString(3);
				String conv_addr = rs.getString(4);
				float conv_latitude = rs.getFloat(5);
				float conv_longitude = rs.getFloat(6);
				String conv_tel = rs.getString(7);
				String conv_approach = rs.getString(8);
				String conv_parking = rs.getString(9);
				String conv_height_diff = rs.getString(10);
				String conv_elev = rs.getString(11);
				String conv_toilet = rs.getString(12);

				dto = new ConvDTO(conv_seq, conv_name, conv_addr, conv_gu, conv_tel, conv_approach, conv_height_diff, conv_parking, conv_elev, conv_toilet, conv_latitude, conv_longitude);
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
