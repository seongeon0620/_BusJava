package dao;

import java.sql.*;
import java.util.*;
import javax.sql.*;
import org.springframework.jdbc.core.*;
import vo.*;

public class TravelDao {
	private JdbcTemplate jdbc;
	
	public TravelDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public int getTraverListCount(String where) {
		String sql = "select count(*) from t_travel_list " + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<TravelList> getTravelList(String where, int cpage, int psize) {
		String sql = "select tl_idx, ai_idx, tl_ctgr, tl_area, tl_title, tl_content, tl_img, tl_isview, "+ 
				"if(curdate() = date(tl_date), left(time(tl_date), 5), mid(tl_date, 3, 8)) wdate from t_travel_list " + where + 
				" order by tl_idx desc limit " + ((cpage - 1) * psize) + ", " + psize;
		List<TravelList> travelList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			TravelList tl = new TravelList();
			tl.setTl_idx(rs.getInt("tl_idx"));
			tl.setAi_idx(rs.getInt("ai_idx"));
			tl.setTl_ctgr(rs.getString("tl_ctgr"));
			tl.setTl_area(rs.getString("tl_area"));
			tl.setTl_content(rs.getString("tl_content"));
			tl.setTl_img(rs.getString("tl_img"));
			tl.setTl_date(rs.getString("wdate").replace("-", "."));
			
			String title = "";	int cnt = 30;
			if (rs.getString("tl_title").length() > cnt)
				title = rs.getString("tl_title").substring(0, cnt - 3) + "..." + title;
			else
				title = rs.getString("tl_title") + title;
			tl.setTl_title(title);
			
			String isview = "";
			if (rs.getString("tl_isview").equals("y"))	isview = "Y";
			else 										isview = "N";
			tl.setTl_isview(isview);
			
			return tl;
		});
		return travelList;
	}

	public int travelIn(TravelList tr, String kind) {
		String sql = "";
		if (kind.equals("in")) {
			sql = "insert into t_travel_list(ai_idx, tl_ctgr, tl_area, tl_title, tl_content, tl_img, tl_isview)" + 
				" values(" + tr.getAi_idx() + ", '" + tr.getTl_ctgr() + "', '" + tr.getTl_area() + "', '" + tr.getTl_title() + "', '" + 
				tr.getTl_content() + "', '" + tr.getTl_img() + "', '" + tr.getTl_isview() + "')";
		} else {
			sql = "update t_travel_list set ai_idx = '" + tr.getAi_idx() + "', tl_ctgr = '" + tr.getTl_ctgr() + "', tl_area = '" +
					tr.getTl_area() + "', tl_title = '" + tr.getTl_title() +"', tl_content = '" + tr.getTl_content() + "', tl_img = '"
					+ tr.getTl_img() + "', tl_isview = '" + tr.getTl_isview() + "' where tl_idx = " + tr.getTl_idx();
		}
			
		int result = jdbc.update(sql);
		int tl_idx = 0;
		if (kind.equals("in")) {
			if (result == 1) {
				sql = "select MAX(tl_idx) from t_travel_list";
				tl_idx = jdbc.queryForObject(sql, Integer.class);
			}
		} else {
			tl_idx = tr.getTl_idx();
		}
		return tl_idx;
	}

	public TravelList getTravelView(int tl_idx) {
		String sql = "select tl_idx, ai_idx, tl_ctgr, tl_area, tl_title, tl_content, tl_img, tl_isview, " +
				"if(curdate() = date(tl_date), left(time(tl_date), 5), mid(tl_date, 3, 8)) date from t_travel_list where tl_idx = " + tl_idx;
		TravelList tr = jdbc.queryForObject(sql, new RowMapper<TravelList>() {
			@Override
			public TravelList mapRow(ResultSet rs, int rowNum) throws SQLException {
				TravelList tr = new TravelList();
				tr.setAi_idx(rs.getInt("ai_idx"));
				tr.setTl_area(rs.getString("tl_area"));
				tr.setTl_content(rs.getString("tl_content"));
				tr.setTl_ctgr(rs.getString("tl_ctgr"));
				tr.setTl_date(rs.getString("date").replace("-", "."));
				tr.setTl_idx(rs.getInt("tl_idx"));
				tr.setTl_img(rs.getString("tl_img"));
				tr.setTl_title(rs.getString("tl_title"));
				
				String isview = "";
				if (rs.getString("tl_isview").equals("y"))	isview = "Y";
				else 										isview = "N";
				tr.setTl_isview(isview);
				return tr;
			}
		});
		return tr;
	}

	public int travelDel(String where) {
		String sql = "update t_travel_list set tl_isview = 'n' " + where;
		int result = jdbc.update(sql);
		return result;
	}
	
}
