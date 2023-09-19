package service;

import java.util.*;
import dao.*;
import vo.*;

public class BannerSvc {
	private BannerDao bannerDao;

	public void setBannerDao(BannerDao bannerDao) {
		this.bannerDao = bannerDao;
	}

	public int getBannerListCount(String where) {
		int rcnt = bannerDao.getBannerListCount(where);
		return rcnt;
	}

	public List<BannerInfo> getBannerList(String where, int cpage, int psize) {
		List<BannerInfo> bannerList = bannerDao.getBannerList(where, cpage, psize);
		return bannerList;
	}

	public int BisviewChange(String where, String isview) {
		int result = bannerDao.BisviewChange(where, isview);
		return result;
	}

	public BannerInfo getBannerView(int bl_idx) {
		BannerInfo bi = bannerDao.getBannerView(bl_idx);
		return bi;
	}

	public int bannerIn(BannerInfo bi, String kind) {
		int bl_idx = bannerDao.bannerIn(bi, kind);
		return bl_idx;
	}

	public int chkIsview() {
		int result = bannerDao.chkIsview();
		return result;
	}
	
	
}
