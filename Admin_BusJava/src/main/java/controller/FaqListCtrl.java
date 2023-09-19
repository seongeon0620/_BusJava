package controller;

import java.io.*;
import java.net.URLEncoder;
import java.util.*;
import javax.servlet.http.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.*;
import service.*;
import vo.*;

@Controller
public class FaqListCtrl {
private FaqListSvc faqListSvc;
	
	
	public void setFaqListSvc(FaqListSvc faqListSvc) {
	this.faqListSvc = faqListSvc;
}

	@GetMapping("/faqList")
	public String faqList(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String[] schctgr = request.getParameterValues("schctgr");
		String allChk = request.getParameter("all");

		if (allChk == null) allChk = "";
		System.out.println(allChk);
		String isview = request.getParameter("isview");
		String where = " where 1 = 1 ";
		String args = "", schargs = "";
		String ctgr = "";
		if (schctgr != null) {
			if (request.getParameter("cpage") != null) {
				ctgr = schctgr[0];
				schctgr = ctgr.split(":");
			}
			if (schctgr[0].equals("tt")) {
				schctgr = Arrays.copyOfRange(schctgr, 1, schctgr.length); 
				if (schctgr.length == 0) {		
					schctgr = null;
				}
			}
		}
		
		if (schctgr != null) {
			if (schctgr.length > 1 ) {
				where += " and (";
			} else {
				where += " and ";
			}
			for (int i = 0; i < schctgr.length; i++) {
				if (schctgr[i].equals("all")) {
					break;
				} else {
					where += (i == 0 ? "" : " or ") + "fl_ctgr = '" + schctgr[i] + "' ";
				}
			}
			if (schctgr.length > 1)
				where += ") ";
			String tmp = "";
			for (int i = 0; i < schctgr.length; i++) {
				tmp += (i == 0 ? "" : ":") + schctgr[i];
			}
			schargs = "&schctgr=" + tmp;
		}
		if (isview != null && !isview.equals("")) {
			where += " and fl_isview = '" + isview + "'";
			schargs = "&isview=" + isview;
		}
		
		if (schtype == null || keyword == null) {
			schtype = ""; keyword = "";
		} else if (!schtype.equals("") && !keyword.trim().equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			if (schtype.equals("tc")) {
				where += " and (fl_title" + " like '%" + keyword + "%' or fl_content" + " like '%" + keyword + "%')";
			} else {
				where += " and fl_" + schtype + " like '%" + keyword + "%'";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword;
		}
		args = "&cpage=" + cpage + schargs;
		
		rcnt = faqListSvc.getfaqListCount(where);
		List<FaqInfo> ctgrList = faqListSvc.getCtgrList();
		List<FaqInfo> faqList = faqListSvc.getfaqList(where, cpage, psize);
		//System.out.println(rcnt);
		pcnt = rcnt / psize;	if(rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);		pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);
		pi.setRcnt(rcnt);		pi.setSpage(spage);		pi.setNum(num);			pi.setSchtype(schtype);
		pi.setKeyword(keyword);	pi.setArgs(args);		pi.setSchargs(schargs); pi.setIsview(isview);
		
		String ctgrChk = Arrays.toString(schctgr);
		
		model.addAttribute("pi", pi);
		model.addAttribute("ctgrChk", ctgrChk);
		model.addAttribute("ctgrList", ctgrList);
		model.addAttribute("allChk", allChk);
		model.addAttribute("faqList", faqList);
		
		return "cs/faq_list";
	}
	
	@PostMapping("isviewChange")
	@ResponseBody
	public String isviewChange(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String isview = request.getParameter("isview");
		String flidx = request.getParameter("flidx");
		String where = " where 1 = 1 ";
		if (flidx.indexOf(',') >= 0) {
			String[] arr = flidx.split(",");
			for (int i = 0; i < arr.length; i ++) {
				if (i == 0) where += " and (fl_idx = " + arr[i];
				else 		where += " or fl_idx = " + arr[i];
			}
			where += ") ";
		} else {
			where += " and fl_idx = " + flidx;
		}
		
		int result = faqListSvc.isviewChange(where, isview);
		
		return result + "";
	}
	
	@GetMapping("faqView")
	public String faqView(Model model,HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int flidx = Integer.parseInt(request.getParameter("flidx"));
		int cpage = 1;
		if (request.getParameter("cpage") != null) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		//System.out.println("faqView " + cpage);
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
		FaqInfo fi = faqListSvc.getfaqInfo(flidx);
		fi.setFl_content(fi.getFl_content().replaceAll("\r\n", "<br />"));
		
		model.addAttribute("fi", fi);
		model.addAttribute("args", args);
		
		return "cs/faq_view";
	}
	
	@GetMapping("/faqForm")
	public String faqForm(Model model, HttpServletRequest request) throws Exception {
	// 공지사항 글등록
		request.setCharacterEncoding("utf-8");
		
		String kind = request.getParameter("kind");
		
		if (kind != null && kind.equals("up")) {
			int flidx = Integer.parseInt(request.getParameter("flidx"));
			FaqInfo fi = faqListSvc.getfaqInfo(flidx);
			model.addAttribute("fi", fi);
		}
		return "cs/faq_form";
	}
	
	
	@PostMapping("/faqProcUp")
	public String faqProcUp(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		int fl_idx = Integer.parseInt(request.getParameter("flidx"));
		//System.out.println(fl_idx);
		String fl_ctgr = request.getParameter("ctgr");
		System.out.println(fl_ctgr);
		String fl_title = request.getParameter("title");
		String fl_content = request.getParameter("content");
		String fl_isview = request.getParameter("isview");

		int result = faqListSvc.faqProcUp(fl_idx, fl_title, fl_content, fl_isview, fl_ctgr);
		
		  if (result != 1) { 
			  response.setContentType("text/html; charset=utf-8");
			  PrintWriter out = response.getWriter(); out.println("<script>");
			  out.println("alert('정보수정에 실패했습니다.');"); out.println("location.reload();");
			  out.println("</script>"); out.close(); 
		  }
		
		return "redirect:/faqList";
	}
	
	@PostMapping("/faqProcIn")
	public String faqFormIn(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		AdminInfo loginInfo = (AdminInfo)session.getAttribute("loginInfo");
		int ai_idx = loginInfo.getAi_idx();
		
		String fl_ctgr = request.getParameter("ctgr");
		String fl_title = request.getParameter("title");
		String fl_content = request.getParameter("content");
		String fl_isview = request.getParameter("isview");
		
		int result = faqListSvc.faqFormIn(ai_idx, fl_title, fl_content, fl_isview, fl_ctgr);
		
		if (result != 1) { 
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter(); out.println("<script>");
			out.println("alert('FAQ등록에 실패했습니다.');"); out.println("location.reload();");
			out.println("</script>"); out.close(); 
		}
		
		return "redirect:/faqList";
	}
	
	
}
