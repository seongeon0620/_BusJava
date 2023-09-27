<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
PageInfo pi = (PageInfo) request.getAttribute("pi");

String schTerName = "";
if (pi != null && pi.getSchargs() != "") {
	schTerName = pi.getSchtype();
}
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">유실물 관리</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
					<li class="breadcrumb-item active" aria-current="page">유실물 목록</li>
				</ol>
			</nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<form name="frmSch">
							<table class="table table-sm custom">
								<colgroup>
									<col width="20%">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">습득물명</th>
										<td class="text-left">
											<div class="d-flex">
												<input type="text" name="keyword" value="${pi.getKeyword() }" class="form-control">
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">보관장소</th>
										<td class="text-left">
											<div class="col-lg-6 pl-0 d-flex">
												<input type="text" id="terName" name="terName" class="form-control bg-white w-auto" value="<%=schTerName%>" readonly />
												<button type="button" class="btn btn-primary waves-effect waves-light" onclick="openModal();" data-toggle="modal" data-target="#pickModal">선택</button>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray">상태</th>
										<td class="text-left">
											<div class="d-flex">
												<select class="form-control w-auto" name="status">
													<option value="">전체</option>
													<option value="A" <c:if test="${pi.getStatus() == 'A' }">selected='selected'</c:if>>보관중</option>
													<option value="B" <c:if test="${pi.getStatus() == 'B' }">selected='selected'</c:if>>수령완료</option>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray">습득일자</th>
										<td class="text-left">
											<div class="d-flex">
												<div class="form-group mb-0 custom-input-icon">
													<span><i class="icon-calender"></i></span> <input type="text" id="Date" class="form-control" value="${pi.getDate() }" readonly name="date" />
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="d-flex justify-content-center">
								<button type="button" class="btn waves-effect waves-light btn-light mb-2" onclick="location.href='lostList'">필터 초기화</button>
								<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2 ml-2">
									검색 <i class="icon-magnifier"></i>
								</button>
							</div>
						</form>
						<form name="frm">
							<div class="text-right mt-2">
								<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='lostForm?kind=in'">글등록</button>
								<button type="button" class="btn waves-effect waves-light btn-secondary ml-2" value="" onclick="chkDel();">수령완료로 상태변경</button>
							</div>
							<input type="hidden" name="chk" value="" />
							<table id="table" class="table table-sm text-center mt-3 mb-0">
								<colgroup>
									<col width="5%">
									<col width="5%">
									<col width="*%">
									<col width="30%">
									<col width="10%">
									<col width="10%">
								</colgroup>
								<thead class="bg-primary text-white">
									<tr>
										<th class="align-middle">
											<div class="custom-control custom-checkbox">
												<input type="checkbox" class="custom-control-input" id="checkall" name="checkall" onclick="chkAll(this);">
												<label class="custom-control-label" for="checkall"></label>
											</div>
										</th>
										<th>No</th>
										<th>습득물명</th>
										<th>보관장소</th>
										<th>상태</th>
										<th>습득일자</th>
									</tr>
								</thead>
								<c:if test="${lostList.size() > 0 }">
									<c:forEach items="${lostList }" var="ll" varStatus="status">
										<tbody class="border">
											<tr class="tr" onclick="location.href='lostView?ll_idx=${ll.getLl_idx() }&date=${ll.getLl_date()}&time=${ll.getLl_time() }'">
												<td class="align-middle" onclick="event.cancelBubble=true">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" id="customCheck${ll.getLl_idx() }" name="chk" value="${ll.getLl_idx() }" onclick="chkOne(this);">
														<label class="custom-control-label" for="customCheck${ll.getLl_idx() }"></label>
													</div>
												</td>
												<td>${pi.getNum() - status.index}</td>
												<td class="text-left">${ll.getLl_title()}</td>
												<td>${ll.getLl_tername()}</td>
												<td>
													<c:if test="${ll.getLl_status() == 'A' }">보관중</c:if>
													<c:if test="${ll.getLl_status() == 'B' }">수령완료</c:if>
												</td>
												<td>${ll.getLl_getdate() }</td>
											</tr>
										</tbody>
									</c:forEach>
								</c:if>
								<c:if test="${lostList.size() == 0 }">
									<tbody class="border">
										<tr>
											<td colspan="6">검색결과가 없습니다.</td>
										</tr>
									</tbody>
								</c:if>
							</table>
							<!-- 페이지 네이션 시작 -->
							<c:if test="${lostList.size() > 0 }">
								<%@ include file="../_inc/pagination.jsp"%>
							</c:if>
							<!-- 페이지 네이션 종료 -->
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
	function openModal() {
		$('#pickModal .modal-content').load("/Admin_BusJava/pickTerminal");
		$('#pickModal').modal();
	}

	function chkAll(all) {
		// 전체 선택 체크박스 클릭시 모든 체크박스에 대한 체크 여부를 처리하는 함수
		var arr = document.frm.chk;

		for (var i = 1; i < arr.length; i++) {
			arr[i].checked = all.checked;
		}
	}

	function chkOne(one) {
		// 특정 체크박스 클릭시 체크 여부에 따른 '전체 선택' 체크박스의 체크 여부를 처리하는 함수
		var frm = document.frm;
		var all = frm.chechkall; // '전체 선택' 체크박스 객체
		if (one.checked) { // 특정 체크박스를 체크했을 경우
			var arr = frm.chk;
			var isChk = true;
			for (var i = 1; i < arr.length; i++) { // hidden으로 chk값을 넣엇을 경우 i = 1로 바꿔줘야함
				if (arr[i].checked == false) {
					isChk = false;
					break;
				}
			}
			all.checked = isChk;
		} else { // 특정 체크박스를 체크 해체했을 경우
			all.checked = false;
		}
	}

	function isviewDel(ll_idx) {
		if (confirm("정말 삭제하시겠습니까?")) {
			$.ajax({
				type : "POST",
				url : "./lostDel",
				data : {
					"ll_idx" : ll_idx
				},
				success : function(chkRs) {
					if (chkRs == 0) {
						alert("게시여부 미게시로 변경 실패했습니다.\n다시 시도하세요.");
					}
					location.reload();
				}
			});
		}
	}

	function getSelectedChk() {
		// 체크박스들 중 선택된 체크박스들의 값(value)들을 쉼표로 구분하여 문자열로 리턴하는 함수
		var chk = document.frm.chk;
		var idxs = ""; // chk컨트롤 배열에서 선택된 체크박스의 값들을 누적 저장할 변수
		for (var i = 1; i < chk.length; i++) { // hidden으로 chk 하나 만들엇을경우 1부터
			if (chk[i].checked)
				idxs += "," + chk[i].value;
		}
		return idxs.substring(1);
	}

	function chkDel() {
		var ll_idx = getSelectedChk();
		// 선택한 체크박스의 oc_idx 값들이 쉼표를 기준으로 '1,2,3,4' 형태의 문자열로 저장됨
		if (ll_idx == "")
			alert(" 상품을 선택하세요.");
		else
			isviewDel(ll_idx);
	}

	$(document).ready(function() {
		$("#Date").datepicker({
			format : "yyyy.mm.dd",
			autoclose : true,
			startDate : "-1y",

			endDate : "0d",
			language : "kr",
			showMonthAfterYear : true,
			weekStart : 1,
		})
	});

	/* 팝업창 */

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

	$(document).on("click", ".tem_nam", function() {
		$("#sPointPop").val($(this).text());
	});

	const choosePosition = function() {
		let keyword = $("#keyword").val();
		if (keyword == "")
			return;
		$.ajax({
			url : "getKeywordList",
			type : "GET",
			data : {
				keyword : keyword
			},
			success : function(data) {
				let keywordList = "";
				if (data.length > 0) {
					data.forEach(function(terminal) {
						console.log(terminal);
						keywordList += '<li><button class="btn-sm btn-primary">'
								+ terminal.bh_name
								+ '</button></li>';
					});
				} else {
					keywordList = '<li>검색결과가 없습니다.</li>';
				}
				$("#keywordArea").html(keywordList);
			},
			error : function(xhr, status, error) {
				console.error(error);
			}
		});
	};

	$(document).on("keypress", "#keyword", function(e) {
		if (e.keyCode && e.keyCode == 13 && $("#keyword").val() != "") {
			choosePosition();
		}
	});
	$(document).on("click", "#schBtnPop", function() {
		if ($("#keyword").val() != "") {
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