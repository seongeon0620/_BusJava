package dao;

import java.util.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.sql.*;

import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;

import config.*;
import vo.*;

public class TicketingDao {
	private JdbcTemplate jdbc;

	public TicketingDao(DataSource dataSource) {
		 this.jdbc = new JdbcTemplate(dataSource);
	}

	public List<TerminalInfo> getTerminalList(String typeCode) {
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT B" + typeCode + "_CODE");
		sql.append(", B" + typeCode + "_NAME");
		sql.append(", B" + typeCode + "_AREA");
		sql.append(" FROM T_BUS_" + typeCode + "TERMINAL WHERE B" + typeCode + "_STATUS = 'Y'");
		System.out.println(sql.toString());
		List<TerminalInfo> terminalList = jdbc.query(sql.toString(), (ResultSet rs, int rowNum) -> {
			TerminalInfo ti = new TerminalInfo();
			ti.setBt_code(rs.getInt("b" + typeCode + "_code"));
			ti.setBt_name(rs.getString("b" + typeCode + "_name"));
			ti.setBt_area(rs.getString("b" + typeCode + "_area"));
			return ti;
		});
		
		return terminalList;
	}
	
	// 페이머니 충전내역에 insert
	public int chargePaymoneyIn(MemberInfo loginInfo, PaymoneyCharge pc) {
		String sql = "INSERT INTO T_PAYMONEY_HISTORY (MI_ID, PH_PAYMENT, PH_REAL_PRICE, PH_PMONEY) VALUES (?, ?, ?, ?)";
		return jdbc.update(sql, loginInfo.getMi_id(), pc.getPayment(), pc.getReal_price(), pc.getTotal_point());
	}
	
	// 회원정보 테이블의 회원의 페이머니 update
	public int chargePaymoneyUp(MemberInfo loginInfo, PaymoneyCharge pc) {
		String sql = "UPDATE T_MEMBER_INFO SET MI_PMONEY = MI_PMONEY + " + pc.getTotal_point() + " WHERE MI_ID = '" + loginInfo.getMi_id() + "'";
		
		// 세션에 담긴 회원의 페이머니 재설정
		loginInfo.setMi_pmoney(loginInfo.getMi_pmoney() + pc.getTotal_point());
		return jdbc.update(sql);
	}
	
	private String getReservationId() {
	// 예약번호를 만드는 메서드. 다른곳에서 쓰지 않으므로 private로 선언
		String ri_idx = "";
		LocalDate today = LocalDate.now();	// yyyy-mm-dd
		String td = (today + "").substring(2).replace("-", "");	// yymmdd
		
		String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		Random rnd = new Random();
		String eng = alpha.charAt(rnd.nextInt(26)) + "" + alpha.charAt(rnd.nextInt(26));
		
		String sql = "SELECT MAX(RIGHT(ri_idx, 4)) seq FROM T_RESERVATION_INFO WHERE LEFT(ri_idx, 6) = '" + td + "' ";
		
		Integer maxIdx = jdbc.queryForObject(sql, Integer.class);
		int nextIdx = (maxIdx != null) ? maxIdx + 1 : 1001; 
		
		ri_idx = td + eng + nextIdx;
		
		return ri_idx;
	}

	public String reservationIn(String mi_id, ReservationInfo ri) {
		String ri_idx = getReservationId();
		StringBuilder sql = new StringBuilder();
		sql.append("INSERT INTO T_RESERVATION_INFO (RI_IDX, MI_ID, RI_LINE_ID, RI_LINE_TYPE, RI_FR, RI_TO, RI_FRDATE, RI_TODATE, RI_ACNT, RI_SCNT, RI_CCNT, RI_COM, RI_LEVEL, RI_STATUS) VALUES (");
		sql.append("'" + ri_idx + "','" + mi_id + "','" + ri.getRi_line_id() + "', '" + ri.getRi_line_type());
		sql.append("', '" + ri.getRi_fr() + "', '" + ri.getRi_to() + "', '" + ri.getRi_frdate() + "', '" + ri.getRi_todate());
		sql.append("', " + ri.getRi_acnt() + ", " + ri.getRi_scnt() + ", " + ri.getRi_ccnt() + ", '" + ri.getRi_com());
		sql.append("', '" + ri.getRi_level() + "', '예매')");
		System.out.println(sql.toString());
		jdbc.update(sql.toString());
		
		return ri_idx;
	}

	public void reservationSeatIn(String ri_idx, List<String> seatArr) {
		for (String seat : seatArr) {
			String sql = "INSERT INTO T_RESERVATION_DETAIL (RI_IDX, RD_SEAT_NUM) VALUES ('" + ri_idx + "', '" + seat + "')";
			jdbc.update(sql);
		}
	}

	public void reservationPaymoneyUp(String mi_id, int realPrice) {
		String sql = "UPDATE T_MEMBER_INFO SET MI_PMONEY = MI_PMONEY - " + realPrice + " WHERE MI_ID = '" + mi_id + "'";
		jdbc.update(sql);
	}

	public void reservationPayIn(String ri_idx, String mi_id, ReservationInfo ri, int realPrice) {
	// 회원 결제내역 테이블 insert
		String sql = "INSERT INTO T_PAYMENT_DETAIL (RI_IDX, MI_ID, PD_PAYMENT, PD_TOTAL_PRICE, PD_TYPE, PD_REAL_PRICE) VALUES ('" +
				ri_idx + "', '" + mi_id + "', '"+ ri.getPayment() + "', " + ri.getTotalFee() + ", '" + ri.getCoupon_type() + "', " + realPrice + ")";
		jdbc.update(sql);
	}

	public void reservationCntIn(String ri_idx, ReservationInfo ri, int realPrice) {
		String sql;
		if (ri.getPayment().equals("페이머니")) {
			sql = "INSERT INTO T_COUNT_RINFO (RI_IDX, CR_PAYMENT, CR_PMONEY) VALUES ('" + ri_idx + "', '" + ri.getPayment() + "', " + realPrice + ")";
		} else {
			sql = "INSERT INTO T_COUNT_RINFO (RI_IDX, CR_PAYMENT, CR_PAY) VALUES ('" + ri_idx + "', '" + ri.getPayment() + "', " + realPrice + ")";
		}
		
		jdbc.update(sql);
	}

	// 사용자가 선택한 출발지 터미널에서 도착 가능한 도착지 터미널 리스트 리턴 
	public List<TerminalInfo> getTerminalList(String typeCode, String where) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT B" + typeCode + "_CODE");
		sql.append(", B" + typeCode + "_NAME");
		sql.append(", B" + typeCode + "_AREA");
		sql.append(" FROM T_BUS_" + typeCode + "TERMINAL " + where);
		System.out.println(sql.toString());
		
		List<TerminalInfo> terminalList = jdbc.query(sql.toString(), (ResultSet rs, int rowNum) -> {
			TerminalInfo ti = new TerminalInfo();
			ti.setBt_code(rs.getInt("B" + typeCode + "_CODE"));
			ti.setBt_name(rs.getString("B" + typeCode + "_NAME"));
			ti.setBt_area(rs.getString("B" + typeCode + "_AREA"));
			return ti;
		});
		
		return terminalList;
	}

	// 해당 시간표의 예약 완료 좌석을 리턴 
	public int getReservedSeat(String where) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT COUNT(*) FROM T_RESERVATION_DETAIL RD");
		sql.append(" JOIN T_RESERVATION_INFO RI ON RD.RI_IDX = RI.RI_IDX");
		sql.append(" WHERE " + where);
		return jdbc.queryForObject(sql.toString(), Integer.class);
	}

	public List<Integer> getSeatList(String where) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT RD_SEAT_NUM");
		sql.append(" FROM T_RESERVATION_INFO RI ");
		sql.append(" JOIN T_RESERVATION_DETAIL RD ON RI.RI_IDX = RD.RI_IDX " + where);
		
		List<Integer> seatList = jdbc.query(sql.toString(), (ResultSet rs, int rowNum) -> {
			int seat_num = 0;
			seat_num = rs.getInt("RD_SEAT_NUM");
			return seat_num;
		});
		return seatList;
	}

	// 스탬프 적립 히스토리 테이블에 인서트
	public void reservationStampIn(String ri_idx, String mi_id, int stampCnt) {
		StringBuilder sql = new StringBuilder();
		sql.append("INSERT INTO T_STAMP_HISTORY (MI_ID, RI_IDX, SH_SU, SH_CNT) VALUES (");
		sql.append("'" + mi_id + "', '" + ri_idx + "', 'S', " + stampCnt +")");
		jdbc.update(sql.toString());
	}
	
	// 회원정보 테이블에 스탬프 갯수 업데이트
	public void reservationStampUp(MemberInfo loginInfo, int stampCnt) {	
		String sql = "UPDATE T_MEMBER_INFO SET MI_STAMP = MI_STAMP + " + stampCnt + " WHERE MI_ID = '" + loginInfo.getMi_id() + "'";
		loginInfo.setMi_stamp(loginInfo.getMi_stamp() + stampCnt);
		jdbc.update(sql);
	}

	public String checkUserStamp(int maxStamp, String mi_id) {
		String sql = "SELECT IF(MI_STAMP >= " + maxStamp + ", 'Y', 'N') isOver FROM T_MEMBER_INFO WHERE MI_ID = '"+ mi_id + "'";
		return jdbc.queryForObject(sql, String.class);
	}

	// 스탬프가 30개 초과일 경우 멤버 쿠폰 테이블에  인서트
	public void reservationCouponIn(String mi_id) {
		String sql = "INSERT INTO T_MEMBER_COUPON (MI_ID) VALUES ('" + mi_id + "')";
		jdbc.update(sql.toString());
	}
	
	// 회원 쿠폰 발급 후 stamp 차감 히스토리 insert
	public void reservationStampIn(String ri_idx, int maxStamp, String mi_id) {
		String sql = "INSERT INTO T_STAMP_HISTORY (MI_ID, RI_IDX, SH_SU, SH_CNT) VALUES ('" + mi_id + "', '" + ri_idx + "', 'U', " + maxStamp + ")";
		jdbc.update(sql.toString());
	}	

	// 회원 테이블에 쿠폰 갯수 및 스탬프 갯수 업데이트
	public void reservationUserInfoUp(int maxStamp, MemberInfo loginInfo) {
		String sql = "UPDATE T_MEMBER_INFO SET MI_COUPON = MI_COUPON + 1, MI_STAMP = MI_STAMP - " + maxStamp + " WHERE MI_ID = '" + loginInfo.getMi_id() + "'";
		jdbc.update(sql.toString());
	}

	// 가장 최근 예매한 예매일시 리턴
	public LocalDateTime getRevervationDate(String mi_id) {
		String sql = "SELECT RI_DATE FROM T_RESERVATION_INFO WHERE MI_ID = '" + mi_id + "' ORDER BY RI_DATE DESC LIMIT 0, 1";
		return jdbc.queryForObject(sql, LocalDateTime.class);
	}

	public List<UserResourceInfo> getUserResource(String category, String mi_id) {
		String tableName = "";
		if (category.equals("C"))	tableName = "COUPON";
		else if (category.equals("S")) tableName = "STAMP";
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT IF("+ category + "H." + category + "H_SU = 'S', '적립', '사용') AS ACTION, " + category + "H." + category + "H_CNT AS CNT,");
		sql.append(" REPLACE(LEFT(" + category + "H." + category + "H_DATE, 16), '-', '.') DATE, RI.RI_FR, RI.RI_TO, RI.RI_LINE_TYPE");
		sql.append(" FROM T_"+ tableName + "_HISTORY " + category + "H");
		sql.append(" JOIN T_RESERVATION_INFO RI ON " + category + "H.RI_IDX = RI.RI_IDX");		
		sql.append(" WHERE " + category + "H.MI_ID = '" + mi_id + "'");
		sql.append(" ORDER BY " + category + "H." + category + "H_DATE DESC");
		System.out.println(sql.toString());
		
		List<UserResourceInfo> resourceList = jdbc.query(sql.toString(), (ResultSet rs, int rowNum) -> {
			UserResourceInfo uri = new UserResourceInfo();
			uri.setAction(rs.getString("ACTION"));
			uri.setCnt(rs.getInt("CNT"));
			uri.setDate(rs.getString("DATE"));
			uri.setRi_fr(rs.getString("RI_FR"));
			uri.setRi_to(rs.getString("RI_TO"));
			uri.setLine_type(rs.getString("RI_LINE_TYPE"));
			return uri;
		});
		return resourceList;
	}

	// 해당 회원의 쿠폰 목록을 List로 반환
	public List<UserResourceInfo> getUserCoupon(String mi_id) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT MC_IDX, REPLACE(LEFT(MC_DATE, 16), '-', '.') DATE");
		sql.append(" FROM T_MEMBER_COUPON");
		sql.append(" WHERE MI_ID = '" + mi_id + "'");
		sql.append(" ORDER BY MC_DATE DESC");
		
		List<UserResourceInfo> couponList = jdbc.query(sql.toString(), (ResultSet rs, int rowNum) -> {
			UserResourceInfo uri = new UserResourceInfo();
			uri.setDate(rs.getString("DATE"));
			uri.setCoupon_id(rs.getString("MC_IDX"));
			return uri;
		});
		return couponList;
	}

	// [예매] 쿠폰 사용시 쿠폰 삭제
	public void reservationCouponDel(String mi_id, int couponId) {
		String sql = "DELETE FROM T_MEMBER_COUPON WHERE MI_ID = ? AND MC_IDX = ?";
		jdbc.update(sql, mi_id, couponId);
	}

	// [예매] 해당 회원의 쿠폰 갯수 업데이트
	public void reservationCouponUp(String mi_id) {
		String sql = "UPDATE T_MEMBER_INFO SET MI_COUPON = MI_COUPON - 1 WHERE MI_ID = ?";
		jdbc.update(sql, mi_id);
	}

	// [예매] 쿠폰 사용, 적립시 쿠폰 내역 테이블에 인서트
	public void reservationCouponIn(String mi_id, String ri_idx, String suCode) {
		String sql = "INSERT INTO T_COUPON_HISTORY (MI_ID, RI_IDX, CH_SU, CH_CNT) VALUES (?, ?, ?, ?)";
		jdbc.update(sql, mi_id, ri_idx, suCode, 1);
	}

}

