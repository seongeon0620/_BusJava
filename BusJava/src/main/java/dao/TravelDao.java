package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import config.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

public class TravelDao {
	private JdbcTemplate jdbc;

	public TravelDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public List<TravelInfo> getTravelList(String where) {
		String sql = "select * from t_travel_list " + where;
		List<TravelInfo> travelList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			TravelInfo tl = new TravelInfo();
			tl.setTl_idx(rs.getInt("tl_idx"));
			tl.setAi_idx(rs.getInt("ai_idx"));
			tl.setTl_ctgr(rs.getString("tl_ctgr"));
			tl.setTl_area(rs.getString("tl_area"));
			tl.setTl_content(rs.getString("tl_content"));
			tl.setTl_img(rs.getString("tl_img"));
			tl.setTl_date(rs.getString("tl_date"));
			
			String title = "";	int cnt = 15;
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

}
