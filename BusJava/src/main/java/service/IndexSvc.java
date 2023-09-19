package service;

import java.util.*;
import dao.*;
import vo.*;

public class IndexSvc {
	private IndexDao indexDao;

	public void setIndexDao(IndexDao indexDao) {
		this.indexDao = indexDao;
	}

	public List<BannerInfo> getbannerList() {
		List<BannerInfo> bi = indexDao.getbannerList();
		return bi;
	}

	public List<ReservationInfo> getRecentReservation(String mi_id) {
		return indexDao.getRecentReservation(mi_id);
	}
	
}
