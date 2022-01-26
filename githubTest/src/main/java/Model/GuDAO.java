package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class GuDAO {

	
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;
	GuDTO dto = null;

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
		} catch (Exception e) {

			e.printStackTrace();
		}
	}

	// select option¿¡¼­ 25°³ ±¸¸¦ º¸¿©ÁÜ
	public ArrayList<GuDTO> selectAll() {

		
		ArrayList<GuDTO> list = new ArrayList<GuDTO>();

		try {
			DBconn();

			String sql = "select gu_addr from tbl_gu_coordinate order by gu_addr";

			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();

			while (rs.next()) {
				
				String addr = rs.getString(1);
				
				dto = new GuDTO(addr);
				list.add(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return list;
	}

	// ¼±ÅÃÇÑ ±¸ÀÇ ÁÂÇ¥¸¦ Âï¾îÁÜ
	public GuDTO selectGu(String gu) {


		try {
			DBconn();

			String sql = "select * from tbl_gu_coordinate where gu_addr = ?";

			psmt = conn.prepareStatement(sql);

			psmt.setString(1, gu);

			rs = psmt.executeQuery();

			if (rs.next()) {
				int num = rs.getInt(1);
				String addr = rs.getString(2);
				float latitude = rs.getFloat(3);
				float longitude = rs.getFloat(4);

				dto = new GuDTO(num, addr, latitude, longitude);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return dto;
	}
}
