package dao;

import java.sql.*;
import java.time.*;
import java.util.*;
import javax.sql.*;
import org.springframework.jdbc.core.*;
import vo.*;

public class SalesDao {
	private JdbcTemplate jdbc;
	
	public SalesDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public List<SalesInfo> getSalesList(String lineType, String terName, String fromDate, String toDate) {
	// 기본 일주일 매출목록 불러옴
		LocalDate nowDate = LocalDate.now();

		String sql = "SELECT RI.RI_LINE_TYPE, RI.RI_FR, RI.RI_TO, COUNT(RI.RI_LINE_ID) AS NUM_OF_TRIPS," +
		" SUM(CASE WHEN CR.CR_PAYMENT = '카드' THEN CR.CR_PAY ELSE 0 END) AS CARD_SALES," +
		" SUM(CASE WHEN CR.CR_PAYMENT = '무통장입금' THEN CR.CR_PAY ELSE 0 END) AS BANK_SALES," +
		" SUM(CASE WHEN CR.CR_PAYMENT = '간편결제' THEN CR.CR_PAY ELSE 0 END) AS MOBILE_SALES," +
		" SUM(CASE WHEN CR.CR_PAYMENT IN ('카드', '무통장입금', '간편결제') THEN CR.CR_PAY ELSE 0 END) AS TOTAL_SALES" +
		" FROM T_RESERVATION_INFO RI" +
		" JOIN T_COUNT_RINFO CR ON RI.RI_IDX = CR.RI_IDX" +
		" WHERE RI.RI_STATUS = '예매'"+ lineType + terName + "AND RI.RI_DATE BETWEEN ? AND ?" +
		" GROUP BY RI.RI_LINE_TYPE, RI.RI_FR, RI.RI_TO" +
		" ORDER BY TOTAL_SALES DESC";
		System.out.println(sql);
		List<SalesInfo> salesList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			SalesInfo sl = new SalesInfo();
			sl.setLineType(rs.getString("RI_LINE_TYPE"));
			sl.setFromName(rs.getString("RI_FR"));
			sl.setToName(rs.getString("RI_TO"));
			sl.setCount_schedule(rs.getInt("NUM_OF_TRIPS"));
			sl.setCardFee(rs.getInt("CARD_SALES"));
			sl.setBankFee(rs.getInt("BANK_SALES"));
			sl.setEasyFee(rs.getInt("MOBILE_SALES"));
			sl.setTotalFee(rs.getInt("TOTAL_SALES"));
			return sl;
		}, fromDate, toDate);
		
		return salesList;
		
	}
	
	public List<PaymoneyInfo> getPaymoneyList() {
		String sql = "select sum(CASE WHEN ph_payment = '카드' THEN ph_real_price ELSE 0 END) card_salse,"
			+ " sum(CASE WHEN ph_payment = '무통장입금' THEN ph_real_price ELSE 0 END) bank_salse, "
			+ " sum(CASE WHEN ph_payment = '간편결제' THEN ph_real_price ELSE 0 END) mobile_salse, left(ph_date, 7) wdate" +
			" from t_paymoney_history group by wdate";

		List<PaymoneyInfo> paymoneyList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			PaymoneyInfo pi = new PaymoneyInfo();
			pi.setCard_salse(rs.getInt("card_salse"));
			pi.setBank_salse(rs.getInt("bank_salse"));
			pi.setMobile_salse(rs.getInt("mobile_salse"));
			pi.setPh_date(rs.getString("wdate"));
			return pi;
		});
		return paymoneyList;
	}

	public List<TerminalInfo> getTerminalList() {
		String sql = "SELECT BH_NAME, BH_AREA FROM T_BUS_HTERMINAL WHERE BH_STATUS = 'Y'" +
		" UNION ALL SELECT BS_NAME, BS_AREA FROM T_BUS_STERMINAL WHERE BS_STATUS = 'Y'";
		List<TerminalInfo> terminalList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			TerminalInfo ti = new TerminalInfo();
			ti.setBh_name(rs.getString("BH_NAME"));
			ti.setBh_area(rs.getString("BH_AREA"));
			return ti;
		});
		
		return terminalList;
	}

	public List<TerminalInfo> getTerminalList(String whereH, String whereS) {
		String sql = "SELECT BH_NAME, BH_AREA FROM T_BUS_HTERMINAL WHERE BH_STATUS = 'Y'" + whereH +
		" UNION ALL SELECT BS_NAME, BS_AREA FROM T_BUS_STERMINAL WHERE BS_STATUS = 'Y'" + whereS;
		List<TerminalInfo> terminalList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			TerminalInfo ti = new TerminalInfo();
			ti.setBh_name(rs.getString("BH_NAME"));
			ti.setBh_area(rs.getString("BH_AREA"));
			return ti;
		});
		
		return terminalList;
	}
	
}
