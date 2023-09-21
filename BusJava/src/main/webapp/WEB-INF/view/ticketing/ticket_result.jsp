<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
ReservationInfo ri1 = (ReservationInfo) session.getAttribute("ri1");
ReservationInfo ri2 = null;
int discount = ri1.getDiscountFee();
int realPrice = ri1.getTotalFee() - discount;
String reservedDate = request.getAttribute("reservedDate").toString();
String reservedPayment = request.getAttribute("reservedPayment").toString();
%>
<section class="section">
	<div class="container">
		<div class="row text-center">
			<div class="col-md-12">
				<h2 class="border-bottom heading"><%=ri1.getRi_line_type().equals("고속") ? "고속" : "시외" %>버스 예매</h2>
			</div>
			<div class="col-md-12">
				<% if (ri1.getMode().equals("p")) { // 편도일 경우 %>
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
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">좌석 선택</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">확인/결제</div>
						</div>
						<div class="progress-step is-active">
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
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">오는 날 좌석 선택</div>
						</div>
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">확인/결제</div>
						</div>
						<div class="progress-step is-active">
							<div class="step-count"></div>
							<div class="step-description">예매 결과</div>
						</div>
					</div>
				</div>
				<% } %>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="allchkbox active mb-5 mt-5">
					<input type="checkbox" id="chkAll">
					<label for="chkAll" id="chkAllL"><i class="bi bi-check-lg"></i>예매가 완료되었습니다.</label>
				</div>
			</div>
			<div class="col-md-12 text-center mb-5">
				<h4 class="text-left text-primary">승차권 정보</h4>
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
						<tr>
							<td class="align-middle"><span class="badge badge-danger font-weight-normal">출발지</span></td>
							<td><%=ri1.getRi_fr() %></td>
							<td class="align-middle"><span class="badge badge-primary text-white font-weight-normal">도착지</span></td>
							<td><%=ri1.getRi_to() %></td>
							<td><%=ri1.getRi_frdate().substring(0, 11) %></td>
							<td>출발 <%=ri1.getRi_frdate().substring(11, 16) %></td>
							<td>도착 <%=ri1.getRi_todate().substring(11, 16) %></td>
							<td><%=ri1.getRi_com() %></td>
						</tr>
						<tr class="border-b">
							<td colspan="2">예매 매수</td>
							<td colspan="3" class="text-left">어른 <%=ri1.getRi_acnt() %>명,
								청소년 <%=ri1.getRi_scnt() %>명, 아동 <%=ri1.getRi_ccnt() %>명
							</td>
							<td>예매 좌석</td>
							<td colspan="2" class="text-left"><%=ri1.getSeat() %></td>
						</tr>
					</tbody>
				</table>
<% 
	if (ri1.getMode().equals("w")) {
	ri2 = (ReservationInfo) session.getAttribute("ri2");
	realPrice += ri2.getTotalFee();
%>
				<h5 class="text-left mt-5">오는편</h5>
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
						<tr>
							<td class="align-middle"><span class="badge badge-danger font-weight-normal">출발지</span></td>
							<td><%=ri2.getRi_fr() %></td>
							<td class="align-middle"><span class="badge badge-primary text-white font-weight-normal">도착지</span></td>
							<td><%=ri2.getRi_to() %></td>
							<td><%=ri2.getRi_frdate().substring(0, 11) %></td>
							<td>출발 <%=ri2.getRi_frdate().substring(11, 16) %></td>
							<td>도착 <%=ri2.getRi_todate().substring(11, 16) %></td>
							<td><%=ri2.getRi_com() %></td>
						</tr>
						<tr class="border-b">
							<td colspan="2">예매 매수</td>
							<td colspan="3" class="text-left">어른 <%=ri2.getRi_acnt() %>명,
								청소년 <%=ri2.getRi_scnt() %>명, 아동 <%=ri2.getRi_ccnt() %>명
							</td>
							<td>예매 좌석</td>
							<td colspan="2" class="text-left"><%=ri2.getSeat() %></td>
						</tr>
					</tbody>
				</table>
				<% } %>
			</div>
			<div class="col-md-12 text-center mb-5">
				<h4 class="text-left text-primary">결제 정보</h4>
				<table class="table">
					<colgroup>
						<col width="25%">
						<col width="25%">
						<col width="25%">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th class="text-center bg-light">결제일시</th>
							<td><%=reservedDate %></td>
							<th class="text-center bg-light">결제방법</th>
							<td><%=reservedPayment %></td>
						</tr>
						<tr>
							<th class="text-center bg-light">할인금액</th>
							<td class="text-right">
							<% if (discount == 0) { %> - <% } else { %>-<%=String.format("%,d", discount) %>원<% } %>
							</td>
							<th class="text-center bg-light">결제금액</th>
							<td class="text-right"><%=String.format("%,d", realPrice) %>원</td>
						</tr>
					</tbody>
				</table>
				<ul class="text-left">
					<li>인터넷 예매를 이용한 승차권의 발권 및 환불은 해당 승차권의 출발지 터미널에서만 가능합니다.</li>
					<li>승차권 예매와 관련한 문의사항은 콜센터로 문의해주시기 바랍니다.</li>
				</ul>
				<div class="btn-wrap mt-2">
					<a href="../booking" class="btn btn-lg btn-primary">예매 확인</a>
				</div>
			</div>
</section>
<%@ include file="../_inc/foot.jsp"%>