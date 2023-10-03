<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<BookInfo> bookList = (List<BookInfo>) request.getAttribute("bookList");
PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
//View로 넘어갈때  cpage번호랑 예매번호 가지고 가야함
%>
<section class="section">
	<div class="container">
		<div class="row text-center">
			<div class="col-md-12">
				<h2 class="border-bottom heading mb-5">예매 내역</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table class="table">
					<colgroup>
						<col width="*">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col" class="text-center">예매번호</th>
							<th scope="col" class="text-center">구분</th>
							<th scope="col" class="text-center">출발지</th>
							<th scope="col" class="text-center">도착지</th>
							<th scope="col" class="text-center">출발일자</th>
							<th scope="col" class="text-center">출발시간</th>
							<th scope="col" class="text-center">상태</th>
						</tr>
					</thead>
					<tbody class="text-center">
						<%
						if (bookList.size() > 0) {
							for (BookInfo bl : bookList) {
						%>
						<tr>
							<!-- 이동할 주소입력(ri_idx값 들고 가야함) -->
							<td>
								<a href="bookDetail${pi.getArgs()}&riidx=<%=bl.getRi_idx()%>"><%=bl.getRi_idx()%></a>
							</td>
							<td><%=bl.getRi_line_type()%></td>
							<td><%=bl.getRi_fr()%></td>
							<td><%=bl.getRi_to()%></td>
							<td><%=bl.getRi_frdate()%></td>
							<td><%=bl.getRi_frtime()%></td>
							<td><%=bl.getRi_status()%></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td class="text-center" colspan="7">예매내역이 존재하지 않습니다.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				<!-- 페이지 네이션 부분-------------------------------------- -->
				<%
				if (bookList.size() > 0) {
				%>
				<%@ include file="../_inc/pagination.jsp"%>
				<%}%>
				<!-- 페이지 네이션 부분-------------------------------------- -->
			</div>
		</div>
		<ul>
			<li>예매 내역 및 예매 취소 내역은 과거 3개월까지 조회 가능합니다.</li>
			<li>신용카드 예매 취소 시 일주일 내로 예매했던 카드로 청구 취소 처리가 되면서 반환됩니다.</li>
		</ul>
	</div>

</section>
<%@ include file="../_inc/foot.jsp"%>