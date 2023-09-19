package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.transaction.annotation.Transactional;

import static controller.TicketingCtrl.*;
import dao.*;
import vo.*;

public class TicketingSvc {
	private TicketingDao ticketingDao;

	public void setTicketingDao(TicketingDao ticketingDao) {
		this.ticketingDao = ticketingDao;
	}

	public List<TerminalInfo> getTerminalList(String typeCode) {
		List<TerminalInfo> terminalList = ticketingDao.getTerminalList(typeCode);
		return terminalList;
	}
	
	public List<TerminalInfo> getTerminalList(String typeCode, String keyword) {
		String where = "WHERE B" + typeCode + "_STATUS = 'Y' AND B" + typeCode + "_NAME LIKE '" + keyword + "%'";
		List<TerminalInfo> terminalList = ticketingDao.getTerminalList(typeCode, where);
		return terminalList;
	}

	// 회원 페이머니 충전 메서드
	@Transactional
	public int chargePaymoney(MemberInfo loginInfo, PaymoneyCharge pc) {
		int result = 0;
		// 페이머니 충전내역 Insert
		result += ticketingDao.chargePaymoneyIn(loginInfo, pc);
		
		// 회원정보 테이블에 회원의 기존 페이머니와 충전한 페이머니 더하여 업데이트
		result += ticketingDao.chargePaymoneyUp(loginInfo, pc);
		
		return result;
	}

	// 버스 예매 메서드
	@Transactional
	public Map<String, Object> reservationIn(MemberInfo loginInfo, ReservationInfo ri) {
		int realPrice = ri.getTotalPee() - ri.getDiscountPee();	// 실 결제금액
		int unit = 20000;	// 스탬프를 적립하는 단위
		int maxStamp = 30;	// 최대 보유 스탬프
		String mi_id = loginInfo.getMi_id();
		
		// 예매 정보 테이블에 인서트 후 예매번호 리턴
		String ri_idx = ticketingDao.reservationIn(mi_id, ri);
		ri.setRi_idx(ri_idx);
		
		// 예매 정보 좌석 테이블에 인서트
		ticketingDao.reservationSeatIn(ri_idx, ri.getSeatList());
		
		// 결제방식이 페이머니, 쿠폰이아니고 총 결제금액이 20000원 이상인경우 스탬프 적립 로직 통과
		if ((!(ri.getPayment().equals("페이머니") || ri.getPayment().equals("쿠폰")) && realPrice >= unit)) {
			ticketingDao.reservationStampIn(ri_idx, mi_id, realPrice/unit);
			ticketingDao.reservationStampUp(loginInfo, realPrice/unit);
			
			String isOver = ticketingDao.checkUserStamp(maxStamp, mi_id);	// 회원의 스탬프가 30개 이상인지 확인하는 변수
			
			if (isOver.equals("Y"))	{	// 회원의 스탬프 갯수가 30개 이상이라면 쿠폰 생성 로직
				ticketingDao.reservationStampIn(ri_idx, maxStamp, mi_id); 	// 스탬프 내역 테이블에 인서트
				ticketingDao.reservationCouponIn(mi_id);	// 회원 보유 쿠폰 테이블에 인서트
				ticketingDao.reservationUserInfoUp(maxStamp, loginInfo); // 회원 테이블에 현재 쿠폰갯수, 스탬프 갯수 update
				ticketingDao.reservationCouponIn(mi_id, ri_idx, "S");	// 쿠폰 내역 테이블에 인서트
				
				loginInfo.setMi_coupon(loginInfo.getMi_coupon() + 1);
				loginInfo.setMi_stamp(loginInfo.getMi_stamp() - maxStamp);
			}
			
		} else if (ri.getPayment().equals("페이머니")) {
			// 해당 회원의 페이머니 잔액 업데이트			
			ticketingDao.reservationPaymoneyUp(mi_id, realPrice);
			
			loginInfo.setMi_pmoney(loginInfo.getMi_pmoney() - realPrice);
			
		} else if (ri.getPayment().equals("쿠폰")) {
			ticketingDao.reservationCouponDel(mi_id, ri.getCoupon_id());	// 해당 회원이 결제시 선택한 쿠폰 삭제
			ticketingDao.reservationCouponUp(mi_id);	// 회원테이블에서 해당 회원의 정보 업데이트
			ticketingDao.reservationCouponIn(mi_id, ri_idx, "U");
			
			loginInfo.setMi_coupon(loginInfo.getMi_coupon() - 1);
		}
		
		// 회원 결제내역 테이블 insert
		ticketingDao.reservationPayIn(ri_idx, mi_id, ri, realPrice);
		
		// 예매 매출 집계 테이블 insert 
		ticketingDao.reservationCntIn(ri_idx, ri, realPrice);
		
		// 예매건의 결제일시 가져옴
		LocalDateTime reservedDate = ticketingDao.getRevervationDate(mi_id);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd E요일 HH:mm");
		String formattedDate = reservedDate.format(formatter);
		
		Map<String, Object> reservedInfo = new HashMap<String, Object>();
		reservedInfo.put("reservedDate", formattedDate);
		
		return reservedInfo;
	}

	public List<TerminalInfo> getTerminalList(String typeCode, String frCode, JSONObject response) {
		List<String> toSpotCodeList = new ArrayList<String>();
		
		StringBuilder where = new StringBuilder();
		where.append("WHERE B" + typeCode + "_STATUS = 'Y'");
		where.append(" AND B" + typeCode + "_CODE IN (");
		
		if (typeCode.equals("H")) {	// 고속 버스인경우
        	JSONArray linList = (JSONArray) response.get("lin_list");
            
            linList.forEach(obj -> {
                JSONObject linObject = (JSONObject) obj;
                String linCode = (String)linObject.get("LIN_COD");
                if (linCode.startsWith(frCode)) {
                    toSpotCodeList.add(linCode.substring(3));
                }
            });
            
        } else {	// 시외 인 경우
        	JSONArray linList = (JSONArray) response.get("TER_LIST");
        	
        	linList.forEach(obj -> {
                JSONObject linObject = (JSONObject) obj;
                String toCode = (String)linObject.get("TER_COD");
                toSpotCodeList.add(toCode);
            });
        }
		
		if (!toSpotCodeList.isEmpty()) {	// 도착지 코드 목록이 존재하는 경우
	        where.append(String.join(", ", toSpotCodeList));
	        where.append(")");
	        return ticketingDao.getTerminalList(typeCode, where.toString());
	    } else {	// 도착지 코드 목록이 존재하지 않는 경우
	    	return null;
	    }
	}

	public List<ScheduleInfo> getScheduleList(String typeCode, JSONObject response, ReservationInfo ri) throws Exception {
		List<ScheduleInfo> scheduleList = new ArrayList<ScheduleInfo>();
		if (typeCode.equals("H")) {
			int timeTaken = Integer.parseInt(response.get("lin_tim").toString());	// 해당 노선의 소요시간			
			JSONArray linList = (JSONArray) response.get("line_list");
			linList.forEach(obj -> {
				JSONObject linObject = (JSONObject) obj;
                String fr_time = linObject.get("tim_tim").toString();	// 출발시간 0000
                String ri_com = linObject.get("cor_nam").toString();	// 버스회사
                int level_code = Integer.parseInt(linObject.get("bus_gra_o").toString());	// 해당 시간표의 등급코드
                int total_seat = Integer.parseInt(linObject.get("web_cnt").toString());	// 총 좌석수
                String to_time = convertToTimeFormat(convertToMinutes(fr_time) + timeTaken);	// 분 형식으로 연산 후 hh:mm 형식으로 바꿈
                
                String where = "RI_STATUS = '예매'";
    			where += " AND RI_LINE_ID = '" + ri.getFr_code() + ri.getTo_code() + "'";
    			where += " AND RI_FRDATE = '" + ri.getRi_frdate() + " ";
                where += fr_time.substring(0, 2) + ":" + fr_time.substring(2) + ":00'";

                int reserved_seat = ticketingDao.getReservedSeat(where.toString());
                
                String level = "";
                int adult_pee = 0, student_pee = 0, child_pee = 0;
                switch (level_code) { 
                case 1 :
                	level = "우등";
                	adult_pee = Integer.parseInt(response.get("exc_amt_100").toString());
                	student_pee = hasAmountSchedule(response, "cnt_100", "exc_amt_100");
                	child_pee = hasAmountSchedule(response, "chg_cnt_100", "exc_amt_100");
                	break;
                case 2 :
                	level = "고속";
                	adult_pee = Integer.parseInt(response.get("exc_amt_050").toString());
                	student_pee = hasAmountSchedule(response, "cnt_050", "exc_amt_050");
                	child_pee = hasAmountSchedule(response, "chg_cnt_050", "exc_amt_050");
                	break;
                case 3 : 
                	level = "심야우등";
                	adult_pee = Integer.parseInt(response.get("exm_amt_100").toString());
                	student_pee = hasAmountSchedule(response, "amt_050", "exm_amt_100");
                	child_pee = hasAmountSchedule(response, "chg_fee_100", "exm_amt_100");
                	break;
                case 4 :
                	level = "심야고속";
                	adult_pee = Integer.parseInt(response.get("exc_amt_050").toString());
                	student_pee = hasAmountSchedule(response, "amt_100", "exc_amt_050");
                	child_pee = hasAmountSchedule(response, "chg_fee_050", "exc_amt_050");
                	break;
                case 7 :
                	level = "프리미엄";
                	adult_pee = Integer.parseInt(response.get("cad_cnt").toString());
                	student_pee = hasAmountSchedule(response, "pre_cnt", "cad_cnt");
                	child_pee = hasAmountSchedule(response, "can_cnt", "cad_cnt");
                	break;
                case 8 :
                	level = "심야프리미엄";
                	adult_pee = Integer.parseInt(response.get("cst_cnt").toString());
                	student_pee = hasAmountSchedule(response, "rem_tot_cnt", "cst_cnt");
                	child_pee = hasAmountSchedule(response, "arr_cnt", "cst_cnt");
                	break;
                }
                
                ScheduleInfo si = new ScheduleInfo();
                si.setRoute_id(ri.getFr_code() + ri.getTo_code());
                si.setFr_time(fr_time.substring(0, 2) + ":" + fr_time.substring(2));
                si.setTo_time(to_time);
                si.setRi_com(ri_com);
                si.setLevel(level);
                si.setAdult_pee(adult_pee);
                si.setStudent_pee(student_pee);
                si.setChild_pee(child_pee);
                si.setTotal_seat(total_seat);
                si.setLeft_seat(total_seat - reserved_seat);
                scheduleList.add(si);
			});
			
		} else {	// 시외버스 일 경우
			JSONArray linList = (JSONArray) response.get("LINE_LIST");
			linList.forEach(obj -> {
				JSONObject linObject = (JSONObject) obj;
				String fr_time = linObject.get("TIM_TIM").toString();	// 출발시간 0000
	            String ri_com = linObject.get("COR_NAM").toString();	// 버스회사
	            String level_code = linObject.get("BUS_GRA_O").toString();	// 해당 시간표의 등급코드
	            int timeTaken = Integer.parseInt(linObject.get("LIN_TIM").toString());
	            String to_time = convertToTimeFormat(convertToMinutes(fr_time) + timeTaken);	// 분 형식으로 연산 후 hh:mm 형식으로 바꿈
	            String route_id = linObject.get("ROT_ID").toString();
	            int route_sq = Integer.parseInt(linObject.get("ROT_SQNO").toString());
	            String alcnDate =  linObject.get("ALCN_DT").toString();
	            int alcnSq = Integer.parseInt(linObject.get("ALCN_SQNO").toString());
	            int total_seat = Integer.parseInt(linObject.get("WEB_CNT").toString());	// 총 좌석수
	            	
            	String where = "RI_STATUS = '예매'";
    			where += " AND RI_LINE_ID = '" + route_id + "'";
    			where += " AND RI_FRDATE = '" + ri.getRi_frdate() + " ";
                where += fr_time.substring(0, 2) + ":" + fr_time.substring(2) + ":00'";

                int reserved_seat = ticketingDao.getReservedSeat(where.toString());
            	
            	/*
				시간표의 등급코드
				IDB 프리미엄 프리미엄(일반) 
				IDG 일반 
				IDP 우등 
				IDW 프리미엄 프리미엄(주말) 
				INB 심야프리미엄(일반) 
				ING 심야일반 
				INP 심야우등 
				INW 심야프리미엄(주말)
	            */
            	String level = "";
	            if (level_code.equals("IDB") || level_code.equals("IDW"))			level = "프리미엄";
	            else if (level_code.equals("INB") || level_code.equals("INW"))		level = "심야프리미엄";
	            else if (level_code.equals("IDG"))									level = "일반";
	            else if (level_code.equals("ING"))									level = "심야일반";
	            else if (level_code.equals("IDP"))									level = "우등";
	            else if (level_code.equals("INP"))									level = "심야우등";
	            
	            ScheduleInfo si = new ScheduleInfo();
	            si.setRoute_id(route_id);
	            si.setFr_time(fr_time.substring(0, 2) + ":" + fr_time.substring(2));
	            si.setTo_time(to_time);
	            si.setTotal_seat(total_seat);
                si.setLeft_seat(total_seat - reserved_seat);
	            si.setRi_com(ri_com);
	            si.setLevel(level);
	            si.setRoute_sq(route_sq);
	            si.setDispatch_date(alcnDate);
	            si.setDispatch_sq(alcnSq);
	            scheduleList.add(si);
			});
			
			if (scheduleList.size() > 0) {
				String apiUrl = "https://apigw.tmoney.co.kr:5556/gateway/xzzIbtInfoGet/v1/ibt_info/" + ri.getFr_code() + "/" + ri.getTo_code() + "/" + 
				scheduleList.get(0).getRoute_id() + "/" + scheduleList.get(0).getRoute_sq() + "/" + scheduleList.get(0).getDispatch_date()  + "/" + scheduleList.get(0).getDispatch_sq();
				
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
		        JSONObject joTmp = (JSONObject) jo.get("response");
		        int adult_pee = Integer.parseInt(joTmp.get("TCK_FEE1").toString());
		        int student_pee = Integer.parseInt(joTmp.get("TCK_FEE1").toString());
		        int child_pee = hasAmountSchedule(joTmp, "TCK_FEE2", "TCK_FEE1");
		        
		        List<ScheduleInfo> scheduleListAddPrice = new ArrayList<>();
		        for (ScheduleInfo si: scheduleList) {
		        	si.setAdult_pee(adult_pee);
		        	si.setStudent_pee(student_pee);
		        	si.setChild_pee(child_pee);
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
    
	// 분을 "hh:mm" 형태의 문자열로 변환 (util)
    private static String convertToTimeFormat(int minutes) {
    	if (minutes >= 1440) {	// 24:00과 같거나 클 경우
            minutes %= 1440;
        }
        int hours = minutes / 60;
        int remainingMinutes = minutes % 60;
        return String.format("%02d:%02d", hours, remainingMinutes);
    }

    // [예매] 예약객체의 노선id와 출발일자로 예약완료된 좌석을 가져옴
	public List<Integer> getSeatList(ReservationInfo ri) {
		StringBuilder where = new StringBuilder();
		where.append("WHERE RI.RI_STATUS = '예매'");
		where.append(" AND RI.RI_LINE_ID = '" + ri.getRi_line_id() + "'");
		where.append(" AND RI.RI_FRDATE = '" + ri.getRi_frdate() + "'");
		return ticketingDao.getSeatList(where.toString());
	}
	
	// param: 데이터를 뽑아낼 JSONOBject, 기존 컬럼명, 값이 없을 경우 바꿀 컬럼명  (util)
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

	/* param: categoryCode(쿠폰 : C, 스탬프 : S), 회원아이디
	 * 해당 회원의 쿠폰 또는 스탬프 내역을 불러옴
	 */
	public List<UserResourceInfo> getUserResource(String category, String mi_id) {
		List<UserResourceInfo> userResourceList = ticketingDao.getUserResource(category, mi_id);
		return userResourceList;
	}

	// 해당 회원의 쿠폰의 목록
	public List<UserResourceInfo> getUserCoupon(String mi_id) {
		return ticketingDao.getUserCoupon(mi_id);
	}
}
