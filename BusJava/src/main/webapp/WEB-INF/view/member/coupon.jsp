<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
List<UserResourceInfo> couponList = (ArrayList<UserResourceInfo>)request.getAttribute("couponList");
List<UserResourceInfo> couponHistoryList = (ArrayList<UserResourceInfo>)request.getAttribute("couponHistoryList");
%>
<section class="probootstrap_section">
	<div class="container">
		<div class="row text-center mb-5 probootstrap-animate fadeInUp probootstrap-animated">
			<div class="col-md-12"><h2 class="border-bottom probootstrap-section-heading">내 쿠폰</h2></div>
		</div>
		<div class="row">
			<div class="col-md-8 text-center mb-5 m-auto">
				<p class="h4 text-left text">보유중인 쿠폰 <%=loginInfo.getMi_coupon() %>장</p>
				<div class="col-md-12 p-0 d-flex justify-content-between flex-wrap">
					<c:choose>
						<c:when test="${ couponList.size() > 0 }">
							<c:forEach items="${couponList}" var="cl" varStatus="status">
								<div class="coupon mb-3">
									<div class="center">
										<div>
											<h2>예매 1회 무료</h2>
											<h3 class="mb-1">Coupon</h3>
											<p class="mb-0">${ cl.getDate()}</p>
										</div>
									</div>
									<div class="right">
										<div>------</div>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<p class="text-muted">보유중인 쿠폰이 없습니다.</p>
						</c:otherwise>
					</c:choose>
				</div>
				<p class="h4 mt-5 text-left text">쿠폰 적립&사용 내역</p>
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
							<c:when test="${ couponHistoryList.size() > 0 }">
								<c:forEach items="${couponHistoryList}" var="cl"
									varStatus="status">
									<tr>
										<td class="align-middle"><p class="h2 mb-0">${ cl.getAction() == '적립' ? '+' : '-'}${ cl.getCnt() }</p></td>
										<td class="text-left">
											<p class="mb-0">
												<c:choose>
													<c:when test="${cl.getAction() == '적립'}">버스 무료 탑승권</c:when>
													<c:otherwise>${cl.getLine_type()}버스 예매</c:otherwise>
												</c:choose>
											</p>
											<p class="mb-0">
												<c:choose>
													<c:when test="${cl.getAction() == '적립'}">스탬프 30개 리워드</c:when>
													<c:otherwise>${cl.getRi_fr()} <i
															class="bi bi-arrow-right"></i> ${cl.getRi_to()}</c:otherwise>
												</c:choose>
											</p>
										</td>
										<td class="text-right"><span class="mr-2">${ cl.getAction()}일시</span>
											${ cl.getDate()}</td>
									<tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="3" class="text-left text-muted pl-0">쿠폰 적립&사용 내역이 존재하지 않습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
</section>
<%@ include file="../_inc/foot.jsp"%>