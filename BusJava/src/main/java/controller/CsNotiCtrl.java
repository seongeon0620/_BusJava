package controller;

import java.io.*;
import java.net.*;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;

import javax.servlet.http.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class CsNotiCtrl {
	private CsNotiSvc csNotiSvc;
	
	public void setCsNotiSvc(CsNotiSvc csNotiSvc) {
		this.csNotiSvc = csNotiSvc;
	}
	
	@GetMapping("/noticeList")
	public String noticeList(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 리스트
		request.setCharacterEncoding("utf-8");
		
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 5, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String where = " where nl_isview = 'Y' ";
		String args = "", schargs = "";
		
		if (schtype != null && keyword != null) {	// 검색 했을 때
			if (schtype.equals("title") || schtype.equals("content")) {
				where += " and nl_" + schtype + " like '%" + keyword + "%' ";
			} else if (schtype.equals("tc")) {
				where += " and (nl_title like '%" + keyword + "' or nl_content like '%" + keyword + "%') ";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword;
		} else {
			schtype = "";	keyword = "";
		}
		
		args = "&cpage=" + cpage + schargs;
		
		rcnt = csNotiSvc.getNoticeListCount(where);
		// 검색된 게시글의 총 개수로 게시글 일련번호 출력과 전체 페이지수 계산을 위한 값
		

		if (cpage == 1) { // 중요공지는 첫페이지에만 노출 
			List<NoticeInfo> aNoticeList = csNotiSvc.getANoticeList(where, cpage, psize);
			model.addAttribute("aNoticeList", aNoticeList); 
		} 
		List<NoticeInfo> noticeList = csNotiSvc.getNoticeList(where, cpage, psize);
		
		pcnt = rcnt / psize;	if (rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);			pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);	
		pi.setRcnt(rcnt);			pi.setSpage(spage);		pi.setNum(num);			
		pi.setSchtype(schtype);		pi.setArgs(args);		pi.setSchargs(schargs);	pi.setKeyword(keyword);
		
		String fullUrl = request.getRequestURI();
		
		model.addAttribute("pi", pi);
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("url", fullUrl);
		
		return "/cs/notice_list";
	}
	
	@GetMapping("/noticeView")
	public String noticeView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int nlidx = Integer.parseInt(request.getParameter("nlidx"));
		int cpage = 1;
		if (request.getParameter("cpage") != null) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String args = "?cpage=" + cpage;
		
		if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			args += "&schtype=" + schtype + "&keyword=" + keyword;
		}
		
		NoticeInfo ni = csNotiSvc.getNoticeInfo(nlidx);
		model.addAttribute("ni", ni);
		model.addAttribute("args", args);
		
		return "/cs/notice_view";
	}
	
}
