package controller;

import java.io.*;
import java.net.URLEncoder;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class TerminalCtrl {
	private TerminalSvc terminalSvc;
	
	public void setTerminalSvc(TerminalSvc terminalSvc) {
		this.terminalSvc = terminalSvc;
	}
	
	@GetMapping("/terminal")	// 고속버스 터미널관리 목록
	public String terminal(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		request.setCharacterEncoding("utf-8");
		String kind = request.getParameter("kind");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String[] schctgr = request.getParameterValues("schctgr");
		String status = request.getParameter("isview");
		String where = " where 1 = 1 ";
		String args = "", schargs = "";
		String column = "b" + kind;
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
					where += (i == 0 ? "" : " or ") + column +"_area = '" + schctgr[i] + "' ";
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
		if (status != null && !status.equals("")) {
			where += " and " + column + "_status = '" + status + "'";
			schargs = "&status=" + status;
		}
		
		if (schtype == null || keyword == null) {
			schtype = ""; keyword = "";
		} else if (!schtype.equals("") && !keyword.trim().equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			if (schtype.equals("all")) {
				where += " and (" + column + "_name" + " like '%" + keyword + "%' or " + column + "_addr" + " like '%" + keyword + "%')";
			} else {
				where += " and "+ column +"_" + schtype + " like '%" + keyword + "%'";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword;
		}
		args = "&cpage=" + cpage + schargs;
			
		rcnt = terminalSvc.getTerminalListCount(where, kind);
		List<TerminalInfo> areaList = terminalSvc.getAreaList(kind, schctgr);
		List<TerminalInfo> terminalList = terminalSvc.getTerminalList(kind, cpage, psize, where);
		
		pcnt = rcnt / psize;	if(rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);		pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);
		pi.setRcnt(rcnt);		pi.setSpage(spage);		pi.setNum(num);			pi.setSchtype(schtype);
		pi.setKeyword(keyword);	pi.setArgs(args);		pi.setSchargs(schargs); pi.setSchctgr2(schctgr);
		pi.setIsview(status);
		
		model.addAttribute("kind", kind);
		model.addAttribute("pi", pi);
		model.addAttribute("areaList", areaList);
		model.addAttribute("terminalList", terminalList);
		return "line/terminal";
	}
	
	@PostMapping("/statusChange")
	@ResponseBody
	public String statusChange(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String code = request.getParameter("code");
		String status = request.getParameter("status");
		String kind = request.getParameter("kind");
		String where = " where 1 = 1 ";
		if (code.indexOf(',') >= 0) {
			String[] arr = code.split(",");
			for (int i = 0; i < arr.length; i ++) {
				if (i == 0) where += " and (b" + kind + "_code = " + arr[i];
				else 		where += " or b"+ kind +"_code = " + arr[i];
			}
			where += ") ";
		} else {
			where += " and tl_idx = " + code;
		}
		
		int result = terminalSvc.statusChange(where, status, kind);
		
		return result + "";
	}
}
