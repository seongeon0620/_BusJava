<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>

<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">시간표 조회</h2>
			</div>
		</div>

		<div class="col-md-8 m-auto">
			<form name="frmScheduleInfo" method="post" class="custom-form">
				<input type="hidden" name="frCode" id="frCode" /> <input type="hidden" name="toCode" id="toCode" />
				<div class="form-group">
					<div class="mb-2">
						<div class="form-check custom">
							<input class="form-check-input" type="radio" name="busType" id="highBus" value="H" checked> <label class="form-check-label" for="highBus">고속</label>
						</div>
						<div class="form-check custom">
							<input class="form-check-input" type="radio" name="busType" id="slowBus" value="S"> <label class="form-check-label" for="slowBus">시외</label>
						</div>
					</div>
					<div class="tab-content" id="pills-tabContent">
						<div class="tab-pane active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab" aria-expanded="false">
							<div class="row mb-3">
								<div class="col-md">
									<div class="form-group">
										<label for="sday1">가는날</label>
										<div class="input-with-icon-wrap">
											<i class="icon bi bi-calendar"></i><input type="text" id="frDate" class="form-control bg-white" value="" readonly>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-md">
							<div class="form-group">
								<label for="btsname">출발지</label>
								<div class="input-with-icon-wrap">
									<i class="icon bi bi-geo-alt-fill"></i><input type="text" class="form-control bg-white" id="sPoint" name="sPoint" readonly>
								</div>
							</div>
						</div>
						<div class="col-md">
							<div class="form-group">
								<label for="btename">도착지</label>
								<div class="input-with-icon-wrap">
									<i class="icon bi bi-geo-alt-fill"></i><input type="text" class="form-control bg-white" id="ePoint" name="ePoint" readonly>
								</div>
							</div>
						</div>
					</div>

					<div class="row mb-3">
						<div class="col-md">
							<input type="button" id="schBtn" value="조회하기" class="btn btn-primary btn-block">
						</div>
					</div>
					<div class="row">
						<ul class="mb-0">
							<li>실시간 운행상태 조회를 위해서는 <a href="arrivaltime">도착시간 안내 메뉴</a>를 이용하시기 바랍니다.
							</li>
						</ul>
					</div>
				</div>
			</form>
		</div>
		<div class="row">
			<div class="col-md-12 text-center mb-5" style="display: none;" id="timetable-container">
				<div id="timetable"></div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="ViewModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			<div class="modal-content"></div>
		</div>
	</div>
</section>
<!-- END section -->

<%@ include file="../_inc/foot.jsp"%>
<script>

$("#sPoint").click(function() {
	const isHighBusSelected = document.getElementById("highBus").checked;
	const url = isHighBusSelected ? "/BusJava/pickSpot?typeCode=H" : "/BusJava/pickSpot?typeCode=S";
	
	$('#ViewModal .modal-content').load(url);
	$('#ViewModal').modal('show');
});

function getToday(){
	const DATE = new Date();
    const YEAR = DATE.getFullYear();
    const MONTH = ("0" + (1 + DATE.getMonth())).slice(-2);
    const DAY = ("0" + DATE.getDate()).slice(-2);

    return YEAR + "." + MONTH + "." + DAY;
}

// 출발 터미널을 클릭했을 때
$(document).on("click", "#go li a", function(e) {
	e.preventDefault();
	addValueInput(this.innerHTML, "#sPointPop");	// 메소드 호출(1)

    let frCode = $(this).attr('href');
    $("#frCode").val(frCode);
   
    selectFromSpot(frCode);	// 메소드 호출(2)
});

// 검색 결과로 나온 버튼을 클릭 했을 때
$(document).on("click", "#keywordArea li .go", function(e) {
	e.preventDefault();
	addValueInput(this.innerHTML, "#sPointPop");
	
	let frCode = $(this).attr('href');
    $("#frCode").val(frCode);
    selectFromSpot(frCode);
    
    $("#keywordArea").children().remove();
});

const addValueInput = function (value, targetId) {	// (1)
	$(targetId).val(value);
	$(targetId).removeClass("active");
	console.log(value);
	console.log(targetId);
	if (targetId == "#sPointPop")	 $("#ePointPop").addClass("active"); 
	else 	$("#arrival").hide();	
};

//각 탭에 데이터를 추가하는 함수
const addTerminalToTab = function (data, targetTabId) {
  let tabContent = "";
  if (data.length > 0) {
    data.forEach(function (terminal) {
		tabContent += '<li><a href="'+ terminal.bt_code +'">' + terminal.bt_name + '</a></li>';
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

$(document).on("click", "#schBtnPop", function(e) {		// 검색버튼 클릭
	($("#sPointPop").val() == "") ? choosePosition("go") : choosePosition("arrival"); 
	
});

const choosePosition = function(type) {	// 출발지 입력
	let keyword = $("#keyword").val();
	if (keyword == "") return;
	
	const isHighBusSelected = document.getElementById("highBus").checked;
	const typeCode = isHighBusSelected ? "H" : "S";
	console.log(typeCode + "::" + keyword);
	
	$.ajax({
		url: "./getKeywordList",
	     type: "GET",
	     data: {
	    	typeCode : typeCode,
	    	keyword : keyword
	     },
	     success: function (data) {
	   	  let keywordList = "";
	   	  if (data.length > 0) {
	   	    data.forEach(function (terminal) {
	   	    	keywordList += '<li><a class="' + type + ' btn-sm btn-primary" href="'+ terminal.bt_code +'">' + terminal.bt_name + '</a></li>';
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

const selectFromSpot = function(terminal_code) {	// (2)
	const isHighBusSelected = document.getElementById("highBus").checked;
	const typeCode = isHighBusSelected ? "H" : "S";
	$.ajax({
	      url: "ticket/getToSpot",
	      type: "GET",
	      data: { 
	    	  frCode : terminal_code,
	    	  typeCode : typeCode
			},		// 출발지 인덱스
	      success: function (data) {
			$("#go").hide();
	        $("#arrival").show();
	        // 필요한 데이터를 필터링하여 함수 호출
	        addTerminalToTab(data, '#all2');
	        console.log(data);
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
	$("#sPoint").val(($("#sPointPop").val()));
	$("#ePoint").val(($("#ePointPop").val()));
	$('#ViewModal').modal("hide");
});

// 라디오 버튼이 변경될 때 clearStartAndEndLocations 함수 호출
$("#highBus, #slowBus").change(function() {
	$("#sPoint").val(""); // 출발지 입력란 초기화
	$("#ePoint").val(""); // 도착지 입력란 초기화
});

$("#frDate").val(getToday());

$("#frDate").datepicker({	// 편도 가는 날
     format: "yyyy.mm.dd"
     , autoclose: true
     , startDate: "0d"	// 오늘 이후의 날짜만 선택할 수 있도록 시작 날짜를 오늘로 설정
     , endDate: "+30d"	// 30일 이후의 날짜는 선택하지 못하도록 설정
     , language: "kr"
     , showMonthAfterYear: true	// 월, 년순의 셀렉트 박스를 년,월 순으로 변경
     , weekStart: 1				// 주의 시작 요일을 월요일로 설정
     , })
     .datepicker("setDate",'now')		// 날짜 선택기를 현재 날짜로 설정
     .on('changeDate', function(e) {	
       $("#frDate").val($(this).val());
     });

function number_format(num) {	// 숫자를 천 단위로 쉼표로 구분된 문자열로 변환
	if (typeof num !== 'number' || isNaN(num)) {
		return "N/A"; // 또는 원하는 다른 기본값으로 설정
	}
	return num.toLocaleString();
}

$("#schBtn").click(function() {	// 조회하기 버튼 클릭
    if ($("#sPoint").val() == "" || $("#ePoint").val() == "") {
        alert("출발지와 도착지를 선택해주세요.");
        return false;
    }
    const sPoint = $("#sPoint").val();	// 출발 터미널 명
    const ePoint = $("#ePoint").val();	// 도착 터미널 명
    const frCode = $("#frCode").val();	// 출발 터미널 코드
    const toCode = $("#toCode").val();	// 도착 터미널 코드
    const isHighBusSelected = document.getElementById("highBus").checked;
    const busType = isHighBusSelected ? "H" : "S";
    const frDate = $("#frDate").val();	// 선택한 조회날짜
    
//    alert(busType + "::" + sPoint + "::" + ePoint + "::" + frCode + "::" + toCode + "::" + frDate);
    // H::서울경부::안성::010::130::2023.09.12
    // S::부산동부::오산::4620401::1813701::2023.09.12

    $.ajax({
        type: "POST", 
        url: "./getSchedule",
        data: { sPoint: sPoint, ePoint: ePoint, frCode: frCode, toCode: toCode, busType: busType, frDate: frDate },
        success: function(data) {
			console.log(data);
            if (data != null && data.length > 0) {
                let tableHTML = "<table class='table table-hover'>" + 
               					"<colgroup><col width='10%'><col width='14%'><col width='15%'><col width='15%'>" +
								"<col width='15%'><col width='15%'><col width='8%'><col width='8%'></colgroup>" + 
	            				"<thead class='bg-light'><tr>" + 
	            				"<th scope='col' class='text-center'>출발시간</th><th scope='col' class='text-center'>고속사</th>" + 
	            				"<th scope='col' class='text-center'>등급</th><th scope='col' class='text-center'>성인요금</th>" + 
	            				"<th scope='col' class='text-center'>청소년요금</th><th scope='col' class='text-center'>아동요금</th>" + 
	            				"<th scope='col' class='text-center'>전체좌석</th><th scope='col' class='text-center'>잔여좌석</th></tr></thead><tbody>";
                data.forEach(function(table) {
                    tableHTML += "<tr>";
                    tableHTML += "<td>" + table.fr_time + "</td>";
                    tableHTML += "<td>" + table.ri_com + "</td>";
                    tableHTML += "<td>" + table.level + "</td>";
                    tableHTML += "<td>" + number_format(table.adult_pee); + "</td>";
                    tableHTML += "<td>" + number_format(table.student_pee); + "</td>";
                    tableHTML += "<td>" + number_format(table.child_pee); + "</td>";
                    tableHTML += "<td>" + table.total_seat + "</td>";
                    tableHTML += "<td>" + table.left_seat + "</td>";
                    tableHTML += "</tr>";
                });
                tableHTML += "</tbody></table>";

                // 테이블을 보여줌
                $("#timetable").html(tableHTML);
                $("#timetable-container").show();
            } else {	// 데이터가 없는 경우
                alert("조회된 시간표가 없습니다.");
                $("#timetable").empty();
                $("#timetable-container").hide();
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
        }
    });
});
</script>