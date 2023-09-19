<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<c:set var="kind" value="${param.kind }" />
<script>
function ctgrAll(all) {
// 검색창의 전체 체크박스 클릭시
	var arr = document.frmSch.schctgr;

	for (var i = 0; i < arr.length; i++) {
		arr[i].checked = all.checked;
	}
}
function ctgrOne(one) {
// 검색창의 특정 체크박스(전체 체크박스 제외) 클릭시
	var frm = document.frmSch;
	var all = frm.all;	// '전체 선택' 체크박스 객체
	if (one.checked) {	// 특정 체크박스를 체크했을 경우
		var arr = frm.schctgr;
		var isChk = true;
		for (var i = 0; i < arr.length; i++) {
			if (arr[i].checked == false) {
				isChk = false;		break;
			}
		}
		all.checked = isChk;
	} else {	// 특정 체크박스를 체크 해체했을 경우
		all.checked = false;
	}
}

function chkAll(all) {
// 검색창의 전체 체크박스 클릭시
	var arr = document.frm.chk;

	for (var i = 0; i < arr.length; i++) {
		arr[i].checked = all.checked;
	}
}
function chkOne(one) {
// 검색창의 특정 체크박스(전체 체크박스 제외) 클릭시
	var frm = document.frm;
	var all = frm.chechkall;	// '전체 선택' 체크박스 객체
	if (one.checked) {	// 특정 체크박스를 체크했을 경우
		var arr = frm.chk;
		var isChk = true;
		for (var i = 0; i < arr.length; i++) {
			if (arr[i].checked == false) {
				isChk = false;		break;
			}
		}
		all.checked = isChk;
	} else {	// 특정 체크박스를 체크 해체했을 경우
		all.checked = false;
	}
}

function statusChange(code, status) {
// 특정 터미널 사용여부 변경
	if (confirm("정말 변경하시겠습니까?")) {
		$.ajax({
			type : "POST", url : "./statusChange", data : { "code" : code, "status" : status, "kind" : "${kind}" }, 
			success : function(chkRs) {
				if (chkRs == 0) {
					alert("변경 실패했습니다.\n다시 시도하세요.");
				}
				location.reload();
			}
		});
	}
}

function getSelectedChk() {
// 체크박스들 중 선택된 체크박스들의 값(value)들을 쉼표로 구분하여 문자열로 리턴하는 함수

	var chk = document.frm.chk;
	var code = "";	// chk컨트롤 배열에서 선택된 체크박스의 값들을 누적 저장할 변수
	for (var i = 1; i < chk.length; i++) {	// hidden으로 chk 하나 만들엇을경우 1부터
		if (chk[i].checked) code += "," + chk[i].value;
	}
	return code.substring(1);
}

function chkChange(status) {
	var code = getSelectedChk();
	// 선택한 체크박스의 oc_idx 값들이 쉼표를 기준으로 '1,2,3,4' 형태의 문자열로 저장됨
	
	if (code == "")	alert("변경할 터미널을 선택하세요.");
	else				statusChange(code, status);
}
</script>

<div class="page-wrapper">
<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold"><c:if test="${kind == 'h'}">고속</c:if>
		<c:if test="${kind == 's'}">시외</c:if> 터미널 목록</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
			    <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/busjava_admin" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item active" aria-current="page">
		            <c:if test="${kind == 'h'}">고속</c:if>
					<c:if test="${kind == 's'}">시외</c:if> 버스 터미널 목록</li>
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
							<c:if test="${kind == 'h' }" ><input type="hidden" name="schctgr" value="tt" /></c:if>
							<input type="hidden" id="kind" name="kind" value="${kind }" />
				            <table class="table table-sm custom v-middle">
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
				                                	<option value="all" <c:if test="${param.schtype == 'all' }">selected="selected"</c:if>>전체</option>
				                                	<option value="name" <c:if test="${param.schtype == 'name' }">selected="selected"</c:if>>터미널명</option>
				                                	<option value="addr" <c:if test="${param.schtype == 'addr' }">selected="selected"</c:if>>주소</option>
				                                </select>
				                                <input type="text" name="keyword" value="${param.keyword }" class="form-control">
				                            </div>
				                        </td> 
				                    </tr>
<c:forEach items="${areaList }" var="al" varStatus="status">
<c:if test="${al.getBh_status() == 'Y'}"><c:set var="count" value="${count + 1}" /></c:if>
</c:forEach>
<c:if test="${areaList.size() > 0 }">
	<c:forEach items="${areaList }" var="al" varStatus="status">
		<c:if test="${status.index == 0}">
			<th scope="row" class="text-center bg-gray">지역</th>
			<td><div class="d-table">
		</c:if>
		
		<c:if test="${status.index == 0}">
				<div class="form-check form-check-inline">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" name="all" value="all" class="custom-control-input" id="${status.index}"
			            onclick="ctgrAll(this);"
			            <c:choose>
							<c:when test="${kind == 'h'}">
							<c:if test="${count == 15}">checked="checked"</c:if></c:when>
							<c:when test="${kind == 's'}">
							<c:if test="${count == 17 }">checked="checked"</c:if></c:when>
						</c:choose> />
			        	<label class="custom-control-label" for="${status.index}">전체</label>
			    	</div>
				</div>
		</c:if>
		<div class="form-check form-check-inline">
			<div class="custom-control custom-checkbox">
				<input type="checkbox" name="schctgr" value="${al.getBh_area() }" class="custom-control-input" id="${status.count}"
				 onclick="ctgrOne(this);" <c:if test="${al.getBh_status() == 'Y'}">checked="checked"</c:if> />
				<label class="custom-control-label" for="${status.count}">${al.getBh_area() }</label>
			</div>
		</div>
		<c:if test="${status.index == areaList.size()}">
			</div></td>
		</c:if>
	</c:forEach>
</c:if>
				                    <tr>
				                        <th scope="row" class="text-center bg-gray align-middle">사용여부</th>
				                        <td class="text-left">
				                            <div class="d-flex">
				                                <select class="form-control w-auto" name="isview">
				                                    <option value="">전체</option>
				                                    <option <c:if test="${param.isview == 'Y' }">selected='selected'</c:if>>Y</option>
				                                    <option <c:if test="${param.isview == 'N' }">selected='selected'</c:if>>N</option>
				                                </select>
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
							<button type="button" class="btn waves-effect waves-light btn-primary" onclick="chkChange('Y');">사용으로변경</button>
							<button type="button" class="btn waves-effect waves-light btn-secondary ml-2" onclick="chkChange('N');" value="">미사용으로변경</button>
						</div>
        					<input type="hidden" name="chk" value="" />
							<table id="table" class="table text-center mt-3 mb-0 table-sm table-hover">
			                <colgroup>
			                    <col width="5%">
								<col width="5%">
								<col width="12%">
								<col width="15%">
								<col width="*">
								<col width="10%">
			                </colgroup>
			                <thead class="bg-primary text-white">
			                <tr>
			                    <th class="align-middle"><input type="checkbox" name="chechkall" style="width:18px; height:18px;" onclick="chkAll(this);" /></th>
			                    <th>No</th>
			                    <th>지역</th>
			                    <th>터미널명</th>
			                    <th class="text-left">주소</th>
			                    <th>사용여부</th>
			                </tr>
			            	</thead>  
			            	<c:if test="${terminalList.size() > 0 }">
								<c:forEach items="${terminalList }" var="tl" varStatus="status">
					                <tbody class="border">
					                <tr class="tr">
					                    <td class="align-middle"><input type="checkbox" name="chk" value="${tl.getBh_code() }" style="width:18px; height:18px;" onclick="chkOne(this);" /></td>
					                    <td>${pi.getNum() - status.index}</td>
					                    <td>${tl.getBh_area()}</td>
					                    <td><span class="text-primary">${tl.getBh_name() }</span></td>
					                    <td class="text-left">${tl.getBh_addr()}</td>
										<td>${tl.getBh_status() }</td>
					                </tr>
					           		</tbody>
					           	</c:forEach>
							</c:if>
			           		<c:if test="${terminalList.size() == 0 }">
								<tbody class="border">
					                <tr>
					                    <td colspan="6">검색결과가 없습니다.</td>
					                </tr>
					           	</tbody>
							</c:if>
							</table>
				            <nav aria-label="Page navigation m-auto" class="mt-4">
								<ul class="pagination justify-content-center">
								<c:if test="${terminalList.size() > 0 }">
								    <li class="page-item">
								    <c:choose>
										<c:when test="${ pi.getCpage() == 1 }">
										<a class="page-link" href="terminal?kind=${kind }&cpage=1${pi.getSchargs()}" aria-label="Previous"></c:when>
										<c:when test="${ pi.getCpage() > 1 }">
										<a class="page-link" href="terminal?kind=${kind }&cpage=${pi.getCpage() - 1}${pi.getSchargs()}" aria-label="Previous"></c:when>
									</c:choose>
								            <span aria-hidden="true">«</span>
								            <span class="sr-only">Previous</span>
								        </a>
								    </li>
								    <c:forEach var="i" begin="${pi.getSpage() }" end="${pi.getSpage() + pi.getBsize() - 1 <= pi.getPcnt() ? pi.getSpage() + pi.getBsize() - 1 : pi.getPcnt()}">
											<li class="page-item <c:if test='${pi.getCpage() == i }'>active</c:if>"><a class="page-link"  href="terminal?kind=${kind }&cpage=${i }${pi.getSchargs() }">${i }</a></li>
									</c:forEach>
								    <li class="page-item">
								    <c:choose>
										<c:when test="${pi.getCpage() == pi.getPcnt()}">
										<a class="page-link" href="terminal?kind=${kind }&cpage=${pi.getCpage()}${pi.getSchargs() }" aria-label="Next"></c:when>
										<c:when test="${pi.getCpage() <  pi.getPcnt()}">
										<a class="page-link" href="terminal?kind=${kind }&cpage=${pi.getCpage() + 1 }${pi.getSchargs() }" aria-label="Next"></c:when>
									</c:choose>
								            <span aria-hidden="true">»</span>
								            <span class="sr-only">Next</span>
								        </a>
								    </li>
								</c:if>
								</ul>
							</nav>
        				</form>
        			</div> 
				</div>
    		</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>