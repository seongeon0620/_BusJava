<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
ReservationInfo ri2 = (ReservationInfo) session.getAttribute("ri2");
int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
int leftSeat = Integer.parseInt(request.getParameter("leftSeat"));
List<Integer> seatList = (List<Integer>) session.getAttribute("seatList");
%>
<section class="section">
	<div class="container">
		<div class="row text-center">
			<div class="col-md-12">
				<h2 class="border-bottom heading"><%=ri2.getRi_line_type().equals("H") ? "고속" : "시외" %>버스 예매</h2>
			</div>
			<div class="col-md-12">
				<div class="col-md-12 m-auto">
					<div class="progress-bar-custom 2">
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">정보 입력</div>
						</div>
						<div class="progress-step">
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
						<div class="progress-step is-active">
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
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 text-center mb-5">
				<h4 class="display-5 probootstrap-section-heading text-left">오는편</h4>
				<table class="table">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
					</colgroup>
					<tbody>
						<tr class="border-b">
							<td class="align-middle"><span class="badge badge-danger font-weight-normal">출발지</span></td>
							<td><%=ri2.getRi_fr()%></td>
							<td class="align-middle"><span class="badge badge-primary text-white font-weight-normal">도착지</span></td>
							<td><%=ri2.getRi_to()%></td>
							<td><%=ri2.getRi_frdate().substring(0, 11)%></td>
							<td>출발 <%=ri2.getRi_frdate().substring(11, 16)%></td>
							<td>도착 <%=ri2.getRi_todate().substring(11, 16)%></td>
							<td><%=ri2.getRi_com()%></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<form name="frmSeat" action="payment" method="post">
			<input type="hidden" name="totalFee" class="totalFee" value="<%=(ri2.getRi_acnt() * ri2.getAdult_fee() + ri2.getRi_scnt() * ri2.getStudent_fee() + ri2.getRi_ccnt() * ri2.getChild_fee())%>" />
			<div class="row justify-content-center">
				<div class="col-md-6 text-center">
					<p class="mb-0 h5">좌석선택<%=leftSeat%>/<%=totalSeat%></p>
					<div class="seat-bg ml-auto 
<%if (ri2.getRi_level().indexOf("일반") != -1 || ri2.getRi_level().indexOf("고속") != -1) {%>
	seat45
<%} else if (ri2.getRi_level().indexOf("우등") != -1) {%>
	seat28
<%} else if (ri2.getRi_level().indexOf("프리") != -1) {%>
	seat21
<%}%>			
			 ">
						<div class="seat-list">
							<%
								if (seatList.size() == 0) {
									for (int i = 1; i < totalSeat + 1; i++) {
							%>
							<span class="seat-box">
								<input type="checkbox" name="seatBoxDtl" id="seatNum_<%=i%>" value="<%=i%>" onclick="getSeat(this);">
								<label for="seatNum_<%=i%>"><%=i%></label>
							</span>
							<%
									}
								} else {
									for (int i = 1; i < totalSeat + 1; i++) {
							%>
							<span class="seat-box <%if (seatList.get(i - 1) == i)%> disabled">
								<input type="checkbox" name="seatBoxDtl" id="seatNum_<%=i%>" value="<%=i%>" onclick="getSeat(this);" <%if (seatList.get(i - 1) == i)%> disabled>
								<label for="seatNum_<%=i%>"><%=i%></label>
							</span>
							<%
									}
								}
							%>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="col-md-6 mb-5">
						<h4>매수</h4>
						<div class="d-flex mb-2 align-items-center justify-content-between">
							<span>성인</span>
							<div class="col-md-7">
								<div class="btn-group custom">
									<button type="button" class="btn btn-primary p-1" disabled="disabled">
										<i class="bi bi-dash-lg"></i>
									</button>
									<input class="form-control text-center bg-white" type="text" value="<%=ri2.getRi_acnt()%>" size="5" readonly>
									<button type="button" class="btn btn-primary p-1" disabled="disabled">
										<i class="bi bi-plus-lg"></i>
									</button>
								</div>
							</div>
						</div>
						<div class="d-flex mb-2 align-items-center justify-content-between">
							<span>청소년</span>
							<div class="col-md-7">
								<div class="btn-group custom">
									<button type="button" class="btn btn-primary p-1" disabled="disabled">
										<i class="bi bi-dash-lg"></i>
									</button>
									<input class="form-control text-center bg-white" type="text" value="<%=ri2.getRi_scnt()%>" size="5" readonly>
									<button type="button" class="btn btn-primary p-1" disabled="disabled">
										<i class="bi bi-plus-lg"></i>
									</button>
								</div>
							</div>
						</div>
						<div class="d-flex mb-2 align-items-center justify-content-between">
							<span>아동</span>
							<div class="col-md-7">
								<div class="btn-group custom">
									<button type="button" class="btn btn-primary p-1" disabled="disabled">
										<i class="bi bi-dash-lg"></i>
									</button>
									<input class="form-control text-center bg-white" type="text" value="<%=ri2.getRi_ccnt()%>" size="5" disabled="disabled">
									<button type="button" class="btn btn-primary p-1" disabled="disabled">
										<i class="bi bi-plus-lg"></i>
									</button>
								</div>
							</div>
						</div>
						<hr />
						<p class="h5 text-right">
							총 <span id="totalCnt"><%=ri2.getRi_acnt() + ri2.getRi_scnt() + ri2.getRi_ccnt()%></span>명
						</p>
					</div>
					<div class="col-md-6 mb-5">
						<h4>선택 좌석</h4>
						<p id="seatArr" class="h5">좌석을 선택해주세요.</p>
						<hr />
					</div>
					<div class="col-md-6">
						<h4>금액</h4>
						<div class="d-flex justify-content-between">
							<span>성인 <span id="adult2"><%=ri2.getRi_acnt()%></span>명
							</span> <span id="adultFee"><%=String.format("%,d", (ri2.getRi_acnt() * ri2.getAdult_fee()))%></span>
						</div>
						<div class="d-flex justify-content-between">
							<span>청소년 <span id="teen2"><%=ri2.getRi_scnt()%></span>명
							</span> <span id="teenFee"><%=String.format("%,d", (ri2.getRi_scnt() * ri2.getStudent_fee()))%></span>
						</div>
						<div class="d-flex justify-content-between">
							<span>아동 <span id="child2"><%=ri2.getRi_ccnt()%></span>명
							</span> <span id="childFee"><%=String.format("%,d", (ri2.getRi_ccnt() * ri2.getChild_fee()))%></span>
						</div>
						<hr />
						<p class="h5 text-right mb-5">
							총 <span id="totalFee"><%=String.format("%,d", (ri2.getRi_acnt() * ri2.getAdult_fee() + ri2.getRi_scnt() * ri2.getStudent_fee() + ri2.getRi_ccnt() * ri2.getChild_fee()))%></span>원
						</p>
						<button type="button" id="submitBtn" class="btn btn-primary btn-block">선택완료</button>
					</div>
				</div>
			</div>
		</form>
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>
<script>
const selectedValues = [];
const seats = document.getElementsByName("seatBoxDtl");

function getSeat(obj) {

	const value = obj.value;
	const index = selectedValues.indexOf(value); // 체크한 값이 배열에 이미 있는지 확인을 위한 변수

	let seatsCnt = 0;
	let max = parseInt($("#totalCnt").text());
	for (let i = 0; i < seats.length; i++) {
		if (seats[i].checked) {
			seatsCnt++;
		}
	}
	if (seatsCnt > max) {
		alert("가는편의 매수와 동일하게 선택 가능합니다.");
		obj.checked = false;
		return false;
	}

	if (index === -1) {
		selectedValues.push(value);
	} else {
		selectedValues.splice(index, 1);
	}

	// 배열 오름차순 정렬
	selectedValues.sort(function(a, b) {
		return a - b;
	});

	$("#seatArr").text(selectedValues.join(", "));

	if (selectedValues.length == 0) {
		$("#seatArr").text("좌석을 선택해주세요.");
	}

}

$(document).ready(function() {

	$("#submitBtn").click(function() {
		if (!(selectedValues.length == parseInt($("#totalCnt").text()))) {
			alert("좌석을 선택해주세요.");
		} else {
			document.frmSeat.submit();
		}
	});
});
</script>