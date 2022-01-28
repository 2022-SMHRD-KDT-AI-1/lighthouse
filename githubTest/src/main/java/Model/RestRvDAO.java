package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RestRvDAO {
	
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;

	RestRvDTO dto = null;
	int cnt = 0;
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
	
	public int insertReview(int seq, int s1, int s2, int s3, String text) {
		
		try {
			DBconn();
			
			String sql = "insert into tbl_rest_review values(?,?,?,?,?)";
			
			psmt=conn.prepareStatement(sql);
			
			psmt.setInt(1, seq);
			psmt.setInt(2, s1);
			psmt.setInt(3, s2);
			psmt.setInt(4, s3);
			psmt.setString(5, text);
			
			cnt = psmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		} return cnt;
	}

}
