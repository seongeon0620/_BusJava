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
public class CsLostCtrl {
	private CsLostSvc csLostSvc;
	
	public void setCsLostSvc(CsLostSvc csLostSvc) {
		this.csLostSvc = csLostSvc;
	}
	
	@GetMapping("/lostList")
	public String lostList(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 리스트
		request.setCharacterEncoding("utf-8");
		
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String sDate = request.getParameter("sDate");
		String eDate = request.getParameter("eDate");
		String where = " where ll_status = 'A' ";
		String args = "", schargs = "";
		
		if (schtype != null && keyword != null) {	// 검색 했을 때
			if (schtype.equals("title") || schtype.equals("tername")) {
				where += " and ll_" + schtype + " like '%" + keyword + "%' ";
			} else if (schtype.equals("all")) {
				if (!keyword.equals(""))
					where += " and (ll_title like '%" + keyword + "%' or ll_tername like '%" + keyword + "%' )";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword;
		} else {
			schtype = "";	keyword = "";
		}
		
		if (sDate != null) {
			if (!sDate.equals("")) {
				where += " and date(ll_getdate) >= '" + sDate.replace(".", "-") + "'";
			}
		} else {
			sDate = "";
		}
		if (eDate != null) {
			if (!eDate.equals("")) {
				where += " and date(ll_getdate) <= '" + eDate.replace(".", "-") + "'";
			}
		} else {
			eDate = "";
		}
		schargs += "&sDate=" + sDate + "&eDate=" + eDate;
	System.out.println(where);
		args = "&cpage=" + cpage + schargs;
		
		rcnt = csLostSvc.getLostListCount(where);
		// 검색된 게시글의 총 개수로 게시글 일련번호 출력과 전체 페이지수 계산을 위한 값
		
		List<LostInfo> lostList = csLostSvc.getLostList(where, cpage, psize);
		
		pcnt = rcnt / psize;	if (rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);			pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);	
		pi.setRcnt(rcnt);			pi.setSpage(spage);		pi.setNum(num);
		pi.setSchtype(schtype);		pi.setArgs(args);		pi.setSchargs(schargs);	pi.setKeyword(keyword);
		pi.setEdate(eDate);			pi.setSdate(sDate);
		
		model.addAttribute("pi", pi);
		model.addAttribute("lostList", lostList);
		
		return "/cs/lost_list";
	}
	
	@GetMapping("/lostView")
	public String lostView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int ll_idx = Integer.parseInt(request.getParameter("ll_idx"));
		int cpage = 1;
		if (request.getParameter("cpage") != null) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String sDate = request.getParameter("sDate");
		String eDate = request.getParameter("eDate");
		String args = "?cpage=" + cpage;
		
		if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			args += "&schtype=" + schtype + "&keyword=" + keyword;
		}
		if (sDate != null) {
			args += "&sDate=" + sDate;
		}
		if (eDate != null) {
			args += "&eDate=" + eDate;
		}
		
		LostInfo li = csLostSvc.getLostInfo(ll_idx);
		model.addAttribute("li", li);
		model.addAttribute("args", args);
		
		return "/cs/lost_view";
	}
}
