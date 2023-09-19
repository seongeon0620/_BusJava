package service;

import java.util.*;
import dao.*;
import vo.*;

public class CsNoticeSvc {
	private CsNoticeDao csNoticeDao;

	public void setCsNoticeDao(CsNoticeDao csNoticeDao) {
		this.csNoticeDao = csNoticeDao;
	}

	public int insertNotice(NoticeInfo ni) {
	// 공지사항 등록
		int nlidx = csNoticeDao.insertNotice(ni);
		return nlidx;
	}

	public int accentCnt() {
	// 공지사항 중요 공지 개수 
		int result = csNoticeDao.accentCnt();
		return result;
	}
	
	public NoticeInfo getNoticeInfo(int nlidx) {
	// 공지사항 글보기
		NoticeInfo ni = csNoticeDao.getNoticeInfo(nlidx);
		return ni;
	}

	public int updateNotice(NoticeInfo ni, int idx) {
	// 공지사항 수정
		int nlidx = csNoticeDao.updateNotice(ni, idx);
		return nlidx;
	}

	public void updateNlisview(int nlidx) {
	// 공지사항 미게시로 수정 (한개)
		csNoticeDao.updateNlisview(nlidx);
	}

	public int getNoticeListCount(String where) {
	// 검색조건에 맞는 공지사항 글 개수
		int rcnt = csNoticeDao.getNoticeListCount(where);
		return rcnt;
	}

	public List<NoticeInfo> getANoticeList(String where, int cpage, int psize) {
	// 중요공지 리스트
		List<NoticeInfo> aNoticeList = csNoticeDao.getANoticeList(where, cpage, psize);
		return aNoticeList;
	}
	
	public List<NoticeInfo> getNoticeList(String where, int cpage, int psize) {
	// 공지사항 리스트
		List<NoticeInfo> noticeList = csNoticeDao.getNoticeList(where, cpage, psize);
		return noticeList;
	}

	public int updateNlisview(String[] nlidx) {
	// 공지사항 미게시로 수정 (여러개)
		int result = csNoticeDao.updateNlisview(nlidx);
		
		return result;
	}
}
