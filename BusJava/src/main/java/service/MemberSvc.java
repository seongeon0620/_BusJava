package service;

import java.sql.SQLException;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import dao.*;
import vo.*;

public class MemberSvc {
	private MemberDao memberDao;
	
	public void setMemberDao(MemberDao memberDao) {
		this.memberDao = memberDao;
	}
	
	public MemberInfo getLoginInfo(String mi_id, String mi_pw) {
		MemberInfo mi = memberDao.getLoginInfo(mi_id, mi_pw);
		return mi;
	}
	
	public int memberInsert(MemberInfo mi) {
		int result = memberDao.memberInsert(mi);
		return result;
	}
	

	public int chkDupId(String uid) {
		int result = memberDao.chkDupId(uid);
		
		return result;
	}
	
	public int chkDupMail(String email) {
		int result = memberDao.chkDupMail(email);
		
		return result;
	}
	
	public int chkDupPhone(String phone) {
		int result = memberDao.chkDupPhone(phone);
		
		return result;
	}
	
	public int chkDupIdMail(String mi_id, String email) {
		int result = memberDao.chkDupIdMail(mi_id, email);
		
		return result;
	}

	public String passDupMail(String email) {
		String mi_id = memberDao.passDupMail(email);
		return mi_id;
	}

	public int passDupIdMail(String mi_id, String email, String newPw) {
		int resultUp = memberDao.passDupIdMail(mi_id, email, newPw);
		return resultUp;
	}

	public int memberPwChk(String mi_id, String mi_pw) {
		int result = memberDao.memberPwChk(mi_id, mi_pw);
		return result;
	}

	public int memberUpPw(String mi_id, String mi_pw) {
		int result = memberDao.memberUpPw(mi_id, mi_pw);
		return result;
	}

	public int memberUpMail(String mi_id, String mi_email) {
		int result = memberDao.memberUpMail(mi_id, mi_email);
		return result;
	}

	public int memberUpPhone(String mi_id, String mi_phone) {
		int result = memberDao.memberUpPhone(mi_id, mi_phone);
		return result;
	}

	public int memberDel(String mi_id, String mi_pw) {
		int result = memberDao.memberDel(mi_id, mi_pw);
		return result;
	}

	public List<BookInfo> getBookList(String mi_id,int cpage, int psize) {
		List<BookInfo> bookList = memberDao.getBookList(mi_id, cpage, psize);
		return bookList;
	}

	public int getbookListCount(String mi_id) {
		int rcnt = memberDao.getbookListCount(mi_id);
		return rcnt;
	}

	public BookInfo getBookInfo(String riidx) {
		BookInfo bi = memberDao.getBookInfo(riidx);
		return bi;
	}
	
	@Transactional(rollbackFor = SQLException.class) 
	public int getrealCancel(String riidx, String mi_id) {
		int result = memberDao.getrealCancel(riidx, mi_id);
		return result;
	}

	public List<paymoneyInfo> getpaymoneyList(String mi_id) {
		List<paymoneyInfo> pList = memberDao.getpaymoneyList(mi_id);
		return pList;
	}

	public List<paymoneyInfo> getmphList(String mi_id) {
		List<paymoneyInfo> mphList = memberDao.getmphList(mi_id);
		return mphList;
	}

}
