package controller;

import java.io.*;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import java.net.*;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Random;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.*;
import vo.*;

@Controller
public class MemberCtrl {
	
	@Autowired
	private JavaMailSender mailSender;
	
	private MemberSvc memberSvc;
	
	public void setMemberSvc(MemberSvc memberSvc) {
		this.memberSvc = memberSvc;
	}
	
	/* 회원로그인 시작*/	
	@GetMapping("/memberLogin")
	public String index(@RequestParam(name = "returnUrl", required = false) String returnUrl) {
		return "/member/login";
	}
	
	@PostMapping("/memberLogin")
	public String loginProc(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String mi_id = request.getParameter("mi_id").trim().toLowerCase();
		String mi_pw = request.getParameter("mi_pw").trim();
		MemberInfo loginInfo = memberSvc.getLoginInfo(mi_id, mi_pw);
		
		String returnUrl = request.getParameter("returnUrl");
		if (returnUrl == null)	returnUrl = "redirect:/";
		else 				returnUrl = "redirect:/" + returnUrl.replace('~', '&');
		
		if (loginInfo == null) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('아이디와 암호를 확인하세요.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("loginInfo", loginInfo);
			
		}
		
		return returnUrl;
	}
	/* 회원로그인 끝*/	

	/* 회원로그아웃 시작*/	
	@RequestMapping("/memberLogout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	/* 회원로그아웃 끝*/
	
	/* 회원가입 시작 */
	@GetMapping("/memberJoinStep1")
	public String joinStep1(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		if (loginInfo != null) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('알 수 없는 접근입니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		} 
		return "/member/join_step1";
	}
	
	@GetMapping("/memberJoinStep2")
	public String joinStep2() {
		return "/member/join_step2";
	}
	
	@PostMapping("/memberJoinStep2")
	public String joinProc(HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {
		request.setCharacterEncoding("utf-8");
		MemberInfo mi = new MemberInfo();
		mi.setMi_id(request.getParameter("mi_id"));
		mi.setMi_pw(request.getParameter("mi_pw"));
		mi.setMi_name(request.getParameter("mi_name"));
		mi.setMi_gender(request.getParameter("mi_gender"));
		mi.setMi_type(request.getParameter("mi_type"));
		String p2 = request.getParameter("p2");
		String p3 = request.getParameter("p3");
		mi.setMi_phone("010-" + p2 + "-" + p3);
		String e1 = request.getParameter("e1");
		String e2 = request.getParameter("e2");
		String e3 = request.getParameter("e3");
		if (e3 == null) {
			mi.setMi_email(e1 + "@" + e2);			
		} else {
			mi.setMi_email(e1 + "@" + e3);	
		}
		
		/*
		 * System.out.println(e1 + "@" + e2); System.out.println(e1 + "@" + e3);
		 */
		
		int result = memberSvc.memberInsert(mi);
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('회원가입에 실패했습니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		}
		
		redirectAttributes.addFlashAttribute("mi_id", mi.getMi_id());
	    redirectAttributes.addFlashAttribute("mi_name", mi.getMi_name());
	    
		return "redirect:/memberJoinStep3";
	}
	
	@ResponseBody // 회원가입지 자동입력 방지
	@RequestMapping(value = "/VerifyRecaptcha", method = RequestMethod.POST)
	public int VerifyRecaptcha(HttpServletRequest request) {
		// 시크릿 키를 캡챠를 받아올수 있는 Class에 보내서 그곳에서 값을 출력한다
	    VerifyRecaptcha.setSecretKey("6Lc_X-4nAAAAAP6-TLr7af5Tl_zIyqDvsetONt7t");
	    String gRecaptchaResponse = request.getParameter("recaptcha");
	    try {
	       if(VerifyRecaptcha.verify(gRecaptchaResponse))
	          return 0; // 성공
	       else return 1; // 실패
	    } catch (Exception e) {
	        e.printStackTrace();
	        return -1; //에러
	    }
	}
	
	@GetMapping("/memberJoinStep3")
	public String joinStep3(String mi_id, String mi_name, Model model) {
		return "/member/join_step3";
	}
	
	/* 회원가입 아이디 검사 부분 */
	@PostMapping("/dupId")
	@ResponseBody // 자바 객체를 http 응답을 객체로 변환하여 클라이언트에 전송
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String dupId(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String uid = request.getParameter("uid").trim().toLowerCase();
		int result = memberSvc.chkDupId(uid);
		
		return result + "";
	}
	/* 회원가입 아이디 검사 부분 */
	
	
	/* 회원가입 메일 검사 부분 */
	@PostMapping("/dupMail")
	@ResponseBody // 자바 객체를 http 응답을 객체로 변환하여 클라이언트에 전송
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String dupMail(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String e1 = request.getParameter("e1").trim();
		String e3 = request.getParameter("e3").trim();
		String email = (e1 + "@" + e3);
		int result = memberSvc.chkDupMail(email);
		
		return result + "";
	}
	/* 회원가입 메일 검사 부분 */
	
	
	/* 회원가입 전화번호 부분 */
	@PostMapping("/dupPhone")
	@ResponseBody // 자바 객체를 http 응답을 객체로 변환하여 클라이언트에 전송
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String dupPhone(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String p2 = request.getParameter("p2").trim();
		String p3 = request.getParameter("p3").trim();
		String phone = ("010-" + p2 + "-" + p3);
		int result = memberSvc.chkDupPhone(phone);
		
		return result + "";
	}
	/* 회원가입 전화번호 부분 */
	
	/* 회원 아이디 / 비밀번호 찾기 부분 */
	@GetMapping("/memberFind")
	public String find() {
		return "/member/find";
	}
	
	@PostMapping("/memberFindId")
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String memberFindId(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("utf-8");
		String idE1 = request.getParameter("idE1").trim();
		String idE2 = request.getParameter("idE2");
		String idE3 = request.getParameter("idE3");
		String email = "";
		if (idE3 == null) {
			idE2.trim();
			email = (idE1 + "@" + idE2);		
		} else {
			idE3.trim();
			email = (idE1 + "@" + idE3);
		}
		
		String setfrom = "jeenworks@naver.com";		
		String title = "busjava"; // 제목
		String content = "회원님의 아이디는 : "; // 내용

		int result = memberSvc.chkDupMail(email);
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('유효하지 않은 회원 정보 입니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		}
		
		String mi_id = memberSvc.passDupMail(email);
		content += mi_id + "입니다.";
			
		try {
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
	
				messageHelper.setFrom(setfrom); // 보내는사람 생략하면 정상작동을 안함
				messageHelper.setTo(email); // 받는사람 이메일
				messageHelper.setSubject(title); // 메일제목은 생략이 가능하다
				messageHelper.setText(content); // 메일 내용
	
				mailSender.send(message);
				
			} catch (Exception e) {
				System.out.println(e);
		}
		
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("alert('회원님께서 입력하신 이메일 주소로 아이디를 발송했습니다.');");
		out.println("location.href='memberLogin';");
		out.println("</script>");
		out.close();
		
		return "/member/login";
	}

/* 비밀번호 찾기 */
	
	@PostMapping("/memberFindPw")
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String memberFindPw(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String pwE1 = request.getParameter("pwE1").trim();
		String pwE2 = request.getParameter("pwE2");
		String pwE3 = request.getParameter("pwE3");
		String mi_id = request.getParameter("mi_id");
		String email = "";
		if (pwE3 == null) {
			pwE2.trim();
			email = (pwE1 + "@" + pwE2);		
		} else {
			pwE3.trim();
			email = (pwE1 + "@" + pwE3);
		}
		
		String setfrom = "jeenworks@naver.com";		
		String title = "busjava"; // 제목
		String newPw = getRandomPassword();
		String content = "회원님의 임시비밀번호는 : " + newPw; // 내용
		
		int result = memberSvc.chkDupIdMail(mi_id, email);
		
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('유효하지 않은 회원 정보 입니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		} 
			

		 int resultUp = memberSvc.passDupIdMail(mi_id, email, newPw);
		 
		 if (resultUp != 1) { 
			 response.setContentType("text/html; charset=utf-8");
			 PrintWriter out = response.getWriter(); 
			 out.println("<script>");
			 out.println("alert('임시비밀번호 전송이 실패하였습니다.');"); 
			 out.println("history.back();");
			 out.println("</script>"); 
			 out.close();
		 }
		 
		
		try {
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
	
				messageHelper.setFrom(setfrom); // 보내는사람 생략하면 정상작동을 안함
				messageHelper.setTo(email); // 받는사람 이메일
				messageHelper.setSubject(title); // 메일제목은 생략이 가능하다
				messageHelper.setText(content); // 메일 내용
	
				mailSender.send(message);
				
			} catch (Exception e) {
				System.out.println(e);
		}
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("alert('회원님께서 입력하신 이메일 주소로 임시 비밀번호를 발송했습니다.');");
		out.println("location.href='memberLogin';");
		out.println("</script>");
		out.close();
		
		
		return "/member/login";
		
	}
	
	private String getRandomPassword() {
		Random rnd = new Random();
		char[] arr = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
				'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
		StringBuilder pwBuilder = new StringBuilder();
		pwBuilder.append(arr[rnd.nextInt(26)]); // 첫 글자는 영문
		for (int i = 1; i < 10; i++) {
			pwBuilder.append(arr[rnd.nextInt(arr.length)]);
		}
		return pwBuilder.toString().toUpperCase();
	}
	/* 회원 아이디 / 비밀번호 찾기 부분 */


	/* 회원 마이페이지 부분*/
	@GetMapping("/mypage")
	public String mypage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		if (loginInfo == null) {		// 로그인이 되어 있지 않다면
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("location.href='memberLogin?returnUrl=mypage'");
			out.println("</script>");
			out.close();
		}
		return "/member/mypage";
	}
	
	
	@GetMapping("/pwChk")
	public String pwForm() {
		return "/member/pw_form";
	}
	
	@PostMapping("/chkPw")
	@ResponseBody
	public int chkPw(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		String mi_id = loginInfo.getMi_id();
		String mi_pw = request.getParameter("mi_pw");
		
		int result = memberSvc.memberPwChk(mi_id, mi_pw);
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('비밀번호가 잘못되었습니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		}
		
		return result;
		
	}
	
	/* 회원 내정보 비밀번호 체크 부분 */
	@GetMapping("/mypage/myInfo")
	public String memberUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
//		request.setCharacterEncoding("utf-8");
//		HttpSession session = request.getSession();
//		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
//		
//		String mi_id = loginInfo.getMi_id();
//		String mi_pw = request.getParameter("mi_pw");
//		
//		int result = memberSvc.memberPwChk(mi_id, mi_pw);
//		
//		if (result != 1) {
//			response.setContentType("text/html; charset=utf-8");
//			PrintWriter out = response.getWriter();
//			out.println("<script>");
//			out.println("alert('비밀번호가 잘못되었습니다.');");
//			out.println("history.back();");
//			out.println("</script>");
//			out.close();
//		} 
		
		return "/member/modify";
		
	}
	
	/* 회원 비밀번호 변경 */
	@PostMapping("/mypage/memberUpPw")
	@ResponseBody
	public int memberUpPw(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		String mi_id = loginInfo.getMi_id();
		String mi_pw = request.getParameter("mi_pw");
		
		System.out.println(mi_id); 
		System.out.println(mi_pw);
		
		int result = memberSvc.memberUpPw(mi_id, mi_pw);
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('정보수정에 실패했습니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		} else {
		// 정보수정 성공시 세션에 들어있는 로그인 정보도 수정함
			loginInfo.setMi_pw(mi_pw);
		}
		
		return result;
		
	}
	
	/* 회원 메일 변경 */
	@PostMapping("/mypage/memberUpMail")
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String memberUpMail(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		String mi_id = loginInfo.getMi_id();
		String e1 = request.getParameter("e1");
		String e2 = request.getParameter("e2");
		String e3 = request.getParameter("e3");
		String mi_email = "";
		if (e3 == null) {
			mi_email = (e1 + "@" + e2);			
		} else {
			mi_email =(e1 + "@" + e3);	
		}
		
		/*
		  System.out.println(mi_id); 
		  System.out.println(mi_pw);
		 */
		int result = memberSvc.memberUpMail(mi_id, mi_email);
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('정보수정에 실패했습니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		} else {
		// 정보수정 성공시 세션에 들어있는 로그인 정보도 수정함
			loginInfo.setMi_pw(mi_email);
		}
		
		return "redirect:/";
		
	}
	
	/* 회원 번호 변경 */
	@PostMapping("/mypage/memberUpPhone")
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public String memberUpPhone(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		String mi_id = loginInfo.getMi_id();
		String p2 = request.getParameter("p2");
		String p3 = request.getParameter("p3");
		String mi_phone = "";
		mi_phone = ("010-" + p2 + "-" + p3);
		
		/*
		  System.out.println(mi_id); 
		  System.out.println(mi_pw);
		 */
		int result = memberSvc.memberUpPhone(mi_id, mi_phone);
		
		if (result != 1) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('정보수정에 실패했습니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		} else {
		// 정보수정 성공시 세션에 들어있는 로그인 정보도 수정함
			loginInfo.setMi_pw(mi_phone);
			session.invalidate();
		} 
		
		return "redirect:/";
		
	}
	
	@GetMapping("/memberDelPwChk")
	public String delPwForm() {
		return "/member/del_pw_form";
	}
	
	/* 회원 탈퇴 */
	@PostMapping("/memberDel")
	// 비동기 통신(ajax)시 서버에서 클라이언트로 응답 메세지를 보낼 떄 데이터를 담아서 보낼 해당 본문을 의미
	public void memberDel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		String mi_id = loginInfo.getMi_id();
		String mi_pw = request.getParameter("mi_pw");

		int result = memberSvc.memberDel(mi_id , mi_pw);
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>");
		
		if (result != 1) {
			out.println("alert('비밀번호가 잘못되었습니다.');");
			out.println("history.back();");
		} else {
		// 정보수정 성공시 세션에 들어있는 로그인 정보도 수정함
			out.println("alert('회원탈퇴 되었습니다.');");
			session.invalidate();
			out.println("location.href='/busjavaf'");
		} 
		out.println("</script>");
		out.close(); 
	}
	
// 예매 부분
	@GetMapping("/booking")
	public String bookingList(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		if (loginInfo == null) {
			out.println("<script>");
			out.println("location.href='memberLogin?returnUrl=booking';");
			out.println("</script>");
		}
		
		String mi_id = loginInfo.getMi_id();
		
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 10;
		//현제페이지 번호, 페이지 수, 시작페이지 , 게시글수, 페이지크기(내가 정하는 값), 블록크기(내가 정하는 값)
    	if (request.getParameter("cpage") != null)
    		cpage = Integer.parseInt(request.getParameter("cpage"));
    	
    	String args = "";
    	args = "?cpage=" + cpage;

    	rcnt = memberSvc.getbookListCount(mi_id);
        
    	List<BookInfo> bookList = memberSvc.getBookList(mi_id, cpage, psize);
    	
    	pcnt = rcnt / psize;
        if (rcnt % psize > 0) pcnt ++;
        spage = (cpage - 1) / bsize * bsize + 1;
    	
        PageInfo pi = new PageInfo();
        pi.setBsize(bsize);   
        pi.setCpage(cpage);
        pi.setPsize(psize);   
        pi.setPcnt(pcnt);
        pi.setRcnt(rcnt);      
        pi.setSpage(spage);
        pi.setArgs(args);
        
        String fullUrl = request.getRequestURI();
		
		request.setAttribute("bookList", bookList);
		request.setAttribute("pageInfo", pi);
		model.addAttribute("url", fullUrl);
		model.addAttribute("activeBooking", "active");
			
		return "/member/booking_list";
	}
	
	@GetMapping("/bookDetail")
	public String freeView(Model model, HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String riidx = request.getParameter("riidx");
		int cpage = Integer.parseInt(request.getParameter("cpage"));
		
		BookInfo bi = memberSvc.getBookInfo(riidx);
		String args = "?cpage=" + cpage;
		
		request.setAttribute("bi", bi);
		request.setAttribute("args", args);
		
		return "member/booking_detail";
	}
	
	@GetMapping("/cancel")
	public String cancel() {
		return "popup/cancel";
	}

	@GetMapping("/realCancel")
	public void realCancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		String riidx = request.getParameter("riidx");
		int cpage = Integer.parseInt(request.getParameter("cpage"));
		String mi_id =  loginInfo.getMi_id();
		
		int result = memberSvc.getrealCancel(riidx, mi_id);
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("alert('예매가 취소처리 되었습니다.');");
		out.println("location.href='bookDetail?cpage=" + cpage + "&riidx=" + riidx + "';");
		out.println("</script>");
		out.close();
	}
	
	
	@GetMapping("/payMoney")
	public String paymoney(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		String mi_id = loginInfo.getMi_id();
		
		List<paymoneyInfo> pList = memberSvc.getpaymoneyList(mi_id);
		List<paymoneyInfo> mphList = memberSvc.getmphList(mi_id);
		
		
		request.setAttribute("loginInfo", loginInfo);
		request.setAttribute("pList", pList);
		request.setAttribute("mphList", mphList);
		
		return "/member/paymoney";
	}

	

	
}







