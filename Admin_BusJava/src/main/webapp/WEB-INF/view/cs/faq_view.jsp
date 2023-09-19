<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");

if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/busjava_admin/login' ");
	out.println("</script>");
	out.close();
}
%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>
<c:set var="kind" value="up" />
<c:if test="${kind == 'up'}" ><c:set var="type" value="수정" /></c:if>
<div class="page-wrapper">
<div class="page-breadcrumb">
	<h3 class="page-title text-truncate text-dark font-weight-bold">FAQ 글보기</h3>
	<div class="d-flex align-items-center">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb m-0 p-0">
	            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
	            <li class="breadcrumb-item"><a href="noticeList" class="text-muted">FAQ 목록</a></li>
	            <li class="breadcrumb-item text-muted active" aria-current="page">FAQ 글보기</li>
	        </ol>
		</nav>
	</div>
</div>
	<div class="container-fluid" id="app">
		<div class="row">
    	<div class="col-lg-12">
        	<div class="card">
			<div class="card-body">
			<input type="hidden" name="kind" value="${kind }" />	<!-- 등록/수정 -->
				<table class="table custom">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row" class="text-center table-primary">제목</th>
	                        <td class="text-left" colspan="9">${fi.getFl_title() }</td>
	                    </tr>
	                    <tr>
	                    	<th scope="row" class="text-center table-primary ">분류</th>
	                    	<td class="text-center">${fi.getFl_ctgr() }</td>
	                    	<th scope="row" class="text-center table-primary ">등록일</th>
	                    	<td class="text-center">${fi.getFl_date() }</td>
	                    	<th scope="row" class="text-center table-primary ">게시여부</th>
	                    	<td class="text-center">
	                    	<c:if test="${fi.getFl_isview() == 'Y'}" >게시</c:if><c:if test="${fi.getFl_isview() == 'N'}" >미게시</c:if></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="text-center table-primary ">내용</th>
	                        <td class="text-left" colspan="9">${fi.getFl_content() } </td>
	                    </tr>
	                </tbody>
	            </table>
	            <div class="d-flex justify-content-center">
		            <button type="button" style="margin:10px" class="btn waves-effect waves-light btn-primary" onclick="location.href='faqList${args }'">목록</button>
		            <button type="button" style="margin:10px" class="btn waves-effect waves-light btn-primary" onclick="location.href='faqForm?cpage=${param.cpage }&kind=up&flidx=${fi.getFl_idx() }';">수정</button>
		            <button type="submit" style="margin:10px" class="btn waves-effect waves-light btn-secondary mr-3" onclick="isviewChange(${fi.getFl_idx() })">삭제</button>
	            </div>
			</div>
			</div>
		</div>
		</div>
	</div>
</div>
<script>

function isviewChange(flidx) {
	if ('${fi.getFl_isview() }' == 'N') {
		alert('이미 미게시 상태인 게시글입니다.');
	} else {
		if (confirm('정말 삭제하시겠습니까?(게시글 미게시로 전환)')) {
		var isview = "N";			
			$.ajax({
				type : "POST",
				url : "./isviewChange",
				data : { "flidx" : flidx, "isview" : isview },
				success : function(chkRs) { // chkRs는 그냥 내가 정한 변수명
					if (chkRs == 0) {
						alert("변경에 실패하였습니다.\n 다시 시도하세요");
					}
					location.reload();
				}
			});
		}
	}
}
</script>
<%@ include file="../_inc/foot.jsp" %>