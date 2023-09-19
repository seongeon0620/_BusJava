package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

public class CsLostDao {
	private JdbcTemplate jdbc;
	
	public CsLostDao(DataSource dataSource) {
	      this.jdbc = new JdbcTemplate(dataSource);
	}
	
	public int getLostListCount(String where) {
		String sql = "select count(*) from t_lost_list" + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<LostInfo> getLostList(String where, int cpage, int psize) {
		String sql = "select ll_idx, ll_title, ll_tername, if(left(ll_getdate, 10) = curdate(), mid(ll_getdate, 11, 6), left(replace(ll_getdate, '-', '.'), 10)) wdate " + 
				" from t_lost_list " + where + " order by ll_idx desc limit " + ((cpage - 1) * psize) + ", " + psize;
		
		int cnt = 30;
		List<LostInfo> lostList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			LostInfo li = new LostInfo();
			li.setLl_idx(rs.getInt("ll_idx"));
			li.setLl_getdate(rs.getString("wdate"));
			li.setLl_tername(rs.getString("ll_tername"));

			String title = rs.getString("ll_title");
			if (title.length() > cnt) 
				title = title.substring(0, cnt - 3) + "...";
			li.setLl_title(title);
		
			return li;
		}); 
		return lostList;
	}
	
	public LostInfo getLostInfo(int ll_idx) {
		
		String sql = "select ll_idx, ll_title, ll_content, ll_img, ll_tername, replace(ll_date, '-', '.') wdate from t_lost_list " + 
				"where ll_status = 'A' and ll_idx=" + ll_idx;
		LostInfo li = jdbc.queryForObject(sql, new RowMapper<LostInfo>() {	
			@Override
			public LostInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				LostInfo li = new LostInfo();
				li.setLl_idx(ll_idx);
				li.setLl_title(rs.getString("ll_title"));
				li.setLl_content(rs.getString("ll_content").replaceAll("\r\n", "<br />"));
				li.setLl_tername(rs.getString("ll_tername"));
				li.setLl_getdate(rs.getString("wdate"));
				li.setLl_img(rs.getString("ll_img"));
				return li;
			}
		});
		return li;
	}
}
