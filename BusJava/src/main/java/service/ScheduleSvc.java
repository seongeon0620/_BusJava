package service;

import static controller.TicketingCtrl.H_API_KEY;
import static controller.TicketingCtrl.S_API_KEY;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import dao.*;
import vo.*;

public class ScheduleSvc {
	private ScheduleDao scheduleDao;

	public void setScheduleDao(ScheduleDao scheduleDao) {
		this.scheduleDao = scheduleDao;
	}

	public List<ScheduleInfo> getScheduleList(String typeCode, JSONObject responseObj, ReservationInfo ri, String formattedNowTime) throws Exception {
		List<ScheduleInfo> scheduleList = new ArrayList<ScheduleInfo>();
		if (typeCode.equals("H")) {
			JSONArray linList = (JSONArray) responseObj.get("line_list");
			for (int i = 0; i < linList.size(); i++) {
				JSONObject linObject = (JSONObject) linList.get(i);

				String fr_time = linObject.get("tim_tim").toString(); // 출발시간 HHmm
				String ri_com = linObject.get("cor_nam").toString(); // 버스회사
				int level_code = Integer.parseInt(linObject.get("bus_gra_o").toString()); // 해당 시간표의 등급코드
				int total_seat = Integer.parseInt(linObject.get("web_cnt").toString()); // 총 좌석수

				String where = "RI_STATUS = '예매' AND RI_LINE_ID = '" + ri.getFr_code() + ri.getTo_code() + "' ";
				if (fr_time.substring(0, 2).equals("24")) { // 출발시간이 24:mm 일 때 날짜에 +1일 시간은 00:mm 로 변경
					where += " AND date(RI_FRDATE) = adddate('" + ri.getRi_frdate() + "', 1) and time(RI_FRDATE) = '00:"
							+ fr_time.substring(2) + ":00'";
				} else {
					where += " AND RI_FRDATE = '" + ri.getRi_frdate() + " " + fr_time.substring(0, 2) + ":"
							+ fr_time.substring(2) + ":00'";
				}
				int reserved_seat = scheduleDao.getReservedSeat(where.toString()); // 예약된 좌석 개수

				String level = "";
				int adult_fee = 0, student_fee = 0, child_fee = 0;
				switch (level_code) {
				case 1:
					level = "우등";
					adult_fee = Integer.parseInt(responseObj.get("exc_amt_100").toString());
					student_fee = hasAmountSchedule(responseObj, "cnt_100", "exc_amt_100");
					child_fee = hasAmountSchedule(responseObj, "chg_cnt_100", "exc_amt_100");
					break;
				case 2:
					level = "고속";
					adult_fee = Integer.parseInt(responseObj.get("exc_amt_050").toString());
					student_fee = hasAmountSchedule(responseObj, "cnt_050", "exc_amt_050");
					child_fee = hasAmountSchedule(responseObj, "chg_cnt_050", "exc_amt_050");
					break;
				case 3:
					level = "심야우등";
					adult_fee = Integer.parseInt(responseObj.get("exm_amt_100").toString());
					student_fee = hasAmountSchedule(responseObj, "amt_050", "exm_amt_100");
					child_fee = hasAmountSchedule(responseObj, "chg_fee_100", "exm_amt_100");
					break;
				case 4:
					level = "심야고속";
					adult_fee = Integer.parseInt(responseObj.get("exc_amt_050").toString());
					student_fee = hasAmountSchedule(responseObj, "amt_100", "exc_amt_050");
					child_fee = hasAmountSchedule(responseObj, "chg_fee_050", "exc_amt_050");
					break;
				case 7:
					level = "프리미엄";
					adult_fee = Integer.parseInt(responseObj.get("cad_cnt").toString());
					student_fee = hasAmountSchedule(responseObj, "pre_cnt", "cad_cnt");
					child_fee = hasAmountSchedule(responseObj, "can_cnt", "cad_cnt");
					break;
				case 8:
					level = "심야프리미엄";
					adult_fee = Integer.parseInt(responseObj.get("cst_cnt").toString());
					student_fee = hasAmountSchedule(responseObj, "rem_tot_cnt", "cst_cnt");
					child_fee = hasAmountSchedule(responseObj, "arr_cnt", "cst_cnt");
					break;
				}

				ScheduleInfo si = new ScheduleInfo();
				si.setRoute_id(ri.getFr_code() + ri.getTo_code());
				si.setFr_time(fr_time.substring(0, 2) + ":" + fr_time.substring(2));
				si.setRi_com(ri_com);
				si.setLevel(level);
				si.setAdult_fee(adult_fee);
				si.setStudent_fee(student_fee);
				si.setChild_fee(child_fee);
				si.setTotal_seat(total_seat);
				si.setLeft_seat(total_seat - reserved_seat);
				scheduleList.add(si);
			}
		} else { // 시외버스 일 경우
			JSONArray linList = (JSONArray) responseObj.get("LINE_LIST");
			for (int i = 0; i < linList.size(); i++) {
				JSONObject linObject = (JSONObject) linList.get(i);

				String fr_time = linObject.get("TIM_TIM").toString(); // 출발시간 HHmm
				String ri_com = linObject.get("COR_NAM").toString(); // 버스회사
				String level_code = linObject.get("BUS_GRA_O").toString(); // 해당 시간표의 등급코드
				String route_id = linObject.get("ROT_ID").toString(); // 노선 ID
				int route_sq = Integer.parseInt(linObject.get("ROT_SQNO").toString()); // 노선 순번
				String alcnDate = linObject.get("ALCN_DT").toString(); // 배차 일자
				int alcnSq = Integer.parseInt(linObject.get("ALCN_SQNO").toString()); // 배차 순번

				int total_seat = Integer.parseInt(linObject.get("WEB_CNT").toString()); // 총 좌석수
				if (convertToMinutes(fr_time) > convertToMinutes(formattedNowTime)) {
					// 시외버스의 경우 api출발시간 파라미터가 작동안하는 이슈로 시간 비교후 이후시간 인 경우 작업 시작

					String where = "RI_STATUS = '예매' AND RI_LINE_ID = '" + ri.getFr_code() + ri.getTo_code() + "' ";
					if (fr_time.substring(0, 2).equals("24")) { // 출발시간이 24:mm 일 때 날짜에 +1일 시간은 00:mm 로 변경
						where += " AND date(RI_FRDATE) = adddate('" + ri.getRi_frdate()
								+ "', 1) and time(RI_FRDATE) = '00:" + fr_time.substring(2);
					} else {
						where += " AND RI_FRDATE = '" + ri.getRi_frdate() + " " + fr_time.substring(0, 2) + ":"
								+ fr_time.substring(2);
					}

					int reserved_seat = scheduleDao.getReservedSeat(where.toString());

					/*
					 * 등급코드 IDB 프리미엄 프리미엄(일반) IDG 일반 IDP 우등 IDW 프리미엄 프리미엄(주말) INB 심야프리미엄(일반) ING
					 * 심야일반 INP 심야우등 INW 심야프리미엄(주말)
					 */
					String level = "";
					if (level_code.equals("IDB") || level_code.equals("IDW"))
						level = "프리미엄";
					else if (level_code.equals("INB") || level_code.equals("INW"))
						level = "심야프리미엄";
					else if (level_code.equals("IDG"))
						level = "일반";
					else if (level_code.equals("ING"))
						level = "심야일반";
					else if (level_code.equals("IDP"))
						level = "우등";
					else if (level_code.equals("INP"))
						level = "심야우등";

					ScheduleInfo si = new ScheduleInfo();
					si.setRoute_id(route_id);
					si.setFr_time(fr_time.substring(0, 2) + ":" + fr_time.substring(2));
					si.setTotal_seat(total_seat);
					si.setLeft_seat(total_seat - reserved_seat);
					si.setRi_com(ri_com);
					si.setLevel(level);
					si.setRoute_sq(route_sq);
					si.setDispatch_date(alcnDate);
					si.setDispatch_sq(alcnSq);
					scheduleList.add(si);
				}
			}

			if (scheduleList.size() > 0) { // 시외버스 배차리스트에 대한 상세 좌석 정보 조회 API (요금정보요청)
				String apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/xzzIbtInfoGet/v1/ibt_info/" + ri.getFr_code()
						+ "/" + ri.getTo_code() + "/" + scheduleList.get(0).getRoute_id() + "/"
						+ scheduleList.get(0).getRoute_sq() + "/" + scheduleList.get(0).getDispatch_date() + "/"
						+ scheduleList.get(0).getDispatch_sq();

				URL url = new URL(apiUrl);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Content-type", "application/json");
				conn.setRequestProperty("x-Gateway-APIKey", S_API_KEY);

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
				JSONObject joTmp = (JSONObject) jo.get("response");
				int adult_fee = Integer.parseInt(joTmp.get("TCK_FEE1").toString());
				int student_fee = Integer.parseInt(joTmp.get("TCK_FEE1").toString());
				int child_fee = hasAmountSchedule(joTmp, "TCK_FEE2", "TCK_FEE1");

				List<ScheduleInfo> scheduleListAddPrice = new ArrayList<>();
				for (ScheduleInfo si : scheduleList) {
					si.setAdult_fee(adult_fee);
					si.setStudent_fee(student_fee);
					si.setChild_fee(child_fee);
					scheduleListAddPrice.add(si);
				}
			}
		}
		return scheduleList;
	}

	// "hhmm" 형태의 문자열을 분으로 변환 (util)
	private static int convertToMinutes(String time) {
		int hours = Integer.parseInt(time.substring(0, 2));
		int minutes = Integer.parseInt(time.substring(2));
		return hours * 60 + minutes;
	}

	// 중고생, 아동요금 처리 메서드
	private int hasAmountSchedule(JSONObject obj, String origin_name, String change_name) {
		int result = 0;
		if (obj.get(origin_name).toString() != null) {
			result = Integer.parseInt(obj.get(origin_name).toString());
			if (result == 0) {
				result = Integer.parseInt(obj.get(change_name).toString());
			}
		}
		return result;
	}

	public List<TerminalInfo> getDepartureTerminal(String selectedArea) {
		// 선택한 출발지역에 있는 터미널 이름
		List<TerminalInfo> departureTerminal = scheduleDao.getDepartureTerminal(selectedArea);
		return departureTerminal;
	}

	public List<TerminalInfo> getArrTerminal(String departureTCode, JSONArray linList) {
		// 출발 터미널 코드와 JSONArray linList로 도착터미널을 특정 짓는 메서드
		List<TerminalInfo> arrTerminal = scheduleDao.getArrTerminal(departureTCode, linList);
		return arrTerminal;
	}

	public List<TerminalInfo> getAreaList(String kind) {
		// 지역명으로 찾기 버튼에 들어갈 지역명리스트를 반환하는 메서드
		List<TerminalInfo> areaList = scheduleDao.getAreaList(kind);
		return areaList;
	}

	public List<TerminalInfo> getTerminalList(String type, String val, int cpage, int psize) {
		// 받아온 지역명 또는 터미널명으로 해당 지역에 있는 터미널리스트를 반환하는 메서드
		List<TerminalInfo> terminalList = scheduleDao.getTerminalList(type, val, cpage, psize);
		return terminalList;
	}

	public int getTerminalCnt(String schtype, String val) {
		// 검색된 터미널의 총 개수를 반환하는 메서드
		int result = scheduleDao.getTerminalCnt(schtype, val);
		return result;
	}

}
