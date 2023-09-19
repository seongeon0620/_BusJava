package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import config.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class MemberDao {
	private JdbcTemplate jdbc;

	public MemberDao(DataSource dataSource) {
		 this.jdbc = new JdbcTemplate(dataSource);
	}
	
	public MemberInfo getLoginInfo(String mi_id, String mi_pw) {
		String sql = "select * from t_member_info where mi_id = ? and mi_pw = ? and mi_status != '탈퇴' ";

		List<MemberInfo> results = jdbc.query(sql, new RowMapper<MemberInfo>() {
			public MemberInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				MemberInfo mi = new MemberInfo();
				mi.setMi_id(rs.getString("mi_id"));
	            mi.setMi_pw(rs.getString("mi_pw"));
	            mi.setMi_name(rs.getString("mi_name"));
	            mi.setMi_gender(rs.getString("mi_gender"));
	            mi.setMi_phone(rs.getString("mi_phone"));
	            mi.setMi_email(rs.getString("mi_email"));
	            mi.setMi_status(rs.getString("mi_status"));
	            mi.setMi_date(rs.getString("mi_date"));
	            mi.setMi_lastlogin(rs.getString("mi_lastlogin"));
	            mi.setMi_pmoney(rs.getInt("mi_pmoney"));
	            mi.setMi_stamp(rs.getInt("mi_stamp"));
	            mi.setMi_coupon(rs.getInt("mi_coupon"));
	            mi.setMi_type(rs.getString("mi_type"));
	            return mi;
			}
		}, mi_id, mi_pw);
		// 쿼리에 직접 값을 넣으면 매개변수로 값을 추가할 필요 없음
		
		return results.isEmpty() ? null : results.get(0);
	}

	public int memberInsert(MemberInfo mi) {
		String sql = "insert into t_member_info (mi_id, mi_pw, mi_name, mi_gender, mi_phone, mi_email, mi_type) \r\n"
				+ " values ('" + mi.getMi_id() + "', '" + mi.getMi_pw() + "', '" + mi.getMi_name() + "', '" + mi.getMi_gender() + "', "
						+ " '" + mi.getMi_phone() + "', '" + mi.getMi_email() + "', '" + mi.getMi_type() + "') "; 
		int result = jdbc.update(sql);
		
		System.out.println(sql);
		
		return result;
	}

	public int chkDupId(String mi_id) {
		String sql = "select count(*) from t_member_info where mi_id = '" + mi_id + "' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	}
	
	public int chkDupMail(String mi_email) {
		String sql = "select count(*) from t_member_info where mi_email = '" + mi_email + "' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	}
	
	public int chkDupPhone(String mi_phone) {
		String sql = "select count(*) from t_member_info where mi_phone = '" + mi_phone + "' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	} 

	public int chkDupIdMail(String mi_id, String mi_email) {
		String sql = "select count(*) from t_member_info where mi_id = '" + mi_id + "' and mi_email= '" + mi_email + "' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	}

	public String passDupMail(String email) {
		String sql = "select mi_id from t_member_info where mi_email = '" + email + "'";
		String mi_id = jdbc.queryForObject(sql, String.class);
		return mi_id;
	}

	public int passDupIdMail(String mi_id, String email, String newPw) {
		String sql = "update t_member_info set mi_pw = '" + newPw + "' where mi_id = '" + mi_id + "' and mi_email = '" + email + "' ";
		int resultUp = jdbc.update(sql);
		return resultUp;
	}

	public int memberPwChk(String mi_id, String mi_pw) {
		String sql = "select count(*) from t_member_info where mi_id = '" + mi_id + "' and mi_pw= '" + mi_pw + "' ";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	}

	public int memberUpPw(String mi_id, String mi_pw) {
		String sql = "update t_member_info set mi_pw = '" + mi_pw + "' where mi_id = '" + mi_id + "' ";
		int result = jdbc.update(sql);
		return result;
	}

	public int memberUpMail(String mi_id, String mi_email) {
		String sql = "update t_member_info set mi_email = '" + mi_email + "' where mi_id = '" + mi_id + "' ";
		int result = jdbc.update(sql);
		return result;
	}

	public int memberUpPhone(String mi_id, String mi_phone) {
		String sql = "update t_member_info set mi_phone = '" + mi_phone + "' where mi_id = '" + mi_id + "' ";
		int result = jdbc.update(sql);
		return result;
	}

	public int memberDel(String mi_id, String mi_pw) {
		String sql = "update t_member_info set mi_status = '탈퇴' where mi_id = '" + mi_id + "' and mi_pw = '" + mi_pw + "' ";
		int result = jdbc.update(sql);
		return result;
	}

	public List<BookInfo> getBookList(String mi_id, int cpage, int psize) { // basic 부분
		String sql = " select ri_idx, ri_line_type, ri_fr, ri_to, ri_status, "
				+ " replace(substring(ri_frdate, 1 , 10), '-', '.') ri_frdate, substring(ri_frdate, 11, 6) ri_frtime, "
				+ " ri_acnt, ri_scnt, ri_ccnt "
				+ " from t_reservation_info "
				+ " where mi_id = '" + mi_id + "' and ri_date >= date_sub(now(), interval 3 month) "
				+ " group by ri_idx, ri_line_type, ri_fr, ri_to, ri_frdate, ri_status, ri_frtime "
				+ " order by ri_date desc limit " + ((cpage - 1) * psize) + ", " + psize;
		/* System.out.println(sql); */
		List<BookInfo> bookList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {  
			BookInfo  bi = new BookInfo(
					rs.getString("ri_idx"),
					rs.getString("ri_line_type"),
					rs.getString("ri_fr"),
					rs.getString("ri_to"),
					rs.getString("ri_frdate"),
					rs.getString("ri_status"),
					rs.getString("ri_frtime"),
					rs.getInt("ri_acnt"),
					rs.getInt("ri_scnt"),
					rs.getInt("ri_ccnt"),
					getBusSeatList(rs.getString("ri_idx")));
			return bi;
		});
		return bookList;
	}
	
	public List<BusSeatList> getBusSeatList(String ri_idx) {
        String sql = "select rd_seat_num from t_reservation_detail where ri_idx = '" + ri_idx + "' ";
        /* System.out.println(sql); */
        List<BusSeatList> busSeatList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
            BusSeatList bs = new BusSeatList(rs.getString("rd_seat_num"));
            return bs;
        });
        return busSeatList;
    }
	
	public int getbookListCount(String mi_id) {
		String sql = "select count(*) from t_reservation_info where mi_id = '" + mi_id + "' ";
		/* System.out.println(sql); */
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public BookInfo getBookInfo(String riidx) { // detail 부분
		String sql = " select ri.ri_idx, ri.ri_line_type, ri.ri_fr, ri.ri_to, ri.ri_status, ri.ri_acnt, ri.ri_scnt, ri.ri_ccnt, ri.ri_com, ri.ri_level, "
				+ " replace(substring(ri.ri_frdate, 1 , 10), '-', '.') ri_frdate, substring(ri.ri_frdate, 11, 6) ri_frtime, "
				+ " replace(substring(ri.ri_todate, 1 , 10), '-', '.') ri_todate, substring(ri.ri_todate, 11, 6) ri_totime, "
				+ " pd.pd_payment, pd.pd_real_price, pd.pd_date, pd_total_price "
				+ " from t_reservation_info ri, t_payment_detail pd "
				+ " where ri.ri_idx = pd.ri_idx and ri.ri_idx = '"+ riidx +"' and ri.ri_date >= DATE_SUB(NOW(), INTERVAL 3 MONTH) "
				+ " GROUP BY ri.ri_idx, ri.ri_line_type, ri.ri_fr, ri.ri_to, ri.ri_frdate, ri_todate, ri.ri_status, ri_frtime, "
				+ " ri_totime, pd.pd_payment, pd.pd_real_price, pd.pd_date, pd_total_price "
				+ " order by ri.ri_idx desc ";
		//System.out.println(sql);
		BookInfo bi = jdbc.queryForObject(sql, new RowMapper<BookInfo>() {
			@Override
			public BookInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				BookInfo bi = new BookInfo(
				rs.getInt("ri_acnt"),
				rs.getInt("ri_scnt"),
				rs.getInt("ri_ccnt"),
				rs.getString("ri_status"),
				rs.getString("ri_idx"),
				rs.getString("ri_line_type"),
				rs.getString("ri_fr"),
				rs.getString("ri_to"),
				rs.getString("ri_frdate"),
				rs.getString("ri_todate"),
				rs.getString("ri_com"),
				rs.getString("ri_level"),
				rs.getString("ri_frtime"),
				rs.getString("ri_totime"),
				rs.getString("pd_payment"),
				rs.getString("pd_date"),
				rs.getInt("pd_real_price"),
				rs.getInt("pd_total_price"),
				getBusSeatList(rs.getString("ri_idx")));
	            return bi;
			}
		});
		
		return bi;
	}
	

	public int getrealCancel(String riidx, String mi_id) { // 취소 및 환불 처리 부분
		String sday="";
		int result = 0;
		String sql = " select DISTINCT substring(ri.ri_frdate, 1 , 16) ri_frdate, pd.pd_real_price, pd.pd_total_price, pd.pd_payment, "
				+ " mi.mi_pmoney, cr.cr_pmoney, cr.cr_pay, cr_coupon " 
				+ " from t_reservation_info ri, t_payment_detail pd, t_member_info mi, t_count_rinfo cr "
				+  "where ri.ri_idx = pd.ri_idx and ri.ri_idx = cr.ri_idx and ri.mi_id = mi.mi_id and ri.mi_id='" + mi_id + "' and ri.ri_idx='" + riidx + "' ";
		// ri_frdate, pd_real_price, pd_total_price, pd_payment, mi_pmoney, cr_pmoney, cr_pay
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
			rs.getInt("cr_pay"),
			rs.getInt("cr_coupon"));
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
	        sql = "update t_reservation_info set ri_status = '예매취소' where mi_id= '" + mi_id + "' and ri_idx = '" + riidx + "' " ;
	        result += jdbc.update(sql);
	        // System.out.println(sql);
	        
	        sql = "update t_payment_detail set pd_real_price = '" + cancelPrice + "' where mi_id= '" + mi_id + "' and ri_idx = '" + riidx + "' " ;
	        result += jdbc.update(sql);
	        
	        sql = "update t_count_rinfo set cr_pay = '" + cancelPrice + "' where ri_idx = '" + riidx + "' " ;
	        result += jdbc.update(sql);
	        
	        sql = "delete from t_reservation_detail where ri_idx = '" + riidx + "' ";
	        result += jdbc.update(sql);  
	        
	        sql = "update t_member_info set mi_stamp = mi_stamp - 1 where mi_id = '" + mi_id + "' ";
	        result += jdbc.update(sql); 
	        
	        if (bi.getCr_coupon() > 0) {
	        	sql = "update t_member_info set mi_coupon = mi_coupon + 1 where mi_id = '" + mi_id + "' ";
		        result += jdbc.update(sql); 
	        }
        } else { // 5. 예매 취소 처리 결제방식이 페이머니인 경우
        	
        	sql = "update t_reservation_info set ri_status = '예매취소' where mi_id= '" + mi_id + "' and ri_idx = '" + riidx + "' " ;
        	result += jdbc.update(sql);
        	// System.out.println(sql);

        	sql = "update t_payment_detail set pd_real_price = '" + cancelPrice + "' where mi_id= '" + mi_id + "' and ri_idx = '" + riidx + "' " ;
	        result += jdbc.update(sql);
        	
        	sql = "update t_member_info set mi_pmoney = '" + (bi.getMi_pmoney() + (bi.getPd_total_price() - cancelPrice)) + "' where mi_id= '" + mi_id + "' " ;
        	result += jdbc.update(sql);
        	
        	sql = "update t_count_rinfo set cr_pmoney = '" + cancelPrice + "' where ri_idx = '" + riidx + "' " ;
        	result += jdbc.update(sql);
        	
        	sql = "delete from t_reservation_detail where ri_idx = '" + riidx + "' ";
        	result += jdbc.update(sql);     
        	
        	sql = "delete from t_reservation_detail where ri_idx = '" + riidx + "' ";
        	result += jdbc.update(sql);     

        }
        
        return result;
	}
	
	
	public List<paymoneyInfo> getpaymoneyList(String mi_id) { // 페이머니 사용
		String sql = "select pd.pd_real_price, pd.pd_date, ri.ri_fr, ri.ri_to, ri.ri_line_type "
				+ " from t_payment_detail pd, t_member_info mi, t_reservation_info ri "
				+ " where pd.mi_id = mi.mi_id and pd.ri_idx = ri.ri_idx "
				+ " and mi.mi_id = '" + mi_id + "' "
				+ " and pd_payment = '페이머니' "
				+ " AND pd.pd_date >= DATE_SUB(NOW(), INTERVAL 3 MONTH) "
				+ " order by pd.pd_date desc;";
		List<paymoneyInfo> pList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
				paymoneyInfo pi = new paymoneyInfo(
				rs.getString("ri_fr"),
				rs.getString("ri_to"),
				rs.getString("ri_line_type"),
				rs.getString("pd_date"),
				rs.getInt("pd_real_price"));
	            return pi;
			});
		return pList;
	}
 
	public List<paymoneyInfo> getmphList(String mi_id) { // 페이머니 충전
		String sql = " select ph_real_price, ph_pmoney, ph_date "
				+ " from t_paymoney_history where mi_id = '" + mi_id + "' AND ph_date >= DATE_SUB(NOW(), INTERVAL 3 MONTH) order by ph_date desc ";
		List<paymoneyInfo> mphList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
				paymoneyInfo pi = new paymoneyInfo(
				rs.getString("ph_date"),
				rs.getInt("ph_real_price"),
				rs.getInt("ph_pmoney"));
	            return pi;
			});
		return mphList;
	}
	
	
}















