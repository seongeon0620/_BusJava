package service;

import java.io.*;
import java.net.*;
import org.json.simple.*;
import org.json.simple.parser.*;
import java.util.*;
import dao.*;
import vo.*;

public class LoginSvc {
	private LoginDao loginDao;

	public void setLoginDao(LoginDao loginDao) {
		this.loginDao = loginDao;
	}

	public String getAccessTokenK(String code) {
		// 로그인 성공 시 받아온 code로 필요한 정보 받아오기 담아올 변수 : access_token
			String access_token = "";
			String refresh_token  = "";
			String reqURL = "https://kauth.kakao.com/oauth/token";
			
			try {
				URL url = new URL(reqURL);
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				conn.setRequestMethod("POST");	// 요청시 post 방식사용
				conn.setDoOutput(true);			// post방식을 사용하기 위한 셋팅
				
				// post요청에 필요한 파라미터 생성
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				StringBuilder sb = new StringBuilder();
				sb.append("grant_type=authorization_code");
				sb.append("&client_id=be7adf36fd8efa4f57b4b83208a0b9f6"); // <!-- 자바스크립트 키 -->		
				sb.append("&redirect_uri=http://localhost:8086/busjavaf/kakaoLoginProc");
				sb.append("&code=" + code);
				bw.write(sb.toString());
				bw.flush();
				// conn객체에 등록된 url로 bw의 파라미터들을 가지고 실행(연결)
				
				int resonseCode = conn.getResponseCode();
				System.out.println("resonseCode : " + resonseCode);
				// 값이 200이면 성공
				
				// 요청을 통해 얻은 JSON형식의 Response 메시지 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line = "", result = "";
				while ((line = br.readLine()) != null) {
					result += line;
				}
				System.out.println("result : " + result);
				// result : {"access_token":"5zyr6f08eMCmM7kqbu__6wETh4cyTl9Fb6QSBsB4CiolUwAAAYn8MPIR","token_type":"bearer","refresh_token":"b_1FnHXWOakk1CezfPhq4yRshHBVjiNlcUH-mVW1CiolUwAAAYn8MPIQ","expires_in":7199,"scope":"age_range birthday account_email gender profile_nickname","refresh_token_expires_in":5183999}
				
				// JSON파싱 및 JSONObject객체 생성
				JSONParser p = new JSONParser();
				JSONObject jo = (JSONObject)p.parse(result);
				access_token = (String)jo.get("access_token");
				// 실제 데이터를 가져올 수 있는 코드값
				refresh_token = (String)jo.get("refresh_token");
				
				br.close();				bw.close();
				
			} catch(Exception e) {
				System.out.println("getAccessToken() 메소드 오류");
				e.printStackTrace();
			}
			
			return access_token;
		}

		public HashMap<String, String> getUserInfoK(String accessToken) {
		// 요청하는 클라이언트마다 가진 정보다 다를 수 있기에 HashMap타입으로 리턴
			HashMap<String, String> loginInfo = new HashMap<String, String>();
			String reqURL = "https://kapi.kakao.com/v2/user/me";
			
			try {
				URL url = new URL(reqURL);
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Authorization", "Bearer " + accessToken);
				
				int responseCode = conn.getResponseCode();
				System.out.println("responseCode : " + responseCode);
				// 값이 200이면 성공

				// 요청을 통해 얻은 JSON형식의 Response 메시지 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line = "", result = "";
				while ((line = br.readLine()) != null) {
					result += line;
				}
				System.out.println("result : " + result);
				
				
				// JSON파싱 및 JSONObject객체 생성
				JSONParser p = new JSONParser();
				JSONObject jo = (JSONObject)p.parse(result);
				JSONObject properties = (JSONObject)jo.get("properties");
				JSONObject kakao_account = (JSONObject)jo.get("kakao_account");
				
				String kakao_id = jo.get("id").toString();
				String nickname = properties.get("nickname").toString();
				String email = "";
				String gender = "";
				
				if (kakao_account.containsKey("gender")) {
					gender = kakao_account.get("gender").toString();
				} else if (kakao_account.containsKey("email")) {
					email = kakao_account.get("email").toString();
				}

				loginInfo.put("nickname", nickname);
				loginInfo.put("gender", gender);
				loginInfo.put("email", email);
				loginInfo.put("kakao_id", kakao_id);
				// 받아온 로그인 정보들을 HashMap인 loginInfo에 저장
				
			} catch(Exception e) {
				System.out.println("getUserInfo() 메소드 오류");
				e.printStackTrace();
			}
			return loginInfo;
		}
		
		
		public String getAccessTokenN(String code) {
			String access_token = "";
			String refresh_token  = "";
			String reqURL = "https://nid.naver.com/oauth2.0/token";
			
			try {
				URL url = new URL(reqURL);
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				conn.setRequestMethod("POST");	// 요청시 post 방식사용
				conn.setDoOutput(true);			// post방식을 사용하기 위한 셋팅
				
				// post요청에 필요한 파라미터 생성
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				StringBuilder sb = new StringBuilder();
				sb.append("grant_type=authorization_code");
				sb.append("&client_id=gd01GYXHHa_j2i1TDt8V"); // <!-- 자바스크립트 키 -->		
				sb.append("&client_secret=1aQYmdtz68"); // <!-- 자바스크립트 키 -->		
				sb.append("&redirect_uri=http://localhost:8086/busjavaf/naverLoginProc");
				sb.append("state=9kgsGTfH4j7IyAkg");
				sb.append("&code=" + code);
				bw.write(sb.toString());
				bw.flush();
				// conn객체에 등록된 url로 bw의 파라미터들을 가지고 실행(연결)
				
				int resonseCode = conn.getResponseCode();
				System.out.println("resonseCode : " + resonseCode);
				// 값이 200이면 성공
				
				// 요청을 통해 얻은 JSON형식의 Response 메시지 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line = "", result = "";
				while ((line = br.readLine()) != null) {
					result += line;
				}
//				System.out.println("result : " + result);

				// JSON파싱 및 JSONObject객체 생성
				JSONParser p = new JSONParser();
				JSONObject jo = (JSONObject)p.parse(result);
				access_token = (String)jo.get("access_token");
				// 실제 데이터를 가져올 수 있는 코드값
				refresh_token = (String)jo.get("refresh_token");
				
				br.close();				bw.close();
				
			} catch(Exception e) {
				System.out.println("getAccessToken() 메소드 오류");
				e.printStackTrace();
			}
			
			return access_token;
		}

		public HashMap<String, String> getUserInfoN(String accessToken) {
			HashMap<String, String> loginInfo = new HashMap<String, String>();
			String reqURL = "https://openapi.naver.com/v1/nid/me";
			
			try {
				URL url = new URL(reqURL);
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Authorization", "Bearer " + accessToken);
				
				int responseCode = conn.getResponseCode();
				System.out.println("responseCode : " + responseCode);
				// 값이 200이면 성공

				// 요청을 통해 얻은 JSON형식의 Response 메시지 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line = "", result = "";
				while ((line = br.readLine()) != null) {
					result += line;
				}
//				System.out.println("result : " + result);
				
				
				// JSON파싱 및 JSONObject객체 생성
				JSONParser p = new JSONParser();
				JSONObject jo = (JSONObject)p.parse(result);
				JSONObject response = (JSONObject)jo.get("response");
				
				String gender = response.get("gender").toString();
				String email = response.get("email").toString();
				String mobile = response.get("mobile").toString();
				String naver_id = response.get("id").toString();
				
				// 이메일은 없을 수도 있으므로 가져올 수 없음
				
				loginInfo.put("gender", gender);
				loginInfo.put("naver_id", naver_id);
				loginInfo.put("email", email);
				loginInfo.put("mobile", mobile);
				// 받아온 로그인 정보들을 HashMap인 loginInfo에 저장
				
			} catch(Exception e) {
				System.out.println("getUserInfo() 메소드 오류");
				e.printStackTrace();
			}
			return loginInfo;
		}
		
		public int kakaoInsert(MemberInfo mi) {
			int result = loginDao.kakaoInsert(mi);
			return result;
		}
		
		public int chkId(String mi_id) {
			int result = loginDao.chkId(mi_id);
			return result;
		}

		public MemberInfo getkakaoLogin(String mi_id) {
			MemberInfo kakaoLogin = loginDao.getkakaoLogin(mi_id);
			return kakaoLogin;
		}

		public int naverInsert(MemberInfo mi) {
			int result = loginDao.naverInsert(mi);
			return result;
		}
		
}
