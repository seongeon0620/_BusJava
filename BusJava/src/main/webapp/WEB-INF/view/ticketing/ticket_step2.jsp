<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<ScheduleInfo> scheduleList = (List<ScheduleInfo>)session.getAttribute("scheduleList");
ReservationInfo ri1 = (ReservationInfo) session.getAttribute("ri1");
boolean hasSchedule = scheduleList != null ? true : false;
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-3">
			<div class="col-md-12">
				<h2 class="border-bottom heading"><%=ri1.getRi_line_type().equals("H") ? "고속" : "시외" %>버스 예매
				</h2>
			</div>
			<div class="col-md-12">
				<% if (ri1.getMode().equals("p")) { // 편도일 경우 %>
				<div class="col-md-8 m-auto">
					<div class="progress-bar-custom 1">
						<div class="progress-step ">
							<div class="step-count"></div>
							<div class="step-description">정보 입력</div>
						</div>
						<div class="progress-step is-active">
							<div class="step-count"></div>
							<div class="step-description">배차 조회</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">좌석 선택</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">확인/결제</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">예매 결과</div>
						</div>
					</div>
				</div>
				<% } else { // 왕복일 경우 %>
				<div class="col-md-12 m-auto">
					<div class="progress-bar-custom 2">
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">정보 입력</div>
						</div>
						<div class="progress-step is-active">
							<div class="step-count"></div>
							<div class="step-description">가는 날 배차 조회</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">가는 날 좌석 선택</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">오는 날 배차 조회</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">오는 날 좌석 선택</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">확인/결제</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">예매 결과</div>
						</div>
					</div>
				</div>
				<% } %>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 text-center mb-2">
				<h5 class="text-left">가는편</h5>
				<table class="table">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="15%">
						<col width="*">
					</colgroup>
					<tbody>
						<tr class="border-b">
							<td class="align-middle">
								<span class="badge badge-danger font-weight-normal">출발지</span>
							</td>
							<td class="align-middle"><%=ri1.getRi_fr() %></td>
							<td class="align-middle">
								<span class="badge badge-primary text-white font-weight-normal">도착지</span>
							</td>
							<td class="align-middle"><%=ri1.getRi_to() %></td>
							<td class="align-middle">탑승일</td>
							<td class="text-left"><%=ri1.getRi_frdate()%>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<colgroup>
						<col width="10%">
						<col width="12%">
						<col width="10%">
						<col width="12%">
						<col width="12%">
						<col width="12%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead class="bg-light">
						<tr>
							<th scope="col" class="text-center">출발시각</th>
							<th scope="col" class="text-center">고속사</th>
							<th scope="col" class="text-center">등급</th>
							<th scope="col" class="text-center">어른</th>
							<th scope="col" class="text-center">청소년</th>
							<th scope="col" class="text-center">아동</th>
							<th scope="col" class="text-center">전체좌석</th>
							<th scope="col" class="text-center">잔여좌석</th>
						</tr>
					</thead>
					<tbody class="text-center">
						<form name="frmSchedule" method="post" action="step03">
							<input type="hidden" id="routeId" name="routeId" value="" /> <input type="hidden" id="frTime" name="frTime" value="" /> <input type="hidden" id="toTime" name="toTime" value="" /> <input type="hidden" id="company" name="company" value="" /> <input type="hidden" id="lineLevel" name="lineLevel" value="" /> <input type="hidden" id="adultFee" name="adultFee" value="" /> <input type="hidden" id="teenFee" name="teenFee" value="" /> <input type="hidden" id="childFee" name="childFee" value="" /> <input type="hidden" id="totalSeat" name="totalSeat" value="" /> <input type="hidden" id="leftSeat" name="leftSeat" value="" />
							<% if (hasSchedule && scheduleList.size() > 0) {	// 해당 노선의 시간표가 있는 경우
	for (ScheduleInfo si : scheduleList) { 
		if (si.getLeft_seat() == 0) {	// 해당 노선이 매진인 경우 %>
							<tr class="sold-out">
								<td><%=si.getFr_time() %></td>
								<td><%=si.getRi_com() %></td>
								<td><%=si.getLevel() %></td>
								<td><%=String.format("%,d", si.getAdult_fee()) %></td>
								<td><%=String.format("%,d", si.getStudent_fee()) %></td>
								<td><%=String.format("%,d", si.getChild_fee()) %></td>
								<td><%=si.getTotal_seat() %></td>
								<td>매진</td>
							</tr>

							<%	} else { // 해당 노선이 매진이 아닌경우 %>
							<tr class="data">
								<td id="route_id" class="d-none"><%=si.getRoute_id() %></td>
								<td id="to_time" class="d-none"><%=si.getTo_time() %></td>
								<td id="fr_time"><%=si.getFr_time() %></td>
								<td id="ri_com"><%=si.getRi_com() %></td>
								<td id="ri_level"><%=si.getLevel() %></td>
								<td id="adult_fee"><%=String.format("%,d", si.getAdult_fee()) %></td>
								<td id="student_fee"><%=String.format("%,d", si.getStudent_fee()) %></td>
								<td id="child_fee"><%=String.format("%,d", si.getChild_fee()) %></td>
								<td id="total_seat"><%=si.getTotal_seat() %></td>
								<td id="left_seat"><%=si.getLeft_seat() %></td>
							</tr>
							<% }  %>
							<% 
	} 
} else { // 해당 노선의 시간표가 없는 경우 %>
							<tr class="bg-none">
								<td colspan="8">
									<p>해당 노선의 시간표가 없습니다.</p>
									<button type="button" class="btn btn-primary" onclick="history.back();">뒤로가기</button>
								</td>
							</tr>
							<% } %>
						</form>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>
<script>
$("tr.data").on("click", function() {
	let route_id = $(this).children("#route_id").text();
	let fr_time = $(this).children("#fr_time").text();
	let to_time = $(this).children("#to_time").text();
	let company = $(this).children("#ri_com").text();
	let line_level = $(this).children("#ri_level").text();
	let adult_fee = $(this).children("#adult_fee").text().replace(",", "");
	let student_fee = $(this).children("#student_fee").text().replace(",", "");
	let child_fee = $(this).children("#child_fee").text().replace(",", "");
	let total_seat = $(this).children("#total_seat").text();
	let left_seat =$(this).children("#left_seat").text();
	
	$("#routeId").val(route_id);
	$("#frTime").val(fr_time);
	$("#toTime").val(to_time);
	$("#company").val(company);
	$("#lineLevel").val(line_level);
	$("#adultFee").val(parseInt(adult_fee));
	$("#teenFee").val(parseInt(student_fee));
	$("#childFee").val(parseInt(child_fee));
	$("#totalSeat").val(total_seat);
	$("#leftSeat").val(left_seat);
	document.frmSchedule.submit();
});
</script>



