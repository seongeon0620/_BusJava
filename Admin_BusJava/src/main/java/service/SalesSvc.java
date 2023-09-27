package service;

import java.util.*;

import com.fasterxml.jackson.core.JsonProcessingException;

import dao.*;
import vo.*;

public class SalesSvc {
	private SalesDao salesDao;

	public void setSalesDao(SalesDao salesDao) {
		this.salesDao = salesDao;
	}

	public List<SalesInfo> getSalesList(String lineType, String terName, String fromDate, String toDate) {
		if (lineType != null) {
			if (lineType.equals("high"))
				lineType = " AND RI.RI_LINE_TYPE = '고속' ";
			else if (lineType.equals("slow"))
				lineType = " AND RI.RI_LINE_TYPE = '시외' ";
			else if (lineType.equals("all"))
				lineType = "";
		} else
			lineType = "";

		if (terName != null) {
			terName = " AND RI.RI_FR = '" + terName + "'";
		} else
			terName = "";

		List<SalesInfo> salesList = salesDao.getSalesList(lineType, terName, fromDate, toDate);
		List<SalesInfo> tmpList = new ArrayList<>();
		for (SalesInfo si : salesList) {
			if (si.getCardFee() != 0)
				si.setCardRatio(Math.round(((double) si.getCardFee() / (double) si.getTotalFee() * 100.0) * 10) / 10.0);
			if (si.getBankFee() != 0)
				si.setBankRatio(Math.round(((double) si.getBankFee() / (double) si.getTotalFee() * 100.0) * 10) / 10.0);
			if (si.getEasyFee() != 0)
				si.setEasyRatio(Math.round(((double) si.getEasyFee() / (double) si.getTotalFee() * 100.0) * 10) / 10.0);
			tmpList.add(si);
		}
		salesList.addAll(tmpList);
		return salesList;
	}

	public List<PaymoneyInfo> getPaymoneyList() {
		List<PaymoneyInfo> paymoneyList = salesDao.getPaymoneyList();
		return paymoneyList;
	}

	public List<TerminalInfo> getTerminalList() {
		return salesDao.getTerminalList();
	}

	public List<TerminalInfo> getTerminalList(String keyword) {
		String whereH = " AND BH_NAME LIKE '" + keyword + "%'";
		String whereS = " AND BS_NAME LIKE '" + keyword + "%'";
		return salesDao.getTerminalList(whereH, whereS);
	}

	public String getTopCtgr() throws JsonProcessingException {
		return salesDao.getTopCtgr();
	}

	public List<String> getSales(int i) {
		return salesDao.getSales(i);
	}
}