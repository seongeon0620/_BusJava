package controller;

import java.util.*;
import java.io.*;
import java.net.*;
import javax.servlet.http.*;
import org.json.simple.*;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.*;
import service.*;
import vo.*;

@Controller
public class TravelCtrl {
	private TravelSvc travelSvc;
	
	public void setTravelSvc(TravelSvc travelSvc) {
		this.travelSvc = travelSvc;
	}
	

	@GetMapping("/travelList")
	public String pmoneyInfo(Model model, HttpServletRequest request) throws Exception {
		int cpage = 1, pcnt = 0, spage = 0, rcnt = 0, psize = 12, bsize = 10, num = 0;
		// 현재 페이지 번호, 페이지 크기, 데이터 개수, 블록 크기
		String args = "", schargs = "";
		String keyword = request.getParameter("keyword");
		String code = request.getParameter("mainCode");
		String name = request.getParameter("mainCtgr");
		String urlType = "areaBasedList1";
		if (request.getParameter("cpage") != null)	cpage = Integer.parseInt(request.getParameter("cpage"));
		if (request.getParameter("psize") != null)	psize = Integer.parseInt(request.getParameter("psize"));
		if (keyword != null && !keyword.equals(""))	{
			urlType = "searchKeyword1";
			schargs += "&keyword=" + keyword;
		}
		if (name == null) {
			code = ""; name = "";
		}
		if (name != null && !name.equals(""))	{
			schargs += "&mainCode=" + code + "&mainCtgr=" + name;
		}
		
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/" + urlType); /*URL*/
	       
		// Open API의 요청 규격에 맞는 쿼리스트링 생성
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=k6Xkj60fwUQxNu4HspvIV0zmw9G0xF3gJytmlTWV3w5LGkj4AH3boXdY8f8ZgU0uETJ%2BUjCILyNM1fgDt%2FMtGQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode(cpage + "", "UTF-8")); /*페이지 번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode(psize + "", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8") + "=" + URLEncoder.encode("travel", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
        if (keyword != null && !keyword.equals(""))
        	urlBuilder.append("&" + URLEncoder.encode("keyword","UTF-8") + "=" + URLEncoder.encode(keyword, "UTF-8"));
        if (code != null && !code.equals("")) {
        	if (code.length() > 7) {
        		urlBuilder.append("&" + URLEncoder.encode("cat1","UTF-8") + "=" + URLEncoder.encode(code.substring(0, 3), "UTF-8"));
        		urlBuilder.append("&" + URLEncoder.encode("cat2","UTF-8") + "=" + URLEncoder.encode(code.substring(0, 5), "UTF-8"));
        		if (keyword == null && keyword.equals("")) {
        			urlBuilder.append("&" + URLEncoder.encode("cat3","UTF-8") + "=" + URLEncoder.encode(code, "UTF-8"));
        		}
        	} else if (code.length() < 7 && code.length() > 4) {
        		urlBuilder.append("&" + URLEncoder.encode("cat1","UTF-8") + "=" + URLEncoder.encode(code.substring(0, 3), "UTF-8"));
        		urlBuilder.append("&" + URLEncoder.encode("cat2","UTF-8") + "=" + URLEncoder.encode(code, "UTF-8"));
        	} else {
        		urlBuilder.append("&" + URLEncoder.encode("cat1","UTF-8") + "=" + URLEncoder.encode(code, "UTF-8"));
        	}
        }
        // URL 객체 생성
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        conn.setConnectTimeout(20000);
        conn.setReadTimeout(40000);
        
        BufferedReader rd;
        // Open API에서 보낸 데이터를 받아 저장할 객체 선언
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        
        StringBuilder sb = new StringBuilder();
        // 받아온 데이터 전체를 문자열로 저장할 객체
        String line;	 // 받아온 데이터를 한 줄씩 문자열로 받아 저장할 객체
        while ((line = rd.readLine()) != null) {
        // 읽어들인 한 줄의 문자열을 line에 저장(더 이상 읽어들일 데이터가 없으면 null)
            sb.append(line);
            // 읽어들인 한 줄의 문자열을 차례대로 sb에 누적 저장
        }	// open api에서 보낸 json형식의 문자열을 sb에 저장
		
        // 받아 놓은 json형식의 문자열을 JSONArray로 변환
        JSONParser p = new JSONParser();	// parse를 사용하기 위해 import 후 사용
		
        JSONObject jo = (JSONObject)p.parse(sb.toString());		// new String(sb) -> sb를 새로운 String 변수로 만듦	sb.toString() -> String으로 변환
        // sb에 저장된 값을 String으로 변환하여 JSONObject 객체로 생성
        // 받아온 값들 중 'data'라는 키에 해당하는 값만 사용하기 위해
        
        JSONObject joResponse = (JSONObject)jo.get("response");
        JSONObject joBody = (JSONObject)joResponse.get("body");
        JSONObject joItems;
        JSONArray joItem;
        if(Integer.parseInt(joBody.get("totalCount").toString()) == 0) {
        	joItem = null;
        } else {
            joItems = (JSONObject)joBody.get("items");
            joItem = (JSONArray)joItems.get("item");
        }
		// 'data'라는 키에 해당하는 값들을 JSONArray 객체로 저장
		
		rcnt = Integer.parseInt(joBody.get("totalCount").toString());
		
		
//	서비스 분류 가져오는 api
		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/categoryCode1"); /*URL*/
	       
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=k6Xkj60fwUQxNu4HspvIV0zmw9G0xF3gJytmlTWV3w5LGkj4AH3boXdY8f8ZgU0uETJ%2BUjCILyNM1fgDt%2FMtGQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8") + "=" + URLEncoder.encode("ctgr", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));

        url = new URL(urlBuilder.toString());
        conn = (HttpURLConnection) url.openConnection();
//        System.out.println("Response code: " + conn.getResponseCode());
        
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        
        sb.setLength(0);
        line = "";	 
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
//        System.out.println(sb.toString());
		
        jo = (JSONObject)p.parse(sb.toString());
        joResponse = (JSONObject)jo.get("response");
        joBody = (JSONObject)joResponse.get("body");
        joItems = (JSONObject)joBody.get("items");
        JSONArray joCtgr = (JSONArray)joItems.get("item");
        
		if (joItem != null) {
	        for (int i = 0; i < joItem.size(); i++) {
	        	JSONObject joTmp1 = (JSONObject)joItem.get(i);
	
	        	for (int j = 0; j < joCtgr.size(); j++) {
	        		JSONObject joTmp2 = (JSONObject)joCtgr.get(j);
	        		if (joTmp1.get("cat1").equals(joTmp2.get("code"))) {
	        			joTmp1.replace("cat1", joTmp2.get("name"));
	        		}
	        	}
	        }
		}
        
        pcnt = rcnt / psize;	if(rcnt % psize > 0)	pcnt++;
		spage = (cpage - 1) / bsize * bsize + 1;
        
        PageInfo pi = new PageInfo();
		pi.setBsize(bsize);		pi.setCpage(cpage);		pi.setPcnt(pcnt);		pi.setPsize(psize);
		pi.setRcnt(rcnt);		pi.setSpage(spage);		pi.setSchargs(schargs);
		// 페이징을 위한 정보를 PageInfo형 인스턴스 pi에 저장

		model.addAttribute("pi", pi );
		request.setAttribute("joItem", joItem);
		model.addAttribute("keyword", keyword);
		request.setAttribute("code", code);
		request.setAttribute("name", name);
		return "/travel/travel_list";
	}
	
	@GetMapping("/serviceCtgr")
	public String serviceCtgr(HttpServletRequest request) throws Exception {	
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/categoryCode1"); /*URL*/
	       
		// Open API의 요청 규격에 맞는 쿼리스트링 생성
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=k6Xkj60fwUQxNu4HspvIV0zmw9G0xF3gJytmlTWV3w5LGkj4AH3boXdY8f8ZgU0uETJ%2BUjCILyNM1fgDt%2FMtGQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8") + "=" + URLEncoder.encode("ctgr", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));

        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        
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
        
        JSONObject joResponse = (JSONObject)jo.get("response");
        JSONObject joBody = (JSONObject)joResponse.get("body");
        JSONObject joItems = (JSONObject)joBody.get("items");
        JSONArray joItem = (JSONArray)joItems.get("item");
        request.setAttribute("joItem", joItem);
		return "popup/service_ctgr";
	}
	
	@PostMapping("/getCtgr")
	@ResponseBody
	public JSONArray getCtgr(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String code = request.getParameter("code");
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/categoryCode1"); /*URL*/
	       
		// Open API의 요청 규격에 맞는 쿼리스트링 생성
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=k6Xkj60fwUQxNu4HspvIV0zmw9G0xF3gJytmlTWV3w5LGkj4AH3boXdY8f8ZgU0uETJ%2BUjCILyNM1fgDt%2FMtGQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8") + "=" + URLEncoder.encode("ctgr", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
        if (code != null && !code.equals("")) {
        	if (code.length() > 4) {
        		urlBuilder.append("&" + URLEncoder.encode("cat1","UTF-8") + "=" + URLEncoder.encode(code.substring(0, 3), "UTF-8"));
        		urlBuilder.append("&" + URLEncoder.encode("cat2","UTF-8") + "=" + URLEncoder.encode(code, "UTF-8"));
        	} else {
        		urlBuilder.append("&" + URLEncoder.encode("cat1","UTF-8") + "=" + URLEncoder.encode(code, "UTF-8"));
        	}
        	
        }
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
//        System.out.println("Response code: " + conn.getResponseCode());
        
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
//        System.out.println(sb.toString());
        JSONParser p = new JSONParser();
		
        JSONObject jo = (JSONObject)p.parse(sb.toString());
        
        JSONObject joResponse = (JSONObject)jo.get("response");
        JSONObject joBody = (JSONObject)joResponse.get("body");
        JSONObject joItems = (JSONObject)joBody.get("items");
        JSONArray joArr = (JSONArray)joItems.get("item");
        
		return joArr;
	}
	
	@GetMapping("/detail")
	public String detaile(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("utf-8");
		String id = request.getParameter("id");
		
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailCommon1"); /*URL*/
	       
		// Open API의 요청 규격에 맞는 쿼리스트링 생성
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=k6Xkj60fwUQxNu4HspvIV0zmw9G0xF3gJytmlTWV3w5LGkj4AH3boXdY8f8ZgU0uETJ%2BUjCILyNM1fgDt%2FMtGQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8") + "=" + URLEncoder.encode("ctgr", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("contentId","UTF-8") + "=" + URLEncoder.encode(id, "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("overviewYN","UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("firstImageYN","UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("addrinfoYN","UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("defaultYN","UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));
         
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        
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
        
        JSONParser p = new JSONParser();
		
        JSONObject jo = (JSONObject)p.parse(sb.toString());
        
        JSONObject joResponse = (JSONObject)jo.get("response");
        JSONObject joBody = (JSONObject)joResponse.get("body");
        JSONObject joItems = (JSONObject)joBody.get("items");
        JSONArray joArr = (JSONArray)joItems.get("item");
        
        
        urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailImage1"); /*URL*/
	       
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=k6Xkj60fwUQxNu4HspvIV0zmw9G0xF3gJytmlTWV3w5LGkj4AH3boXdY8f8ZgU0uETJ%2BUjCILyNM1fgDt%2FMtGQ%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8") + "=" + URLEncoder.encode("ctgr", "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("contentId","UTF-8") + "=" + URLEncoder.encode(id, "UTF-8"));
   //     urlBuilder.append("&" + URLEncoder.encode("imageYN","UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("subImageYN","UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));

        url = new URL(urlBuilder.toString());
        conn = (HttpURLConnection) url.openConnection();
        
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        
        sb.setLength(0);
        line = "";	 
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        jo = (JSONObject)p.parse(sb.toString());
        joResponse = (JSONObject)jo.get("response");
        joBody = (JSONObject)joResponse.get("body");

        JSONArray joImg;
        if(Integer.parseInt(joBody.get("totalCount").toString()) == 0) {
        	joImg = null;
        } else {
            joItems = (JSONObject)joBody.get("items");
            joImg = (JSONArray)joItems.get("item");
        }
        
        if (joArr != null) {
        	for (int i = 0; i < joArr.size(); i++) {
	        	JSONObject joTmp1 = (JSONObject)joArr.get(i);
	        	joTmp1.replace("tel", "");
	        	joTmp1.replace("telname", "");
	        	joTmp1.replace("homepage", "");
	        	joTmp1.replace("booktour", "");
        	}
        }
        
        if (joArr != null && joImg != null) {
	        for (int i = 0; i < joArr.size(); i++) {
	        	JSONObject joTmp1 = (JSONObject)joArr.get(i);
	        	for (int j = 0; j < joImg.size(); j++) {
	        		JSONObject joTmp2 = (JSONObject)joImg.get(j);
	        		switch (j) {
					case 0:
						joTmp1.replace("tel", joTmp2.get("originimgurl"));
						break;
					case 1:
						joTmp1.replace("telname", joTmp2.get("originimgurl"));
						break;
					case 2:
						joTmp1.replace("homepage", joTmp2.get("originimgurl"));
						break;
					case 3:
						joTmp1.replace("booktour", joTmp2.get("originimgurl"));
						break;
					}
	        	}
	        	
	        }
		}
		
        
        request.setAttribute("joArr", joArr);
		return "popup/detail";
	}
	
}
