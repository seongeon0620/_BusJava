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
public class LostCtrl {
	private LostSvc lostSvc;

	public void setLostSvc(LostSvc lostSvc) {
		this.lostSvc = lostSvc;
	}

	@GetMapping("/lostList")
	public String lostList(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		// 현재페이지 번호, 페이지 수, 시작 페이지, 게시글 수, 페이지 크기, 블록 크기, 번호
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage"));
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		String date = request.getParameter("date");
		String terName = request.getParameter("terName");
		String where = " where 1 = 1 ";
		String args = "", schargs = "";

		if (status != null && !status.equals("")) {
			where += " and ll_status = '" + status + "'";
			schargs += "&status=" + status;
		}

		if (date != null && !date.equals("")) {
			where += " and date(ll_getdate) = '" + date.replace(".", "-") + "'";
			schargs += "&date=" + date;
		}

		if (keyword == null) {
			keyword = "";
		} else if (!keyword.trim().equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			where += " and ll_title" + " like '%" + keyword + "%' ";
			schargs += "&keyword=" + keyword;
		}

		if (terName == null) {
			terName = "";
		} else if (!terName.trim().equals("")) {
			URLEncoder.encode(terName, "UTF-8");
			where += " and ll_tername" + " like '%" + terName + "%' ";
			schargs += "&terName=" + terName;
		}

		args = "&cpage=" + cpage + schargs;

		rcnt = lostSvc.getLostListCount(where);

		List<LostInfo> lostList = lostSvc.getLostList(where, cpage, psize);

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
		pi.setKeyword(keyword);
		pi.setArgs(args);
		pi.setSchargs(schargs);
		pi.setStatus(status);
		pi.setDate(date);
		pi.setSchtype(terName);
		// 페이징에 필요한 정보들과 검색 조건을 PageInfo형 인스턴스에 저장

		model.addAttribute("lostList", lostList);
		model.addAttribute("pi", pi);

		return "/cs/lost_list";
	}

	@GetMapping("/lostForm")
	public String lostForm(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String kind = request.getParameter("kind");

		if (kind.equals("up")) {
			int ll_idx = Integer.parseInt(request.getParameter("ll_idx"));

			LostInfo li = lostSvc.getLostView(ll_idx);

			model.addAttribute("li", li);

		}

		return "cs/lost_form";
	}

	@PostMapping("/lostIn")
	public String lostIn(@RequestParam("uploadFile") MultipartFile uploadFile, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		String uploadPath = "E:\\lsj\\spring\\busjava_final\\admin_busjavaF\\src\\main\\webapp\\resources\\images\\lost";
		String uploadPath2 = "E:\\lsj\\spring\\busjava_final\\busjavaf\\src\\main\\webapp\\resources\\images\\lost";
		String files = "";
		String kind = request.getParameter("kind");
		String fileSrc = request.getParameter("fileSrc");
		String date = request.getParameter("date").replace(".", "-");
		String time = request.getParameter("time") + ":00";
		String dateTime = date + " " + time;
		if (date == null || date.equals("")) {
			out.println("<script>");
			out.println("alert('습득일자를 확인해주세요.');");
			out.println("history.back();");
			out.println("</script>");
		}

		MultipartFile file = uploadFile;
		File saveFile = new File(uploadPath, file.getOriginalFilename());
		File saveFile2 = new File(uploadPath2, file.getOriginalFilename());
		try {
			files += file.getOriginalFilename();
			if (!files.equals("")) {
				int num = files.indexOf(".");
				String tmp = files.substring(num + 1).toLowerCase();

				if (!tmp.equals("jpeg") && !tmp.equals("png") && !tmp.equals("gif") && !tmp.equals("jpg")) {
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
			if (!saveFile.exists()) {
				file.transferTo(saveFile);
				file.transferTo(saveFile2);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		LostInfo li = new LostInfo();
		li.setLl_tername(request.getParameter("terName"));
		li.setLl_title(request.getParameter("title").trim());
		li.setLl_content(request.getParameter("content").trim());
		li.setLl_status(request.getParameter("status"));
		li.setLl_getdate(dateTime);
		li.setLl_img(files);

		HttpSession session = request.getSession();
		AdminInfo loginInfo = (AdminInfo) session.getAttribute("loginInfo");
		li.setAi_idx(loginInfo.getAi_idx());
		if (kind.equals("up")) {
			li.setLl_idx(Integer.parseInt(request.getParameter("ll_idx")));
		}

		int ll_idx = lostSvc.lostIn(li, kind);

		return "redirect:/lostView?ll_idx=" + ll_idx;
	}

	@GetMapping("/lostView")
	public String lostView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int ll_idx = Integer.parseInt(request.getParameter("ll_idx"));

		LostInfo li = lostSvc.getLostView(ll_idx);
		li.setLl_content(li.getLl_content().replace("\r\n", "<br />"));

		model.addAttribute("li", li);
		return "cs/lost_view";

	}

	@PostMapping("/lostDel")
	@ResponseBody
	public String lostDel(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String ll_idx = request.getParameter("ll_idx");

		String where = " where 1 = 1 ";
		if (ll_idx.indexOf(',') >= 0) {
			String[] arr = ll_idx.split(",");
			for (int i = 0; i < arr.length; i++) {
				if (i == 0)
					where += " and (ll_idx = " + arr[i];
				else
					where += " or ll_idx = " + arr[i];
			}
			where += ") ";
		} else {
			where += " and ll_idx = " + ll_idx;
		}

		int result = lostSvc.lostDel(where);

		return result + "";
	}
}