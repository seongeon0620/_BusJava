package dao;

import java.sql.*;
import java.util.*;
import javax.sql.*;
import org.springframework.jdbc.core.*;
import vo.*;

public class LostDao {
	private JdbcTemplate jdbc;
	
	public LostDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public int getLostListCount(String where) {
		String sql = "select count(*) from t_lost_list " + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<LostInfo> getLostList(String where, int cpage, int psize) {
		String sql = "select ll_idx, ai_idx, ll_tername, ll_title, ll_content, ll_img, ll_status, "+ 
				"if(curdate() = date(ll_getdate), left(time(ll_getdate), 5), mid(ll_getdate, 1, 10)) wdate, " + 
				"left(time(ll_getdate), 5) time from t_lost_list " + where + 
				" order by ll_idx desc limit " + ((cpage - 1) * psize) + ", " + psize;
		
		List<LostInfo> lostList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			LostInfo li = new LostInfo();
			li.setLl_idx(rs.getInt("ll_idx"));
			li.setAi_idx(rs.getInt("ai_idx"));
			li.setLl_tername(rs.getString("ll_tername"));
			li.setLl_content(rs.getString("ll_content"));
			li.setLl_img(rs.getString("ll_img"));
			li.setLl_getdate(rs.getString("wdate").replace("-", "."));
			li.setLl_time(rs.getString("time"));
			li.setLl_status(rs.getString("ll_status"));
			
			String title = "";	int cnt = 30;
			if (rs.getString("ll_title").length() > cnt)
				title = rs.getString("ll_title").substring(0, cnt - 3) + "..." + title;
			else
				title = rs.getString("ll_title") + title;
			li.setLl_title(title);
			
			
			return li;
		});
		return lostList;
	}

	public int lostIn(LostInfo li, String kind) {
		String sql = "";
		if (kind.equals("in")) {
			sql = "insert into t_lost_list(ai_idx, ll_tername, ll_title, ll_content, ll_img, ll_status, ll_getdate)" + 
				" values(" + li.getAi_idx() + ", '" + li.getLl_tername() + "', '" + li.getLl_title() + "', '" + 
				li.getLl_content() + "', '" + li.getLl_img() + "', '" + li.getLl_status() + "', '" + li.getLl_getdate() + "')";
		} else {
			sql = "update t_lost_list set ai_idx = '" + li.getAi_idx() + "', ll_tername = '" +
					li.getLl_tername() + "', ll_title = '" + li.getLl_title() +"', ll_content = '" + li.getLl_content() + "', ll_img = '"
					+ li.getLl_img() + "', ll_status = '" + li.getLl_status() + "', ll_getdate = '" + li.getLl_getdate() 
					+ "' where ll_idx = " + li.getLl_idx();
		}
			
		int result = jdbc.update(sql);
		int ll_idx = 0;
		if (kind.equals("in")) {
			if (result == 1) {
				sql = "select MAX(ll_idx) from t_lost_list";
				ll_idx = jdbc.queryForObject(sql, Integer.class);
			}
		} else {
			ll_idx = li.getLl_idx();
		}
		return ll_idx;
	}

	public LostInfo getLostView(int ll_idx) {
		String sql = "select ll_idx, ai_idx, ll_tername, ll_title, ll_content, ll_img, ll_status, " +
				"left(ll_getdate, 10) date, left(time(ll_getdate), 5) time from t_lost_list where ll_idx = " + ll_idx;
		
		LostInfo li = jdbc.queryForObject(sql, new RowMapper<LostInfo>() {
			@Override
			public LostInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				LostInfo li = new LostInfo();
				li.setAi_idx(rs.getInt("ai_idx"));
				li.setLl_tername(rs.getString("ll_tername"));
				li.setLl_content(rs.getString("ll_content"));
				li.setLl_date(rs.getString("date").replace("-", "."));
				li.setLl_time(rs.getString("time"));
				li.setLl_idx(rs.getInt("ll_idx"));
				li.setLl_img(rs.getString("ll_img"));
				li.setLl_title(rs.getString("ll_title"));
				li.setLl_status(rs.getString("ll_status"));
				return li;
			}
		});
		return li;
	}

	public int lostDel(String where) {
		String sql = "update t_lost_list set ll_status = 'B' " + where;
		int result = jdbc.update(sql);
		return result;
	}
}
