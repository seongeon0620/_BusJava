package service;

import java.util.*;

import dao.*;
import vo.*;

public class CsNotiSvc {
   private CsNotiDao csNotiDao;

   public void setCsNotiDao(CsNotiDao csNotiDao) {
      this.csNotiDao = csNotiDao;
   }

	public int getNoticeListCount(String where) {
	// 검색조건에 맞는 공지사항 글 개수
		int rcnt = csNotiDao.getNoticeListCount(where);
		return rcnt;
	}

	public List<NoticeInfo> getANoticeList(String where, int cpage, int psize) {
	// 중요공지 리스트
		List<NoticeInfo> aNoticeList = csNotiDao.getANoticeList(where, cpage, psize);
		return aNoticeList;
	}

	public List<NoticeInfo> getNoticeList(String where, int cpage, int psize) {
	// 공지사항 리스트
		List<NoticeInfo> noticeList = csNotiDao.getNoticeList(where, cpage, psize);
		return noticeList;
	}

	public NoticeInfo getNoticeInfo(int nlidx) {
	// 공지사항 글보기
		NoticeInfo ni = csNotiDao.getNoticeInfo(nlidx);
		return ni;
	}

}