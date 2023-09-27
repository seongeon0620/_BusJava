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
public class CsNoticeCtrl {
	private CsNoticeSvc csNoticeSvc;
	
	public void setCsNoticeSvc(CsNoticeSvc csNoticeSvc) {
		this.csNoticeSvc = csNoticeSvc;
	}
	
	@GetMapping("/noticeList")
	public String noticeList(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 리스트
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String isview = request.getParameter("isview");
		String where = " where 1 = 1 ";
		String args = "", schargs = "";
		
		if (schtype == null || keyword == null || isview == null) {
			schtype = "";	keyword = "";	isview = "";
		} else if (!schtype.equals("") && !keyword.trim().equals("")) {	// 검색조건에 뭐라도 있을 때 
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			if (!isview.equals("")) {	// 게시여부 조건을 선택했을 경우
				where += " and nl_isview='" + isview + "' ";
			}
			if (schtype.equals("tc")) {	// 검색조건이 '제목+내용'일 경우
				where += " and (nl_title like '%" + keyword + "%' or nl_content like '%" + keyword + "%') ";
			} else {
				where += " and nl_" + schtype + " like'%" + keyword + "%' ";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword + "&isview=" + isview;
		} else if (!isview.equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			where += " and nl_isview='" + isview + "' ";
		}
		args = "&cpage=" + cpage + schargs;
		
		rcnt = csNoticeSvc.getNoticeListCount(where);
		// 검색된 게시글의 총 개수로 게시글 일련번호 출력과 전체 페이지수 계산을 위한 값
		
		if (cpage == 1) {	// 중요공지는 첫페이지에만 노출
			List<NoticeInfo> aNoticeList = csNoticeSvc.getANoticeList(where, cpage, psize);
			model.addAttribute("aNoticeList", aNoticeList);
		}
		List<NoticeInfo> noticeList = csNoticeSvc.getNoticeList(where, cpage, psize); 
		
		pcnt = rcnt / psize;	if (rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);			pi.setCpage(cpage);			pi.setPcnt(pcnt);
		pi.setPsize(psize);			pi.setRcnt(rcnt);			pi.setSpage(spage);
		pi.setNum(num);				pi.setSchtype(schtype);		pi.setKeyword(keyword);
		pi.setIsview(isview);		pi.setArgs(args);			pi.setSchargs(schargs);
		
		String fullUrl = request.getRequestURI();
		
		model.addAttribute("pi", pi);
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("url", fullUrl);
		
		
		return "cs/notice_list";
	}
	
	@GetMapping("/noticeForm")
	public String noticeForm(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 글등록
		request.setCharacterEncoding("utf-8");
		
		String kind = request.getParameter("kind");
		
		if (kind != null && kind.equals("up")) {
			int nlidx = Integer.parseInt(request.getParameter("nlidx"));
			NoticeInfo ni = csNoticeSvc.getNoticeInfo(nlidx);
			model.addAttribute("ni", ni);
		}
		return "cs/notice_form";
	}
	
	@PostMapping("/noticeProcInUp")
	public String noticeProcInUp(HttpServletRequest request) throws Exception {
	// 공지사항 등록&수정	
		request.setCharacterEncoding("utf-8");
		String accent = request.getParameter("accent");
		String kind = request.getParameter("kind");
		int nlidx = 0;
		int cpage = 1;
		if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		HttpSession session = request.getSession();
		AdminInfo loginInfo = (AdminInfo)session.getAttribute("loginInfo");

		NoticeInfo ni = new NoticeInfo();
		ni.setAi_idx(loginInfo.getAi_idx());
		ni.setNl_accent(accent == null ? "N" : "Y");
		ni.setNl_title(request.getParameter("title").trim().replaceAll("[\"]", "&quot;"));
		ni.setNl_content(request.getParameter("content").trim());
		ni.setNl_isview(request.getParameter("isview"));
		
		if (kind.equals("up")) {	// 글 수정일 경우 nl_idx값 ni에 저장
			int idx = Integer.parseInt(request.getParameter("nlidx"));
			ni.setNl_idx(idx);
			nlidx = csNoticeSvc.updateNotice(ni, idx);
		} else {
			nlidx = csNoticeSvc.insertNotice(ni);
		}
		
		return "redirect:/noticeView?cpage=" + cpage + "&nlidx=" + nlidx;
	}
	
	@GetMapping("/accentCnt")
	@ResponseBody
	public String accentCnt() {
	// 중요공지 개수
		int result = csNoticeSvc.accentCnt();
		return result + "";
	}
	
	@GetMapping("/noticeView")
	public String noticeView(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 글 보기	
		request.setCharacterEncoding("utf-8");
		int nlidx = Integer.parseInt(request.getParameter("nlidx"));
		int cpage = 1;
		if (request.getParameter("cpage") != null) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String isview = request.getParameter("isview");
		String args = "?cpage=" + cpage;
		
		if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			args += "&schtype=" + schtype + "&keyword=" + keyword;
			if (isview != null && !isview.equals("")) {
				args += "&isview=" + isview;
			} 
		}
		
		NoticeInfo ni = csNoticeSvc.getNoticeInfo(nlidx);
		ni.setNl_content(ni.getNl_content().replaceAll("\r\n", "<br />"));
		
		model.addAttribute("ni", ni);
		model.addAttribute("args", args);
		return "cs/notice_view";
	}
	
	@GetMapping("/isviewChange")
	public String isviewChange(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 미게시로 수정 (한개)
		request.setCharacterEncoding("utf-8");
		int nlidx = Integer.parseInt(request.getParameter("nlidx"));
		
		csNoticeSvc.updateNlisview(nlidx);
		
		return "redirect:/noticeView?nlidx=" + nlidx;
	}
	
	@GetMapping("/isviewChangeIdxs")
	public String isviewChangeIdxs( HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String[] nlidx = request.getParameter("nlidx").split(",");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		int result = csNoticeSvc.updateNlisview(nlidx);
		
		if (result != nlidx.length) {
			out.println("<script>");
			out.println("alert('게시여부 미게시로 변경 실패했습니다.\n다시 시도해주세요.');");
			out.println("</script>");
		}
		
		return "redirect:/noticeList";
	}
}
