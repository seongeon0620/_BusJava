<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ page import="java.text.*"%>
<%@ page import="vo.*"%>
<%
request.setCharacterEncoding("utf-8");
BookInfo bi = (BookInfo) request.getAttribute("bi");
String args = (String) request.getAttribute("args");

// 세자리수 마다 ,를 찍어주는 코드
NumberFormat nf = NumberFormat.getInstance();
String formattedNumber = "";
if (bi.getPd_real_price() > 1000) {
	nf = NumberFormat.getInstance();
	formattedNumber = nf.format(bi.getPd_real_price());
	// 이제 formattedNumber는 세 자리마다 쉼표가 찍힌 숫자를 문자열 형태로 저장합니다.
}

// 환불금액 계산 코드
String sday = "", stime = "";
// 1. 예매정보조회 - 날짜 및 시간 출력
sday = bi.getRi_frdate().replace(".", "-").trim();
stime = bi.getRi_frtime().trim();
int realPrice = bi.getPd_total_price();
// 2.1 날짜 및 시간 LocalDateTime 객체로 변환
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
LocalDateTime departTime = LocalDateTime.parse(sday + " " + stime, formatter);

// 2.2 현재 시간과의 차이 계산
LocalDateTime now = LocalDateTime.now();
long diffMinutes = ChronoUnit.MINUTES.between(now, departTime);

// 3. 취소 수수료 결정
int cancelPrice;
if (diffMinutes >= 2 * 24 * 60) {
	cancelPrice = 0;
} else if (diffMinutes >= 24 * 60) {
	cancelPrice = (realPrice / 100) * 5;
} else if (diffMinutes >= 60) {
	cancelPrice = (realPrice / 100) * 10;
} else {
	cancelPrice = (realPrice / 100) * 30;
}

String date = bi.getRi_todate().replace(".", "-");
String time = bi.getRi_totime();
String dateTimeString = date + " " + time;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
Date date1 = new Date();
Date date2 = sdf.parse(dateTimeString);
%>

<section class="section">
	<div class="container">
		<div class="row text-center">
			<div class="col-md-12">
				<h2 class="border-bottom heading">예매 내역</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<h5 class="text-left">예매정보</h5>
				<table class="table" class="thead-light">
					<colgroup>
						<col width="25%">
						<col width="25%">
						<col width="25%">
						<col width="25%">
					</colgroup>
					<tr>
						<th scope="col" class="text-center bg-light">예매번호</th>
						<td><%=bi.getRi_idx()%></td>
						<th scope="col" class="text-center bg-light">버스구분</th>
						<td><%=bi.getRi_line_type()%></td>
					</tr>
					<tr>
						<th scope="col" class="text-center bg-light">출발지</th>
						<td><%=bi.getRi_fr()%></td>
						<th scope="col" class="text-center bg-light">도착지</th>
						<td><%=bi.getRi_to()%></td>
					</tr>
					<tr>
						<th scope="col" class="text-center bg-light">출발일시</th>
						<td><%=bi.getRi_frdate()%><%=bi.getRi_frtime()%></td>
						<th scope="col" class="text-center bg-light">도착일시</th>
						<td><%=bi.getRi_todate()%><%=bi.getRi_totime()%></td>
					</tr>
					<tr>
						<th scope="col" class="text-center bg-light">버스등급</th>
						<td><%=bi.getRi_level()%></td>
						<th scope="col" class="text-center bg-light">버스회사</th>
						<td><%=bi.getRi_com()%></td>
					</tr>
					<tr>
						<th scope="col" class="text-center bg-light">매수</th>
						<td>
							어른
							<%=bi.getRi_acnt()%>명, 청소년
							<%=bi.getRi_scnt()%>명, 아동
							<%=bi.getRi_ccnt()%>명
						</td>
						<th scope="col" class="text-center bg-light">좌석</th>
						<td>
							<%
							StringBuilder seats = new StringBuilder();
							if (bi.getBusSeatList().size() > 0) {
								for (BusSeatList bs : bi.getBusSeatList()) {
									if (seats.length() != 0) {
								seats.append(",");
									}
									seats.append(bs.getRd_seat_num());
								}
							}
							%>
							<%=seats.toString()%>
						</td>
					</tr>
					<tr>
						<th scope="col" class="text-center bg-light">상태</th>
						<td><%=bi.getRi_status()%></td>
						<th scope="col" class="text-center bg-light">환불금액</th>
						<%
						if (!bi.getRi_status().equals("예매취소")) {
						%>
						<td>-</td>
						<%
						} else {
						int returnCount = (bi.getPd_total_price() - cancelPrice);
						NumberFormat nft = NumberFormat.getInstance();
						String result = nft.format(returnCount); // tmp 값을 세 자리마다 쉼표가 찍힌 문자열로 변환 */
						%>
						<td><%=result%>원
						</td>

						<%
						}
						%>
					</tr>
				</table>
				<h5 class="text-left">결제정보</h5>
				<table class="table" class="thead-light">
					<colgroup>
						<col width="25%">
						<col width="25%">
						<col width="25%">
						<col width="25%">
					</colgroup>
					<tr>
						<th scope="col" class="text-center bg-light">결제일시</th>
						<td><%=bi.getPd_date()%></td>
						<th scope="col" class="text-center bg-light">결제수단</th>
						<td><%=bi.getPd_payment()%></td>
					</tr>
					<tr>
						<th scope="col" class="text-center bg-light">할인금액</th>
						<td><%=bi.getPd_payment()%></td>
						<th scope="col" class="text-center bg-light">결제금액</th>
						<td id="pay"><%=formattedNumber%>원
						</td>
					</tr>
				</table>
				<div class="d-flex justify-content-center">
					<%
					if (!bi.getRi_status().equals("예매취소") && date1.before(date2)) {
					%>
					<button type="button" class="btn waves-effect waves-light btn-secondary mb-2 mr-2" onclick="openModal('<%=bi.getRi_idx()%>');">예매취소</button>
					<button type="button" class="btn waves-effect waves-light btn-primary mb-2" onclick="history.back()">확인</button>
					<%
					} else {
					%>
					<button type="button" class="btn btn-primary" onclick="location.href='booking'">확인</button>
					<%
					}
					%>
				</div>

			</div>
		</div>
	</div>
	<div class="modal fade" id="ViewModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content"></div>
		</div>
	</div>
</section>
<script>
	function openModal(riidx) {
		$('#ViewModal .modal-content').load("/BusJava/cancel<%=args%>&riidx=" + riidx);
		$('#ViewModal').modal();
	}
</script>
<%@ include file="../_inc/foot.jsp"%>