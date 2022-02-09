package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class checkDAO {
	
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;

	

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
	
	public int checkEmail(String Email) {
		
		int  chk = 0;
		
		try {
			DBconn();
			
			String sql = "select * from web_login where email = ?";
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, Email);
			
			rs = psmt.executeQuery();
			
			if(rs.next() || Email.equals("")) {
				chk = 0; // 이미 존재하는 경우
			}else {
				chk = 1; // 존재하지 않는 경우
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		} return chk;
	}
	
	public int checkNick(String nick) {
			
			int  chk = 0;
			
			try {
				DBconn();
				
				String sql = "select * from web_login where nickname = ?";
				psmt = conn.prepareStatement(sql);
				psmt.setString(1, nick);
				
				rs = psmt.executeQuery();
				
				if(rs.next() || nick.equals("")) {
					chk = 0; // 이미 존재하는 경우
				}else {
					chk = 1; // 존재하지 않는 경우
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBclose();
			} return chk;
		}
}
