package dao;

import java.sql.*;
import java.util.*;
import javax.sql.*;
import org.springframework.jdbc.core.*;
import vo.*;

public class CsNoticeDao {
	private JdbcTemplate jdbc;
	
	public CsNoticeDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public int insertNotice(NoticeInfo ni) {
	// 공지사항 등록
		String sql = "select ifnull(max(nl_idx), 0) + 1 from t_notice_list";
		int nlidx = jdbc.queryForObject(sql, Integer.class);
		
		sql = "insert into t_notice_list values(" + nlidx + ", " + ni.getAi_idx() + ", '" + ni.getNl_title() + "', '" + ni.getNl_content() + "', 0, '" + 
				ni.getNl_isview() + "', '" + ni.getNl_accent() + "', now())";
		jdbc.update(sql);
	
		return nlidx;
	}

	public int accentCnt() {
	// 공지사항 중요 공지 개수
		String sql = "select count(nl_idx) from t_notice_list where nl_accent = 'Y' and nl_isview = 'Y'";
		int result = jdbc.queryForObject(sql, Integer.class);
		return result;
	}
	
	public NoticeInfo getNoticeInfo(int nlidx) {
	// 공지사항 글보기
		String sql = "select * from t_notice_list where nl_idx=" + nlidx;
		NoticeInfo ni = jdbc.queryForObject(sql, new RowMapper<NoticeInfo>() {	
			@Override
			public NoticeInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				NoticeInfo ni = new NoticeInfo();
				ni.setNl_idx(nlidx);
				ni.setAi_idx(rs.getInt("ai_idx"));
				ni.setNl_title(rs.getString("nl_title"));
				ni.setNl_content(rs.getString("nl_content"));
				ni.setNl_read(rs.getInt("nl_read"));
				ni.setNl_isview(rs.getString("nl_isview"));
				ni.setNl_accent(rs.getString("nl_accent"));
				ni.setNl_date(rs.getString("nl_date"));
				return ni;
			}
		});
		return ni;
	}

	public int updateNotice(NoticeInfo ni, int idx) {
	// 공지사항 수정 (한개)
		String sql = "update t_notice_list set nl_title = '" + ni.getNl_title() + "', nl_content = '" + ni.getNl_content() + 
				"', nl_isview = '" + ni.getNl_isview() + "', nl_accent = '" + ni.getNl_accent() + "' where nl_idx = " + idx;
		jdbc.update(sql);
		return idx;
	}

	public void updateNlisview(int nlidx) {
	// 공지사항 미게시로 수정
		String sql = "update t_notice_list set nl_isview = 'N' where nl_idx = " + nlidx;
		jdbc.update(sql);
	}

	public int getNoticeListCount(String where) {
	// 검색조건에 맞는 공지사항 글 개수
		String sql = "select count(*) from t_notice_list" + where + " and nl_accent='N' ";
//		System.out.println(sql);
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public List<NoticeInfo> getANoticeList(String where, int cpage, int psize) {
	// 중요공지 리스트
		String sql = "select nl_idx, nl_title, nl_isview, if(left(nl_date, 10) = curdate(), mid(nl_date, 11, 6), left(replace(nl_date, '-', '.'), 10)) wdate " + 
				"from t_notice_list " + where + " and nl_accent = 'Y' order by nl_idx desc limit 0, 10";
//		System.out.println(sql);
		List<NoticeInfo> aNoticeList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			NoticeInfo anl = new NoticeInfo();
			anl.setNl_idx(rs.getInt("nl_idx"));
			anl.setNl_title(rs.getString("nl_title"));
			anl.setNl_date(rs.getString("wdate"));
			anl.setNl_isview(rs.getString("nl_isview"));
			
			return anl;
		}); 
		return aNoticeList;
	}
	
	public List<NoticeInfo> getNoticeList(String where, int cpage, int psize) {
	// 공지사항 리스트
		String sql = "select nl_idx, nl_title, nl_isview, if(left(nl_date, 10) = curdate(), mid(nl_date, 11, 6), left(replace(nl_date, '-', '.'), 10)) wdate " + 
				" from t_notice_list " + where + " and nl_accent = 'N' order by nl_idx desc limit " + ((cpage - 1) * psize) + ", " + psize;
//		System.out.println(sql);
		List<NoticeInfo> noticeList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			NoticeInfo nl = new NoticeInfo();
			nl.setNl_idx(rs.getInt("nl_idx"));
			nl.setNl_title(rs.getString("nl_title"));
			nl.setNl_date(rs.getString("wdate"));
			nl.setNl_isview(rs.getString("nl_isview"));
			
			return nl;
		}); 
		return noticeList;
	}

	public int updateNlisview(String[] nlidx) {
	// 공지사항 수정 (여러개)
		String sql = "";
		int result = 0;
		
		for (int i = 0 ; i < nlidx.length ; i++) {
			System.out.println(nlidx[i]);
			sql = "update t_notice_list set nl_isview = 'N' where nl_idx = " + nlidx[i];
			result += jdbc.update(sql);
		}
		
		return result;
	}
}
