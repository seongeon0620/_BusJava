package service;

import java.util.*;
import dao.*;
import vo.*;


public class FaqListSvc {
	private FaqListDao faqListDao;

	public void setFaqListDao(FaqListDao faqListDao) {
		this.faqListDao = faqListDao;
	}


	public int faqProcUp(int fl_idx, String fl_title, String fl_content, String fl_isview,String fl_ctgr) {
		int result = faqListDao.faqProcUp(fl_idx, fl_title, fl_content, fl_isview, fl_ctgr);
		return result;
	}

	public int faqFormIn(int ai_idx, String fl_title, String fl_content, String fl_isview, String fl_ctgr) {
		int result = faqListDao.faqFormIn(ai_idx, fl_title, fl_content, fl_isview, fl_ctgr);
		return result;
	}

	public int getfaqListCount(String where) {
		int rcnt = faqListDao.getfaqListCount(where);
		return rcnt;
	}

	public List<FaqInfo> getfaqList(String where, int cpage, int psize) {
		List<FaqInfo> faqList = faqListDao.getfaqList(where, cpage, psize);
		return faqList;
	}

	public List<FaqInfo> getCtgrList() {
		List<FaqInfo> ctgrList = faqListDao.getCtgrList();
		return ctgrList;
	}

	public int isviewChange(String where, String isview) {
		int result = faqListDao.isviewChange(where, isview);
		return result;
	}

	public FaqInfo getfaqInfo(int flidx) {
		FaqInfo fi = faqListDao.getfaqInfo(flidx);
		
		return fi;
	}

	
	
}
