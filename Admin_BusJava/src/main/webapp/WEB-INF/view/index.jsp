<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/head.jsp" %>
<script>
const hTopLineJson = '${hTopLineList}';
const sTopLineJson = '${sTopLineList}';
const hSalesQuarterLast = ${hSalesQuarterLast};
const hSalesQuarterNow = ${hSalesQuarterNow};
const sSalesQuarterLast = ${sSalesQuarterLast};
const sSalesQuarterNow = ${sSalesQuarterNow};
</script>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">대시보드</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
			    <ol class="breadcrumb m-0 p-0">
			    	 <li class="breadcrumb-item text-muted active" aria-current="page">Dashboard</li>
			    </ol>
			</nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="card-group">
			<c:forEach var="i" begin="0" end="${salesList.size() - 1}" varStatus="status">
			<div class="card border-right">
				<div class="card-body">
					<div class="d-md-block">
						<div>
							<div class="d-flex justify-content-end align-items-center">
								<h2 class="text-dark mb-1 font-weight-medium">
									<fmt:formatNumber value="${salesList.get(i).get('Sales')}" pattern="#,##0원"/>
								</h2>
							</div>
							<div class="d-flex justify-content-between">
								<h4 class="text-muted font-weight-normal mb-0 w-100 text-truncate">${salesList.get(i).get("Title")}</h4>
								<h4 class="text-muted font-weight-normal mb-0 w-100 text-truncate text-right">
									<span class="text-dark">
										<fmt:formatNumber value="${salesList.get(i).get('Count')}" pattern="#,##0"/>
									</span>건
								</h4>
							</div>
						</div>
					</div>
				</div>
			</div>
			</c:forEach>
		</div>
		<div class="row">
			<div class="col-lg-6">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">이달의 고속버스 인기 노선<span class="h6 ml-2">팔린 좌석 수 [단위 : 석]</span></h4>
						<div>
							<canvas id="hTopPie" height="150"></canvas>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">이달의 시외버스 인기 노선<span class="h6 ml-2">팔린 좌석 수 [단위 : 석]</span></h4>
						<div>
							<canvas id="sTopPie" height="150"></canvas>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">고속버스 분기별 매출 현황<span class="h6 ml-2">[단위 : 원]</span></h4>
						<div>
							<canvas id="hTopSales" height="150"></canvas>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">시외버스 분기별 매출 현황<span class="h6 ml-2">[단위 : 원]</span></h4>
						<div>
							<canvas id="sTopSales" height="150"></canvas>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="_inc/foot.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/pages/chartjs/chartjs.init.js"></script>