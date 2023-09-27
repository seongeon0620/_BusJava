<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<SalesInfo> salesList = (List<SalesInfo>)session.getAttribute("salesList");
PageInfo pageInfo = (PageInfo)session.getAttribute("pi");
int realTotal = 0;

String schLineType = "", schTerName = "", schFromDate = "", schToDate = "";
if (pageInfo != null && pageInfo.getSchargs() != "") {
	String[] tmp = pageInfo.getSchargs().split("&");
	schLineType = pageInfo.getSchctgr();
	schFromDate = tmp[1].substring(tmp[1].indexOf("=") + 1);
	schToDate = tmp[2].substring(tmp[2].indexOf("=") + 1);
	schTerName = pageInfo.getKeyword();
} 
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">매출 현황</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
					<li class="breadcrumb-item active" aria-current="page">전체 매출</li>
				</ol>
			</nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">
							총 매출 금액 : <span id="realTotal"></span>원
						</h4>
						<form name="frmSchHidden">
							<input type="hidden" name="lineCategory" />
							<input type="hidden" name="terName" />
							<input type="hidden" name="fromDate" />
							<input type="hidden" name="toDate" />
						</form>
						<form name="frmSch">
							<table class="table table-sm custom">
								<colgroup>
									<col width="20%">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">노선구분</th>
										<td class="text-left">
											<div class="d-flex">
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="all" id="busCategoryAll" name="busCategory" <% if (schLineType.equals("all") || schLineType == "") { %> checked="checked" <% } %>>
														<label class="custom-control-label" for="busCategoryAll">전체</label>
													</div>
												</div>
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="high" id="busCategory1" name="busCategory" <% if (schLineType.equals("all") || schLineType == "" || schLineType.equals("high")) { %> checked="checked" <% } %>>
														<label class="custom-control-label" for="busCategory1">고속</label>
													</div>
												</div>
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="slow" id="busCategory2" name="busCategory" <% if (schLineType.equals("all") || schLineType == "" || schLineType.equals("slow")) { %> checked="checked" <% } %>>
														<label class="custom-control-label" for="busCategory2">시외</label>
													</div>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">출발지</th>
										<td class="text-left">
											<div class="col-lg-6 pl-0 d-flex">
												<input type="text" id="terName" name="terName" class="form-control bg-white w-auto" value="<%=schTerName %>" readonly/>
												<button type="button" class="btn btn-primary waves-effect waves-light" onclick="openModal();" data-toggle="modal" data-target="#pickModal">선택</button>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">기간</th>
										<td class="text-left">
											<div class="d-flex align-center">
												<div class="col-lg-2 pl-0">
													<div class="form-group mb-0 custom-input-icon">
														<span><i class="icon-calender"></i></span>
														<input type="text" id="fromDate" name="fromDate" class="form-control" readonly>
													</div>
												</div>
												<span style="line-height: 2.1;"> ~ </span>
												<div class="col-lg-2 pr-0">
													<div class="form-group mb-0 custom-input-icon">
														<span><i class="icon-calender"></i></span>
														<input type="text" id="toDate" name="toDate" class="form-control" readonly>
													</div>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="d-flex justify-content-center">
								<button type="button" id="schBtn" class="btn waves-effect waves-light btn-secondary mb-2">
									검색 <i class="icon-magnifier"></i>
								</button>
							</div>
						</form>
						<table id="table" class="table text-center table-sm mt-3 mb-0">
							<colgroup>
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="8%">
								<col width="15%">
								<col width="15%">
								<col width="15%">
								<col width="*">
							</colgroup>
							<thead class="bg-primary text-white">
								<tr>
									<th>노선구분</th>
									<th>출발지</th>
									<th>도착지</th>
									<th>운영횟수</th>
									<th>카드</th>
									<th>무통장 입금</th>
									<th>간편 결제</th>
									<th>매출 합계</th>
								</tr>
							</thead>
							<tbody class="border">
<% if (salesList.size() > 0) {	// 매출내역이 있을경우
	for (SalesInfo si : salesList) {
	realTotal += si.getTotalFee();
%>
								<tr>
									<td><%=si.getLineType()%></td>
									<td><%=si.getFromName()%></td>
									<td><%=si.getToName() %></td>
									<td><%=si.getCount_schedule() %></td>
									<td><%=String.format("%,d",si.getCardFee()) %>
										<% if (si.getCardRatio() != 0.0) { %>(<%=si.getCardRatio() %>%)<% } %>
									</td>
									<td><%=String.format("%,d",si.getBankFee()) %>
										<% if (si.getBankRatio() != 0.0) { %>(<%=si.getBankRatio() %>%)<% } %>
									</td>
									<td><%=String.format("%,d",si.getEasyFee()) %>
										<% if (si.getEasyRatio() != 0.0) { %>(<%=si.getEasyRatio() %>%)<% } %>
									</td>
									<td><%=String.format("%,d",si.getTotalFee()) %></td>
								</tr>
								<%
	}	
} else { // 매출내역이 없을경우 
%>
								<tr>
									<td colspan="8">매출내역이 존재하지 않습니다.</td>
								</tr>
								<%
	}
%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="pickModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
        </div>
    </div>
</div>
<%@ include file="../_inc/foot.jsp"%>
<script>
function openModal() {
	$('#pickModal .modal-content').load("/Admin_BusJava/pickTerminal");
	$('#pickModal').modal();
}

let busCategoryChks = document.getElementsByName("busCategory");

let total_period = <%=realTotal%>
$("#realTotal").text(total_period.toLocaleString("ko-KR"));

document.addEventListener("click", function(e) {
	if (e.target && e.target.name === "busCategory") {
		let chkCount = 0; 
    	for (let i = 1; i < busCategoryChks.length; i++) {
    		if (busCategoryChks[i].checked) {
    			chkCount++;
    		}
      	}
		if (chkCount == busCategoryChks.length - 1) {
			$("#busCategoryAll").prop("checked", true);
		} else {
			$("#busCategoryAll").prop("checked", false);
		}
		
   	}
});

$("#busCategoryAll").on('click', function() {
		if (this.checked == true) {
			for (let i = 0; i < busCategoryChks.length; i++) {
				busCategoryChks[i].checked = true;
			}
		} else {
			for (let i = 0; i < busCategoryChks.length; i++) {
				busCategoryChks[i].checked = false;
			}
		}
});
		
// 데이트피커	
let today = new Date(); // 현재 날짜
let sevenDaysAgo = new Date();
sevenDaysAgo.setDate(today.getDate() - 7);

	$("#fromDate").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "-180d",
		endDate: "0d",
		language: "kr",
		weekStart: 1,
	}).datepicker("setDate", sevenDaysAgo).on('changeDate', function(e) {
		var startDate = new Date(e.date.valueOf());
		$('#toDate').datepicker('setStartDate', startDate);
	});
	
	
	$("#toDate").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		endDate: "0d",
		language: "kr",
		weekStart: 1,
	}).datepicker("setDate", 'today').on('changeDate', function(e) {
		var endDate = new Date(e.date.valueOf());
		$('#fromDate').datepicker('setEndDate', endDate);
	});
	
	
	// 검색이후 데이터가 있는경우 데이터피커 노출 값 재설정
	let schFromDate = "<%=schFromDate%>";
	let schToDate = "<%=schToDate%>";
	
    if (schFromDate && schToDate) {
    	schFromDate = schFromDate.replace("-", ".");
    	schToDate = schToDate.replace("-", ".");
    	
        $("#fromDate").datepicker("setDate", new Date(schFromDate));
        $("#toDate").datepicker("setDate", new Date(schToDate));
    }

	$("#schBtn").click(function() {
		makeSch();
		document.frmSchHidden.submit();
	});
	
const makeSch = function () {
// 검색폼의 조건들을 쿼리스트링 sch의 값으로 만듦	
	let sch = "";
	
	// 노선구분
	let isFirst = true;
	for (let i = 0 ; i < busCategoryChks.length ; i++) {
		if (busCategoryChks[i].checked) {
			if (isFirst) {
				isFirst = false;
				sch = busCategoryChks[i].value;
			} else {	// 값이 2개이상인경우 (분류가 2종류이므로 all)
				sch = "all"; 
			}
		}
	}
	
	document.frmSchHidden.lineCategory.value = sch;
	document.frmSchHidden.terName.value = document.frmSch.terName.value;
	document.frmSchHidden.fromDate.value = document.frmSch.fromDate.value;
	document.frmSchHidden.toDate.value = document.frmSch.toDate.value;
}

$(document).on("click", ".tem_nam", function (){
	$("#sPointPop").val($(this).text());
});

const choosePosition = function() {
	let keyword = $("#keyword").val();
	if (keyword == "") return;
	$.ajax({
		url: "getKeywordList",
		type: "GET",
		data: {
			keyword : keyword
		},
		success: function (data) {
			let keywordList = "";
			if (data.length > 0) {
			data.forEach(function (terminal) {
	   	    	console.log(terminal);
	   	    	keywordList += '<li><button class="btn-sm btn-primary">' + terminal.bh_name + '</button></li>';
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

$(document).on("keypress", "#keyword", function(e) {
	if(e.keyCode && e.keyCode == 13 && $("#keyword").val() != "") {
		choosePosition();
	}
});
$(document).on("click", "#schBtnPop", function() {
	if($("#keyword").val() != "") {
		choosePosition();	
	}
	
});

$(document).on("click", "#keywordArea li button", function() {
	$("#sPointPop").val($(this).text());
});

$(document).on("click", "#btnSubmit", function() {
	if (($("#sPointPop").val() == "")) {
		alert("터미널을 선택해주세요.");
		return;
	}
	
	$("#terName").val(($("#sPointPop").val()));
	$("#pickModal").modal("hide");
});
</script>