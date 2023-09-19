package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import config.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;


public class FaqListDao {
	private JdbcTemplate jdbc;
	
	public FaqListDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}


	public int faqProcUp(int fl_idx, String fl_title, String fl_content, String fl_isview,String fl_ctgr) { // update
		String sql = "update t_faq_list "
				+ " set fl_title = '" + fl_title + "', fl_content = '" + fl_content + "', fl_isview = '" + fl_isview + "' "
				+ ", fl_ctgr= '"+ fl_ctgr +"' " 
				+ " where fl_idx = '" + fl_idx + "' ";
		//System.out.println(sql);
		int result = jdbc.update(sql);
		return result;
	}

	public int faqFormIn(int ai_idx, String fl_title, String fl_content, String fl_isview, String fl_ctgr) { // insert
		String sql = "INSERT INTO t_faq_list (ai_idx, fl_ctgr, fl_title, fl_content) "
						+ "VALUES (" + ai_idx + ", '" + fl_ctgr + "', '" + fl_title + "', '" + fl_content + "') ";
		//System.out.println(sql);
		int result = jdbc.update(sql);
		return result;
	}
	
	public int getfaqListCount(String where) {
		String sql = "select count(*) from t_faq_list " + where;
		//System.out.println(sql);
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<FaqInfo> getfaqList(String where, int cpage, int psize) {
		String sql = "select fl_idx, ai_idx, fl_ctgr, fl_title, fl_content, fl_isview, "
				+ " if(left(fl_date, 10) = curdate(), mid(fl_date, 11, 6), left(replace(fl_date, '-', '.'), 10)) wdate  "
				+ " from t_faq_list " + where + "  order by fl_idx desc limit " + ((cpage - 1) * psize) + ", " + psize;
		System.out.println(sql);
		List<FaqInfo> faqList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			FaqInfo fi = new FaqInfo();
			fi.setAi_idx(rs.getInt("ai_idx"));
			fi.setFl_idx(rs.getInt("fl_idx"));
			fi.setFl_content(rs.getString("fl_content"));
			fi.setFl_ctgr(rs.getString("fl_ctgr"));
			fi.setFl_date(rs.getString("wdate"));
			fi.setFl_isview(rs.getString("fl_isview"));
			fi.setFl_title(rs.getString("fl_title"));
			return fi;
		});
		return faqList;
	}


	public List<FaqInfo> getCtgrList() {
		String sql = "select DISTINCT fl_ctgr FROM t_faq_list";
		List<FaqInfo> ctgrList = jdbc.query(sql, 
			(ResultSet rs, int rowNum) -> {
			FaqInfo fi = new FaqInfo();
					fi.setFl_ctgr(rs.getString("fl_ctgr"));
				return fi;
			});
		return ctgrList;
	}


	public int isviewChange(String where, String isview) {
		String sql = "update t_faq_list set fl_isview = '" + isview + "' " + where;
		int result = jdbc.update(sql);
		return result;
	}


	public FaqInfo getfaqInfo(int flidx) {
		String sql = "select * from t_faq_list where fl_idx=" + flidx;
		FaqInfo fi = jdbc.queryForObject(sql, new RowMapper<FaqInfo>() {	
			@Override
			public FaqInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				FaqInfo fi = new FaqInfo();
				fi.setFl_idx(flidx);
				fi.setAi_idx(rs.getInt("ai_idx"));
				fi.setFl_ctgr(rs.getString("fl_ctgr"));
				fi.setFl_title(rs.getString("fl_title"));
				fi.setFl_content(rs.getString("fl_content"));
				fi.setFl_isview(rs.getString("fl_isview"));
				fi.setFl_date(rs.getString("fl_date"));
				return fi;
			}
		});
		return fi;
	}
	
	
}
