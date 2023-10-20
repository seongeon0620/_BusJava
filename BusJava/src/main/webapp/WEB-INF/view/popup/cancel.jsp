<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
String riidx = request.getParameter("riidx");
int cpage = Integer.parseInt(request.getParameter("cpage"));
%>
<div class="modal-header">
	<h5 class="modal-title" id="exampleModalLabel" align="center">취소수수료 안내</h5>
</div>
<div class="modal-body">
<table class="table">
  <thead class="thead-dark">
    <tr>
      <th scope="col">취소시기</th>
      <th scope="col">수수료</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>예매 당일 또는 승차일 2일전 취소
(단, 당일출발차량 예매 후 1시간 이후 취소는 수수료 발생)</td>
      <td>없음</td>
    </tr>
    <tr>
      <td>예매 후 출발일 1일 전일부터 지정차 출발 1시간 전 취소
(단, 당일출발차량 예매 후 1시간 이내 취소는 수수료 없음)</td>
      <td>승차권 요금의 5%</td>
    </tr>
    <tr>
      <td>예매 후 지정차 출발 1시간 이내 취소
(단, 당일출발차량 예매 후 1시간 이내 취소는 수수료 없음)</td>
      <td>승차권 요금의 10%</td>
    </tr>
    <tr>
      <td>예매하신 지정차 출발 후 목적지 도착예정시간 전 취소</td>
      <td>승차권 요금의 30%</td>
    </tr>
    <tr>
      <td>쿠폰 구매 승차권 : 출발시간 이전 취소</td>
      <td>사용 쿠폰 환원</td>
    </tr>
    <tr>
      <td>쿠폰 구매 승차권 : 출발시간 이후 취소</td>
      <td>사용 쿠폰 차감</td>
    </tr>
  </tbody>
</table>
<ul>
  <li>사용하지 않은 모든 승차권은 지정차 출발 후 도착예정시간이 지나면 환불하실 수 없습니다.</li>
  <li>취소수수료 산정은 날짜를 기준(시간 기준이 아님)으로 합니다.홈페이지 예매 후 창구에서 발권 시 예매에 사용한 신용카드를 반드시 지참하셔야 합니다. 현행법상 신용카드는 타인에게 대여, 양도 할 수 없습니다.</li>
  <li>홈티켓 발권 시 반드시 인쇄하신 홈티켓을 소지 하시고 차량에 탑승하시기 바랍니다. 홈티켓 분실 시 [예매 확인/취소/변경] 메뉴 혹은 출발지 터미널 창구에서 재발행 받으셔야 합니다.</li>
  <li>본 홈페이지를 통한 승차권 예매는 실시간 온라인 처리가 되므로 회원장애나 기타 통신장애로 인하여 예매 성공여부를 확인하지 못한 경우에는 반드시 예매 내역 메뉴를 통하여 성공여부를 확인하시기 바랍니다.</li>
</ul>
</div>
<div class="modal-footer">
  <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
  <button type="button" id="btnSubmit" class="btn btn-primary" data-dismiss="modal" onclick="location.href='realCancel?cpage=<%=cpage%>&riidx=<%=riidx %>'">동의</button>
</div>
