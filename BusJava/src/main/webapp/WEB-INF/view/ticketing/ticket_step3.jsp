<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
ReservationInfo ri1 = (ReservationInfo) session.getAttribute("ri1");
String mode = ri1.getMode();

int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
int leftSeat = Integer.parseInt(request.getParameter("leftSeat"));

List<Integer> seatList = (List<Integer>) session.getAttribute("seatList");
int adult_fee = ri1.getAdult_fee(), student_fee = ri1.getStudent_fee(), child_fee = ri1.getChild_fee();

String action = "";
if (mode.equals("p"))	action = "payment";
else	action = "step04";
%>
<section class="section">
	<div class="container">
		<div class="row text-center">
			<div class="col-md-12">
				<h2 class="border-bottom heading"><%=ri1.getRi_line_type().equals("H") ? "고속" : "시외"%>버스 예매</h2>
			</div>
			<div class="col-md-12">
				<%
					if (mode.equals("p")) { // 편도일 경우
				%>
				<div class="col-md-8 m-auto">
					<div class="progress-bar-custom 1">
						<div class="progress-step ">
							<div class="step-count"></div>
							<div class="step-description">정보 입력</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">배차 조회</div>
						</div>
						<div class="progress-step is-active">
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
				<%
					} else { // 왕복일 경우
				%>
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
						<div class="progress-step is-active">
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
				<%
					}
				%>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 text-center mb-5">
				<h5 class="text-left">가는편</h5>
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
							<td><%=ri1.getRi_fr()%></td>
							<td class="align-middle"><span class="badge badge-primary text-white font-weight-normal">도착지</span></td>
							<td><%=ri1.getRi_to()%></td>
							<td><%=ri1.getRi_frdate().substring(0, 11)%></td>
							<td>출발 <%=ri1.getRi_frdate().substring(11, 16)%></td>
							<td>도착 <%=ri1.getRi_todate().substring(11, 16)%></td>
							<td><%=ri1.getRi_com()%></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<form name="frmSeat" action="<%=action%>" method="post">
			<input type="hidden" name="totalFee" class="totalFee" value="" />
			<div class="row justify-content-center">
				<div class="col-md-6 text-center">
					<p class="mb-0 h5">
						좌석선택
						<%=leftSeat%>/<%=totalSeat%></p>
					<div
						class="seat-bg ml-auto 
<%if (ri1.getRi_level().indexOf("일반") != -1 || ri1.getRi_level().indexOf("고속") != -1) {%>
	seat45
<%} else if (ri1.getRi_level().indexOf("우등") != -1) {%>
	seat28
<%} else if (ri1.getRi_level().indexOf("프리") != -1) {%>
	seat21
<%}%>			
			 ">
						<div class="seat-list">
							<%
								for (int i = 1; i < totalSeat + 1; i++) {
							%>
							<span
								class="seat-box <%if (seatList.contains(i)) {%> disabled <%}%>">
								<input type="checkbox" name="seatBoxDtl" id="seatNum_<%=i%>"
								value="<%=i%>" onclick="getSeat(this);"
								<%if (seatList.contains(i)) {%> disabled <%}%>> <label
								for="seatNum_<%=i%>"><%=i%></label>
							</span>
							<%
								}
							%>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="col-md-6 mb-5">
						<h4>매수</h4>
						<div class="d-flex mb-2 align-items-center justify-content-between">
							<span class="mr-3">성인</span>
							<div class="col-md-7">
								<div class="btn-group custom">
									<button type="button" id="minusA" class="btn btn-primary p-1" onclick="setCnt(this.id);">
										<i class="bi bi-dash-lg"></i>
									</button>
									<input class="form-control text-center bg-white" type="text" name="adultCnt" id="adultCnt" value="0" size="5" readonly>
									<button type="button" id="plusA" class="btn btn-primary p-1" onclick="setCnt(this.id);">
										<i class="bi bi-plus-lg"></i>
									</button>
								</div>
							</div>
						</div>
						<div class="d-flex mb-2 align-items-center justify-content-between">
							<span class="mr-3">청소년</span>
							<div class="col-md-7">
								<div class="btn-group custom">
									<button type="button" id="minusT" class="btn btn-primary p-1" onclick="setCnt(this.id);">
										<i class="bi bi-dash-lg"></i>
									</button>
									<input class="form-control text-center bg-white" type="text" name="teenCnt" id="teenCnt" value="0" size="5" readonly>
									<button type="button" id="plusT" class="btn btn-primary p-1" onclick="setCnt(this.id);">
										<i class="bi bi-plus-lg"></i>
									</button>
								</div>
							</div>
						</div>
						<div class="d-flex mb-2 align-items-center justify-content-between">
							<span class="mr-3">아동</span>
							<div class="col-md-7">
								<div class="btn-group custom">
									<button type="button" id="minusC" class="btn btn-primary p-1" onclick="setCnt(this.id);">
										<i class="bi bi-dash-lg"></i>
									</button>
									<input class="form-control text-center bg-white" type="text" name="childCnt" id="childCnt" value="0" size="5" readonly>
									<button type="button" id="plusC" class="btn btn-primary p-1" onclick="setCnt(this.id);">
										<i class="bi bi-plus-lg"></i>
									</button>
								</div>
							</div>
						</div>
						<hr />
						<p class="h5 text-right">
							총 <span id="totalCnt">0</span>명
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
							<span>성인 <span id="adult2">0</span>명
							</span> <span id="adultFee">0</span>
						</div>
						<div class="d-flex justify-content-between">
							<span>청소년 <span id="teen2">0</span>명
							</span> <span id="teenFee">0</span>
						</div>
						<div class="d-flex justify-content-between">
							<span>아동 <span id="child2">0</span>명
							</span> <span id="childFee">0</span>
						</div>
						<hr />
						<p class="h5 text-right mb-5">
							총 <span class="totalFee"></span>원
						</p>
						<button type="button" id="submitBtn"
							class="btn btn-primary btn-block">선택완료</button>
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
	let seatsCnt = 0;

	const setCnt = function(op) {
		if ( <%=leftSeat%> >= 10) {
			if ($("#totalCnt").text() == 10
					&& (op == 'plusA' || op == 'plusT' || op == 'plusC')) {
				alert("최대 예약 가능 인원은 10명입니다.");
				return;
			}
		} else if ( <%=leftSeat%> < 10) {
			if ($("#totalCnt").text() == <%=leftSeat%> && (op == 'plusA' || op == 'plusT' || op == 'plusC')) {
				alert("예약 가능한 좌석을 모두 선택하셨습니다.");
				return;
			}
		}

		let adultFee = <%=adult_fee%>;
		let teenFee = <%=student_fee%>;
		let childFee = <%=child_fee%>;

		let adultCnt = parseInt($("#adultCnt").val());
		let teenCnt = parseInt($("#teenCnt").val());
		let childCnt = parseInt($("#childCnt").val());
		let totalCnt = parseInt($("#totalCnt").text());

		// 연산자 마이너스, 해당 필드가 0인경우 return
		if ((op == 'minusA' && adultCnt === 0) || (op == 'minusT' && teenCnt === 0) || (op == 'minusC' && childCnt === 0)) {
			return;
		}

		if ((op == 'minusA' || op == 'minusT' || op == 'minusC') && totalCnt == selectedValues.length) {
			return;
		}

		if (op == 'minusA' || op == 'minusT' || op == 'minusC') {
			if (seatsCnt == selectedValues.length) {
				if (selectedValues.length == 0) {
					$("#seatArr").text("좌석을 선택해주세요.");
				} else {
					$("#seatArr").text(selectedValues.join(", "));
				}
			}
		}

		// 어른 필드 계산시
		if (op == 'minusA' && !(adultCnt < 1)) {
			$("#adultCnt").val(adultCnt - 1);
			adultCnt--;
		} else if (op == 'plusA' && !(adultCnt > 9)) {
			$("#adultCnt").val(adultCnt + 1);
			adultCnt++;
		}

		// 청소년 필드 계산시
		if (op == 'minusT' && !(teenCnt < 1)) {
			$("#teenCnt").val(teenCnt - 1);
			teenCnt--;
		} else if (op == 'plusT' && !(teenCnt > 9)) {
			$("#teenCnt").val(teenCnt + 1);
			teenCnt++;
		}

		// 아동 필드 계산시
		if (op == 'minusC' && !(childCnt < 1)) {
			$("#childCnt").val(childCnt - 1);
			childCnt--;
		} else if (op == 'plusC' && !(childCnt > 9)) {
			$("#childCnt").val(childCnt + 1);
			childCnt++;
		}

		$("#totalCnt").text(adultCnt + teenCnt + childCnt);
		$("#adult2").text(adultCnt);
		$("#teen2").text(teenCnt);
		$("#child2").text(childCnt);
		$("#adultFee").text((adultFee * adultCnt).toLocaleString("ko-KR"));
		$("#teenFee").text((teenFee * teenCnt).toLocaleString("ko-KR"));
		$("#childFee").text((childFee * childCnt).toLocaleString("ko-KR"));
		$(".totalFee").val(adultFee * adultCnt + teenFee * teenCnt + childFee * childCnt);
		$("span.totalFee").text((adultFee * adultCnt + teenFee * teenCnt + childFee * childCnt).toLocaleString("ko-KR"));
	}

	const getSeat = function(obj) {
		const value = obj.value;
		const index = selectedValues.indexOf(value); // 체크한 값이 배열에 이미 있는지 확인을 위한 변수

		let max = parseInt($("#totalCnt").text());
		seatsCnt = $("input[name='seatBoxDtl']:checked").length;

		if (seatsCnt > max) {
			alert("먼저 매수를 선택해 주세요.");
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

	$("#submitBtn").click(function() {
		if (!(selectedValues.length == parseInt($("#totalCnt").text()))) {
			alert("좌석을 선택해주세요.");
		} else {
			document.frmSeat.submit();
		}
	});
</script>