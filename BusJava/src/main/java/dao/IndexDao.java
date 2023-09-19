package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import config.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

public class IndexDao {
	private JdbcTemplate jdbc;
	
	public IndexDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public List<BannerInfo> getbannerList() {
		String sql = "select bl_img from t_banner_list where bl_isview = 'Y' order by bl_idx desc ";
		System.out.println(sql);
		List<BannerInfo> bannerInfo  = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			BannerInfo bi = new BannerInfo();
			bi.setBl_img(rs.getString("bl_img"));
			return bi;
		});
		return bannerInfo;
	}

	public List<ReservationInfo> getRecentReservation(String mi_id) {
		String sql = 
			"SELECT RI_IDX," +
				" CASE WHEN DATEDIFF(RI_FRDATE, CURDATE()) < 1 THEN" +
					" CONCAT(HOUR(TIMEDIFF(RI_FRDATE, NOW())), '시간 ', MINUTE(TIMEDIFF(RI_FRDATE, NOW())), '분')" +
				" ELSE CONCAT(DATEDIFF(RI_FRDATE, CURDATE()), '일')" +	
				" END AS REMAINING_TIME FROM T_RESERVATION_INFO WHERE MI_ID = ? AND RI_STATUS = '예매' AND RI_FRDATE > curdate()" +
				" ORDER BY REMAINING_TIME LIMIT 0, 1";
		List<ReservationInfo> result = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			ReservationInfo ri = new ReservationInfo();
			ri.setRi_idx(rs.getString("RI_IDX"));
			ri.setRi_date(rs.getString("REMAINING_TIME"));
			return ri;
		}, mi_id);
		
		return result;
	}
	
}
