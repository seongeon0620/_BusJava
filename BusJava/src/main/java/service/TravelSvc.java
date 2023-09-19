package service;

import java.util.*;
import dao.*;
import vo.*;

public class TravelSvc {
	private TravelDao travelDao;

	public void setTravelDao(TravelDao travelDao) {
		this.travelDao = travelDao;
	}

	public List<TravelInfo> getTravelList(String where) {
		List<TravelInfo> travelList = travelDao.getTravelList(where);
		return travelList;
	}

}
