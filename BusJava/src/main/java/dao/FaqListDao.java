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

	public List<FaqInfo> getfaqList(String where) {
		String sql = "select * from t_faq_list " + where;
		System.out.println(sql);
		List<FaqInfo> faqList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			FaqInfo fi = new FaqInfo();
			fi.setAi_idx(rs.getInt("ai_idx"));
			fi.setFl_idx(rs.getInt("fl_idx"));
			fi.setFl_content(rs.getString("fl_content"));
			fi.setFl_ctgr(rs.getString("fl_ctgr"));
			fi.setFl_date(rs.getString("fl_date"));
			fi.setFl_isview(rs.getString("fl_isview"));
			fi.setFl_title(rs.getString("fl_title"));
			return fi;
		});
		return faqList;
	}
	
	
}
