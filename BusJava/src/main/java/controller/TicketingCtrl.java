package controller;

import java.util.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.*;

import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.*;

import service.*;
import vo.*;

@Controller
public class TicketingCtrl {
	private TicketingSvc ticketingSvc;
	public static final String H_API_KEY = "81a754c8-9166-451d-8a66-aa65f64775ab";
	public static final String S_API_KEY = "43fa6411-8371-45e6-9731-b3e00a9df24d";
			
	public void setTicketingSvc(TicketingSvc ticketingSvc) {
		this.ticketingSvc = ticketingSvc;
	}

	@GetMapping("/pmoneyInfo")
	public String pmoneyInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		if (loginInfo == null) {
			out.println("<script>");
			out.println("alert('해당 메뉴는 회원 전용 메뉴입니다. 로그인 후 다시 시도하세요.');");
			out.println("location.href='memberLogin?returnUrl=pmoneyInfo';");
			out.println("</script>");
			out.close();
		}
		return "member/paymoney_info";
	}

	@GetMapping("/pmoneyCharge1")
	public String pmoneyCharge1() {
		return "popup/paymoney_charge1";
	}

	@GetMapping("/pmoneyCharge2")
	public String pmoneyCharge2() {
		return "popup/paymoney_charge2";
	}

	@PostMapping("/chargePaymoney")
	@ResponseBody
	public int chargePmoney(HttpServletRequest request, @RequestParam String payment, @RequestParam int realAmount) {
		// chargePmoney에 해당하는 값을 해당 회원의 아이디에 충전후 충전금액 리턴
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");

		if (payment.equals("card"))		payment = "카드";
		else if (payment.equals("bankbook"))	payment = "무통장입금";
		else if (payment.equals("simplepay"))	payment = "간편결제";

		PaymoneyCharge pc = new PaymoneyCharge();
		pc.setPayment(payment);
		pc.setReal_price(realAmount);
		pc.setTotal_point(realAmount + (realAmount / 10));

		return ticketingSvc.chargePaymoney(loginInfo, pc);
	}

	@GetMapping("ticket/step01")
	public String ticketingStep01(HttpServletRequest request, @RequestParam String type) {
		request.setAttribute("typeCode", type.toUpperCase());		// 타입코드 H: 고속, S: 시외
		return "ticketing/ticket_step1";
	}
	

	// 출발지 선택 팝업
	@GetMapping("/pickSpot")
	public String pickSpot(HttpServletRequest request, @RequestParam String typeCode, @RequestParam(required = false) String keyword) throws Exception {
		List<TerminalInfo> terminalList = ticketingSvc.getTerminalList(typeCode);
		request.setAttribute("typeCode", typeCode);
		request.setAttribute("terminalList", terminalList);
		if (keyword != null) request.setAttribute("keyword", keyword);

		return "popup/pick_spot";
	}
	
	// 출발지 선택 팝업에서 키워드 검색시
	@GetMapping("/getKeywordList")
	@ResponseBody
	public List<TerminalInfo> getKeywordList(@RequestParam String typeCode, @RequestParam String keyword) throws Exception {
		List<TerminalInfo> keywordList = ticketingSvc.getTerminalList(typeCode, keyword);
		return keywordList;
	}
	
	@GetMapping("/ticket/getToSpot")
	@ResponseBody
	public List<TerminalInfo> getToSpot(@RequestParam String frCode, @RequestParam String typeCode) throws Exception {
		String apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/koLoadInfo/v1/load_info/20230901180000";
		if (typeCode.equals("S")) {
			apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/xzzLinListGet/v1/lin_list/s/" + frCode;
		}
		
		URL url = new URL(apiUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		
		if (typeCode.equals("H")) conn.setRequestProperty("x-Gateway-APIKey", H_API_KEY);
		else	conn.setRequestProperty("x-Gateway-APIKey", S_API_KEY);
		
		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
		    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
		    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
		    sb.append(line);
		}
		rd.close();
		conn.disconnect();
		
		JSONParser p = new JSONParser();
        JSONObject jo = (JSONObject)p.parse(sb.toString());
        JSONObject response = (JSONObject) jo.get("response");
        List<TerminalInfo> toSpotList = ticketingSvc.getTerminalList(typeCode, frCode, response);

		return toSpotList;
	}
	
	@PostMapping("/ticket/step02")
	public String ticketingStep02(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String typeCode = request.getParameter("type");
		String mode = request.getParameter("mode");
		String frDate = request.getParameter("frDate").replace(".", "-");	
		String frName = request.getParameter("frName");
		String toName = request.getParameter("toName");
		String frCode = request.getParameter("frCode");
		String toCode = request.getParameter("toCode");
		
		LocalTime nowTime = LocalTime.now();
		LocalDate nowDate = LocalDate.now();
		DateTimeFormatter formatterTime = DateTimeFormatter.ofPattern("HHmm");
		DateTimeFormatter formatterDate = DateTimeFormatter.ofPattern("yyyyMMdd");
		String formattedNowTime = nowTime.format(formatterTime);
	 
		boolean isToday = frDate.replace("-", "").equals(nowDate.format(formatterDate));
		String common = frDate.replace("-", "") + "/";
		if (isToday) {	// 당일 시간표를 조회하는 경우 이후 시간을 조회
			common += formattedNowTime + "/" + frCode + "/" + toCode;
		} else {
			common += "0000/" + frCode + "/" + toCode;
		}
		 
		String apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/koIbtList/v1/ibt_list/" + common + "/0/0/9";
		if (typeCode.equals("S")) {
			apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/xzzIbtListGet/v1/ibt_list/" + common + "/9/0";
		}
		
		URL url = new URL(apiUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		
		if (typeCode.equals("H")) conn.setRequestProperty("x-Gateway-APIKey", H_API_KEY);
		else	conn.setRequestProperty("x-Gateway-APIKey", S_API_KEY);
		
		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
		    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
		    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
		    sb.append(line);
		}
		rd.close();
		conn.disconnect();
		
		JSONParser p = new JSONParser();
        JSONObject jo = (JSONObject)p.parse(sb.toString());
        JSONObject response = (JSONObject) jo.get("response");
        System.out.println(response);
        HttpSession session = request.getSession();
        List<ScheduleInfo> scheduleList = null;
        
        ReservationInfo ri1 = new ReservationInfo();
		ri1.setMode(mode);
		ri1.setRi_frdate(frDate);
		ri1.setFr_code(frCode);
		ri1.setTo_code(toCode);
		ri1.setRi_fr(frName);
		ri1.setRi_to(toName);
		ri1.setRi_line_type(typeCode);
		if(typeCode.equals("H"))	ri1.setRi_line_id(frCode + toCode);
		
		if (mode.equals("w")) { // 왕복일경우 오는날 예약정보를 담을 세션 추가생성
			String toDate = request.getParameter("toDate").replace('.', '-');
			ReservationInfo ri2 = new ReservationInfo();
			ri2.setMode(mode);
			ri2.setRi_frdate(toDate);
			ri2.setFr_code(toCode);
			ri2.setTo_code(frCode);
			ri2.setRi_fr(toName);
			ri2.setRi_to(frName);
			ri2.setRi_line_type(typeCode);
			
			if(typeCode.equals("H"))	ri2.setRi_line_id(frCode + toCode);
			
			session.setAttribute("ri2", ri2);
		}
        if (response != null) {	// 시간표가 있는 경우 작업 수행
    		scheduleList = ticketingSvc.getScheduleList(typeCode, response, ri1);
        }
        session.setAttribute("scheduleList", scheduleList);
        session.setAttribute("ri1", ri1);
		
		return "ticketing/ticket_step2";
	}

	@PostMapping("/ticket/step03")
	public String ticketingStep03(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String routeId = request.getParameter("routeId");
		String frTime = request.getParameter("frTime");
		String toTime = request.getParameter("toTime");
		String company = request.getParameter("company");
		String lineLevel = request.getParameter("lineLevel");
		int adultFee = Integer.parseInt(request.getParameter("adultFee"));
		int studentFee = Integer.parseInt(request.getParameter("teenFee"));
		int childFee = Integer.parseInt(request.getParameter("childFee"));
		
		HttpSession session = request.getSession();
		ReservationInfo ri1 = (ReservationInfo) session.getAttribute("ri1");

		// 출발시간과 도착시간 모두 String으로 받아와서 LocalTime으로 바꾼 뒤 값 비교.
		LocalTime fr_time_local = LocalTime.of(Integer.parseInt(frTime.substring(0, 2)), Integer.parseInt(frTime.substring(3)), 00);
		LocalTime to_time_local = LocalTime.of(Integer.parseInt(toTime.substring(0, 2)), Integer.parseInt(toTime.substring(3)), 00);
		if (!fr_time_local.isBefore(to_time_local))	{
			LocalDate tmp = LocalDate.of(Integer.parseInt(ri1.getRi_frdate().substring(0, 4)), Integer.parseInt(ri1.getRi_frdate().substring(5, 7)), Integer.parseInt(ri1.getRi_frdate().substring(8)));
			tmp.plusDays(1);
			ri1.setRi_todate(tmp + " " + toTime + ":00");
		} else ri1.setRi_todate(ri1.getRi_frdate() + " " + toTime + ":00");
		
		if(ri1.getRi_line_type().equals("S"))	ri1.setRi_line_id(routeId);
		ri1.setRi_frdate(ri1.getRi_frdate() + " " + frTime + ":00");
		ri1.setAdult_fee(adultFee);
		ri1.setStudent_fee(studentFee);
		ri1.setChild_fee(childFee);
		ri1.setRi_level(lineLevel);
		ri1.setRi_com(company);
		session.setAttribute("ri1", ri1);

		List<Integer> seatList = ticketingSvc.getSeatList(ri1);
		session.setAttribute("seatList", seatList);
		
		return "ticketing/ticket_step3";
	}
	
	@PostMapping("/ticket/step04")
	public String ticketingStep04(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		ReservationInfo ri1 = (ReservationInfo)session.getAttribute("ri1");
		int adultCnt = Integer.parseInt(request.getParameter("adultCnt"));
		int teenCnt = Integer.parseInt(request.getParameter("teenCnt"));
		int childCnt = Integer.parseInt(request.getParameter("childCnt"));
		int totalFee = Integer.parseInt(request.getParameter("totalFee"));
		String[] seatsGo = request.getParameterValues("seatBoxDtl");
		String seatListGo = "";
		for (String seatGo : seatsGo) {
			seatListGo += ", " + seatGo;
		}
		
		ri1.setRi_acnt(adultCnt);
		ri1.setRi_scnt(teenCnt);
		ri1.setRi_ccnt(childCnt);
		ri1.setTotalFee(totalFee);
		ri1.setSeat(seatListGo.substring(2));
		ri1.setSeatList(Arrays.asList(seatsGo));
		
		ReservationInfo ri2 = (ReservationInfo)session.getAttribute("ri2");
		ri2.setRi_acnt(adultCnt);
		ri2.setRi_scnt(teenCnt);
		ri2.setRi_ccnt(childCnt);
		
		String typeCode = ri1.getRi_line_type();
	 
		String formattedTime = null;
		boolean isEqual = ri1.getRi_frdate().substring(0, 10).equals(ri2.getRi_frdate());
		String common = ri2.getRi_frdate().replace("-", "") + "/";
		if (isEqual) {	// 가는편과 동일한 일자의 시간표를 조회하는 경우 가는편 이후 시간을 조회
			formattedTime = ri1.getRi_todate().substring(11, 16).replace(":", "");
			common += formattedTime + "/" + ri2.getFr_code() + "/" + ri2.getTo_code();
			
		} else {
			formattedTime = "0000";
			common += formattedTime + "/" + ri2.getFr_code() + "/" + ri2.getTo_code();
		}
		
		String apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/koIbtList/v1/ibt_list/" + common + "/0/0/9";
		if (typeCode.equals("S")) {
			apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/xzzIbtListGet/v1/ibt_list/" + common + "/9/0";
		}
		
		System.out.println(apiUrl);
		URL url = new URL(apiUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		
		if (typeCode.equals("H")) conn.setRequestProperty("x-Gateway-APIKey", H_API_KEY);
		else	conn.setRequestProperty("x-Gateway-APIKey", S_API_KEY);
		
		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
		    rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
		    rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
		    sb.append(line);
		}
		rd.close();
		conn.disconnect();
		
		JSONParser p = new JSONParser();
        JSONObject jo = (JSONObject)p.parse(sb.toString());
        JSONObject response = (JSONObject) jo.get("response");
        List<ScheduleInfo> scheduleList = null;
        
        System.out.println(response);
        if (response != null) {	// 시간표가 있는 경우 작업 수행
			scheduleList = ticketingSvc.getScheduleList(typeCode, response, ri2);
        }
        session.setAttribute("scheduleList", scheduleList);
        session.setAttribute("ri1", ri1);
        session.setAttribute("ri2", ri2);
		
		return "ticketing/ticket_step4";
	}
	
	@PostMapping("/ticket/step05")
	public String ticketingStep05(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		String routeId = request.getParameter("routeId");
		String frTime = request.getParameter("frTime");
		String toTime = request.getParameter("toTime");
		String company = request.getParameter("company");
		String lineLevel = request.getParameter("lineLevel");
		int adultFee = Integer.parseInt(request.getParameter("adultFee"));
		int studentFee = Integer.parseInt(request.getParameter("teenFee"));
		int childFee = Integer.parseInt(request.getParameter("childFee"));
		
		HttpSession session = request.getSession();
		ReservationInfo ri2 = (ReservationInfo) session.getAttribute("ri2");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		if (ri2 == null) {
			out.println("<script>");
			out.println("alert('시간이 경과되었습니다.\\예매를 다시 시도해주세요.')");
			out.println("location.href='../memberLogin';");
			out.println("</script>");
			out.close();
		}
		
		// 출발시간과 도착시간 모두 String으로 받아와서 LocalTime으로 바꾼 뒤 값 비교.
		LocalTime fr_time_local = LocalTime.of(Integer.parseInt(frTime.substring(0, 2)), Integer.parseInt(frTime.substring(3)), 00);
		LocalTime to_time_local = LocalTime.of(Integer.parseInt(toTime.substring(0, 2)), Integer.parseInt(toTime.substring(3)), 00);
		if (!fr_time_local.isBefore(to_time_local))	{
			LocalDate tmp = LocalDate.of(Integer.parseInt(ri2.getRi_frdate().substring(0, 4)), Integer.parseInt(ri2.getRi_frdate().substring(5, 7)), Integer.parseInt(ri2.getRi_frdate().substring(8)));
			tmp.plusDays(1);
			ri2.setRi_todate(tmp + " " + toTime + ":00");
		} else ri2.setRi_todate(ri2.getRi_frdate() + " " + toTime + ":00");
		
		if(ri2.getRi_line_type().equals("S"))	ri2.setRi_line_id(routeId);
		
		ri2.setRi_frdate(ri2.getRi_frdate() + " " + frTime + ":00");
		ri2.setAdult_fee(adultFee);
		ri2.setStudent_fee(studentFee);
		ri2.setChild_fee(childFee);
		ri2.setRi_level(lineLevel);
		ri2.setRi_com(company);
		session.setAttribute("ri2", ri2);

		List<Integer> seatList = ticketingSvc.getSeatList(ri2);
		session.setAttribute("seatList", seatList);

		return "ticketing/ticket_step5";
	}
	
	@PostMapping("/ticket/payment")
	public String payment(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		
		HttpSession session = request.getSession();
		ReservationInfo ri1 = (ReservationInfo)session.getAttribute("ri1");
		MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		if (loginInfo == null || ri1 == null) {
			out.println("<script>");
			out.println("alert('시간이 경과되었습니다.\\예매를 다시 시도해주세요.')");
			out.println("location.href='../memberLogin';");
			out.println("</script>");
			out.close();
		}
		
		if (ri1.getRi_line_type().equals("H")) ri1.setRi_line_type("고속");
		else	ri1.setRi_line_type("시외");
		
		if(ri1.getMode().equals("p")) {	// 편도일 경우
			int adultCnt = Integer.parseInt(request.getParameter("adultCnt"));
			int teenCnt = Integer.parseInt(request.getParameter("teenCnt"));
			int childCnt = Integer.parseInt(request.getParameter("childCnt"));
			int totalFee = Integer.parseInt(request.getParameter("totalFee"));
			String[] seatsGo = request.getParameterValues("seatBoxDtl");
			String seatListGo = "";
			for (String seat : seatsGo) {
				seatListGo += ", " + seat;
			}

			ri1.setRi_acnt(adultCnt);
			ri1.setRi_scnt(teenCnt);
			ri1.setRi_ccnt(childCnt);
			ri1.setTotalFee(totalFee);
			ri1.setSeat(seatListGo.substring(2));
			ri1.setSeatList(Arrays.asList(seatsGo));
			session.setAttribute("ri1", ri1);
		} else {	// 왕복일 경우
			ReservationInfo ri2 = (ReservationInfo)session.getAttribute("ri2");
			int totalFee = Integer.parseInt(request.getParameter("totalFee"));
			String[] seatsCome = request.getParameterValues("seatBoxDtl");
			String seatListCome = "";
			for (String seat : seatsCome) {
				seatListCome += ", " + seat;
			}
			
			ri2.setRi_line_type(ri1.getRi_line_type());
			ri2.setTotalFee(totalFee);
			ri2.setSeat(seatListCome.substring(2));
			ri2.setSeatList(Arrays.asList(seatsCome));
			if (ri2.getRi_line_type().equals("고속")) ri2.setRi_line_type("고속");
			else	ri2.setRi_line_type("시외");
			
			session.setAttribute("ri1", ri1);
			session.setAttribute("ri2", ri2);
		}
		
		int discount = 0;
		String couponType = "";
		if (ri1.getRi_acnt() != 0) {
			couponType = "성인";
			discount = ri1.getAdult_fee();
		} else if (ri1.getRi_scnt() != 0) {
			couponType = "청소년";
			discount = ri1.getStudent_fee();
		} else if (ri1.getRi_ccnt() != 0) { 
			couponType = "아동";
			discount = ri1.getChild_fee();  
		}
		
		request.setAttribute("couponType", couponType);
		request.setAttribute("discount", discount);

		return "ticketing/ticket_pay";
	}
	
	// 쿠폰 선택 팝업
	@GetMapping("/pickCoupon")
	public String pickCoupon(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
		
		List<UserResourceInfo> couponList = ticketingSvc.getUserCoupon(loginInfo.getMi_id());
		
		request.setAttribute("couponList", couponList);
		return "popup/pick_coupon";
	}
	
	@PostMapping("/ticket/result")
	public String hTicketingResult(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
		ReservationInfo ri1 = (ReservationInfo) session.getAttribute("ri1");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		if (loginInfo == null || ri1 == null) {
			out.println("<script>");
			out.println("alert('시간이 경과되었습니다.\\예매를 다시 시도해주세요.')");
			out.println("location.href='../memberLogin';");
			out.println("</script>");
			out.close();
		}
		
		String payment = request.getParameter("paymentOpt");
		String couponType = request.getParameter("couponType");
		int couponId = Integer.parseInt(request.getParameter("couponId"));
		int discountFee = Integer.parseInt(request.getParameter("discount"));
		boolean useCoupon = request.getParameter("useCoupon").equals("true");
		int totalCnt = ri1.getRi_acnt() + ri1.getRi_scnt() + ri1.getRi_ccnt();
		
		if(useCoupon && totalCnt == 1) {
			ri1.setPayment("쿠폰");
			ri1.setDiscountFee(discountFee);
			ri1.setCoupon_type(couponType);
			
		} else if (useCoupon && totalCnt != 0) {
			ri1.setPayment(payment);
			ri1.setDiscountFee(discountFee);
			ri1.setCoupon_type(couponType);
			
		} else {
			ri1.setPayment(payment);
			ri1.setDiscountFee(0);
			ri1.setCoupon_type(null);
		}
				
		ri1.setCoupon_id(couponId);
		List<String> seatsGo = ri1.getSeatList();
		ReservationInfo ri2 = null;
		
		Map<String, Object> reservedInfo = ticketingSvc.reservationIn(loginInfo, ri1);
		if (ri1.getMode().equals("w")) {	// 왕복일 경우
			ri2 = (ReservationInfo)session.getAttribute("ri2");
			ri2.setPayment(payment);
			ri2.setDiscountFee(0);
			ri2.setCoupon_type(null);
			
			ticketingSvc.reservationIn(loginInfo, ri2);
		}
		
		String reservedPayment = "";
		if (ri2 != null) reservedPayment = ri2.getPayment();
		else if (ri1.getPayment().equals("쿠폰") && totalCnt != 0)	reservedPayment = ri1.getPayment();
		else reservedPayment = ri1.getPayment();
		
		request.setAttribute("reservedDate", reservedInfo.get("reservedDate"));
		request.setAttribute("reservedPayment", reservedPayment);
		
		return "ticketing/ticket_result";
	}
	
	@GetMapping("/mypage/stamp")
	public String myStamp(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		if (loginInfo == null) {
			out.println("<script>");
			out.println("alert('해당 메뉴는 회원 전용 메뉴입니다. 로그인 후 다시 시도하세요.');");
			out.println("location.href='../memberLogin?returnUrl=mypage/stamp';");
			out.println("</script>");
			out.close();
		}
		
		List<UserResourceInfo> stampHistoryList = ticketingSvc.getUserResource("S", loginInfo.getMi_id());
		
		request.setAttribute("stampHistoryList", stampHistoryList);
		return "member/stamp";
	}
	
	@GetMapping("/mypage/coupon")
	public String myCoupon(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		if (loginInfo == null) {
			out.println("<script>");
			out.println("alert('해당 메뉴는 회원 전용 메뉴입니다. 로그인 후 다시 시도하세요.');");
			out.println("location.href='../memberLogin?returnUrl=mypage/coupon';");
			out.println("</script>");
			out.close();
		}
		
		List<UserResourceInfo> couponList = ticketingSvc.getUserCoupon(loginInfo.getMi_id());
		List<UserResourceInfo> couponHistoryList = ticketingSvc.getUserResource("C", loginInfo.getMi_id());
		
		request.setAttribute("couponList", couponList);
		request.setAttribute("couponHistoryList", couponHistoryList);
		return "member/coupon";
	}
}
