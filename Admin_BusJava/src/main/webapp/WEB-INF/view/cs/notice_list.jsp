<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
PageInfo pi = (PageInfo)request.getAttribute("pi");
String fullUrl = (String)request.getAttribute("fullUrl");

%>
<div class="page-wrapper">
<div class="page-breadcrumb">
	<h3 class="page-title text-truncate text-dark font-weight-bold">공지사항 관리</h3>
	<div class="d-flex align-items-center">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb m-0 p-0">
	            <li class="breadcrumb-item"><a href="busjava_admin" class="text-muted">홈</a></li>
	            <li class="breadcrumb-item active" aria-current="page">공지사항 목록</li>
	        </ol>
		    </nav>
		</div>
	</div>	
	<div class="container-fluid" id="app">
		<div class="row">
		<div class="col-lg-12">
			<div class="card">
			<div class="card-body">
				<form name="frmSch">
					<table class="table table-sm custom">
						<colgroup>
							<col width="20%">
							<col width="10%">
							<col width="*">
						</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="text-center bg-gray align-middle">검색어</th>
							<td>
								<select class="form-control w-auto" name="schtype">
									<option value="">검색조건</option>
									<option value="title" <c:if test="${pi.getSchtype() == 'title' }">selected='selected'</c:if>>제목</option>
									<option value="content" <c:if test="${pi.getSchtype() == 'content' }">selected='selected'</c:if>>내용</option>
									<option value="tc" <c:if test="${pi.getSchtype() == 'tc' }">selected='selected'</c:if>>제목+내용</option>
								</select>
							</td>
							<td class="text-left">
							<input type="text" class="form-control" name="keyword" <c:if test="${pi.getKeyword() != '' }">value='${pi.getKeyword() }'</c:if> />
							</td> 
						</tr>
						<tr>
							<th scope="row" class="text-center bg-gray align-middle">게시여부</th>
							<td class="text-center">
								<select class="form-control w-auto" name="isview">
									<option value="" <c:if test="${pi.getIsview() == '' }">selected='selected'</c:if>>전체</option>
									<option value="Y" <c:if test="${pi.getIsview() == 'Y' }">selected='selected'</c:if> >게시</option>
									<option value="N" <c:if test="${pi.getIsview() == 'N' }">selected='selected'</c:if>>미게시</option>
								</select>
							</td> 
						</tr>
					</tbody>
					</table>
			            <div class="d-flex justify-content-center">
			            	<button type="button" class="btn waves-effect waves-light btn-light mb-2" onclick="location.href='noticeList'">필터 초기화</button>
			            	<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2 ml-2" id="schBtn">검색
				        	<i class="icon-magnifier"></i></button>
			            </div>
			            <div class="text-right mt-2">
							<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='noticeForm?kind=in'">글등록</button>
							<button type="button" class="btn waves-effect waves-light btn-secondary ml-2" onclick="chkDel();" value="">미게시로변경</button>
						</div>
		            </form>
		            <form name="frm">
					<table id="table" class="table text-center table-sm table-hover mt-3 mb-0">
		                <colgroup>
			                <col width="5%">
			                <col width="10%">
		                    <col width="*">
		                    <col width="20%">
							<col width="10%">
		                </colgroup>
		                <thead class="bg-primary text-white">
			                <tr>
			                	<th class="align-middle">
			                		<input type="checkbox" name="chechkall" style="width:18px; height:18px;" onclick="chkAll(this);" />
			                	</th>
			                	<th>No</th>
			                    <th>제목</th>
			                    <th>작성일</th>
			                    <th>게시여부</th>
			                </tr>
		            	</thead>
<!-- 중요공지 -->
<c:if test="${aNoticeList.size() > 0 }">
<c:forEach items="${aNoticeList }" var="anl" varStatus="status">
						<tbody class="border border-primary">
							<tr class="tr">
								<td class="align-middle">
									<input type="checkbox" name="chk" value="${anl.getNl_idx() }" style="width:18px; height:18px;" onclick="chkOne(this);" />
								</td>
								<td><span class="badge badge-pill badge-primary">중요</span></td>
								<td class="text-left click" onclick="location.href='noticeView?nlidx=${anl.getNl_idx() }${pi.getArgs() }'">${anl.getNl_title() }</td>
								<td>${anl.getNl_date() }</td>
								<td>${anl.getNl_isview() }</td>
			                </tr>
						</tbody>
</c:forEach>
</c:if>

<!-- 일반공지 -->
<c:if test="${noticeList.size() > 0 }">
<c:forEach items="${noticeList }" var="nl" varStatus="status">
						<tbody class="border border-primary">
							<tr class="tr">
								<td class="align-middle">
									<input type="checkbox" name="chk" value="${nl.getNl_idx() }" style="width:18px; height:18px;" onclick="chkOne(this);" />
								</td>
								<td>${pi.getNum() - status.index}</td>
								<td class="text-left click" onclick="location.href='noticeView?nlidx=${nl.getNl_idx() }${pi.getArgs() }'">${nl.getNl_title() }</td>
								<td>${nl.getNl_date() }</td>
								<td>${nl.getNl_isview() }</td>
			                </tr>
						</tbody>
</c:forEach>
</c:if>
<c:if test="${aNoticeList.size() + noticeList.size() <= 0 }">
						<tbody class="border border-primary">
							<tr>
			                    <td colspan="5">검색 결과가 없습니다.</td>
			                </tr>
						</tbody>
</c:if>
					</table>
					</form>
<!-- 페이지네이션 시작 -->
<c:if test="${aNoticeList.size() + noticeList.size() > 0 }">
<%@ include file="../_inc/pagination.jsp" %>
</c:if>
<!-- 페이지네이션 종료 -->
			</div>
			</div>
		</div>
		</div>
	</div>
<%@ include file="../_inc/foot.jsp" %>
<script>

$("#schBtn").click(function(event) {
	var schtype = $("select[name='schtype']").val();
	var keyword = $("input[name='keyword']").val();
	if (schtype == "" && keyword != "") {
		alert("검색조건을 선택하세요.");
		event.preventDefault(); // 이벤트 기본 동작을 막음
	}
});

function chkAll(all) {
// 전체 선택 체크박스 클릭시 모든 체크박스에 대한 체크 여부를 처리하는 함수
	var arr = document.frm.chk;
	for (var i = 0 ; i < arr.length ; i++) {
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
		for (var i = 0 ; i < arr.length ; i++) {	// hidden으로 chk값을 넣엇을 경우 i = 1로 바꿔줘야함
			if (arr[i].checked == false) {
				isChk = false;		break;
			}
		}
		all.checked = isChk;
	} else {	// 특정 체크박스를 체크 해체했을 경우
		all.checked = false;
	}
}

function getSelectedChk() {
// 체크박스들 중 선택된 체크박스들의 값(value)들을 쉼표로 구분하여 문자열로 리턴하는 함수
	var chk = document.frm.chk;
	var idxs = "";	// chk컨트롤 배열에서 선택된 체크박스의 값들을 누적 저장할 변수
	for (var i = 0 ; i < chk.length ; i++) {
		if (chk[i].checked) idxs += "," + chk[i].value;
	}
	return idxs.substring(1);
}

function chkDel() {
	var nlidx = getSelectedChk();
	// 선택한 체크박스의 oc_idx 값들이 쉼표를 기준으로 '1,2,3,4' 형태의 문자열로 저장됨
	if (nlidx == "")	alert("삭제할 게시물을 선택하세요.");
	else {
		alert("정말 삭제하시겠습니까?");
		location.href='isviewChangeIdxs?nlidx=' + nlidx;
	}				
}

</script>