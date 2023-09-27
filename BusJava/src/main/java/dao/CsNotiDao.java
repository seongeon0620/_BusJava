package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;

import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;

public class CsNotiDao {
	private JdbcTemplate jdbc;

	public CsNotiDao(DataSource dataSource) {
		this.jdbc = new JdbcTemplate(dataSource);
	}

	public int getNoticeListCount(String where) {
		// 검색조건에 맞는 공지사항 글 개수
		String sql = "select count(*) from t_notice_list" + where; // 중요 공지까지 포함한 전체 게시글 개수
//		System.out.println(sql);
		int rcnt = jdbc.queryForObject(sql, Integer.class);
		return rcnt;
	}

	public int getNoticeListNomalCnt(String where) {
		// 검색조건에 맞는 기본공지사항 글 개수
		String sql = "select count(*) from t_notice_list" + where + " and nl_accent = 'N'"; // 중요 공지 제외한 게시글 개수
//		System.out.println(sql);
		int nomalCnt = jdbc.queryForObject(sql, Integer.class);
		return nomalCnt;
	}

	public List<NoticeInfo> getANoticeList(String where, int cpage, int psize) {
		// 중요공지 리스트
		String sql = "select nl_idx, nl_title, nl_read, if(curdate() = date(nl_date), mid(nl_date, 11, 6), left(replace(nl_date, '-', '.'), 10)) wdate "
				+ "from t_notice_list " + where + " and nl_accent = 'Y' order by nl_idx desc limit 0, 5";
//		System.out.println(sql);
		int cnt = 30;
		List<NoticeInfo> aNoticeList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			NoticeInfo anl = new NoticeInfo();
			anl.setNl_idx(rs.getInt("nl_idx"));
			anl.setNl_date(rs.getString("wdate"));
			anl.setNl_read(rs.getInt("nl_read"));

			String title = rs.getString("nl_title").replaceAll("\"", "'");
			if (title.length() > cnt)
				title = title.substring(0, cnt - 3) + "...";
			anl.setNl_title(title);

			return anl;
		});
		return aNoticeList;
	}

	public List<NoticeInfo> getNoticeList(String where, int cpage, int psize) {
		// 공시사항 리스트
		String sql = "select nl_idx, nl_title, nl_read, if(left(nl_date, 10) = curdate(), mid(nl_date, 11, 6), left(replace(nl_date, '-', '.'), 10)) wdate "
				+ " from t_notice_list " + where + " and nl_accent = 'N' order by nl_idx desc limit "
				+ ((cpage - 1) * psize) + ", " + psize;
//		System.out.println(sql);
		int cnt = 45;
		List<NoticeInfo> noticeList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
			NoticeInfo nl = new NoticeInfo();
			nl.setNl_idx(rs.getInt("nl_idx"));
			nl.setNl_date(rs.getString("wdate"));
			nl.setNl_read(rs.getInt("nl_read"));

			String title = rs.getString("nl_title").replaceAll("\"", "'");
			if (title.length() > cnt)
				title = title.substring(0, cnt - 3) + "...";
			nl.setNl_title(title);

			return nl;
		});
		return noticeList;
	}

	public NoticeInfo getNoticeInfo(int nlidx) {
		// 공지사항 글보기 (조회수 증가, 글정보)
		String sql = "update t_notice_list set nl_read = nl_read + 1 where nl_isview = 'Y' and nl_idx = " + nlidx;
		jdbc.update(sql); // 조회수 증가

		sql = "select nl_idx, nl_title, nl_content, nl_read, nl_accent, replace(nl_date, '-', '.') wdate from t_notice_list "
				+ "where nl_isview = 'Y' and nl_idx=" + nlidx;
		NoticeInfo ni = jdbc.queryForObject(sql, new RowMapper<NoticeInfo>() {
			@Override
			public NoticeInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				NoticeInfo ni = new NoticeInfo();
				ni.setNl_idx(nlidx);
				ni.setNl_title(rs.getString("nl_title"));
				ni.setNl_content(rs.getString("nl_content").replaceAll("\r\n", "<br />"));
				ni.setNl_read(rs.getInt("nl_read"));
				ni.setNl_accent(rs.getString("nl_accent"));
				ni.setNl_date(rs.getString("wdate"));
				return ni;
			}
		});
		return ni;
	}

}