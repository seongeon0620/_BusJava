package service;

import java.util.*;
import dao.*;
import vo.*;

public class LostSvc {
	private LostDao lostDao;

	public void setLostDao(LostDao lostDao) {
		this.lostDao = lostDao;
	}

	public int getLostListCount(String where) {
		int rcnt = lostDao.getLostListCount(where);
		return rcnt;
	}

	public List<LostInfo> getLostList(String where, int cpage, int psize) {
		List<LostInfo> lostList = lostDao.getLostList(where, cpage, psize);
		return lostList;
	}

	public int lostIn(LostInfo li, String kind) {
		int tl_idx = lostDao.lostIn(li, kind);
		return tl_idx;
	}

	public LostInfo getLostView(int ll_idx) {
		LostInfo li = lostDao.getLostView(ll_idx);
		return li;
	}

	public int lostDel(String where) {
		int result = lostDao.lostDel(where);
		return result;
	}

}
