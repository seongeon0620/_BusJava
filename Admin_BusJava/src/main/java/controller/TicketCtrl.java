package controller;

import java.io.*;
import java.net.URLEncoder;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class TicketCtrl {
	TicketSvc ticketSvc;

	public void setTicketSvc(TicketSvc ticketSvc) {
		this.ticketSvc = ticketSvc;
	}

	@GetMapping("/ticketList")	// 예매관리 목록
	public ModelAndView ticketList(HttpServletRequest request, Model model) throws Exception {
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		if (request.getParameter("cpage") != null) cpage = Integer.parseInt(request.getParameter("cpage"));
		String linetype = request.getParameter("linetype");
		String start = request.getParameter("start");
		String end = request.getParameter("end");
		String status = request.getParameter("status");
		String date = request.getParameter("date");
		String where = " where 1 = 1";
		String args = ""; // 쿼리스트링 전체 통합(페이징+검색내용) 변수
		String schargs = ""; // 검색내용을 담을 쿼리스트링 변수
		
		if (linetype != null && !linetype.equals("")) {
			URLEncoder.encode(linetype, "UTF-8");
			where += " and ri_line_type = '" + linetype + "' ";
		} else { 
			linetype = "";
		}
		if (start != null && !start.equals("")) {
			URLEncoder.encode(linetype, "UTF-8");
			where += " and ri_fr = '" + start + "' ";
		} else { 
			start = "";
		}
		if (end != null && !end.equals("")) {
			URLEncoder.encode(end, "UTF-8");
			where += " and ri_to = '" + end + "' ";
		} else { 
			end = "";
		}
		if (status != null && !status.equals("")) {
			URLEncoder.encode(status, "UTF-8");
			where += " and ri_status = '" + status + "' ";
		} else { 
			status = "";
		}
		if (date != null && !date.equals("")) {
			where += " and date(ri_frdate) = '" + date.replace(".", "-") + "' ";
		} else { 
			date = "";
		}
		schargs += "&linetype=" + linetype + "&start=" + start + "&end=" + end + "&status=" + status + "&date=" + date;
		args = "&cpage=" + cpage + schargs;
		
		rcnt = ticketSvc.getTicketListCount(where);
		List<TicketInfo> ticketList = ticketSvc.getTicketList(where, cpage, psize);
		List<String> startList = ticketSvc.getStartList();
		List<String> endList = ticketSvc.getEndList();
		
		pcnt = rcnt / psize;	if(rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);		pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);
		pi.setRcnt(rcnt);		pi.setSpage(spage);		pi.setNum(num);			pi.setIsview(status);
		pi.setKeyword(linetype);pi.setArgs(args);		pi.setSchargs(schargs); pi.setStart(start);
		pi.setEnd(end);			pi.setDate(date);
		
		String fullUri = request.getRequestURI();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("ticket/ticket_manage");
		mv.addObject("ticketList", ticketList);
		mv.addObject("startList", startList);
		mv.addObject("endList", endList);
		mv.addObject("pi", pi);
		mv.addObject("url", fullUri);
		return mv;
	}
	
	@PostMapping("/getEnd")	// 도착터미널 목록
	@ResponseBody
	public List<String> getEnd(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String start = request.getParameter("start");
		
		List<String> end = ticketSvc.getEndList(start);
		
		return end;
	}
	
	@GetMapping("/ticketView")
	public String bannerView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String ri_idx = request.getParameter("idx");
		
		TicketInfo ti = ticketSvc.getTicketView(ri_idx);
		
		
		model.addAttribute("ti", ti);
		return "ticket/ticket_view";
		
	}
	
	@GetMapping("/cancel")
	public String cancel(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String ri_idx = request.getParameter("ri_idx");
		String mi_id = request.getParameter("mi_id");
		
		request.setAttribute("ri_idx", ri_idx);
		request.setAttribute("mi_id", mi_id);
		return "popup/cancel";
		
	}
	
	@GetMapping("/realCancel")
	public String realCancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String ri_idx = request.getParameter("ri_idx");
		String mi_id = request.getParameter("mi_id");
		
		int result = ticketSvc.realCancel(ri_idx, mi_id);
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("alert('예매가 취소처리 되었습니다.');");
		out.println("location.href='ticketView?idx=" + ri_idx + "'");
		out.println("</script>");
		out.close();
		
		return "";
	}
}
