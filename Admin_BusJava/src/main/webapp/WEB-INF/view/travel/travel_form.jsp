<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/adminbusj/login' ");
	out.println("</script>");
	out.close();
}
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
<c:set var="file1" value="${ti.getTl_img() }" />
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">추천여행지 등록</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item"><a href="travelList" class="text-muted">추천여행지 목록</a></li>
		            <li class="breadcrumb-item text-muted active" aria-current="page">추천여행지 등록</li>
		        </ol>
		    </nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
    		<div class="col-lg-12">
        		<div class="card">
        			<div class="card-body">
			        	<form name="frmIn" action="travelIn" method="post" enctype="multipart/form-data">
				        <input type="hidden" name="kind" value="${kind }" />
				        <input type="hidden" name="tl_idx" value="${ti.getTl_idx() }"	/>
				        <input type="hidden" id="fileSrc" name="fileSrc" value="${file1 }" />
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
			                        <th scope="row" class="text-center table-primary align-middle">지역</th>
			                        <td class="text-left">
				                        <select class="form-control w-auto" name="area">
				                            <option <c:if test="${ti.getTl_area() == '서울' }" >selected="selected" </c:if>>서울</option>
				                            <option <c:if test="${ti.getTl_area() == '경기도' }" >selected="selected" </c:if>>경기도</option>
				                            <option <c:if test="${ti.getTl_area() == '강원도' }" >selected="selected" </c:if>>강원도</option>
				                            <option <c:if test="${ti.getTl_area() == '경상북도' }" >selected="selected" </c:if>>경상북도</option>
				                            <option <c:if test="${ti.getTl_area() == '경상남도' }" >selected="selected" </c:if>>경상남도</option>
				                        </select>
			                        </td>
			                        <th scope="row" class="text-center table-primary align-middle">분류</th>
			                        <td>
			                        <div class="d-flex">
				                        <select class="form-control w-auto" name="ctgr">
				                            <option <c:if test="${ti.getTl_ctgr() == '명소' }" >selected="selected" </c:if>>명소</option>
				                            <option <c:if test="${ti.getTl_ctgr() == '액티비티' }" >selected="selected" </c:if>>액티비티</option>
				                            <option <c:if test="${ti.getTl_ctgr() == '맛집' }" >selected="selected" </c:if>>맛집</option>
				                        </select>
			                        </div>
			                        </td>
			                        <th scope="row" class="text-center table-primary align-middle">장소명</th>
			                        <td><input type="text" class="form-control" name="title" value="${ti.getTl_title() }" maxlength="40" required /></td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary ">내용</th>
			                        <td class="text-left" colspan="5">
			                        <textarea class="form-control" name="content" style="width:100%; height:250px;" maxlength="150" 
			                        placeholder="내용을 입력하세요." required>${ti.getTl_content() }</textarea>
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">이미지</th>
			                        <td class="text-left" colspan="5">
			                            <div class="filebox">
			                           		<label for="file">파일첨부</label>
			                                <input type="file" id="file" name="uploadFile" onchange="showFileName();" />
			                                <c:if test="${ti.getTl_img() == null }" >
			                                <span id="fileName" style="width:250px" value="${ti.getTl_img()}" >선택된 파일이 없습니다.</span>
			                                </c:if>
			                            </div>
			                            <c:if test="${ti.getTl_img() != null }" >
		                                	<span id="fileName" style="width:250px">${ti.getTl_img()}</span>
		                                	<div class="img-box"><img src="resources/images/travel/${ti.getTl_img() }" /></div>
										</c:if>
			                        </td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">게시여부</th>
			                        <td class="text-left" colspan="5">
			                            <div class="d-flex">
			                            <div class="btn-group" data-toggle="buttons">
			                                <label class="btn waves-effect waves-light mb-0 ">
			                                    <div class="custom-control custom-radio">
			                                        <input type="radio" id="customRadio4" name="isview" class="custom-control-input" value="y"
			                                        <c:if test="${ti.getTl_isview() == 'Y' }" >checked="checked" </c:if> checked="checked" />
			                                        <label class="custom-control-label" for="customRadio4">게시</label>
			                                    </div>
			                                </label>
			                                <label class="btn waves-effect waves-light ml-3 mb-0">
			                                    <div class="custom-control custom-radio">
			                                        <input type="radio" id="customRadio5" name="isview" class="custom-control-input" value="n"
			                                        <c:if test="${ti.getTl_isview() == 'N' }" >checked="checked" </c:if> />
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
				            <button type="button" class="btn waves-effect waves-light btn-secondary mr-3" onclick="history.back();">취소</button>
				            <button type="submit" class="btn waves-effect waves-light btn-primary">
				            <c:if test="${kind == 'in'}" >등록</c:if>
				            <c:if test="${kind == 'up'}" >수정</c:if></button>
			            </div>
        				</form>
        			</div>
    			</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>