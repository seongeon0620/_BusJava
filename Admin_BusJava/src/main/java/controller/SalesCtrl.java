package controller;

import java.io.*;
import java.net.URLEncoder;
import java.time.LocalDate;

import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;

import javax.servlet.http.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class SalesCtrl {
   private SalesSvc salesSvc;
   
   public void setSalesSvc(SalesSvc salesSvc) {
      this.salesSvc = salesSvc;
   }
   
   @GetMapping("/salesList")
   public String salesList(HttpServletRequest request, HttpServletResponse response) throws Exception {
	   request.setCharacterEncoding("utf-8");
	   HttpSession session = request.getSession();
	   AdminInfo loginInfo = (AdminInfo) session.getAttribute("loginInfo");
	   
	   response.setContentType("text/html; charset=utf-8");
	   PrintWriter out = response.getWriter();
		
	   
		if (loginInfo == null) {
			out.println("<script>");
			out.println("alert('로그인 후 이용해 주세요.'); location.href='/admin_busjavaF/login' ");
			out.println("</script>");
			out.close();
		}
	      LocalDate nowDate = LocalDate.now();
	      
	      String lineType = request.getParameter("lineCategory");
	      String schargs = "";
	      if (lineType != null) {
	    	  if (lineType.equals("high")) lineType= "high";
	          else if (lineType.equals("slow")) lineType= "slow";
	    	  
	    	  schargs += "lineCategory=" + lineType;
	      }
	      
	      System.out.println(schargs);

	      String fromDate = request.getParameter("fromDate");
	      String toDate = request.getParameter("toDate");
	      if (fromDate == null && toDate == null) {   // 처음 페이지 로딩시 최근 일주일간의 데이터
	         fromDate = nowDate.minusDays(7) + "";
	         toDate = nowDate + "";
	      } else {
	         fromDate = fromDate.replace(".", "-");
	         toDate = toDate.replace(".", "-");
	         schargs +=  "&fromDate=" + fromDate + "&toDate=" + toDate;
	      }
	      
	      System.out.println(schargs);
	      String terName = request.getParameter("terName");
	      if (terName != null) {
	    	  schargs +=  "&terName=" + terName;
	      }
	      
	      List<SalesInfo> salesList = salesSvc.getSalesList(lineType, terName, fromDate, toDate);
	      
	      PageInfo pi = new PageInfo();
	      pi.setSchctgr(lineType);
	      pi.setKeyword(terName);
	      pi.setSchargs(schargs);
	      
	      session.setAttribute("salesList", salesList);
	      session.setAttribute("pi", pi);
	      
	      return "/sales/sales_list";
      
   }
   
   @GetMapping("/paymoneyList")
	public String paymoneyList(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");

		List<PaymoneyInfo> paymoneyList = salesSvc.getPaymoneyList();
		model.addAttribute("paymoneyList", paymoneyList);

		return "/sales/paymoney_list";
	}
   
   @GetMapping("/pickTerminal")
   public String pickTerminal(HttpServletRequest request, @RequestParam(required = false) String keyword) {
	   List<TerminalInfo> terminalList = salesSvc.getTerminalList();
		request.setAttribute("terminalList", terminalList);
		if (keyword != null) request.setAttribute("keyword", keyword);
		
      return "/popup/pick_spot";
   }
   
	// 터미널 선택 팝업에서 터미널 검색시
	@GetMapping("/getKeywordList")
	@ResponseBody
	public List<TerminalInfo> getKeywordList(@RequestParam String keyword)  {
		return salesSvc.getTerminalList(keyword);
	}
   
}   