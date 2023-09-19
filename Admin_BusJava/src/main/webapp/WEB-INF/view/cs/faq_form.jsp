<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%@ page import="vo.*" %>
<%
request.setCharacterEncoding("utf-8");

if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='login?returnUrl=faqForm'; ");
	out.println("</script>");
	out.close();
}
%>

<c:set var="kind" value="${param.kind }" />		<!-- jstl로 request.getParameter 받는 방법 -->
<c:set var="type" value="등록" />
<c:if test="${kind == 'up'}" ><c:set var="type" value="수정" /></c:if>
<div class="page-wrapper">
<div class="page-breadcrumb">
	<h3 class="page-title text-truncate text-dark font-weight-bold">FAQ 관리</h3>
	<div class="d-flex align-items-center">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb m-0 p-0">
	         	 <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
	            <li class="breadcrumb-item"><a href="noticeList" class="text-muted">FAQ 목록</a></li>
	            <li class="breadcrumb-item active" aria-current="page">FAQ ${type }</li>
	        </ol>
		</nav>
	</div>
</div>
	<div class="container-fluid">
		<div class="row">
    	<div class="col-lg-12">
        	<div class="card">
			<div class="card-body">
				<form name="frm" <c:if test="${kind == 'up' }" > action="faqProcUp" </c:if> 
				<c:if test="${kind == 'in' }" > action="faqProcIn" </c:if> 
				  method="post">
				<input type="hidden" name="kind" value="${kind }" />	<!-- 등록/수정 -->
	 			<input type="hidden" name="flidx" value="${fi.getFl_idx() }" />
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
		                        <input type="text" class="form-control" name="title" value="${fi.getFl_title() }" maxlength="100" required />
		                        </td> 
		                        <td class="text-left">
		                            <div class="d-flex">
		                                <select class="form-control w-auto" name="ctgr">
										<option value="예매" <c:if test="${ fi.getFl_ctgr() == '예매' }">selected='selected'</c:if>>예매</option>
										<option value="조회/변경/취소" <c:if test="${ fi.getFl_ctgr() == '조회/변경/취소' }">selected='selected'</c:if>>조회/변경/취소</option>
										<option value="결제" <c:if test="${ fi.getFl_ctgr() == '결제' }">selected='selected'</c:if>>결제</option>
										<option value="기타" <c:if test="${ fi.getFl_ctgr() == '기타' }">selected='selected'</c:if>>기타</option>
										<option value="고속/시외버스 운행" <c:if test="${ fi.getFl_ctgr() == '고속/시외버스 운행' }">selected='selected'</c:if>>고속/시외버스 운행</option>
										<option value="회원" <c:if test="${ fi.getFl_ctgr() == '회원' }">selected='selected'</c:if>>회원</option>
										</select>
									</div>
								</td>
		                    </tr>
		                    <tr>
		                        <th scope="row" class="text-center table-primary ">내용</th>
		                        <td class="text-left" colspan="5">
		                        <textarea class="form-control" name="content" style="width:100%; height:250px;" placeholder="내용을 입력하세요." 
		                        required>${fi.getFl_content() }</textarea>
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
			                                        <c:if test="${fi.getFl_isview() == 'Y' }" >checked="checked" </c:if> />
			                                        <label class="custom-control-label" for="customRadio4">게시</label>
		                                    </div>
		                                </label>
		                                <label class="btn waves-effect waves-light ml-3 mb-0">
		                                    <div class="custom-control custom-radio">
		                                        <input type="radio" id="customRadio5" name="isview" class="custom-control-input" value="N"
			                                        <c:if test="${fi.getFl_isview() == 'N' }" >checked="checked" </c:if> />
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

function cancelConfirm() {
    if (confirm('작성중인 내용은 저장되지 않습니다.\n정말 취소하시겠습니까?')) {
        history.back();
    }
}
</script>
<%@ include file="../_inc/foot.jsp" %>