<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<BannerInfo> bi = (List<BannerInfo>) request.getAttribute("bi");
List<ReservationInfo> recentReservation = (List<ReservationInfo>) request.getAttribute("recentReservation");
String cookie = request.getAttribute("isViewPop").toString();
%>
<section class="section">
	<div class="container">
		<div class="row">
			<div id="bannerArea" class="col-md-8">
				<div id="carouselIndicators" class="carousel slide" data-ride="carousel">
					<ol class="carousel-indicators">
						<li data-target="#carouselIndicators" data-slide-to="0" class="active"></li>
						<li data-target="#carouselIndicators" data-slide-to="1"></li>
						<li data-target="#carouselIndicators" data-slide-to="2"></li>
					</ol>
					<div class="carousel-inner">
						<%
							if (bi.size() > 0) {
								for (int i = 0; i < bi.size(); i++) {
									if (i == 0) {
						%>
						<div class="carousel-item active">
							<%
								} else {
							%>
							<div class="carousel-item">
							<%
								}
							%>
								<img src="${pageContext.request.contextPath}/resources/images/banner/<%= bi.get(i).getBl_img() %>" class="d-block w-100" alt="...">
							</div>
							<%
								}
							}
							%>
						<button class="carousel-control-prev" type="button" data-target="#carouselIndicators" data-slide="prev">
							<span class="carousel-control-prev-icon" aria-hidden="true"></span> <span class="sr-only">Previous</span>
						</button>
						<button class="carousel-control-next" type="button" data-target="#carouselIndicators" data-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span> <span class="sr-only">Next</span>
						</button>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<form name="frmSchSchedule" method="POST">
				<input type="hidden" name="mode" id="mode" value="p" />
				<input type="hidden" name="frDate" id="frDate" />
				<input type="hidden" name="toDate" id="toDate" />
				<input type="hidden" name="frCode" id="frCode" />
				<input type="hidden" name="toCode" id="toCode" />
				<div class="form-group">
					<ul class="nav nav-pills nav-justified mb-3" id="pills-tab" role="tablist">
						<li class="nav-item travel">
							<button class="nav-link travel w-100 active" data-toggle="pill" data-target="#one-way" type="button" role="tab">편도</button>
						</li>
						<li class="nav-item travel">
							<button class="nav-link travel w-100" data-toggle="pill" data-target="#two-way" type="button" role="tab">왕복</button>
						</li>
					</ul>
					<div class="row">
						<div class="col-md">
							<div class="form-check custom">
								<input class="form-check-input" type="radio" name="busType" id="highBus" value="H" checked="">
									<label class="form-check-label" for="highBus">고속</label>
							</div>
							<div class="form-check custom">
								<input class="form-check-input" type="radio" name="busType" id="slowBus" value="S">
									<label class="form-check-label" for="slowBus">시외</label>
							</div>
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-md">
							<div class="form-group">
								<label for="sPoint">출발지</label>
								<div class="probootstrap-date-wrap">
									<span class="icon ion-android-pin"></span>
									<input type="text" class="form-control bg-white" id="frName" name="frName" readonly onclick="openModal();">
								</div>
							</div>
						</div>
						<div class="col-md">
							<div class="form-group">
								<label for="ePoint">도착지</label>
								<div class="probootstrap-date-wrap">
									<span class="icon ion-android-pin"></span>
									<input type="text" class="form-control bg-white" id="toName" name="toName" readonly>
								</div>
							</div>
						</div>
					</div>
					<div class="tab-content" id="pills-tabContent">
						<div class="tab-pane active" id="one-way" role="tabpanel">
							<div class="row mb-3">
								<div class="col-md">
									<div class="form-group">
										<label for="sDate1-2">가는날</label>
										<div class="input-with-icon-wrap">
											<i class="icon bi bi-calendar"></i>
											<input type="text" id="frDate1" class="form-control bg-white" readonly>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="tab-pane" id="two-way" role="tabpanel">
							<div class="row mb-3">
								<div class="col-md">
									<div class="form-group">
										<label for="sDate2-2">가는날</label>
										<div class="input-with-icon-wrap">
											<i class="icon bi bi-calendar"></i>
											<input type="text" id="frDate2" class="form-control bg-white" readonly>
										</div>
									</div>
								</div>
								<div class="col-md">
									<div class="form-group">
										<label for="eDate1-2">오는날</label>
										<div class="input-with-icon-wrap">
											<i class="icon bi bi-calendar"></i>
											<input type="text" id="toDate1" class="form-control bg-white" readonly>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row mb-3">
						<div class="col-md">
							<input type="button" id="schBtn" value="조회하기" class="btn btn-primary btn-block">
						</div>
					</div>
				</div>
				</form>
			</div>
		</div>
	</div>	
	<%
	if (recentReservation != null && recentReservation.size() == 1 && cookie == "") {
	%>
	<div class="modal fade" id="ViewModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel" align="center">예약 알림 안내</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body mt-5 mb-5">
					<div class="text-center">
						<p class="h5">
							<%=loginInfo.getMi_id()%>님
						</p>
						<p>
							예매하신 버스 출발일이
							<%=recentReservation.get(0).getRi_date()%>
							남았습니다.
						</p>
						<a href="booking" class="btn btn-primary mt-3">예매 확인</a>
					</div>
				</div>
				<div class="modal-footer">
					<button id="isViewBtn" type="button" class="d-flex justify-content-between btn btn-secondary btn-block p-2" data-dismiss="modal">
						오늘 하루 보지 않기<span aria-hidden="true">&times;</span>
					</button>
				</div>
			</div>
		</div>
	</div>
	<%
	}
	%>
</section>
<%@ include file="_inc/foot.jsp"%>
<script>
	$(document).ready(function() {
		$("#ViewModal").modal('show');
	});

	$("#isViewBtn").click(function() {
		$.ajax({
			url : "createCookieForPop",
			type : "GET"
		});
	});
</script>