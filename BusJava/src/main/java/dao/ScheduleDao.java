package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import config.*;
import org.apache.tomcat.jdbc.pool.DataSource.*;
import org.json.simple.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

public class ScheduleDao {
	private JdbcTemplate jdbc;

	public ScheduleDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	// 해당 시간표의 예약 완료 좌석을 리턴 
	public int getReservedSeat(String where) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT COUNT(*) FROM T_RESERVATION_DETAIL RD");
		sql.append(" JOIN T_RESERVATION_INFO RI ON RD.RI_IDX = RI.RI_IDX");
		sql.append(" WHERE " + where);
		int reserved_seat = jdbc.queryForObject(sql.toString(), Integer.class);
		return reserved_seat;
	}
	
	public List<TerminalInfo> getDepartureTerminal(String selectedArea) {
	// 선택한 출발 지역에 있는 고속버스 터미널 리스트를 반환하는 메서드
		String sql = "select bh_code, bh_name, bh_area from t_bus_hterminal where bh_status = 'Y' and bh_area = '" + selectedArea + "' ";
//		System.out.println(sql);
		List<TerminalInfo> departureTerminal = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			TerminalInfo ti = new TerminalInfo();
			ti.setBt_code(rs.getInt("bh_code"));	// bh_code는 String이므로 bt_code사용 시 100보다 작은 code앞에 '0'붙여서 사용
			ti.setBt_name(rs.getString("bh_name"));
			ti.setBt_area(rs.getString("bh_area"));
			return ti;
		});
		return departureTerminal;
	}

	public List<TerminalInfo> getArrTerminal(String departureTCode, JSONArray linList) {
	// 출발 터미널 코드와 JSONArray linList로 도착터미널을 특정 짓는 메서드
		JSONObject jo = new JSONObject();
		String arrTCode = "";
		String sql = "";
		List<TerminalInfo> arrTerminal = new ArrayList<>(); // 리스트 초기화 추가
		for(int i = 0 ; i < linList.size() ; i++) {
			jo = (JSONObject)linList.get(i);
			if (jo.get("LIN_COD").toString().substring(0, 3).equals(departureTCode)) {
				arrTCode = jo.get("LIN_COD").toString().substring(3);
				
				sql = "select count(*) from t_bus_hterminal where bh_status = 'Y' and bh_code = '" + arrTCode + "' ";	// db터미널 목록에 터미널이 존재하는지 확인
				int result = jdbc.queryForObject(sql, Integer.class);
				
				if (result == 1) {
					sql = "select bh_code, bh_name from t_bus_hterminal where bh_status = 'Y' and bh_code = '" + arrTCode + "' ";
//					System.out.println(sql);
					TerminalInfo ti = jdbc.queryForObject(sql, new RowMapper<TerminalInfo>() {
						@Override
						public TerminalInfo mapRow(ResultSet rs, int rowNum) throws SQLException {	
							TerminalInfo tmp = new TerminalInfo();
							tmp.setBt_code(rs.getInt("bh_code"));
							tmp.setBt_name(rs.getString("bh_name"));
							return tmp;
						}
					});
					arrTerminal.add(ti);
				}
			}
		}
		return arrTerminal;
	}

	public List<TerminalInfo> getAreaList(String kind) {
	// 지역명으로 찾기 버튼에 들어갈 지역명리스트를 반환하는 메서드
		String sql = "select distinct b" + kind + "_area from t_bus_" + kind + "terminal where b" + kind + "_area <> '제주특별자치도'";
		List<TerminalInfo> areaList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			TerminalInfo ti = new TerminalInfo();
			ti.setBt_area(rs.getString("b" + kind +"_area"));
			return ti;
		});
		return areaList;
	}

	public List<TerminalInfo> getTerminalList(String type, String val, int cpage, int psize) {
	// 받아온 지역명 또는 터미널명으로 해당 지역에 있는 터미널리스트를 반환하는 메서드
		List<TerminalInfo> terminalList = null;
		if (type.equals("area")) {	// 지역명 버튼을 클릭했을 때
			String sql = "select * from t_bus_sterminal where bs_area = '" + val +"' and bs_status = 'Y' union " + 
					" select * from t_bus_hterminal where bh_area = '" + val + "' and bh_status = 'Y' order by bs_name limit " + ((cpage - 1) * psize) + ", " + psize;
			terminalList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
				TerminalInfo ti = new TerminalInfo();
				String btaddr = "";
				if (rs.getString("bs_addr") != null && !rs.getString("bs_addr").equals("null"))	
					btaddr = rs.getString("bs_addr");
				ti.setBt_code(rs.getInt("bs_code"));
				ti.setBt_area(rs.getString("bs_area"));
				ti.setBt_name(rs.getString("bs_name"));
				ti.setBt_addr(btaddr);
				ti.setBt_lat(rs.getDouble("bs_lat"));
				ti.setBt_lon(rs.getDouble("bs_lon"));
				return ti;
			});			
		} else {	// 터미널명을 입력하여 검색했을 때
			String sql = "select * from t_bus_sterminal where bs_name like '%" + val +"%' and bs_status = 'Y' union " + 
					" select * from t_bus_hterminal where bh_name like '%" + val + "%' and bh_status = 'Y' ORDER BY bs_name limit " + ((cpage - 1) * psize) + ", " + psize;
			terminalList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
				TerminalInfo ti = new TerminalInfo();
				String btaddr = "";
				if (rs.getString("bs_addr") != null && !rs.getString("bs_addr").equals("null"))	
					btaddr = rs.getString("bs_addr");
				ti.setBt_code(rs.getInt("bs_code"));
				ti.setBt_area(rs.getString("bs_area"));
				ti.setBt_name(rs.getString("bs_name"));
				ti.setBt_addr(btaddr);
				ti.setBt_lat(rs.getDouble("bs_lat"));
				ti.setBt_lon(rs.getDouble("bs_lon"));
				return ti;
			});	
		}

		return terminalList;
	}

	public int getTerminalCnt(String schtype, String val) {
	// 검색된 터미널의 총 개수를 반환하는 메서드
		int result = 0;
		if (schtype.equals("area")) {	// 지역명 버튼을 클릭했을 때
			String sql = "select sum(cnt) from ("
					+ "select count(*) as CNT from t_bus_sterminal where bs_status = 'Y' and bs_area = '" + val + "' "
					+ "union all "
					+ "select count(*) as CNT from t_bus_hterminal where bh_status = 'Y' and bh_area = '" + val + "' "
					+ ") as s";
			result = jdbc.queryForObject(sql, Integer.class);
		} else {	// 터미널명을 입력하여 검색했을 때
			String sql = "select sum(cnt) from ("
					+ "select count(*) as CNT from t_bus_sterminal where bs_status = 'Y' and bs_name like '%" + val + "%' "
					+ "union all "
					+ "select count(*) as CNT from t_bus_hterminal where bh_status = 'Y' and bh_name like '%" + val + "%' "
					+ ") as s";
//			System.out.println(sql);
			result = jdbc.queryForObject(sql, Integer.class);
		}
//		System.out.println(result);
		return result;
	}

}
