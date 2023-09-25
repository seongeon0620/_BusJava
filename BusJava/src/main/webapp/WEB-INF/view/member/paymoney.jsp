<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%
request.setCharacterEncoding("utf-8");
MemberInfo mi = (MemberInfo) session.getAttribute("loginInfo");
List<paymoneyInfo> pList = (List<paymoneyInfo>) request.getAttribute("pList");
List<paymoneyInfo> mphList = (List<paymoneyInfo>) request.getAttribute("mphList");
NumberFormat nf = NumberFormat.getInstance();

String mi_pmoney = "";
if (mi.getMi_pmoney() > 0) {
	nf = NumberFormat.getInstance();
	mi_pmoney = nf.format(mi.getMi_pmoney());
	// 이제 formattedNumber는 세 자리마다 쉼표가 찍힌 숫자를 문자열 형태로 저장합니다.
}
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">내 페이머니</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-md-8 text-center m-auto">
				<table class="table text-center mt-2">
					<colgroup>
						<col width="*">
						<col width="16.5%">
						<col width="25%">
					</colgroup>
					<tbody>
						<p class="h4 text-left text">보유 페이머니</p>
						<tr>
							<%
							if (mi.getMi_pmoney() <= 0) {
							%>
							<td class="text-left">보유중인 페이머니가 없습니다.</td>
							<td colspan="2" class="text-right">
								<button type="button" class="btn btn-primary" onclick="openModal();">충전하기</button>
							</td>
						</tr>
						<%
						} else {
						%>
						<tr>
							<td class="text-left">
								<p class="h2 mb-0"><%=mi_pmoney%>
									원
								</p>
							</td>
							<td colspan="2" class="text-right">
								<button type="button" class="btn btn-primary" onclick="openModal();">충전하기</button>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				<p class="h4 mt-5 text-left text">페이머니 사용 내역</p>
				<div class="btn-wrap justify-content-start">
					<p class="mb-0">최근 3개월 내역만 노출됩니다.</p>
				</div>
				<table class="table text-center mt-2">
					<colgroup>
						<col width="15%">
						<col width="40%">
						<col width="*">
					</colgroup>
					<tbody>
						<%
						if (pList.size() > 0) {
							for (paymoneyInfo pl : pList) {
								String Total_cr_pmoney = "";
								if (pl.getPd_real_price() > 0) {
							nf = NumberFormat.getInstance();
							Total_cr_pmoney = nf.format(pl.getPd_real_price());
								}
						%>
						<tr>
							<td class="align-middle">
								<p class="h2 mb-0">
									-<%=Total_cr_pmoney%></p>
							</td>
							<td class="text-left">
								<p class="mb-0"><%=pl.getRi_line_type()%>버스 예매
								</p>
								<p class="mb-0"><%=pl.getRi_fr()%>
									<i class="bi bi-arrow-right"></i>
									<%=pl.getRi_to()%></p>
							</td>
							<td class="text-right">
								<span class="font-weight-bold mr-1">사용일시</span>
								<%=pl.getPd_date().substring(0, 16)%></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="3" class="text-left text-muted pl-0">페이머니 사용 내역이 존재하지 않습니다.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>

				<p class="h4 mt-5 text-left text">페이머니 충전 내역</p>
				<div class="btn-wrap justify-content-start">
					<p class="mb-0">최근 3개월 내역만 노출됩니다.</p>
				</div>
				<table class="table text-center mt-2">
					<colgroup>
						<col width="15%">
						<col width="40%">
						<col width="*">
					</colgroup>
					<tbody>
						<%
						if (mphList.size() > 0) {
						for (paymoneyInfo mpl : mphList) {
							String Ph_pmoney = "";
							if (mpl.getPh_pmoney() > 0) {
								nf = NumberFormat.getInstance();
								Ph_pmoney = nf.format(mpl.getPh_pmoney());
								// 이제 formattedNumber는 세 자리마다 쉼표가 찍힌 숫자를 문자열 형태로 저장합니다.
							}
						%>
						<tr>
							<td class="align-middle">
								<p class="h2 mb-0">
									+<%=Ph_pmoney%></p>
							</td>
							<td class="text-left">
								<p class="mb-0"><%=mpl.getPh_real_price() / 10000%>만원 충전
								</p>
								<p class="mb-0">10% 추가 적립</p>
							</td>
							<td class="text-right">
								<span class="font-weight-bold mr-1">충전일시</span>
								<%=mpl.getPh_date().substring(0, 16)%></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="3" class="text-left text-muted pl-0">페이머니 충전 내역이 존재하지 않습니다.</td>
						</tr>
						<% } %>
					</tbody>
				</table>
			</div>
		</div>
		<div class="modal fade" id="PayMoneyModal" tabindex="-1" role="dialog">
			<div class="modal-dialog" role="document">
				<div class="modal-content"></div>
			</div>
		</div>
</section>
<script>
	function openModal() {
		$("#PayMoneyModal .modal-content").load("/BusJava/pmoneyCharge1");
		$('#PayMoneyModal').modal();
	}
</script>
<%@ include file="../_inc/foot.jsp"%>
