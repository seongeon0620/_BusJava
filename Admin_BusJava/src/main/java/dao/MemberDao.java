package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;

import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;

import config.*;
import vo.*;

public class MemberDao {
	private JdbcTemplate jdbc;

	public MemberDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public List<MemberInfo> getmemberList(String where, int cpage, int psize) {
		String sql = "select DISTINCT  * from t_member_Info " + where + " limit " + ((cpage - 1) * psize) + ", " + psize;
		
		/* System.out.println(sql); */
		List<MemberInfo> memberList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			MemberInfo mi = new MemberInfo();
			mi.setMi_id(rs.getString("mi_id"));
			mi.setMi_pw(rs.getString("mi_pw"));
			mi.setMi_name(rs.getString("mi_name"));
			mi.setMi_gender(rs.getString("mi_gender"));
			mi.setMi_phone(rs.getString("mi_phone"));
			mi.setMi_email(rs.getString("mi_email"));
			mi.setMi_pmoney(rs.getInt("mi_pmoney"));
			mi.setMi_stamp(rs.getInt("mi_stamp"));
			mi.setMi_coupon(rs.getInt("mi_coupon"));
			mi.setMi_status(rs.getString("mi_status"));
			mi.setMi_date(rs.getString("mi_date"));
			mi.setMi_lastlogin(rs.getString("mi_lastlogin"));
						
			return mi;
		});
		return memberList;
	}

	public int getFreeListCount(String where) {
		String sql = "select count(*) from t_member_info " + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<MemberInfo> getmemberDetail(String mi_id) {
		String sql = "select * from t_member_Info where mi_id = '" + mi_id + "' ";
		
		/* System.out.println(sql); */
				List<MemberInfo> memDetailList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
					MemberInfo mi = new MemberInfo();
					mi.setMi_id(rs.getString("mi_id"));
					mi.setMi_pw(rs.getString("mi_pw"));
					mi.setMi_name(rs.getString("mi_name"));
					mi.setMi_gender(rs.getString("mi_gender"));
					mi.setMi_phone(rs.getString("mi_phone"));
					mi.setMi_email(rs.getString("mi_email"));
					mi.setMi_pmoney(rs.getInt("mi_pmoney"));
					mi.setMi_stamp(rs.getInt("mi_stamp"));
					mi.setMi_coupon(rs.getInt("mi_coupon"));
					mi.setMi_status(rs.getString("mi_status"));
					mi.setMi_date(rs.getString("mi_date"));
					mi.setMi_lastlogin(rs.getString("mi_lastlogin"));
								
					return mi;
				});
		return memDetailList;
	}

	public int memberUpdate(String mi_id, String mi_status, int mi_pmoney) {
		String sql = "update t_member_Info "
				+ " set mi_pmoney = " + mi_pmoney + ", mi_status = '" + mi_status + "' "
				+ " where mi_id = '" + mi_id + "' ";
		int result = jdbc.update(sql);
		return result;
	}

}