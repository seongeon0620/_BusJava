<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
%>
<c:set var="kind" value="up" />
<c:if test="${kind == 'up'}">
	<c:set var="type" value="수정" />
</c:if>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">공지사항</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
					<li class="breadcrumb-item"><a href="noticeList" class="text-muted">공지사항 목록</a></li>
					<li class="breadcrumb-item active" aria-current="page">공지사항 글보기</li>
				</ol>
			</nav>
		</div>
	</div>
	<div class="container-fluid" id="app">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<input type="hidden" name="kind" value="${kind }" />
						<!-- 등록/수정 -->
						<table class="table custom">
							<colgroup>
								<col width="10%">
								<col width="20%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="text-center table-primary">제목</th>
									<td class="text-left" colspan="9">${ni.getNl_title() }</td>
								</tr>
								<tr>
									<th scope="row" class="text-center table-primary ">등록일시</th>
									<td class="text-center">${ni.getNl_date() }</td>
									<th scope="row" class="text-center table-primary ">조회수</th>
									<td class="text-center">${ni.getNl_read() }</td>
									<th scope="row" class="text-center table-primary ">중요공지</th>
									<td class="text-center">${ni.getNl_accent() }</td>
								</tr>
								<tr>
									<th scope="row" class="text-center table-primary ">내용</th>
									<td class="text-left" colspan="9">${ni.getNl_content() }</td>
								</tr>
								<tr>
									<th scope="row" class="text-center table-primary ">게시여부</th>
									<td>
										<c:if test="${ni.getNl_isview() == 'Y'}">게시</c:if>
										<c:if test="${ni.getNl_isview() == 'N'}">미게시</c:if>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="d-flex justify-content-center">
							<button type="button" style="margin: 10px" class="btn waves-effect waves-light btn-primary" onclick="location.href='noticeList${args }'">목록</button>
							<button type="button" style="margin: 10px" class="btn waves-effect waves-light btn-primary" onclick="location.href='noticeForm?cpage=${param.cpage }&kind=up&nlidx=${ni.getNl_idx() }';">수정</button>
							<button type="submit" style="margin: 10px" class="btn waves-effect waves-light btn-secondary mr-3" onclick="isviewChange(${ni.getNl_idx() })">삭제</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
function isviewChange(idx) {
	if ('${ni.getNl_isview() }' == 'N') {
		alert('이미 미게시 상태인 게시글입니다.');
	} else {
		confirm('정말 삭제하시겠습니까?(게시글 미게시로 전환)');
		location.href="isviewChange?nlidx=" + idx;	// 게시여부 수정
	}
}
</script>
<%@ include file="../_inc/foot.jsp"%>