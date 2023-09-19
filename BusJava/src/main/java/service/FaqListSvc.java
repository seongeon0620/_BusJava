package service;

import java.util.*;
import dao.*;
import vo.*;


public class FaqListSvc {
	private FaqListDao faqListDao;

	public void setFaqListDao(FaqListDao faqListDao) {
		this.faqListDao = faqListDao;
	}

	public List<FaqInfo> getfaqList(String where) {
		List<FaqInfo> faqList = faqListDao.getfaqList(where);
		return faqList;
	}
	
	
}
