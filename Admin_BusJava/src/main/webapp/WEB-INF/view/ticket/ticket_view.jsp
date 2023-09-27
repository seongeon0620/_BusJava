<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.text.*" %>
<%@ page import="vo.*" %>
<%@ include file="../_inc/head.jsp" %>
<%
TicketInfo ti = (TicketInfo)request.getAttribute("ti");

//세자리수 마다 ,를 찍어주는 코드
NumberFormat nf = NumberFormat.getInstance();
String formattedNumber = "";
if (ti.getPd_real_price() > 1000) {
 nf = NumberFormat.getInstance();
 formattedNumber = nf.format(ti.getPd_real_price());
 // 이제 formattedNumber는 세 자리마다 쉼표가 찍힌 숫자를 문자열 형태로 저장합니다.
}

//환불금액 계산 코드
String sday="", stime="";
//1. 예매정보조회 - 날짜 및 시간 출력
sday = ti.getRi_frdate().replace(".", "-").trim(); stime = ti.getRi_frtime().trim(); 
int realPrice = ti.getPd_total_price();
//2.1 날짜 및 시간 LocalDateTime 객체로 변환
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
LocalDateTime departTime = LocalDateTime.parse(sday + " " + stime, formatter);

//2.2 현재 시간과의 차이 계산
LocalDateTime now = LocalDateTime.now();
long diffMinutes = ChronoUnit.MINUTES.between(now, departTime);

//3. 취소 수수료 결정
int cancelPrice;
if (diffMinutes >= 2 * 24 * 60) {
	cancelPrice = 0;
} else if (diffMinutes >= 24 * 60) {
	cancelPrice = (realPrice/100) * 5;
} else if (diffMinutes >= 60) {
	cancelPrice = (realPrice/100) * 10;
} else {
	cancelPrice = (realPrice/100) * 30;
} 

// 매수 및 좌석 
String tmp = ""; 
if (ti.getRi_acnt() > 0) {
	tmp += "성인 "+ ti.getRi_acnt() + "명 ";
}  
if (ti.getRi_scnt() > 0) {
	tmp += "청소년 "+ ti.getRi_acnt() + "명 ";
}  
if (ti.getRi_ccnt() > 0){
	tmp += "아동 "+ ti.getRi_acnt() + "명 ";
}
String str = "";
if (ti.getSeatInfo().size() > 0) {
	for (SeatInfo si : ti.getSeatInfo()) {
		str += ", " + si.getRd_seat_num(); 
	}
	str = str.substring(1);
} 



%>
<div class="page-wrapper">
<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">예매 관리</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="Admin_BusJava" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item text-muted" aria-current="page">예매 목록</li>
		            <li class="breadcrumb-item active" aria-current="page">예매 상세내역</li>
		        </ol>
			    </nav>
		</div>
	</div>
  <div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<h4 class="text-left">예매정보</h4>
	<table class="table text-center table-sm">
	<colgroup>
		<col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="25%">
	</colgroup>
	<thead class="text-black">
		<th class="bg-gray">예매번호</th>
		<td><%=ti.getRi_idx() %></td>
		<th class="bg-gray">버스구분</th>
		<td><%=ti.getRi_line_type() %></td>
   	</thead>
	<thead class="text-black">
		<th class="bg-gray">출발지</th>
		<td><%=ti.getRi_fr() %></td>
		<th class="bg-gray">도착지</th>
		<td><%=ti.getRi_to() %></td>
   	</thead>
	<thead class="text-black">
		<th class="bg-gray">출발일시</th>
		<td><%=ti.getRi_frdate() %> <%=ti.getRi_frtime() %></td>
		<th class="bg-gray">도착일시</th>
		<td><%=ti.getRi_todate() %> <%=ti.getRi_totime() %></td>
   	</thead>
	<thead class="text-black">
		<th class="bg-gray">버스등급</th>
		<td><%=ti.getRi_level() %></td>
		<th class="bg-gray">버스회사</th>
		<td><%=ti.getRi_com() %></td>
   	</thead>
	<thead class="text-black">
		<th class="bg-gray">매수</th>

		<td><%=tmp %></td>
		<th class="bg-gray">좌석</th>

		<td><%=str %></td>
   	</thead>
   	<thead class="text-black">
		<th class="bg-gray">상태</th>
		<td class="border-bottom"><%=ti.getRi_status() %></td>
		<th class="bg-gray">환불금액</th>
<% if (!ti.getRi_status().equals("예매취소")) { %>
		<td class="border-bottom">-</td>
<% } else { 
	int returnCount = (ti.getPd_total_price() - cancelPrice);
	NumberFormat nft = NumberFormat.getInstance();
	String result = nft.format(returnCount);  // tmp 값을 세 자리마다 쉼표가 찍힌 문자열로 변환 */ %>
	<td class="border-bottom"><%=result %>원</td>
<% } %>
   	</thead>
</table>
<h4 class="text-left">결제정보</h4>
<table class="table text-center thead-light table-sm">
	<colgroup>
		<col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="25%">
	</colgroup>
   	<thead class="text-black">
		<th class="bg-gray">결제일자</th>
		<td><%=ti.getPd_date().substring(0,11) %></td>
		<th class="bg-gray">결제시간</th>
		<td><%=ti.getPd_date().substring(11,16) %></td>
   	</thead>
   	<thead class="text-black">
		<th class="bg-gray">결제수단</th>
		<td class="border-bottom"><%=ti.getPd_payment() %></td>
		<th class="bg-gray">결제금액</th>
		<td class="border-bottom"><%=formattedNumber %></td>
   	</thead>
</table>
<div class="d-flex justify-content-center">
	<% if (!ti.getRi_status().equals("예매취소")) { %>
	<button type="button" class="btn waves-effect waves-light btn-secondary mb-2 mr-2" onclick="openModal('<%=ti.getRi_idx() %>', '<%=ti.getMi_id()%>');">예매취소</button>
	<button type="button" class="btn waves-effect waves-light btn-primary mb-2" onclick="history.back()">확인</button>
	<% } else { %>
	<button type="button" class="btn btn-primary" onclick="location.href='ticketList'">확인</button>
	<% } %>
</div>
      </div>
      </div>
					</div>
				</div>
			</div>
		</div>
<div class="modal fade" id="ViewModal" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
		</div>
	</div>	
</div>
	</div>

    

<script>
function openModal(ri_idx, mi_id) {
	$('#ViewModal .modal-content').load("/busjava_admin/cancel?ri_idx=" + ri_idx + "&mi_id=" + mi_id);
	$('#ViewModal').modal();
  }
</script>
<%@ include file="../_inc/foot.jsp" %>