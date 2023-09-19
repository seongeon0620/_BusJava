package dao;

import java.util.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

import javax.sql.*;
import org.springframework.jdbc.core.*;
import vo.*;

public class TicketDao {
	private JdbcTemplate jdbc;

	public TicketDao(DataSource dataSource) {
		 this.jdbc = new JdbcTemplate(dataSource);
	}

	public int getTicketListCount(String where) {
		String sql = "select count(*) from t_reservation_info " + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<TicketInfo> getTicketList(int cpage, int psize, String where) {
		String sql = "select * from t_reservation_info " + where + " order by ri_date desc limit " + ((cpage - 1) * psize) + ", " + psize;

		List<TicketInfo> ticketList = jdbc.query(sql, 
				(ResultSet rs, int rowNum) -> {
					TicketInfo ti = new TicketInfo();
					ti.setRi_idx(rs.getString("ri_idx"));
					ti.setRi_level(rs.getString("ri_level"));
					ti.setRi_fr(rs.getString("ri_fr"));
					ti.setRi_to(rs.getString("ri_to"));
					ti.setRi_acnt(rs.getInt("ri_acnt"));
					ti.setRi_scnt(rs.getInt("ri_scnt"));
					ti.setRi_ccnt(rs.getInt("ri_ccnt"));
					ti.setRi_status(rs.getString("ri_status"));
					ti.setSeatInfo(getReservationDetail(rs.getString("ri_idx")));					
					ti.setRi_frdate(rs.getString("ri_frdate"));
					ti.setRi_line_type(rs.getString("ri_line_type"));
					ti.setRi_date(rs.getString("ri_date"));
					
					return ti;
				});
		return ticketList;
	}
	
	public List<SeatInfo> getReservationDetail(String idx) {
		String sql = "select * from t_reservation_detail where ri_idx = '" + idx + "'";
		List<SeatInfo> seatList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
					SeatInfo si = new SeatInfo();
					si.setRd_idx(rs.getInt("rd_idx"));
					si.setRd_seat_num(rs.getInt("rd_seat_num"));
					return si;
		});
		return seatList;
	}

	public List<String> getStartList() {
		String sql = "select distinct ri_fr from t_reservation_info";
		List<String> startList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			return rs.getString("ri_fr");
		});
		return startList;
	}

	public List<String> getEndList(String start) {
		String sql = "select distinct ri_to from t_reservation_info where ri_fr = '" + start + "'";
		List<String> endList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			return rs.getString("ri_to");
		});
		return endList;
	}

	public List<String> getEndList() {
		String sql = "select distinct ri_to from t_reservation_info";
		List<String> endList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			return rs.getString("ri_to");
		});
		return endList;
	}

	public TicketInfo getTicketView(String ri_idx) {
		String sql = " select ri.ri_idx, ri.mi_id, ri.ri_line_type, ri.ri_fr, ri.ri_to, ri.ri_status, ri.ri_acnt, ri.ri_scnt, ri.ri_ccnt, ri.ri_com, ri.ri_level, "
				+ " replace(substring(ri.ri_frdate, 1 , 10), '-', '.') ri_frdate, substring(ri.ri_frdate, 11, 6) ri_frtime, "
				+ " replace(substring(ri.ri_todate, 1 , 10), '-', '.') ri_todate, substring(ri.ri_todate, 11, 6) ri_totime, "
				+ " pd.pd_payment, pd.pd_real_price, pd.pd_date, pd_total_price "
				+ " from t_reservation_info ri, t_payment_detail pd "
				+ " where ri.ri_idx = pd.ri_idx and ri.ri_idx = '"+ ri_idx +"' and ri.ri_date >= DATE_SUB(NOW(), INTERVAL 3 MONTH) "
				+ " GROUP BY ri.ri_idx, ri.ri_line_type, ri.ri_fr, ri.ri_to, ri.ri_frdate, ri_todate, ri.ri_status, ri_frtime, "
				+ " ri_totime, pd.pd_payment, pd.pd_real_price, pd.pd_date, pd_total_price "
				+ " order by ri.ri_idx desc ";
		TicketInfo ti = jdbc.queryForObject(sql, new RowMapper<TicketInfo>() {
			@Override
			public TicketInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				TicketInfo ti = new TicketInfo();
				ti.setRi_idx(rs.getString("ri_idx"));
				ti.setMi_id(rs.getString("mi_id"));
				ti.setRi_line_type(rs.getString("ri_line_type"));
				ti.setRi_fr(rs.getString("ri_fr"));
				ti.setRi_to(rs.getString("ri_to"));
				ti.setRi_status(rs.getString("ri_status"));
				ti.setRi_acnt(rs.getInt("ri_acnt"));
				ti.setRi_scnt(rs.getInt("ri_scnt"));
				ti.setRi_ccnt(rs.getInt("ri_ccnt"));
				ti.setRi_com(rs.getString("ri_com"));
				ti.setRi_level(rs.getString("ri_level"));
				ti.setRi_frdate(rs.getString("ri_frdate"));
				ti.setRi_frtime(rs.getString("ri_frtime"));
				ti.setRi_todate(rs.getString("ri_todate"));
				ti.setRi_totime(rs.getString("ri_totime"));
				ti.setPd_payment(rs.getString("pd_payment"));
				ti.setPd_real_price(rs.getInt("pd_real_price"));
				ti.setPd_total_price(rs.getInt("pd_total_price"));
				ti.setPd_date(rs.getString("pd_date"));
				ti.setSeatInfo(getReservationDetail(rs.getString("ri_idx")));
				
				
	            return ti;
			}
		});
		return ti;
	}

	public int realCancel(String ri_idx, String mi_id) {
		String sql = " select DISTINCT substring(ri.ri_frdate, 1 , 16) ri_frdate, pd.pd_real_price, pd.pd_total_price, pd.pd_payment, "
				+ " mi.mi_pmoney, cr.cr_pmoney, cr.cr_pay " 
				+ " from t_reservation_info ri, t_payment_detail pd, t_member_info mi, t_count_rinfo cr "
				+  "where ri.ri_idx = pd.ri_idx and ri.ri_idx = cr.ri_idx and ri.mi_id = mi.mi_id and ri.mi_id='" + mi_id 
				+ "' and ri.ri_idx='" + ri_idx + "' ";
		int result = 0;
		String sday="";
		
		BookInfo bi = jdbc.queryForObject(sql, new RowMapper<BookInfo>() {
			@Override
			public BookInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
			BookInfo bi = new BookInfo(
			rs.getString("ri_frdate"),
			rs.getInt("pd_real_price"),
			rs.getInt("pd_total_price"),
			rs.getString("pd_payment"),
			rs.getInt("mi_pmoney"),
			rs.getInt("cr_pmoney"),
			rs.getInt("cr_pay"));
			return bi;
			}
		});
		
		// 1. 예매정보조회 - 날짜 및 시간 출력
		sday = bi.getRi_frdate().trim(); 
		int realPrice = bi.getPd_total_price();
		
		// 2.1 날짜 및 시간 LocalDateTime 객체로 변환
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime departTime = LocalDateTime.parse(sday, formatter);
		
		// 2.2 현재 시간과의 차이 계산
		LocalDateTime now = LocalDateTime.now();
		long diffMinutes = ChronoUnit.MINUTES.between(now, departTime);
		
		// 3. 취소 수수료 결정
		int cancelPrice;
		if (diffMinutes >= 2 * 24 * 60) {
			cancelPrice = 0;
		} else if (diffMinutes >= 24 * 60) {
			cancelPrice = (realPrice/100) * 5;
		} else if (diffMinutes >= 60) {
			cancelPrice = (realPrice/100) * 10;
		} else {
			cancelPrice = (realPrice/100) * 30;
		}
		
		if (!bi.getPd_payment().equals("페이머니")) { // 4. 예매 취소 처리 결제방식이 페이머니가 아닌경우
		    sql = "update t_reservation_info set ri_status = '예매취소' where mi_id= '" + mi_id + "' and ri_idx = '" + ri_idx + "' " ;
		    result += jdbc.update(sql);
		    // System.out.println(sql);
		    
		    sql = "update t_payment_detail set pd_real_price = '" + cancelPrice + "' where mi_id= '" + mi_id + "' and ri_idx = '" + ri_idx + "' " ;
		    result += jdbc.update(sql);
		    
		    sql = "update t_count_rinfo set cr_pay = '" + cancelPrice + "' where ri_idx = '" + ri_idx + "' " ;
		    result += jdbc.update(sql);
		    
		    sql = "delete from t_reservation_detail where ri_idx = '" + ri_idx + "' ";
		    result += jdbc.update(sql);     
		} else { // 5. 예매 취소 처리 결제방식이 페이머니인 경우
			sql = "update t_reservation_info set ri_status = '예매취소' where mi_id= '" + mi_id + "' and ri_idx = '" + ri_idx + "' " ;
			result += jdbc.update(sql);
			// System.out.println(sql);
		
			sql = "update t_payment_detail set pd_real_price = '" + cancelPrice + "' where mi_id= '" + mi_id + "' and ri_idx = '" + ri_idx + "' " ;
		    result += jdbc.update(sql);
			
			sql = "update t_member_info set mi_pmoney = '" + (bi.getMi_pmoney() + (bi.getPd_total_price() - cancelPrice)) + "' where mi_id= '" + mi_id + "' " ;
			result += jdbc.update(sql);
			
			sql = "update t_count_rinfo set cr_pmoney = '" + cancelPrice + "' where ri_idx = '" + ri_idx + "' " ;
			result += jdbc.update(sql);
			
			sql = "delete from t_reservation_detail where ri_idx = '" + ri_idx + "' ";
			result += jdbc.update(sql);     
		
		}
		return result;
	}
	
	
}
