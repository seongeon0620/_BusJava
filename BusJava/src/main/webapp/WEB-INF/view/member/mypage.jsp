<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">마이페이지</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-md-10 text-center mb-5 m-auto">
				<div class="d-flex align-items-end">
					<h3 class="text-left text-primary"><%=memName %></h3>
					<h5 class="text-left">님 반갑습니다.</h5>
				</div>
				<ul class="mypage">
					<li><a href="pwChk" class="text-decoration-none">
							<div class="h-100 d-flex justify-content-center align-items-center flex-column">
								<img src="${pageContext.request.contextPath}/resources/images/User.svg" />
								<p class="h5 mt-3">내 정보</p>
							</div>
					</a></li>
					<li><a href="booking" class="text-decoration-none">
							<div class="h-100 d-flex justify-content-center align-items-center flex-column">
								<img src="${pageContext.request.contextPath}/resources/images/Newspaper.svg" />
								<p class="h5 mt-3">예매 내역</p>
							</div>
					</a></li>
					<li><a href="payMoney" class="text-decoration-none">
							<div class="h-100 d-flex justify-content-center align-items-center flex-column">
								<img src="${pageContext.request.contextPath}/resources/images/Copyright.svg" />
								<p class="h5 mt-3">내 페이머니</p>
							</div>
					</a></li>
					<li><a href="mypage/coupon" class="text-decoration-none">
							<div class="h-100 d-flex justify-content-center align-items-center flex-column">
								<img src="${pageContext.request.contextPath}/resources/images/Money.svg" />
								<p class="h5 mt-3">내 쿠폰</p>
							</div>
					</a></li>
					<li><a href="mypage/stamp" class="text-decoration-none">
							<div class="h-100 d-flex justify-content-center align-items-center flex-column">
								<img src="${pageContext.request.contextPath}/resources/images/Gift.svg" />
								<p class="h5 mt-3">내 스탬프</p>
							</div>
					</a></li>
				</ul>
			</div>
		</div>
</section>

<%@ include file="../_inc/foot.jsp"%>