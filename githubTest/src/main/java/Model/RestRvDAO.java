package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

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
	
	public ArrayList<RestRvDTO> selectReview(int seq) {
		System.out.println("select ¸®ºä µé¾î¿È");
		ArrayList<RestRvDTO> list = new ArrayList<RestRvDTO>();
		try {
			DBconn();
			
			String sql = "select * from tbl_rest_review seq = ?";
			
			psmt=conn.prepareStatement(sql);
			
			psmt.setInt(1, seq);
			
			rs = psmt.executeQuery();
			
			while(rs.next()) {
				int sequence = rs.getInt(1);
				int s1 = rs.getInt(2);
				int s2 = rs.getInt(3);
				int s3 = rs.getInt(4);
				String txt = rs.getString(5);
				
				dto = new RestRvDTO(sequence, s1, s2, s3, txt);
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		} return list;
	}

}
