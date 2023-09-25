<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String typeCode = (String)request.getAttribute("typeCode");
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading"><%=typeCode.equals("H") ? "고속" : "시외" %>버스 예매</h2>
			</div>
			<div class="col-md-12">
				<div class="col-md-8 m-auto">
					<div class="progress-bar-custom 1">
						<div class="progress-step is-active">
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
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">예매 결과</div>
						</div>
					</div>
				</div>

				<div class="col-md-12 m-auto">
					<div class="progress-bar-custom 2">
						<div class="progress-step is-active">
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
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">예매 결과</div>
						</div>
					</div>
				</div>
			</div>

		</div>
		<div class="col-md-8 m-auto">
			<form name="frmSchSchedule" action="step02?type=<%=typeCode %>" method="POST" class="custom-form">
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
					<div class="row mb-3">
						<div class="col-md">
							<div class="form-group">
								<label for="sPoint">출발지</label>
								<div class="input-with-icon-wrap">
									<i class="icon bi bi-geo-alt-fill"></i>
									<input type="text" class="form-control bg-white" id="frName" name="frName" readonly onclick="openModal();">
								</div>
							</div>
						</div>
						<div class="col-md">
							<div class="form-group">
								<label for="ePoint">도착지</label>
								<div class="input-with-icon-wrap">
									<i class="icon bi bi-geo-alt-fill"></i>
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
							<input type="button" id="schBtn" value="조회하기" class="btn btn-primary btn-block btn-lg">
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="modal fade" id="ViewModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-xl modal-dialog-centered" role="document">
			<div class="modal-content"></div>
		</div>
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>
<script>
function openModal() {
	$('#ViewModal .modal-content').load("/BusJava/pickSpot?typeCode=<%=typeCode.toUpperCase()%>");
	$('#ViewModal').modal('show');
}

const getToday = function (){
	const DATE = new Date();
	const YEAR = DATE.getFullYear();
	const MONTH = ("0" + (1 + DATE.getMonth())).slice(-2);
	const DAY = ("0" + DATE.getDate()).slice(-2);

	return YEAR + "." + MONTH + "." + DAY;
}

// 각 탭에 데이터를 추가하는 함수
const addTerminalToTab = function (data, targetTabId) {
	let tabContent = "";
	if (data.length > 0) {
		data.forEach(function (terminal) {
			tabContent += '<li><a href="'+ terminal.bt_code +'" class="text-decoration-none">' + terminal.bt_name + '</a></li>';
		});
	} else {
		tabContent = "해당 지역의 도착지 터미널이 존재하지 않습니다.";
	}
	$(targetTabId).html(tabContent);
}

$(document).on("keypress", "#keyword", function(e) {
	if(e.keyCode && e.keyCode == 13) {
		($("#sPointPop").val() == "") ? choosePosition("go") : choosePosition("arrival");	
	}
});
$(document).on("click", "#schBtnPop", function(e) {
	($("#sPointPop").val() == "") ? choosePosition("go") : choosePosition("arrival"); 
	
});

const choosePosition = function(type) {
	let keyword = $("#keyword").val();
	if (keyword == "") return;
	$.ajax({
		url: "../getKeywordList",
		type: "GET",
		data: {
			typeCode : "<%=typeCode%>",
			keyword : keyword
		},
		success: function (data) {
			let keywordList = "";
			if (data.length > 0) {
				data.forEach(function (terminal) {
					keywordList += '<li><a class="' + type + ' btn-sm btn-primary text-white" href="'+ terminal.bt_code +'">' + terminal.bt_name + '</a></li>';
				});
			} else {
				keywordList = '<li>검색결과가 없습니다.</li>';
			}
			$("#keywordArea").html(keywordList);
		},
		error: function (xhr, status, error) {
			console.error(error);
		}
	});
};

const selectFromSpot = function(terminal_code) {
	$.ajax({
		url: "getToSpot",
		type: "GET",
		data: { 
			frCode : terminal_code,
			typeCode : "<%=typeCode%>"
		},		// 출발지 인덱스
		success: function (data) {
			$("#go").hide();
			$("#arrival").show();
			addTerminalToTab(data, '#all2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("서울")), '#seoul2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("경기")), '#gyeong2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("인천")), '#incheon2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("강원")), '#gang2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("대전")), '#daejeon2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("충청남")), '#chungnam2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("충청북")), '#chungbuk2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("광주")), '#gwangju2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("전라남")), '#jeonnam2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("전라북")), '#jeonbuk2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("부산")), '#busan2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("경상남")), '#gyeongnam2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("대구")), '#daegu2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("경상북")), '#gyeongbuk2');
			addTerminalToTab(data.filter(t => t.bt_area.startsWith("울산")), '#ulsan2');
			},
			error: function (xhr, status, error) {
				console.error(error);
			}
		});
};

const addValueInput = function (value, targetId) {
	$(targetId).val(value);
	$(targetId).removeClass("active");
	if (targetId == "#sPointPop")	 $("#ePointPop").addClass("active"); 
	else 	$("#arrival").hide();
	
};

$(document).on("click", "#go li a", function(e) {
	e.preventDefault();
	addValueInput(this.innerHTML, "#sPointPop");

	let frCode = $(this).attr('href');
	$("#frCode").val(frCode);
	selectFromSpot(frCode);
});

$(document).on("click", "#keywordArea li .go", function(e) {
	e.preventDefault();
	addValueInput(this.innerHTML, "#sPointPop");
	
	let frCode = $(this).attr('href');
	$("#frCode").val(frCode);
	selectFromSpot(frCode);

	$("#keywordArea").children().remove();
});


$(document).on("click", "#arrival li a, #keywordArea li .arrival", function(e) {
	e.preventDefault();
	addValueInput(this.innerHTML, "#ePointPop");
	
	$("#toCode").val($(this).attr('href'));
});

$(document).on("click", "#btnSubmit", function() {
	if (($("#sPointPop").val() == "") || ($("#ePointPop").val() == "")) {
		alert("출발지와 도착지를 선택해주세요.");
		return;
	}
	
	$("#frName").val(($("#sPointPop").val()));
	$("#toName").val(($("#ePointPop").val()));
	$('#ViewModal').modal("hide");
});

$(document).ready(function() {
	$("#frDate").val(getToday());
	/* ui 관련 jquery */
	$(".progress-bar-custom.2").hide();
	$(".nav-item").click(function() {
		let navLink = $(this).find(".nav-link.travel");
		let tabIndex = $(this).index();

		// active 상태에서 클릭시 아무런 변화없음
		if (navLink.hasClass("active"))	return;

		navLink.toggleClass("show");
		let progressBarCustom = $(".progress-bar-custom." + (tabIndex + 1));
		if (navLink.hasClass("show")) {
			if (tabIndex === 0) {	// 편도 클릭 시
				$("#mode").val("p");
				$(".progress-bar-custom.1").css("display","");
				$(".progress-bar-custom.2").css("display","none");
			} else if (tabIndex === 1) {	 // 왕복 클릭 시
				$("#mode").val("w");
				$(".progress-bar-custom.1").css("display","none");
				$(".progress-bar-custom.2").css("display","");
			}
		} 

		$(".nav-item").not(this).find(".nav-link").removeClass("show");
	});

	$("#frDate1").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "0d",
		endDate: "+30d",
		language: "kr",
		weekStart: 1,
	}).datepicker("setDate", "now").on("changeDate", function(e) {
		var startDate = new Date(e.date.valueOf());
		$("#frDate2").datepicker("setDate", startDate);
		$("#toDate1").datepicker("setStartDate", startDate);
		$("#frDate").val($(this).val());
	});
	
	$("#frDate2").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "0d",
		endDate: "+30d",
		language: "kr",
		weekStart: 1,
	}).datepicker("setDate", "now").on("changeDate", function(e) {
		var startDate = new Date(e.date.valueOf());
		$("#toDate1").datepicker("setStartDate", startDate);
		$("#frDate").val($(this).val());
	});
	
	$("#toDate1").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "0d",
		endDate: "+30d",
		language: "kr",
		weekStart: 1,
	}).on("changeDate", function(e) {
		var endDate = new Date(e.date.valueOf());
		$('#frDate1').datepicker("setEndDate", endDate);
		$('#frDate2').datepicker("setEndDate", endDate);
		$("#toDate").val($(this).val());
	});

	$("#schBtn").click(function() {
		if ($("#frName").val() == "" || $("#toName").val() == "") {
			alert("출발지와 도착지를 선택해주세요.");
			return;
		}
		
		if ($("#mode").val() == "w" ) {
			if ($("#toDate1").val() == "") {
				alert("오는 날을 선택해 주세요.");
				return;
			};
		}
		document.frmSchSchedule.submit();
	});
});
</script>