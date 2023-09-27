package controller;

import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.*;
import java.io.*;
import java.net.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class IndexCtrl {
	private IndexSvc indexSvc;

	public void setIndexSvc(IndexSvc indexSvc) {
		this.indexSvc = indexSvc;
	}

	@GetMapping("/")
	public String index(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		HttpSession session = request.getSession();
		List<HashMap<String, Object>> salesList = indexSvc.getSales();

		AdminInfo loginInfo = (AdminInfo) session.getAttribute("loginInfo");

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		if (loginInfo == null) {
			out.println("<script>");
			out.println("location.href='/Admin_BusJava/login' ");
			out.println("</script>");
			out.close();
		}

		String hTopLineList = indexSvc.getTopLine("high");
		String sTopLineList = indexSvc.getTopLine("slow");

		List<String> hSalesQuarterLast = indexSvc.getSalesByQuarter(1, "high");
		List<String> hSalesQuarterNow = indexSvc.getSalesByQuarter(0, "high");

		List<String> sSalesQuarterLast = indexSvc.getSalesByQuarter(1, "slow");
		List<String> sSalesQuarterNow = indexSvc.getSalesByQuarter(0, "slow");

		model.addAttribute("salesList", salesList);
		model.addAttribute("hTopLineList", hTopLineList);
		model.addAttribute("sTopLineList", sTopLineList);
		model.addAttribute("hSalesQuarterLast", hSalesQuarterLast);
		model.addAttribute("hSalesQuarterNow", hSalesQuarterNow);
		model.addAttribute("sSalesQuarterLast", sSalesQuarterLast);
		model.addAttribute("sSalesQuarterNow", sSalesQuarterNow);
		return "index";
	}
}