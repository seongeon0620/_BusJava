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
public class IndexCtrl {
	private IndexSvc indexSvc;
	
	public void setIndexSvc(IndexSvc indexSvc) {
		this.indexSvc = indexSvc;
	}

	@GetMapping("/")
	public String index(HttpServletRequest request) throws Exception {
		List<BannerInfo> bi = indexSvc.getbannerList();
		HttpSession session = request.getSession();
		String cookie = request.getHeader("cookie");
		String isViewPop = "";
		if (cookie != null) {
			Cookie[] cookies = request.getCookies();
			for (int i = 0; i < cookies.length ; i++) {
				if (cookies[i].getName().equals("isViewPop")){
					isViewPop = cookies[i].getValue();					
					break;
				}
			}
		}
		
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
		
		if (loginInfo != null) {
			List<ReservationInfo> ri = indexSvc.getRecentReservation(loginInfo.getMi_id());
			request.setAttribute("recentReservation", ri);
		}
		request.setAttribute("bi", bi);
		request.setAttribute("isViewPop", isViewPop);
		
		return "index";
	}
	
	
	@GetMapping("/createCookieForPop")
	@ResponseBody
	public String createCookie(HttpServletResponse response) {
		Cookie cookie = new Cookie("isViewPop","false");
		cookie.setDomain("localhost");
		cookie.setPath("/");
		cookie.setMaxAge(60 * 60 * 24);
		cookie.setSecure(true);
		response.addCookie(cookie);
		
		return "index";
	}
}
