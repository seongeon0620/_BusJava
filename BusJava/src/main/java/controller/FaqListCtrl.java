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
		String where = " where fl_isview = 'Y' ";
		List<FaqInfo> faqList = faqListSvc.getfaqList(where);
		model.addAttribute("faqList", faqList);
		model.addAttribute("activeCs", "active");
		
		return "cs/faq_list";
	}
	
	@PostMapping("/schFaqList")
	public String schFaqList(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String schtype = request.getParameter("schtype");
		System.out.println(schtype);
		String where = " where fl_isview = 'Y' ";
		
		if (schtype != null && !schtype.equals("")) {
			where += " and fl_ctgr = '" + schtype + "' ";
		}
		
		List<FaqInfo> faqList = faqListSvc.getfaqList(where);
		
		PageInfo pi = new PageInfo();
		pi.setSchtype(schtype);
		
		model.addAttribute("faqList", faqList);
		model.addAttribute("pi", pi);
		
		return "cs/faq_list";
	}
}
