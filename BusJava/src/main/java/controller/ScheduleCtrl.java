package controller;

import java.util.*;
import java.io.*;
import java.lang.invoke.CallSite;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.*;

import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import service.*;
import vo.*;

@Controller
public class ScheduleCtrl {
// 시간표 조회, 도착시간, 터미널 안내에 관련 모든 기능에 대한 컨트롤러
	private ScheduleSvc scheduleSvc;

	public void setScheduleSvc(ScheduleSvc scheduleSvc) {
		this.scheduleSvc = scheduleSvc;
	}

	@GetMapping("/schedule")
	public String schedule() {
		// 시간표 조회 메뉴
		return "raceinfo/schedule";
	}

	@PostMapping("/getSchedule")
	@ResponseBody
	public List<ScheduleInfo> getSchedule(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String frDate = request.getParameter("frDate").replace(".", "-");
		String typeCode = request.getParameter("busType");
		String frName = request.getParameter("sPoint");
		String toName = request.getParameter("ePoint");
		String frCode = request.getParameter("frCode");
		String toCode = request.getParameter("toCode");

		String today = getCurrentDateTime(); // 오늘 년월일시분초 yyyyMMddHHmmss
		String formattedNowTime = today.substring(8, 12);	// 오늘 시분 HHmm
		
		if (!request.getParameter("frDate").replace(".", "").equals(today.substring(0, 8))) // 출발일이 오늘이 아니면
			formattedNowTime = "0001"; // 실 출발시간을 00시01분으로 setting

		String common = frDate.replace("-", "") + "/" + formattedNowTime + "/" + frCode + "/" + toCode;
//		System.out.println(common);	// yyyyMMdd/HHmm/frCode/toCode
		String apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/koIbtList/v1/ibt_list/" + common + "/0/0/9";	// 고속버스 배차 리스트 조회 API 조회flag/업무구분/등급
		if (typeCode.equals("S")) {
			apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/xzzIbtListGet/v1/ibt_list/" + common + "/9/0";	// 시외버스 배차 리스트 조회 API 조회flag/조회flag
		}

		URL url = new URL(apiUrl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");

		if (typeCode.equals("H"))
			conn.setRequestProperty("x-Gateway-APIKey", TicketingCtrl.H_API_KEY);
		else
			conn.setRequestProperty("x-Gateway-APIKey", TicketingCtrl.S_API_KEY);

		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
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
		JSONObject jo = (JSONObject) p.parse(sb.toString());
		JSONObject responseObj = (JSONObject) jo.get("response");
		// 고속버스 - "line_list"	시외버스 - "LINE_LIST"
		
		/* HttpSession session = request.getSession(); */
		List<ScheduleInfo> scheduleList = null;

		ReservationInfo ri1 = new ReservationInfo();
		ri1.setRi_frdate(frDate);
		ri1.setFr_code(frCode);
		ri1.setTo_code(toCode);
		ri1.setRi_fr(frName);
		ri1.setRi_to(toName);
		ri1.setRi_line_type(typeCode);

		if (typeCode.equals("H"))
			ri1.setRi_line_id(frCode + toCode);	// 노선ID
		
		if (responseObj != null) { // 시간표가 있는 경우 작업 수행
			scheduleList = scheduleSvc.getScheduleList(typeCode, responseObj, ri1, formattedNowTime);
		}
		
		return scheduleList;
	}

	@GetMapping("/arrivaltime")
	public String arrivaltime(Model model, HttpServletRequest request) throws Exception {
		// 도착시간 안내 메뉴
		String kind = "h"; // getAreaList메서드 호출 시 구분자(시외버스)
		List<TerminalInfo> areaList = scheduleSvc.getAreaList(kind); // 지역명리스트
		request.setAttribute("areaList", areaList);
		return "raceinfo/arrival_time";
	}

	@PostMapping("/getDepartureTerminal")
	@ResponseBody
	public List<TerminalInfo> getDepartureTerminal(HttpServletRequest request) throws Exception {
		// 지역 선택 시 해당 지역에 있는 터미널 리스트를 불러오는 메서드
		request.setCharacterEncoding("utf-8");

		String selectedArea = request.getParameter("selectedArea");
//		System.out.println(selectedArea);

		List<TerminalInfo> departureTerminal = scheduleSvc.getDepartureTerminal(selectedArea);

		return departureTerminal;
	}

	public String getCurrentDateTime() {
		// 고속버스 배차리스트 기초코드 조회 시 필수요소인 조회일시를 생성하는 메서드
		Date currentDate = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String formattedDate = dateFormat.format(currentDate);

		return formattedDate;
	}

	@PostMapping("/getArrTerminal")
	@ResponseBody
	public List<TerminalInfo> getArrivalTerminal(HttpServletRequest request) throws Exception {
		// 출발 터미널 선택 시 api를 호출 하여 line_list를 받아 출발지역 코드와 대조하여 도착 터미널을 반환
		request.setCharacterEncoding("utf-8");
		String departureTCode = request.getParameter("selectedTerminal"); // 선택한 터미널의 코드를 받아옴

		String askDateTime = getCurrentDateTime(); // 조회일시
//		String apiKey = "81a754c8-9166-451d-8a66-aa65f64775ab";	// 고속버스 api 키
		StringBuilder urlBuilder = new StringBuilder(
				"https://apigw.tmoney.co.kr:5556/gateway/koLoadInfo/v1/load_info/" + askDateTime); /* URL */

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		conn.setRequestProperty("x-Gateway-APIKey", TicketingCtrl.H_API_KEY);
		System.out.println("Response code: " + conn.getResponseCode());

		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
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
		System.out.println(sb.toString());

		JSONParser p = new JSONParser();
		JSONObject jo = (JSONObject) p.parse(sb.toString());

		JSONObject responseObj = (JSONObject) jo.get("response");
		JSONArray linList = (JSONArray) responseObj.get("lin_list"); // 노선코드 LIN_COD

		List<TerminalInfo> arrTerminal = scheduleSvc.getArrTerminal(departureTCode, linList);

		return arrTerminal;
	}

	@PostMapping("/getArrivalTimeInfo")
	@ResponseBody
	public List<ArriveInfo> getArrivalTimeInfo(HttpServletRequest request) throws Exception {
		// 도착시간 안내 조회버튼 클릭 시 도착 안내 정보 api 호출
		request.setCharacterEncoding("utf-8");
		String dTName = request.getParameter("departureTerminal"); // 출발 터미널 명
		String aTCode = request.getParameter("arrivalTerminal"); // 도착 터미널 코드

//		String apiKey = "81a754c8-9166-451d-8a66-aa65f64775ab";	// 고속버스 api 키
		StringBuilder urlBuilder = new StringBuilder(
				"https://apigw.tmoney.co.kr:5556/gateway/koArrList/v1/arr_list/" + aTCode); /* URL */

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		conn.setRequestProperty("x-Gateway-APIKey", TicketingCtrl.H_API_KEY);
		System.out.println("Response code: " + conn.getResponseCode());

		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
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
		System.out.println(sb.toString());

		JSONParser p = new JSONParser();
		JSONObject jo = (JSONObject) p.parse(sb.toString());

		JSONObject responseObj = (JSONObject) jo.get("response");
		JSONArray arrList = (JSONArray) responseObj.get("arrList"); // 도착안내리스트
		// ArriveInfo형 ai로 받기
		List<ArriveInfo> arriveList = new ArrayList<ArriveInfo>();
		for (int i = 0; i < arrList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj = (JSONObject) arrList.get(i);

			if (obj.get("FR_TER_NAM").equals(dTName)) {
				String grade = "";
				switch (obj.get("BUS_GRA").toString()) {
				case "1":
					grade = "우등";			break;
				case "2":
					grade = "고속";			break;
				case "3":
					grade = "심야우등";		break;
				case "4":
					grade = "심야고속";		break;
				case "7":
					grade = "프리미엄";		break;
				case "8":
					grade = "심야프리미엄";		break;
				case "9":
					grade = "전체등급";		break;
				case "0":
					grade = "전체프리미엄";		break;
				}
				String ltime = "";
				String stime = obj.get("TIM_TIM").toString().substring(0, 2) + ":"
						+ obj.get("TIM_TIM").toString().substring(2);
				String etime = obj.get("V_NEED_TIM").toString().substring(0, 2) + ":"
						+ obj.get("V_NEED_TIM").toString().substring(2);
				if (obj.get("RMN_TIM").toString().equals("0000")) {
					ltime = "-";
				} else {
					ltime = obj.get("RMN_TIM").toString().substring(0, 2) + ":"
							+ obj.get("RMN_TIM").toString().substring(2);
				}

				ArriveInfo ai = new ArriveInfo();
				ai.setBh_name(obj.get("TO_TER_NAM").toString());
				ai.setStime(stime);
				ai.setCom(obj.get("CORNAM").toString());
				ai.setNum(obj.get("CNO").toString());
				ai.setGrade(grade);
				ai.setEtime(etime);
				ai.setLtime(ltime);
				ai.setStatus(obj.get("STG_NAM").toString());
				arriveList.add(ai);
			}
		}

		return arriveList;
	}

	@GetMapping("/terminalPlace")
	public String terminalPlace(HttpServletRequest request) throws Exception {
		// 터미널 안내 메뉴
		request.setCharacterEncoding("utf-8");
		String schtype = "";
		String btarea = request.getParameter("btarea");
		String keyword = request.getParameter("keyword");
		String args = "", schargs = "";
		String kind = "s"; // getAreaList메서드 호출 시 구분자(시외버스)

		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 10, bsize = 5;
		if (request.getParameter("cpage") != null) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}

		if (btarea != null) {
			schtype = "area";
			rcnt = scheduleSvc.getTerminalCnt(schtype, btarea);
			List<TerminalInfo> terminalList = scheduleSvc.getTerminalList(schtype, btarea, cpage, psize); // 지역명, 터미널명,
																											// 주소
			request.setAttribute("terminalList", terminalList);
			schargs = "&btarea=" + btarea;
		}

		if (keyword != null) {
			if (keyword.indexOf("터미널") > 0) {
				keyword = keyword.substring(0, keyword.indexOf("터미널"));
			}
			keyword = keyword.trim();
			schtype = "name";
			rcnt = scheduleSvc.getTerminalCnt(schtype, keyword);
			List<TerminalInfo> terminalList = scheduleSvc.getTerminalList(schtype, keyword, cpage, psize); // 지역명, 터미널명,
																											// 주소
			request.setAttribute("terminalList", terminalList);
			schargs = "&keyword=" + keyword;
		}

		args = "&cpage=" + cpage + schargs;

		pcnt = rcnt / psize;
		if (rcnt % psize > 0)
			pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;

		PageInfo pi = new PageInfo();
		pi.setBsize(bsize);			pi.setCpage(cpage);			pi.setPcnt(pcnt);
		pi.setPsize(psize);			pi.setRcnt(rcnt);			pi.setSpage(spage);
		pi.setSchtype(schtype);		pi.setArgs(args);			pi.setSchargs(schargs);

		request.setAttribute("pi", pi);
		
		List<TerminalInfo> areaList = scheduleSvc.getAreaList(kind); // 지역명리스트
		request.setAttribute("areaList", areaList);

		return "raceinfo/terminal_place";
	}
}
