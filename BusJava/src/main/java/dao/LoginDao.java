package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import config.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class LoginDao {
	private JdbcTemplate jdbc;

	public LoginDao(DataSource dataSource) {
		 this.jdbc = new JdbcTemplate(dataSource);
	}
	
	public int chkId(String mi_id) {
		String sql = "select count(*) from t_member_info where mi_id = '" + mi_id + "' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	}
	
	public int kakaoInsert(MemberInfo mi) {
		String sql = "";
		if (mi.getMi_gender().equals("") && mi.getMi_email().equals("")) {
			sql = "insert into t_member_info (mi_id, mi_name, mi_type) "
					+ " values ('"+ mi.getMi_id() +"','"+ mi.getMi_name()+"', '"+ mi.getMi_type() +"') ";
		} else if (mi.getMi_gender().equals("")) {
			sql = "insert into t_member_info (mi_id, mi_name, mi_type) "
					+ " values ('"+ mi.getMi_id() +"','"+ mi.getMi_name()+"', '"+ mi.getMi_type() +"', '"+ mi.getMi_email() +"') ";
		} else if (mi.getMi_email().equals("")) {
			sql = "insert into t_member_info (mi_id, mi_name, mi_type) "
					+ " values ('"+ mi.getMi_id() +"','"+ mi.getMi_name()+"', '"+ mi.getMi_type() +"', '"+ mi.getMi_gender() +"') ";
		} else {
			sql = "insert into t_member_info (mi_id, mi_name, mi_type, mi_gender, mi_email) "
					+ " values ('"+ mi.getMi_id() +"','"+ mi.getMi_name()+"', '"+ mi.getMi_type() +"', '"+ mi.getMi_gender() +"', '"+ mi.getMi_email() +"') ";
		}
		int result = jdbc.update(sql);
		
		System.out.println(sql);
		
		return result;
	}

	public MemberInfo getkakaoLogin(String mi_id) {
		String sql = "select * from t_member_info where mi_id = ? and mi_status != '탈퇴' ";

		List<MemberInfo> results = jdbc.query(sql, new RowMapper<MemberInfo>() {
			public MemberInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				MemberInfo kakaoLogin = new MemberInfo();
				kakaoLogin.setMi_id(rs.getString("mi_id"));
				kakaoLogin.setMi_pw(rs.getString("mi_pw"));
	            kakaoLogin.setMi_name(rs.getString("mi_name"));
	            kakaoLogin.setMi_gender(rs.getString("mi_gender"));
	            kakaoLogin.setMi_phone(rs.getString("mi_phone"));
	            kakaoLogin.setMi_email(rs.getString("mi_email"));
	            kakaoLogin.setMi_status(rs.getString("mi_status"));
	            kakaoLogin.setMi_date(rs.getString("mi_date"));
	            kakaoLogin.setMi_lastlogin(rs.getString("mi_lastlogin"));
	            kakaoLogin.setMi_pmoney(rs.getInt("mi_pmoney"));
	            kakaoLogin.setMi_stamp(rs.getInt("mi_stamp"));
	            kakaoLogin.setMi_coupon(rs.getInt("mi_coupon"));
	            kakaoLogin.setMi_type(rs.getString("mi_type"));
	            return kakaoLogin;
			}
		}, mi_id);
		// 쿼리에 직접 값을 넣으면 매개변수로 값을 추가할 필요 없음
		
		return results.isEmpty() ? null : results.get(0);
	}

	public int naverInsert(MemberInfo mi) {
		String sql = "insert into t_member_info (mi_id, mi_type, mi_phone, mi_gender, mi_email) "
				+ " values ('"+ mi.getMi_id() +"','"+ mi.getMi_type()+"', '"+ mi.getMi_phone() +"', "
						+ " '"+ mi.getMi_gender() +"','"+ mi.getMi_email()+"') ";
		int result = jdbc.update(sql);
		
		System.out.println(sql);
		
		return result;
	}

	
}
