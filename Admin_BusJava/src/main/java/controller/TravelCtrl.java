package controller;

import java.io.*;
import java.net.URLEncoder;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;

import javax.servlet.http.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class TravelCtrl {
	private TravelSvc travelSvc;
	
	public void setTravelSvc(TravelSvc travelSvc) {
		this.travelSvc = travelSvc;
	}
	
	@GetMapping("/travelList")
	public String travelList(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String schctgr = request.getParameter("hiddenCtgr");
		String isview = request.getParameter("isview");
		String where = " where 1 = 1 ";
		String args = "", schargs = "";
		
		
		if (schctgr != null && !schctgr.equals("")) {
			URLEncoder.encode(schctgr, "UTF-8");
			String[] arr = schctgr.split(":");
			if (!arr[0].equals("all"))
				where += " and (";
			for (int i = 0; i < arr.length; i++) {
				if (arr[i].equals("all")) {
					break;
				} else {
					where += (i == 0 ? "" : " or ") + "tl_ctgr = '" + arr[i] + "' ";
				}
				
			}
			if (!arr[0].equals("all"))
				where += ") ";
			schargs = "&schctgr=" + schctgr;
		}
		if (isview != null && !isview.equals("")) {
			where += " and tl_isview = '" + isview + "'";
			schargs = "&isview=" + isview;
		}
		
		if (schtype == null || keyword == null) {
			schtype = ""; keyword = "";
		} else if (!schtype.equals("") && !keyword.trim().equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			if (schtype.equals("all")) {
				where += " and tl_area" + " like '%" + keyword + "%' or tl_title" + " like '%" + keyword + "%'";
			} else {
				where += " and tl_" + schtype + " like '%" + keyword + "%'";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword;
		}
		args = "&cpage=" + cpage + schargs;
		
		rcnt = travelSvc.getTraverListCount(where);
		
		List<TravelList> travelList = travelSvc.getTravelList(where, cpage, psize);
		
		pcnt = rcnt / psize;	if(rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);		pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);
		pi.setRcnt(rcnt);		pi.setSpage(spage);		pi.setNum(num);			pi.setSchtype(schtype);
		pi.setKeyword(keyword);	pi.setArgs(args);		pi.setSchargs(schargs); pi.setSchctgr(schctgr);
		pi.setIsview(isview);
		// 페이징에 필요한 정보들과 검색 조건을 PageInfo형 인스턴스에 저장
		
		model.addAttribute("travelList", travelList);
		model.addAttribute("pi", pi);
		
		return "/travel/travel_list";
	}
	
	@GetMapping("/travelForm")
	public String travelForm(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String kind = request.getParameter("kind");
		
		if (kind.equals("up")) {
			int tl_idx = Integer.parseInt(request.getParameter("tl_idx"));
			
			TravelList ti = travelSvc.getTravelView(tl_idx);
			
			model.addAttribute("ti", ti);
			
		}
		
		return "travel/travel_form";
	}
	
	@PostMapping("/travelIn")
	   public String travelIn(@RequestParam("uploadFile") MultipartFile uploadFile, HttpServletRequest request, HttpServletResponse response) throws Exception {
	      request.setCharacterEncoding("utf-8");
	      response.setContentType("text/html; charset=utf-8");
	      PrintWriter out = response.getWriter();
	      String uploadPath = "C:\\Users\\Administrator.User -2023WPNQB\\git\\busJava\\adminbusj\\src\\main\\webapp\\resources\\images\\travel";
	      String uploadPath2 = "C:\\Users\\Administrator.User -2023WPNQB\\git\\busJava\\busj\\src\\main\\webapp\\resources\\images\\travel";
	      String files = "";
	      String kind = request.getParameter("kind");
	      String fileSrc = request.getParameter("fileSrc");
	      
	      MultipartFile file = uploadFile;
	      File saveFile = new File(uploadPath, file.getOriginalFilename());
	      File saveFile2 = new File(uploadPath2, file.getOriginalFilename());
	      try {
	              
	         files += file.getOriginalFilename();
	         if (!files.equals("")) {
	            int num = files.indexOf(".");
	            String tmp = files.substring(num + 1).toLowerCase();
	            
	            if(!tmp.equals("jpeg") && !tmp.equals("png") && !tmp.equals("gif") && !tmp.equals("jpg")) {
	               out.println("<script>");
	               out.println("alert('파일의 확장자를 확인해주세요.');");
	               out.println("history.back();");
	               out.println("</script>");
	               out.close();
	               return "";
	            }
	            
	         } else {
	            if (files.equals("") && fileSrc.equals("")) {
	               out.println("<script>");
	               out.println("alert('파일을 첨부해 주세요.');");
	               out.println("history.back();");
	               out.println("</script>");
	               out.close();
	               return "";
	            }
	            files += fileSrc;
	         }
	         file.transferTo(saveFile);
	         file.transferTo(saveFile2);
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      
	      
	      TravelList tr = new TravelList();
	      tr.setTl_area(request.getParameter("area"));
	      tr.setTl_ctgr(request.getParameter("ctgr"));
	      tr.setTl_title(request.getParameter("title").trim());
	      tr.setTl_content(request.getParameter("content").trim());
	      tr.setTl_isview(request.getParameter("isview"));
	      tr.setTl_img(files);
	      
	      HttpSession session = request.getSession();
	      AdminInfo loginInfo = (AdminInfo)session.getAttribute("loginInfo");
	      tr.setAi_idx(loginInfo.getAi_idx());
	      if (kind.equals("up")) {
	         tr.setTl_idx(Integer.parseInt(request.getParameter("tl_idx")));
	      }
	      
	      int tl_idx = travelSvc.travelIn(tr, kind);
	      
	      return "redirect:/travelView?tl_idx=" + tl_idx;
	   }
	
	@GetMapping("/travelView")
	public String travelView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int tl_idx = Integer.parseInt(request.getParameter("tl_idx"));
		
		TravelList tr = travelSvc.getTravelView(tl_idx);
		tr.setTl_content(tr.getTl_content().replace("\r\n", "<br />"));
		
		model.addAttribute("tr", tr);
		return "travel/travel_view";
		
	}
	
	@PostMapping("/travelDel")
	@ResponseBody
	public String travelDel(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String tlidx = request.getParameter("tlidx");
		
		String where = " where 1 = 1 ";
		if (tlidx.indexOf(',') >= 0) {
			String[] arr = tlidx.split(",");
			for (int i = 0; i < arr.length; i ++) {
				if (i == 0) where += " and (tl_idx = " + arr[i];
				else 		where += " or tl_idx = " + arr[i];
			}
			where += ") ";
		} else {
			where += " and tl_idx = " + tlidx;
		}
		
		int result = travelSvc.travelDel(where);
		
		return result + "";
	}
}
