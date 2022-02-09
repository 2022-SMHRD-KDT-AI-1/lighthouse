package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MemberDAO {
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;
	MemberDTO dto= null;
	int cnt = 0;
	
	public void DBconn() {
		// 1. jar파일 집어놓고, Class 동적로딩
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver"); // 통로 Class : OracleDriver

			
			String url = "jdbc:oracle:thin:@project-db-stu.ddns.net:1524:xe";
			String dbid = "campus_e_5_0115";
			String dbpw = "smhrd5";
			conn = DriverManager.getConnection(url, dbid, dbpw);// db연결
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
	public int join(MemberDTO dto) {
		try {
			
			DBconn();
			
			String sql = "insert into web_login values(?,?)";
			
			psmt = conn.prepareStatement(sql);
			
			psmt.setString(1,dto.getEmail());
			psmt.setString(2,dto.getPw());
			
			cnt = psmt.executeUpdate();
			
		
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBclose();
		}return cnt;
		
	}
	public MemberDTO login(MemberDTO dto) {
		MemberDTO info = null;
		try {
			
			DBconn();
			
			String sql ="select * from web_login where email=? and pw=?";
			
			psmt = conn.prepareStatement(sql);
			
			psmt.setString(1, dto.getEmail());
			psmt.setString(2, dto.getPw());
			
			rs = psmt.executeQuery();
			
			if(rs.next()) {
				
				String email =rs.getString(1);
				String pw = rs.getString(2);

				
				info =new MemberDTO(email, pw);
				
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBclose();
		}return info;
		
	}
	
	
}
