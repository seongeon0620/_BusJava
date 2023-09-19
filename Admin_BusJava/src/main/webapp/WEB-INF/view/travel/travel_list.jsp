<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/adminbusj/login' ");
	out.println("</script>");
	out.close();
}
%>
<style>
.changePointer {
      cursor: pointer;
}
</style>
<script>
$(document).ready(function(){
	changePointer();
})
 
function changePointer(){
	$('.tr').mouseover(function(){
	   $(this).addClass('changePointer');
	}).mouseout(function() {
	   $(this).removeClass('changePointer');
	});
}

function makeCtgr() {
// 검색폼의 조건들을 쿼리스트링 sch의 값으로 만듦
	var frm = document.frmSch;	var sch = "";
	
	// 브랜드 조건
	var arr = frm.schctgr;	// brand라는 이름의 컨트롤들을 배열로 받아옴
	var isFirst = true;		// brand 체크박스들 중 첫번째로 선택한 체크박스인지 여부를 저장
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].checked) {
			if(isFirst) {	// 첫번째로 선택한 체크박스 이면
				isFirst = false;
				sch += arr[i].value;
			} else {
				sch += ":" + arr[i].value;
			}
		}
	}
	
	document.frmSch.hiddenCtgr.value = sch;
	document.frmSch.submit();
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

function ctgrChkAll(all) {
// 전체 선택 체크박스 클릭시 모든 체크박스에 대한 체크 여부를 처리하는 함수
	var arr = document.frmSch.schctgr;

	for (var i = 1; i < arr.length; i++) {
		arr[i].checked = all.checked;
	}
}

function ctgrChkOne(one) {
// 특정 체크박스 클릭시 체크 여부에 따른 '전체 선택' 체크박스의 체크 여부를 처리하는 함수
	var frmSch = document.frmSch;
	var all = document.getElementById("ctgr1");	// '전체 선택' 체크박스 객체
	if (one.checked) {	// 특정 체크박스를 체크했을 경우
		var arr = frmSch.schctgr;
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

function isviewDel(tlidx) {
// 장바구니내 특정 상품을 삭제하는 함수
	if (confirm("정말 삭제하시겠습니까?")) {
		$.ajax({
			type : "POST", url : "./travelDel", data : { "tlidx" : tlidx }, 
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
	var tlidx = getSelectedChk();
	// 선택한 체크박스의 oc_idx 값들이 쉼표를 기준으로 '1,2,3,4' 형태의 문자열로 저장됨
	if (tlidx == "")	alert("삭제할 상품을 선택하세요.");
	else				isviewDel(tlidx);
}
</script>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">추천여행지 관리</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item text-muted active" aria-current="page">추천여행지 관리</li>
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
							<input type="hidden" id="hiddenCtgr" name="hiddenCtgr" value="" />
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
				                                    <option value="all" <c:if test="${pi.getSchtype() == 'all' }">selected='selected'</c:if>>전체</option>
				                                    <option value="area" <c:if test="${pi.getSchtype() == 'area' }">selected='selected'</c:if>>지역</option>
				                                    <option value="title" <c:if test="${pi.getSchtype() == 'title' }">selected='selected'</c:if>>장소명</option>
				                                </select>
				                                <input type="text" name="keyword" value="${pi.getKeyword() }" class="form-control">
				                            </div>
				                        </td> 
				                    </tr>
				                    <tr>
				                        <th scope="row" class="text-center bg-gray">분류</th>
				                        <td class="text-left">
				                        <div class="d-flex">
				                        <c:set var="ct" value="${pi.getSchctgr() }" />
										<c:set var="arrct" value="${fn:split(ct, ':')}" />
				                            <div class="form-check form-check-inline">
				                                <div class="custom-control custom-checkbox">
				                                    <input type="checkbox" name="schctgr" value="all" class="custom-control-input" id="ctgr1"
				                                    onclick="ctgrChkAll(this);" 
				                                     <c:forEach var="v" items="${arrct}">
				                                    <c:if test="${v == 'all' }"> checked="checked"</c:if>
				                                    </c:forEach> />
				                                    <label class="custom-control-label" for="ctgr1">전체</label>
				                                </div>
				                            </div>
				                            <div class="form-check form-check-inline">
				                                <div class="custom-control custom-checkbox">
				                                    <input type="checkbox" name="schctgr" value="맛집" class="custom-control-input" id="ctgr2" 
				                                    onclick="ctgrChkOne(this);"
				                                    <c:forEach var="v" items="${arrct}">
				                                    <c:if test="${v == '맛집' }"> checked="checked"</c:if>
				                                    </c:forEach> />
				                                    <label class="custom-control-label" for="ctgr2">맛집</label>
				                                </div>
				                            </div>
				                            <div class="form-check form-check-inline">
				                                <div class="custom-control custom-checkbox">
				                                    <input type="checkbox" name="schctgr" value="명소" class="custom-control-input" id="ctgr3" 
				                                    onclick="ctgrChkOne(this);"
				                                    <c:forEach var="v" items="${arrct}">
				                                    <c:if test="${v == '명소' }"> checked="checked"</c:if>
				                                    </c:forEach> />
				                                    <label class="custom-control-label" for="ctgr3">명소</label>
				                                </div>
				                            </div>
				                            <div class="form-check form-check-inline">
				                                <div class="custom-control custom-checkbox">
				                                    <input type="checkbox" name="schctgr" value="액티비티" class="custom-control-input" id="ctgr4" 
				                                    onclick="ctgrChkOne(this);" 
				                                    <c:forEach var="v" items="${arrct}">
				                                    <c:if test="${v == '액티비티' }"> checked="checked"</c:if>
				                                    </c:forEach> />
				                                    <label class="custom-control-label" for="ctgr4">액티비티</label>
				                                </div>
				                            </div>
				                            </div>
				                        </td>
				                    </tr>
				                    <tr>
				                        <th scope="row" class="text-center bg-gray align-middle">게시여부</th>
				                        <td class="text-left">
				                            <div class="d-flex">
				                                <select class="form-control w-auto" name="isview" id="">
				                                    <option value="">전체</option>
				                                    <option value="y" <c:if test="${pi.getIsview() == 'y' }">selected='selected'</c:if> >게시</option>
				                                    <option value="n" <c:if test="${pi.getIsview() == 'n' }">selected='selected'</c:if>>미게시</option>
				                                </select>
				                            </div>
				                        </td> 
				                    </tr>
				                </tbody>
				            </table>
				            <div class="d-flex justify-content-center">
				            	<button type="button" class="btn waves-effect waves-light btn-secondary mb-2" onclick="makeCtgr();">검색
				            	<i class="icon-magnifier"></i></button>
				            </div>
            			</form>
            			<form name="frm">
        					<input type="hidden" name="chk" value="" />
							<table id="table" class="table text-center mt-3 mb-0">
			                <colgroup>
			                    <col width="5%">
								<col width="5%">
								<col width="10%">
								<col width="10%">
								<col width="*%">
								<col width="10%">
								<col width="10%">
			                </colgroup>
			                <thead class="bg-primary text-white">
			                <tr>
			                    <th class="align-middle"><input type="checkbox" name="chechkall" style="width:18px; height:18px;" onclick="chkAll(this);" /></th>
			                    <th>No</th>
			                    <th>지역</th>
			                    <th>분류</th>
			                    <th class="text-left">장소명</th>
			                    <th>작성일</th>
			                    <th>게시여부</th>
			                </tr>
			            	</thead>  
			            	<c:if test="${travelList.size() > 0 }">
								<c:forEach items="${travelList }" var="tl" varStatus="status">
					                <tbody class="border border-primary">
					                <tr class="tr">
					                    <td class="align-middle"><input type="checkbox" name="chk" value="${tl.getTl_idx() }" style="width:18px; height:18px;" onclick="chkOne(this);" /></td>
					                    <td>${pi.getNum() - status.index}</td>
					                    <td>${tl.getTl_area()}</td>
					                    <td><span class="badge badge-pill badge-primary">${tl.getTl_ctgr() }</span></td>
					                    <td class="text-left"><a href="travelView?tl_idx=${tl.getTl_idx() }">${tl.getTl_title()}</a></td>
										<td>${tl.getTl_date() }</td>
										<td>${tl.getTl_isview() }</td>
					                </tr>
					           		</tbody>
					           	</c:forEach>
							</c:if>
			           		<c:if test="${travelList.size() == 0 }">
								<tbody class="border border-primary">
					                <tr>
					                    <td colspan="7">검색결과가 없습니다.</td>
					                </tr>
					           	</tbody>
							</c:if>
							</table>
							<div class="text-right mt-2">
								<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='travelForm?kind=in'">글등록</button>
								<button type="button" class="btn waves-effect waves-light btn-secondary ml-2" onclick="chkDel();" value="">미게시로변경</button>
							</div>
				            <nav aria-label="Page navigation example m-auto">
								<ul class="pagination justify-content-center">
								<c:if test="${travelList.size() > 0 }">
								    <li class="page-item">
								    <c:choose>
										<c:when test="${ pi.getCpage() == 1 }">
										<a class="page-link" href="travelList?cpage=1${pi.getSchargs()}" aria-label="Previous"></c:when>
										<c:when test="${ pi.getCpage() > 1 }">
										<a class="page-link" href="travelList?cpage=${pi.getCpage() - 1}${pi.getSchargs()}" aria-label="Previous"></c:when>
									</c:choose>
								            <span aria-hidden="true">«</span>
								            <span class="sr-only">Previous</span>
								        </a>
								    </li>
								    <c:forEach var="i" begin="${pi.getSpage() }" end="${pi.getSpage() + pi.getBsize() - 1 <= pi.getPcnt() ? pi.getSpage() + pi.getBsize() - 1 : pi.getPcnt()}">
											<li class="page-item"><a class="page-link" href="travelList?cpage=${i }${pi.getSchargs() }">${i }</a></li>
									</c:forEach>
								    <li class="page-item">
								    <c:choose>
										<c:when test="${pi.getCpage() == pi.getPcnt()}">
										<a class="page-link" href="travelList?cpage=${pi.getCpage()}${pi.getSchargs() }" aria-label="Next"></c:when>
										<c:when test="${pi.getCpage() <  pi.getPcnt()}">
										<a class="page-link" href="travelList?cpage=${pi.getCpage() + 1 }${pi.getSchargs() }" aria-label="Next"></c:when>
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