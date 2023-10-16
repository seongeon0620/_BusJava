package controller;

import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.stereotype.*;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;
import javax.servlet.http.*;
import service.*;
import vo.*;

@Controller
public class BannerCtrl {
	private BannerSvc bannerSvc;

	public void setBannerSvc(BannerSvc bannerSvc) {
		this.bannerSvc = bannerSvc;
	}

	@GetMapping("/bannerList")
	// public String bannerList (Model model, HttpServletRequest request) throws
	// Exception {
	public ModelAndView bannerList(Model model, HttpServletRequest request) throws Exception {
		// bl_idx, ai_idx, bl_name, bl_content, bl_img, bl_isview, bl_date
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		String keyword = request.getParameter("keyword");
		String isview = request.getParameter("isview");
		String where = " where 1 = 1";
		String args = ""; // 쿼리스트링 전체 통합(페이징+검색내용) 변수
		String schargs = ""; // 검색내용을 담을 쿼리스트링 변수

		if (isview != null && !isview.equals("")) {
			where += " and bl_isview = '" + isview + "' ";
			schargs = "&isview=" + isview;
		} else {
			isview = "";
		}

		if (keyword != null && !keyword.equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			where += " and bl_name like '%" + keyword + "%' ";
		} else {
			keyword = "";
		}
		schargs = "&keyword=" + keyword;
		args = "&cpage=" + cpage + schargs;

		rcnt = bannerSvc.getBannerListCount(where);

		List<BannerInfo> bannerList = bannerSvc.getBannerList(where, cpage, psize);

		pcnt = rcnt / psize;
		if (rcnt % psize > 0)
			pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt - (psize * (cpage - 1));
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);
		pi.setCpage(cpage);
		pi.setPcnt(pcnt);
		pi.setPsize(psize);
		pi.setRcnt(rcnt);
		pi.setSpage(spage);
		pi.setNum(num);
		pi.setIsview(isview);
		pi.setKeyword(keyword);
		pi.setArgs(args);
		pi.setSchargs(schargs);

		/*
		 * model.addAttribute("bannerList", bannerList); model.addAttribute("pi", pi);
		 * return "banner/banner_list";
		 */
		String fullUri = request.getRequestURI();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("banner/banner_list");
		mv.addObject("bannerList", bannerList);
		mv.addObject("pi", pi);
		mv.addObject("url", fullUri);
		return mv;
	}

	@PostMapping("BisviewChange")
	@ResponseBody
	public String BisviewChange(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String isview = request.getParameter("isview");
		String blidx = request.getParameter("blidx");
		String where = " where 1 = 1 ";
		System.out.println(blidx);
		if (blidx.indexOf(',') >= 0) {
			String[] arr = blidx.split(",");
			for (int i = 0; i < arr.length; i++) {
				if (i == 0) {
					where += " and (bl_idx = " + arr[i];
				} else
					where += " or bl_idx = " + arr[i];
			}
			where += ") ";
		} else {
			where += " and bl_idx = " + blidx;
		}
		int result = bannerSvc.BisviewChange(where, isview);

		return result + "";
	}

	@GetMapping("bannerForm")
	public String bannerForm(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String kind = request.getParameter("kind");

		if (kind.equals("up")) {
			int bl_idx = Integer.parseInt(request.getParameter("bl_idx"));

			BannerInfo bi = bannerSvc.getBannerView(bl_idx);

			model.addAttribute("bi", bi);

		}

		return "banner/banner_form";
	}

	@GetMapping("/bannerView")
	public String bannerView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int bl_idx = Integer.parseInt(request.getParameter("bl_idx"));

		BannerInfo bi = bannerSvc.getBannerView(bl_idx);
		bi.setBl_content(bi.getBl_content().replace("\r\n", "<br />"));

		model.addAttribute("bi", bi);
		return "banner/banner_view";

	}

	@PostMapping("/bannerIn")
	public String bannerIn(@RequestParam("uploadFile") MultipartFile uploadFile, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		String uploadPath = "C:\\Users\\user\\git\\_BusJava\\BusJava\\src\\main\\webapp\\resources\\images\\banner";
		String uploadPath2 = "C:\\Users\\user\\git\\_BusJava\\Admin_BusJava\\src\\main\\webapp\\resources\\images\\banner";
		String files = "";
		String kind = request.getParameter("kind");
		String fileSrc = request.getParameter("fileSrc");

		MultipartFile file = uploadFile;
		File saveFile = new File(uploadPath, file.getOriginalFilename());
		File saveFile2 = new File(uploadPath2, file.getOriginalFilename());
		System.out.println(file.getOriginalFilename());
		try {
			files += file.getOriginalFilename();
			file.transferTo(saveFile);
			file.transferTo(saveFile2);
		} catch (Exception e) {
			e.printStackTrace();
		}

		BannerInfo bi = new BannerInfo();
		bi.setBl_name(request.getParameter("BannerName").trim());
		bi.setBl_content(request.getParameter("content").trim());
		System.out.println(files.toLowerCase());
		bi.setBl_img(files.toLowerCase());
		bi.setBl_isview(request.getParameter("isview"));

		HttpSession session = request.getSession();
		AdminInfo loginInfo = (AdminInfo) session.getAttribute("loginInfo");
		bi.setAi_idx(loginInfo.getAi_idx());
		if (kind.equals("up")) {
			bi.setBl_idx(Integer.parseInt(request.getParameter("bl_idx")));
		}

		int bl_idx = bannerSvc.bannerIn(bi, kind);

		return "redirect:/bannerView?bl_idx=" + bl_idx;

	}

	@PostMapping("chkIsview")
	@ResponseBody
	public int chkIsview(HttpServletRequest request) throws Exception {
		int result = bannerSvc.chkIsview();
		return result;
	}
}
