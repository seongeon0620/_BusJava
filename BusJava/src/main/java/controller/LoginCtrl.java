package controller;

import java.io.*;
import java.net.*;
import java.util.*;
import javax.servlet.http.*;
import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.*;
import vo.MemberInfo;

@Controller
public class LoginCtrl {
	private LoginSvc loginSvc;
	
	public void setLoginSvc(LoginSvc loginSvc) {
		this.loginSvc = loginSvc;
	}

	@GetMapping("/kakaoLoginProc")
	public String kakaoLoginProc(String code, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String accessToken = loginSvc.getAccessTokenK(code);	
		HashMap<String, String> kakaoLogin = loginSvc.getUserInfoK(accessToken);
//		System.out.println("kakaoLogin : " + kakaoLogin);
//		System.out.println("kakao_id : " + kakaoLogin.get("kakao_id"));
//		System.out.println("nickname : " + kakaoLogin.get("nickname"));
//		System.out.println("gender : " + kakaoLogin.get("gender"));
//		System.out.println("email : " + kakaoLogin.get("email"));
		
		String mi_id = kakaoLogin.get("kakao_id");
		String mi_name = kakaoLogin.get("nickname");
		String mi_gender = kakaoLogin.get("gender");
		String mi_email = kakaoLogin.get("email");
		
		int result = loginSvc.chkId(mi_id);
		// System.out.println("chkId 성공");
		if (result != 1) {
			MemberInfo mi = new MemberInfo();
			mi.setMi_id(mi_id);
			mi.setMi_name(mi_name);
			mi.setMi_gender(mi_gender);
			mi.setMi_email(mi_email);
			mi.setMi_type("k");
			
			result = loginSvc.kakaoInsert(mi);
		}
		// System.out.println("kakaoInsert 성공");
		
		MemberInfo loginInfo = loginSvc.getkakaoLogin(mi_id);
		
		String returnUrl = request.getParameter("returnUrl");
		if (returnUrl == null)	returnUrl = "redirect:/";
		else 				returnUrl = "redirect:/" + returnUrl.replace('~', '&');
		
		if (loginInfo == null) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("history.back();");
			out.close();
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("loginInfo", loginInfo);
		}
		// System.out.println("session.setAttribute 성공");
		return returnUrl;	// 로그인 처리 후 이동할 페이지 주소
	}
	
	@GetMapping("/naverLoginProc")
	public String naverLoginProc(String code,HttpServletRequest request , HttpServletResponse response) throws Exception {
		//System.out.println(code);	// code : kakao.com으로 부터 정보를 받기 위한 코드값
		String accessToken = loginSvc.getAccessTokenN(code);	
		// 로그인 정보를 받기 위한 코드를 받아옴
		HashMap<String, String> naverLogin = loginSvc.getUserInfoN(accessToken);
		// 실제 데이터를 HashMap 인스턴스로 받아옴
		
//		System.out.println("naverLogin : " + naverLogin);
//		System.out.println("naver_id : " + naverLogin.get("naver_id"));
//		System.out.println("mobile : " + naverLogin.get("mobile"));
//		System.out.println("gender : " + naverLogin.get("gender"));
//		System.out.println("email : " + naverLogin.get("email"));

		String mi_id = naverLogin.get("naver_id");
		String mobile = naverLogin.get("mobile");
		String mi_gender = naverLogin.get("gender");
		String mi_email = naverLogin.get("email");
		
		int result = loginSvc.chkId(mi_id);
		// System.out.println("chkId 성공");
		if (result != 1) {
			MemberInfo mi = new MemberInfo();
			mi.setMi_id(mi_id);
			mi.setMi_phone(mobile);
			mi.setMi_gender(mi_gender);
			mi.setMi_email(mi_email);
			mi.setMi_type("n");
			
			result = loginSvc.naverInsert(mi);
		}
		// System.out.println("naverInsert 성공");
		
		MemberInfo loginInfo = loginSvc.getkakaoLogin(mi_id);
		
		String returnUrl = request.getParameter("returnUrl");
		if (returnUrl == null)	returnUrl = "redirect:/";
		else 				returnUrl = "redirect:/" + returnUrl.replace('~', '&');
		
		if (loginInfo == null) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("history.back();");
			out.close();
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("loginInfo", loginInfo);
		}
		// System.out.println("session.setAttribute 성공");
		return returnUrl;	// 로그인 처리 후 이동할 페이지 주소
	}

}
