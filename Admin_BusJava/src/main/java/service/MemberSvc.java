package service;

import java.util.List;

import dao.*;
import vo.*;

public class MemberSvc {
	private MemberDao memberDao;

	public void setMemberDao(MemberDao memberDao) {
		this.memberDao = memberDao;
	}

	public List<MemberInfo> getmemberList(String where, int cpage, int psize) {
		List<MemberInfo> memberList = memberDao.getmemberList(where, cpage, psize);
		return memberList;
	}

	public int getmemberListCount(String where) {
		int rcnt = memberDao.getFreeListCount(where);
		return rcnt;
	}

	public List<MemberInfo> getmemberDetail(String mi_id) {
		List<MemberInfo> memDetailList = memberDao.getmemberDetail(mi_id);
		return memDetailList;
	}

	public int memberUpdate(String mi_id, String mi_status, int mi_pmoney) {
		int result = memberDao.memberUpdate(mi_id, mi_status, mi_pmoney);
		return result;
	}
	
}