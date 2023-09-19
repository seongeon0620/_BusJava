package service;

import java.util.*;
import dao.*;
import vo.*;

public class TerminalSvc {
	private TerminalDao terminalDao;
	
	public void setTerminalDao(TerminalDao terminalDao) {
		this.terminalDao = terminalDao;
	}

	public List<TerminalInfo> getTerminalList(String kind, int cpage, int psize, String where) {
		List<TerminalInfo> terminalList = terminalDao.getTerminalList(kind, cpage, psize, where);
		return terminalList;
	}

	public List<TerminalInfo> getAreaList(String kind, String[] schctgr) {
		List<TerminalInfo> areaList = terminalDao.getAreaList(kind, schctgr);
		return areaList;
	}

	public int getTerminalListCount(String where, String kind) {
		int rcnt = terminalDao.getTerminalListCount(where, kind);
		return rcnt;
	}

	public int statusChange(String where, String status, String kind) {
		int result = terminalDao.statusChange(where, kind, status);
		return result;
	}
	
}
