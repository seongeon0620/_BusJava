<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
	List<UserResourceInfo> stampHistoryList = (ArrayList<UserResourceInfo>)request.getAttribute("stampHistoryList");
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">내 스탬프</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-md-8 text-center mb-5 m-auto">
				<div class="d-flex justify-content-between">
					<p class="h5">예매 금액 20,000원당 스탬프 1개 적립</p>
					<p class="h5"><%=loginInfo.getMi_stamp() %> / 30</p>
				</div>
				<table class="table text-center table-bordered stamp">
					<colgroup>
						<col width="16.5%">
						<col width="16.5%">
						<col width="16.5%">
						<col width="16.5%">
						<col width="16.5%">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<c:forEach var="i" begin="1" end="30" varStatus="status">
								<c:choose>
									<c:when test="${i <= loginInfo.getMi_stamp()}">
										<td class="align-middle"><img
											src="${pageContext.request.contextPath}/resources/images/stamp.png" />
										</td>
									</c:when>
									<c:otherwise>
										<td class="align-middle">${i}</td>
									</c:otherwise>
								</c:choose>
								<c:if test="${i % 6 == 0}">
						</tr>
						<tr>
							</c:if>
							</c:forEach>
					</tbody>
				</table>
				<p class="h4 mt-5 text-left text">스탬프 적립&사용 내역</p>
				<p class="mb-0 text-left">최근 3개월 내역만 노출됩니다.</p>
				<!-- <div class="btn-wrap justify-content-start">
              <button type="button" class="btn btn-primary">3개월</button>
              <button type="button" class="btn btn-secondary">6개월</button>
              <button type="button" class="btn btn-secondary">1년</button>
            </div> -->
				<table class="table text-center mt-2">
					<colgroup>
						<col width="15%">
						<col width="40%">
						<col width="*">
					</colgroup>
					<tbody>
						<c:choose>
							<c:when test="${ stampHistoryList.size() > 0 }">
								<c:forEach items="${stampHistoryList}" var="sl" varStatus="status">
									<tr>
										<td class="align-middle"><p class="h2 mb-0">${ sl.getAction() == '적립' ? '+' : '-'}${ sl.getCnt() }</p></td>
										<td class="text-left">
											<p class="mb-0">
												<c:choose>
													<c:when test="${sl.getAction() == '적립'}">${sl.getLine_type()}버스 예매</c:when>
													<c:otherwise>버스 무료 탑승권</c:otherwise>
												</c:choose>
											</p>
											<p class="mb-0">
												<c:choose>
													<c:when test="${sl.getAction() == '적립'}">${sl.getRi_fr()} <i class="bi bi-arrow-right"></i> ${sl.getRi_to()}</c:when>
													<c:otherwise>스탬프 30개 리워드</c:otherwise>
												</c:choose>
											</p>
										</td>
										<td class="text-right"><span class="mr-2">${ sl.getAction()}일시</span> ${ sl.getDate()}</td>
									<tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="3" class="text-left text-muted pl-0">스탬프 적립&사용 내역이 존재하지 않습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
</section>
<%@ include file="../_inc/foot.jsp"%>