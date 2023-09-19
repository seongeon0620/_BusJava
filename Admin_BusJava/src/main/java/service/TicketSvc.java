package service;

import java.sql.SQLException;
import java.util.*;

import org.springframework.transaction.annotation.*;

import dao.*;
import vo.*;

public class TicketSvc {
	private TicketDao ticketDao;

	public void setTicketDao(TicketDao ticketDao) {
		this.ticketDao = ticketDao;
	}

	public int getTicketListCount(String where) {
		int rcnt = ticketDao.getTicketListCount(where);
		return rcnt;
	}

	public List<TicketInfo> getTicketList(String where, int cpage, int psize) {
		List<TicketInfo> ticketList = ticketDao.getTicketList(cpage, psize, where);
		return ticketList;
	}

	public List<String> getStartList() {
		List<String> startList = ticketDao.getStartList();
		return startList;
	}

	public List<String> getEndList(String start) {
		List<String> endList = ticketDao.getEndList(start);
		return endList;
	}

	public List<String> getEndList() {
		List<String> endList = ticketDao.getEndList();
		return endList;
	}

	public TicketInfo getTicketView(String ri_idx) {
		TicketInfo ti = ticketDao.getTicketView(ri_idx);
		return ti;
	}

	@Transactional(rollbackFor = SQLException.class)
	public int realCancel(String ri_idx, String mi_id) {
		int result = ticketDao.realCancel(ri_idx, mi_id);
		return result;
	}
}
