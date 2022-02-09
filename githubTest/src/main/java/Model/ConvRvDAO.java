package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ConvRvDAO {

	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement psmt = null;
	int cnt = 0;
	ConvRvDTO dto = null;

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

	// DB close �޼ҵ�
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

	public int insertReview(int seq, String id, int s1, int s2, int s3, int s4, int s5, String text, String name) {
		System.out.println("���ǽü� insert ���� ����");
		try {
			DBconn();

			String sql = "insert into tbl_conv_review values(?,?,?,?,?,?,?,to_char(sysdate,'yyyy.mm.dd'),?,?)";

			psmt = conn.prepareStatement(sql);

			psmt.setInt(1, seq);
			psmt.setString(2, id);
			psmt.setInt(3, s1);
			psmt.setInt(4, s2);
			psmt.setInt(5, s3);
			psmt.setInt(6, s4);
			psmt.setInt(7, s5);
			psmt.setString(8, text);
			psmt.setString(9, name);
			
			cnt = psmt.executeUpdate();
			
			
			System.out.println(seq);
			System.out.println(s1);
			System.out.println(s2);
			System.out.println(s3);
			System.out.println(s4);
			System.out.println(s5);
			System.out.println(text);
			System.out.println(name);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return cnt;
	}

	public ArrayList<ConvRvDTO> selectReview(String seq) {

		ArrayList<ConvRvDTO> list = new ArrayList<ConvRvDTO>();

		try {
			DBconn();

			String sql = "select * from tbl_conv_review where seq = ?";

			psmt = conn.prepareStatement(sql);
			psmt.setString(1, seq);
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
				String txt = rs.getString(9);
				String name = rs.getString(10);
				
				dto = new ConvRvDTO(sequence, id, sc1, sc2, sc3, sc4, sc5, date, txt, name);
				list.add(dto);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return list;
	}

	public ConvAvg1DTO selectAvgs1(String seq) {

		ConvAvg1DTO dto = null;

		System.out.println("����1 ��հ� ����");
		try {
			DBconn();

			String sql = "select round(avg(score1),1) from tbl_conv_review where seq = ?";

			psmt = conn.prepareStatement(sql);
			psmt.setString(1, seq);
			rs = psmt.executeQuery();

			if (rs.next()) {
				float avgs1 = rs.getFloat(1);

				dto = new ConvAvg1DTO(avgs1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return dto;
	}

	public ConvAvg2DTO selectAvgs2(String seq) {

		System.out.println("����2 ��հ� ����");
		ConvAvg2DTO dto = null;

		try {
			DBconn();

			String sql = "select round(avg(score2),1) from tbl_conv_review where seq = ?";

			psmt = conn.prepareStatement(sql);
			psmt.setString(1, seq);
			rs = psmt.executeQuery();

			if (rs.next()) {
				float avgs2 = rs.getFloat(1);

				dto = new ConvAvg2DTO(avgs2);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return dto;
	}

	public ConvAvg3DTO selectAvgs3(String seq) {

		System.out.println("����3 ��հ� ����");
		ConvAvg3DTO dto = null;

		try {
			DBconn();

			String sql = "select round(avg(score3),1) from tbl_conv_review where seq = ?";

			psmt = conn.prepareStatement(sql);
			psmt.setString(1, seq);
			rs = psmt.executeQuery();

			if (rs.next()) {
				float avgs3 = rs.getFloat(1);

				dto = new ConvAvg3DTO(avgs3);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return dto;
	}
	
	public ConvAvg4DTO selectAvgs4(String seq) {

		System.out.println("����4 ��հ� ����");
		ConvAvg4DTO dto = null;

		try {
			DBconn();

			String sql = "select round(avg(score4),1) from tbl_conv_review where seq = ?";

			psmt = conn.prepareStatement(sql);
			psmt.setString(1, seq);
			rs = psmt.executeQuery();

			if (rs.next()) {
				float avgs4 = rs.getFloat(1);

				dto = new ConvAvg4DTO(avgs4);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return dto;
	}
	
	public ConvAvg5DTO selectAvgs5(String seq) {

		System.out.println("����5 ��հ� ����");
		ConvAvg5DTO dto = null;

		try {
			DBconn();

			String sql = "select round(avg(score5),1) from tbl_conv_review where seq = ?";

			psmt = conn.prepareStatement(sql);
			psmt.setString(1, seq);
			rs = psmt.executeQuery();

			if (rs.next()) {
				float avgs5 = rs.getFloat(1);

				dto = new ConvAvg5DTO(avgs5);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBclose();
		}
		return dto;
	}

	

	

}
