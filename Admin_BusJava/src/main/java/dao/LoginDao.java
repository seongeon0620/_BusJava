package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

public class LoginDao {
	private JdbcTemplate jdbcTemplate;
	public LoginDao(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public AdminInfo getLoginInfo(String uid, String pwd) {
		String sql = "select * from t_admin_info where ai_id = ? and ai_pw = ?";
		
		List<AdminInfo> results = jdbcTemplate.query(sql, new RowMapper<AdminInfo>() {
			public AdminInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				AdminInfo ai = new AdminInfo();
				ai.setAi_idx(rs.getInt("ai_idx"));
				ai.setAi_id(rs.getString("ai_id"));
				ai.setAi_pw(rs.getString("ai_pw"));
				ai.setAi_name(rs.getString("ai_name"));
				ai.setAi_use(rs.getString("ai_use"));
				ai.setAi_date(rs.getString("ai_date"));
	            return ai;
			}
		}, uid, pwd);
		// 쿼리에 직접 값을 넣으면 매개변수로 값을 추가할 필요 없음
		
		return results.isEmpty() ? null : results.get(0);
	}
}
