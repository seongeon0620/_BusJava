package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import org.springframework.jdbc.core.*;
import vo.*;

public class TerminalDao {
	private JdbcTemplate jdbc;

	public TerminalDao(DataSource dataSource) {
		 this.jdbc = new JdbcTemplate(dataSource);
	}
	
	public List<TerminalInfo> getTerminalList(String kind, int cpage, int psize, String where) {
		String sql = "select * from t_bus_" + kind + "terminal " + where + " limit " + ((cpage - 1) * psize) + ", " + psize;

		List<TerminalInfo> terminalList = jdbc.query(sql, 
				(ResultSet rs, int rowNum) -> {
					TerminalInfo ti = new TerminalInfo();
					if (kind.equals("h")) {
						ti.setBh_code(rs.getString("bh_code"));
						ti.setBh_name(rs.getString("bh_name"));
						ti.setBh_area(rs.getString("bh_area"));
						ti.setBh_addr(rs.getString("bh_addr"));
						ti.setBh_status(rs.getString("bh_status"));
						ti.setBh_lat(rs.getDouble("bh_lat"));
						ti.setBh_lon(rs.getDouble("bh_lon"));
					} else {
						ti.setBh_code(rs.getString("bs_code"));
						ti.setBh_name(rs.getString("bs_name"));
						ti.setBh_area(rs.getString("bs_area"));
						ti.setBh_addr(rs.getString("bs_addr"));
						ti.setBh_status(rs.getString("bs_status"));
						ti.setBh_lat(rs.getDouble("bs_lat"));
						ti.setBh_lon(rs.getDouble("bs_lon"));
					}
					return ti;
				});
		return terminalList;
	}

	public List<TerminalInfo> getAreaList(String kind, String[] schctgr) {
		String sql = "select DISTINCT b" + kind + "_area from t_bus_" + kind + "terminal";
		List<TerminalInfo> arealList = jdbc.query(sql, 
				(ResultSet rs, int rowNum) -> {
					TerminalInfo ti = new TerminalInfo();
					if (kind.equals("h")) {
						ti.setBh_area(rs.getString("bh_area"));
						if (schctgr != null) {
							for (int i = 0; i < schctgr.length; i++) {
								if (schctgr[i].equals(rs.getString("bh_area"))) {
									ti.setBh_status("Y");
								}
							}
						}
					} else {
						ti.setBh_area(rs.getString("bs_area"));
						if (schctgr != null) {
							for (int i = 0; i < schctgr.length; i++) {
								if (schctgr[i].equals(rs.getString("bs_area"))) {
									ti.setBh_status("Y");
								}
							}
						}
					}
					return ti;
				});
		return arealList;
	}

	public int getTerminalListCount(String where, String kind) {
		String sql = "select count(*) from t_bus_" + kind + "terminal " + where;
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public int statusChange(String where, String kind, String status) {
		String sql = "update t_bus_"+kind+"terminal set b"+kind+"_status = '"+status+"' " + where;
		int result = jdbc.update(sql);
		return result;
	}
}
