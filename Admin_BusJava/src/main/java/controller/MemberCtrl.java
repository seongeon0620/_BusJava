package controller;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpRequest;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.*;
import vo.*;

@Controller
public class MemberCtrl {
	private MemberSvc memberSvc;

	public void setMemberSvc(MemberSvc memberSvc) {
		this.memberSvc = memberSvc;
	}
	
	@GetMapping("/memberList")
	public String memberList(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10, num = 0;
		//현제페이지 번호, 페이지 수, 시작페이지 , 게시글수, 페이지크기(내가 정하는 값), 블록크기(내가 정하는 값), 번호등을 저장할 변수
		if (request.getParameter("cpage") != null)
			cpage = Integer.parseInt(request.getParameter("cpage")); 
		
		// 검색조건 전체, 아이디, 이메일
		String schtype = request.getParameter("schtype");
		String keyword = request.getParameter("keyword");
		String schctgr = request.getParameter("hiddenCtgr");
		String where = " where 1 = 1 ";
		String args = "", schargs = "";
		
		System.out.println(schctgr); 
		
		if (schctgr != null && !schctgr.equals("")) {
			URLEncoder.encode(schctgr, "UTF-8");
			String[] arr = schctgr.split(":");
			if (!arr[0].equals("all"))
				where += " and (";
			for (int i = 0; i < arr.length; i++) {
				if (arr[i].equals("all")) {
					break;
				} else {
					where += (i == 0 ? "" : " or ") + "mi_status = '" + arr[i] + "' ";
				}
				
			}
			if (!arr[0].equals("all"))
				where += ") ";
			schargs = "&schctgr=" + schctgr;
		}
		
		if(schtype == null || keyword == null) {
			schtype = ""; keyword = ""; 
		} else if (!schtype.equals("") && !keyword.trim().equals("")) {
			URLEncoder.encode(keyword, "UTF-8");
			keyword = keyword.trim();
			if (schtype.equals("all")) { //검색조건이 '아이디 + 이메일'일 경우
				where += " and (mi_id like '%" + keyword + "%' or mi_email like '%" + keyword + "%') ";
			} else {
				where += " and mi_" + schtype + " like '%" + keyword + "%' ";
			}
			schargs = "&schtype=" + schtype + "&keyword=" + keyword;
		}
		args = "&cpage=" + cpage + schargs;
		/* System.out.println(where); */
		rcnt = memberSvc.getmemberListCount(where); //천제 게시글개수
		// 검색된 게시글의 총 개수로 게시글 일련번호 출력과 전체 페이지수 계산을 위한 값
		List<MemberInfo> memberList = memberSvc.getmemberList(where, cpage, psize); // jdbc 템플릿이 제공해주는게 List이기 때문에 List사용 
		
		pcnt = rcnt / psize; if(rcnt % psize >0) pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
		num = rcnt- (psize * (cpage - 1));
		
		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);
		pi.setCpage(cpage);
		pi.setPcnt(pcnt);
		pi.setPsize(psize);
		pi.setRcnt(rcnt);
		pi.setSpage(spage);
		pi.setNum(num);
		pi.setArgs(args);
		pi.setKeyword(keyword);
		pi.setSchargs(schargs);
		pi.setSchtype(schtype);
		/*pi.setSchctgr(schctgr);*/
		// 페이징에 필요한 정보들과 검색조건을 PageInfo형 인스턴스에 저장
		
		request.setAttribute("memberList", memberList);
		request.setAttribute("pi", pi);
		model.addAttribute("schctgr", schctgr);
		/* request.setAttribute("check", check); */
		
		return "member/member_list";
	}
	
	@PostMapping("/memberDetail")
		@ResponseBody
		public List<MemberInfo> getmemberDetail(HttpServletRequest request) throws Exception {
			request.setCharacterEncoding("utf-8");
			
			String mi_id = request.getParameter("uid");
						
			List<MemberInfo> memDetailList = memberSvc.getmemberDetail(mi_id);
			
			
			return memDetailList;
		}
	
	@PostMapping("/memberUp") 
	public String memberUpdate(HttpServletRequest request,  HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String mi_id = request.getParameter("mi_id");
		String mi_status = request.getParameter("mi_status");
		
		int result = memberSvc.memberUpdate(mi_id, mi_status);
		
		  if (result != 1) { 
			  response.setContentType("text/html; charset=utf-8");
			  PrintWriter out = response.getWriter(); out.println("<script>");
			  out.println("alert('정보수정에 실패했습니다.');"); out.println("history.back();");
			  out.println("</script>"); out.close(); 
		  }
		 
		
		return "redirect:/memberList";
	}	
}