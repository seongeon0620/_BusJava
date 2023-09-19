<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
PageInfo pi = (PageInfo)request.getAttribute("pi");
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">유실물 관리</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item text-muted active" aria-current="page">유실물 관리</li>
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
				                        <th scope="row" class="text-center bg-gray align-middle">검색어</th>
				                        <td class="text-left">
				                            <div class="d-flex">
				                                <select class="form-control w-auto" name="schtype">
				                                    <option value="all">전체</option>
				                                    <option value="tername" <c:if test="${pi.getSchtype() == 'tername' }">selected='selected'</c:if>>습득물명</option>
				                                    <option value="title" <c:if test="${pi.getSchtype() == 'title' }">selected='selected'</c:if>>보관장소</option>
				                                </select>
				                                <input type="text" name="keyword" value="${pi.getKeyword() }" class="form-control">
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
				                        	<div class="form-group mb-0 custom-date">
												<span><i class="icon-calender"></i></span>
		                               			<input type="text" id="Date" class="form-control" value="${pi.getDate() }" readonly name="date" />
											</div>
				                        </div>
				                        </td>
				                    </tr>
				                </tbody>
				            </table>
				            <div class="d-flex justify-content-center">
				            	<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2">검색
				            	<i class="icon-magnifier"></i></button>
				            </div>
            			</form>
            			<form name="frm">
            			<div class="text-right mt-2">
							<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='lostForm?kind=in'">글등록</button>
							<button type="button" class="btn waves-effect waves-light btn-secondary ml-2"  value="" onclick="chkDel();">상태변경</button>
						</div>
        					<input type="hidden" name="chk" value="" />
							<table id="table" class="table text-center table-sm table-hover mt-3 mb-0">
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
			                    <th class="align-middle"><input type="checkbox" name="chechkall" style="width:18px; height:18px;" onclick="chkAll(this);" /></th>
			                    <th>No</th>
			                    <th>습득물명</th>
			                    <th>보관장소</th>
			                    <th>상태</th>
			                    <th>습득일자</th>
			                </tr>
			            	</thead>  
			            	<c:if test="${lostList.size() > 0 }">
								<c:forEach items="${lostList }" var="ll" varStatus="status">
					                <tbody class="border border-primary">
					                <tr class="tr" onclick="location.href='lostView?ll_idx=${ll.getLl_idx() }&date=${ll.getLl_date()}&time=${ll.getLl_time() }'">
					                    <td class="align-middle" onclick="event.cancelBubble=true"><input type="checkbox" name="chk" value="${ll.getLl_idx() }" style="width:18px; height:18px;" onclick="chkOne(this);" /></td>
					                    <td>${pi.getNum() - status.index}</td>
					                    <td class="text-left">${ll.getLl_title()}</td>
					                    <td>${ll.getLl_tername()}</td>
										<td><c:if test="${ll.getLl_status() == 'A' }" >보관중</c:if><c:if test="${ll.getLl_status() == 'B' }" >수령완료</c:if></td>
										<td>${ll.getLl_getdate() }</td>
					                </tr>
					           		</tbody>
					           	</c:forEach>
							</c:if>
			           		<c:if test="${lostList.size() == 0 }">
								<tbody class="border border-primary">
					                <tr>
					                    <td colspan="6">검색결과가 없습니다.</td>
					                </tr>
					           	</tbody>
							</c:if>
							</table>
<!-- 페이지 네이션 시작 -->
<c:if test="${lostList.size() > 0 }">
<%@ include file="../_inc/pagination.jsp" %>			   
</c:if>
<!-- 페이지 네이션 종료 -->
        				</form>
        			</div> 
				</div>
    		</div>
		</div>
	</div>
</div>
<script>
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
	var all = frm.chechkall;	// '전체 선택' 체크박스 객체
	if (one.checked) {	// 특정 체크박스를 체크했을 경우
		var arr = frm.chk;
		var isChk = true;
		for (var i = 1; i < arr.length; i++) {	// hidden으로 chk값을 넣엇을 경우 i = 1로 바꿔줘야함
			if (arr[i].checked == false) {
				isChk = false;		break;
			}
		}
		all.checked = isChk;
	} else {	// 특정 체크박스를 체크 해체했을 경우
		all.checked = false;
	}
}


function isviewDel(ll_idx) {
// 장바구니내 특정 상품을 삭제하는 함수
	if (confirm("정말 삭제하시겠습니까?")) {
		$.ajax({
			type : "POST", url : "./lostDel", data : { "ll_idx" : ll_idx }, 
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
	var idxs = "";	// chk컨트롤 배열에서 선택된 체크박스의 값들을 누적 저장할 변수
	for (var i = 1; i < chk.length; i++) {	// hidden으로 chk 하나 만들엇을경우 1부터
		if (chk[i].checked) idxs += "," + chk[i].value;
	}
	return idxs.substring(1);
}

function chkDel() {
	var ll_idx = getSelectedChk();
	// 선택한 체크박스의 oc_idx 값들이 쉼표를 기준으로 '1,2,3,4' 형태의 문자열로 저장됨
	if (ll_idx == "")	alert("삭제할 상품을 선택하세요.");
	else				isviewDel(ll_idx);
}

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
</script>
<%@ include file="../_inc/foot.jsp" %>