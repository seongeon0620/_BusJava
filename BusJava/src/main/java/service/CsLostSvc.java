package service;

import java.util.*;
import dao.*;
import vo.*;


public class CsLostSvc {
	private CsLostDao csLostDao;

	public void setCsLostDao(CsLostDao csLostDao) {
		this.csLostDao = csLostDao;
	}
   
	public int getLostListCount(String where) {
		int rcnt = csLostDao.getLostListCount(where);
		return rcnt;
	}

	public List<LostInfo> getLostList(String where, int cpage, int psize) {
		List<LostInfo> lostList = csLostDao.getLostList(where, cpage, psize);
		return lostList;
	}
	
	public LostInfo getLostInfo(int ll_idx) {
	// 공지사항 글보기
		LostInfo li = csLostDao.getLostInfo(ll_idx);
		return li;
	}
}
