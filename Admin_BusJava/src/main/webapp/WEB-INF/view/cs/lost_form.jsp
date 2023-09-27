<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
%>
<script>
function showFileName() {
    const fileInput = document.getElementById('file');
    const fileNameElement = document.getElementById('fileName');

    const fileName = fileInput.value.split('\\').pop(); // 파일 이름만 추출
    if (fileName) {
    	fileNameElement.innerText = fileName;
    } else {
    	fileNameElement.innerText = fileNameElement.getAttribute('data-tl-img');
    }
}
</script>
<c:set var="kind" value="${param.kind }" />
<c:set var="btn" value="등록" />
<c:set var="file1" value="${li.getLl_img() }" />
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">유실물 등록</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
					<li class="breadcrumb-item"><a href="lostList" class="text-muted">유실물 목록</a></li>
					<li class="breadcrumb-item active" aria-current="page">유실물 등록</li>
				</ol>
			</nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<form name="frmIn" action="lostIn" method="post" enctype="multipart/form-data">
							<input type="hidden" name="kind" value="${kind }" /> <input type="hidden" name="ll_idx" value="${li.getLl_idx() }" /> <input type="hidden" id="fileSrc" name="fileSrc" value="${file1 }" />
							<table class="table custom">
								<colgroup>
									<col width="10%">
									<col width="35%">
									<col width="10%">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="text-center table-primary align-middle">보관장소</th>
										<td class="text-left">
											<div class="pl-0 d-flex">
												<input type="text" id="terName" name="terName" class="form-control bg-white w-auto" value="${li.getLl_tername() }" readonly />
												<button type="button" class="btn btn-primary waves-effect waves-light" onclick="openModal();" data-toggle="modal" data-target="#pickModal">선택</button>
											</div>

											</div>
										</td>
										<th scope="row" class="text-center table-primary align-middle">습득물명</th>
										<td>
											<input type="text" class="form-control" name="title" value="${li.getLl_title() }" maxlength="40" required />
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center table-primary ">내용</th>
										<td class="text-left" colspan="3">
											<textarea class="form-control" name="content" style="width: 100%; height: 250px;" maxlength="150" placeholder="내용을 입력하세요." required>${li.getLl_content() }</textarea>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center table-primary align-middle">이미지</th>
										<td class="text-left" colspan="3">
											<div class="filebox">
												<label for="file">파일첨부</label> <input type="file" id="file" name="uploadFile" onchange="showFileName();" />
												<c:if test="${li.getLl_img() == null }">
													<span id="fileName" style="width: 250px" value="${li.getLl_img()}">선택된 파일이 없습니다.</span>
												</c:if>
											</div>
											<c:if test="${li.getLl_img() != null }">
												<span id="fileName" style="width: 250px">${li.getLl_img()}</span>
												<div class="img-box">
													<img src="resources/images/lost/${li.getLl_img() }" />
												</div>
											</c:if>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center table-primary align-middle">상태</th>
										<td class="text-left">
											<div class="d-flex">
												<div class="btn-group" data-toggle="buttons">
													<label class="btn waves-effect waves-light mb-0 ">
														<div class="custom-control custom-radio">
															<input type="radio" id="customRadio4" name="status" class="custom-control-input" value="A" <c:if test="${li.getLl_status() == 'A' }" >checked="checked" </c:if> checked="checked" /> <label class="custom-control-label" for="customRadio4">보관중</label>
														</div>
													</label> <label class="btn waves-effect waves-light ml-3 mb-0">
														<div class="custom-control custom-radio">
															<input type="radio" id="customRadio5" name="status" class="custom-control-input" value="B" <c:if test="${li.getLl_status() == 'B' }" >checked="checked" </c:if> /> <label class="custom-control-label" for="customRadio5">수령완료</label>
														</div>
													</label>
												</div>
											</div>
										</td>
										<th scope="row" class="text-center table-primary align-middle">습득일시</th>
										<td>
											<div class="d-flex">
												<div class="col-lg-4 pl-0">
													<div class="form-group mb-0 custom-date">
														<span><i class="icon-calender"></i></span> <input type="text" id="Date" class="form-control" value="${li.getLl_date() }" readonly name="date" />
													</div>
												</div>
												<div class="col-lg-4 pl-0">
													<input type="text" class="text-center timepicker" name="time" style="width: 100px; border: 1;" value="${li.getLl_time() }" readonly="readonly" />
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="d-flex justify-content-center">
								<button type="button" class="btn waves-effect waves-light btn-secondary mr-3" onclick="history.back();">취소</button>
								<button type="submit" class="btn waves-effect waves-light btn-primary">
									<c:if test="${kind == 'in'}">등록</c:if>
									<c:if test="${kind == 'up'}">수정</c:if>
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="pickModal" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content"></div>
	</div>
</div>
<script>
$(document).ready(function() {
	$("#Date").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "-1y",
		
		endDate: "0d",
		language: "kr",
		showMonthAfterYear: true,
		weekStart: 1,
	})
});

$(function () {
    $(".timepicker").timepicker({
        timeFormat: 'HH:mm',
        interval: 60,
        minTime: '00:00',
        maxTime: '23:00',
        defaultTime: <%if (kind.equals("in")) {%>'00:00' <%} else {%>'${li.getLl_time() }'<%}%>,
        startTime: '00:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });
});

/* 팝업창 */

function openModal() {
	$('#pickModal .modal-content').load("/Admin_BusJava/pickTerminal");
	$('#pickModal').modal();
}

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
<%@ include file="../_inc/foot.jsp"%>