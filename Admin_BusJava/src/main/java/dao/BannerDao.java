package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import org.springframework.jdbc.core.JdbcTemplate;
import config.*;
import vo.*;
import org.springframework.jdbc.core.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;

public class BannerDao {
	private JdbcTemplate jdbc;

	public BannerDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public int getBannerListCount(String where) {
		String sql = "select count(*) from t_banner_list " + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<BannerInfo> getBannerList(String where, int cpage, int psize) {
		String sql = " select bl_idx, bl_name, bl_content, bl_img, bl_isview, "
				+ " if(curdate() = date(bl_date), left(time(bl_date), 5), mid(bl_date, 3, 8)) bl_date "
				+ " from t_banner_list " + where + " order by bl_idx desc limit " + ((cpage - 1) * psize) + ", " + psize;
		List<BannerInfo> bannerList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			BannerInfo bi = new BannerInfo();
			bi.setBl_idx(rs.getInt("bl_idx"));
			bi.setBl_content(rs.getString("bl_content"));
			bi.setBl_date(rs.getString("bl_date").replace("-", "."));
			bi.setBl_img(rs.getString("bl_img").toLowerCase());
			bi.setBl_isview(rs.getString("bl_isview"));
			bi.setBl_name(rs.getString("bl_name"));
			return bi;
		});
		return bannerList;
	}

	public int BisviewChange(String where, String isview) {
		String sql = "update t_banner_list set bl_isview = '" + isview + "' " + where;
		System.out.println(sql);
		int result = jdbc.update(sql);
		return result;
	}

	public BannerInfo getBannerView(int bl_idx) {
		String sql = " select bl_idx, bl_name, bl_content, bl_img, bl_isview, "
				+ " if(curdate() = date(bl_date), left(time(bl_date), 5), mid(bl_date, 3, 8)) bl_date "
				+ " from t_banner_list where bl_idx = " + bl_idx;
		BannerInfo bi = jdbc.queryForObject(sql, new RowMapper<BannerInfo>() {
			@Override
			public BannerInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				BannerInfo bi = new BannerInfo();
				bi.setBl_idx(rs.getInt("bl_idx"));
				bi.setBl_name(rs.getString("bl_name"));
				bi.setBl_content(rs.getString("bl_content"));
				bi.setBl_img(rs.getString("bl_img"));
				bi.setBl_isview(rs.getString("bl_isview"));
				bi.setBl_date(rs.getString("bl_date"));
				return bi;
			}
		});
		return bi;
	}

	public int bannerIn(BannerInfo bi, String kind) {
		String sql = "";
		if (kind.equals("in")) {
			sql = "insert into t_banner_list(ai_idx, bl_name, bl_content, bl_img, bl_isview)" + 
				" values(" + bi.getAi_idx() + ", '" + bi.getBl_name() + "', '" + bi.getBl_content() + "', '" + 
				bi.getBl_img() + "', '" + bi.getBl_isview() + "')";
		} else {
			sql = "update t_banner_list set ai_idx = '" + bi.getAi_idx() + "', bl_name = '" + bi.getBl_name() +"', bl_content = '" + bi.getBl_content() + "', bl_img = '"
					+ bi.getBl_img() + "', bl_isview = '" + bi.getBl_isview() + "' where bl_idx = " + bi.getBl_idx();
		}
			
		int result = jdbc.update(sql);
		int bl_idx = 0;
		if (kind.equals("in")) {
			if (result == 1) {
				sql = "select MAX(bl_idx) from t_banner_list";
				bl_idx = jdbc.queryForObject(sql, Integer.class);
			}
		} else {
			bl_idx = bi.getBl_idx();
		}
		return bl_idx;
	}

	public int chkIsview() {
		String sql = "select count(*) from t_banner_list where bl_isview = 'Y' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		System.out.println(result);
		return result;
	}
	
}
