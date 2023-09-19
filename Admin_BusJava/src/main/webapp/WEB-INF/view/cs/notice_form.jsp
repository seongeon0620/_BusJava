<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%@ page import="vo.*" %>
<%
request.setCharacterEncoding("utf-8");

%>

<c:set var="kind" value="${param.kind }" />		<!-- jstl로 request.getParameter 받는 방법 -->
<c:set var="type" value="등록" />
<c:if test="${kind == 'up'}" ><c:set var="type" value="수정" /></c:if>
<div class="page-wrapper">
<div class="page-breadcrumb">
	<h3 class="page-title text-truncate text-dark font-weight-bold">공지사항 ${type }</h3>
	<div class="d-flex align-items-center">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb m-0 p-0">
	            <li class="breadcrumb-item"><a href="/busjava_admin" class="text-muted">홈</a></li>
	            <li class="breadcrumb-item"><a href="noticeList" class="text-muted">공지사항 목록</a></li>
	            <li class="breadcrumb-item text-muted active" aria-current="page">공지사항 ${type }</li>
	        </ol>
		</nav>
	</div>
</div>
	<div class="container-fluid">
		<div class="row">
    	<div class="col-lg-12">
        	<div class="card">
			<div class="card-body">
				<form name="frm" action="noticeProcInUp" method="post">
				<input type="hidden" name="kind" value="${kind }" />	<!-- 등록/수정 -->
	 			<input type="hidden" name="nlidx" value="${ni.getNl_idx() }" />
	 			<input type="hidden" name="cpage" value="${param.cpage }" />
					<table class="table custom">
						<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="*">
						</colgroup>
		                <tbody>
		                    <tr>
		                        <th scope="row" class="text-center table-primary">제목</th>
		                        <td colspan="3">
		                        <input type="text" class="form-control" name="title" value="${ni.getNl_title() }" maxlength="100" required />
		                        </td> 
		                        <td class="text-left">
								<div class="form-check form-check-inline">
									<div class="custom-control custom-checkbox">
										<input type="checkbox" name="accent" value="Y" class="custom-control-input" id="accent" onchange="chkAccentCnt(this.value)" 
											<c:if test="${ni.getNl_accent() == 'Y' }" >checked="checked" </c:if> />
											<label class="custom-control-label" for="accent">중요공지</label>
									</div>
								</div>
		                        </td> 
		                    </tr>
		                    <tr>
		                        <th scope="row" class="text-center table-primary ">내용</th>
		                        <td class="text-left" colspan="5">
		                        <textarea class="form-control" name="content" style="width:100%; height:250px;" placeholder="내용을 입력하세요." 
		                        required>${ni.getNl_content() }</textarea>
		                        </td>
		                    </tr>
		                    <tr>
		                        <th scope="row" class="text-center table-primary align-middle">게시여부</th>
		                        <td class="text-left" colspan="5">
		                            <div class="d-flex">
		                            <div class="btn-group" data-toggle="buttons">
		                                <label class="btn waves-effect waves-light mb-0 ">
		                                    <div class="custom-control custom-radio">
		                                        <input type="radio" id="customRadio4" name="isview" class="custom-control-input" value="Y"
			                                        <c:if test="${ni.getNl_isview() == 'Y' }" >checked="checked" </c:if> checked="checked" />
			                                        <label class="custom-control-label" for="customRadio4">게시</label>
		                                    </div>
		                                </label>
		                                <label class="btn waves-effect waves-light ml-3 mb-0">
		                                    <div class="custom-control custom-radio">
		                                        <input type="radio" id="customRadio5" name="isview" class="custom-control-input" value="N"
			                                        <c:if test="${ni.getNl_isview() == 'N' }" >checked="checked" </c:if> />
			                                        <label class="custom-control-label" for="customRadio5">미게시</label>
		                                    </div>
		                                </label>
		                            </div>
		                            </div>
		                        </td> 
		                    </tr>
		                </tbody>
		            </table>
		            <div class="d-flex justify-content-center">
			            <button type="button" class="btn waves-effect waves-light btn-secondary mr-3" onclick="cancelConfirm()">취소</button>
			            <button type="submit" class="btn waves-effect waves-light btn-primary">
 			            <c:if test="${kind == 'in'}" >${type }</c:if>
			            <c:if test="${kind == 'up'}" >${type }</c:if>
			            </button>
		            </div>
				</form>
			</div>
			</div>
		</div>
		</div>
	</div>
</div>
<script>

function chkAccentCnt(chk) {
	$.ajax({
		type : "GET", url : "./accentCnt", success : function(chkRs) {
			if (chkRs >= 5) {
				alert('중요공지는 최대 5개까지만 등록이 가능합니다.\n기존 중요공지체크를 해제하시고 다시 시도해 주세요.');
				$("#accent").prop("checked", false); // 체크 해제
			} 
		}
	});
}

function cancelConfirm() {
    if (confirm('작성중인 내용은 저장되지 않습니다.\n정말 취소하시겠습니까?')) {
        history.back();
    }
}
</script>
<%@ include file="../_inc/foot.jsp" %>