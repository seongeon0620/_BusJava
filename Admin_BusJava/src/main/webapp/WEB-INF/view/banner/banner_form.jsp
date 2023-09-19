<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%@ page import="vo.*" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
BannerInfo bi = (BannerInfo) request.getAttribute("bi");
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/busjava_admin/login' ");
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


$(document).ready(function() {
    $('form[name="frmIn"]').on('submit', function(event) {
        event.preventDefault();  // 기본 제출 동작 중지
        
        var radio1 = document.getElementById('customRadio1');
        var radio2 = document.getElementById('customRadio2');
        
        if (radio1.checked) {
	        $.ajax({
	            type: "POST",
	            url: "./chkIsview",
	            success: function(response) {
	                if (response >= 3) {  // 이미 3개 이상의 배너가 지정된 경우
	                	alert("이미 지정된 배너의 개수가 3개 입니다.");
	                } else {
	                	$('form[name="frmIn"]').off('submit').submit();  // 폼 제출
	                }
	            },
	            error: function() {
	            	alert("서버 통신 오류");
	            }
	        });
        } else if (radio2.checked) {
        	$('form[name="frmIn"]').off('submit').submit();  // 폼 제출
        }
    });
});


</script>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold"><%= (kind.equals("up") ? "배너 수정" : "배너 등록") %></h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/busjava_admin" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item"><a href="bannerList" class="text-muted">배너 목록</a></li>
		            <li class="breadcrumb-item active" aria-current="page"><%= (kind.equals("up") ? "배너 수정" : "배너 등록") %></li>
		        </ol>
		    </nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
    		<div class="col-lg-12">
        		<div class="card">
        			<div class="card-body">
			        	<form name="frmIn" action="bannerIn" method="post" enctype="multipart/form-data">
				        <input type="hidden" name="kind" value="<%=kind %>" />
				        <input type="hidden" name="bl_idx" <% if (kind.equals("up")) { %>value="<%=bi.getBl_idx() %>" <% } %> />
				        <input type="hidden" id="fileSrc" name="fileSrc" <% if (kind.equals("up")) { %>value="<%=bi.getBl_img() %>" <% } %> />
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
			                        <th scope="row" class="text-center table-primary align-middle">배너명</th>
			                        <td class="text-left" colspan="5"><input type="text" class="form-control" name="name" maxlength="40" required 
			                         <% if (kind.equals("up")) { %> value="<%=bi.getBl_name() %>" <% } %>/></td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary ">설명</th>
			                        <td class="text-left" colspan="5">
			                        <textarea class="form-control" name="content" style="width:100%; height:250px;" maxlength="150" 
			                        placeholder="내용을 입력하세요." required><% if (kind.equals("up")) { %><%=bi.getBl_content() %><% } %></textarea>
			                        </td>
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">이미지</th>
			                        <td class="text-left" colspan="5">
			                        	<div class="filebox">
			                           		<label for="file">파일첨부</label> 
			                                <input type="file" id="file" name="uploadFile" onchange="showFileName();" />
			                                <span id="fileName" style="width:250px"></span>
			                                <% if (kind.equals("up")) { 
			                                	if (bi.getBl_img() == null) { %>
			                                <span id="fileName" style="width:250px">선택된 파일이 없습니다.</span>
			                                <% } else { %>
			                                <span id="fileName" style="width:250px"></span>
			                                <div class="img-box"><img src="resources/images/banner/<%=bi.getBl_img().toLowerCase() %>" /></div>
			                                <% }
			                               	}%>
			                            </div> 
			                        <span>첨부 파일형식 : jpg / jpeg / png / gif (3MB X 1개)</span>
			                        </td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">게시여부</th>
			                        <td class="text-left" colspan="5">
			                            <div class="d-flex">
			                            <div class="btn-group" data-toggle="buttons">
			                                <div class="btn waves-effect waves-light ml-3 mb-0">
											    <div class="custom-control custom-radio">
											        <input type="radio" id="customRadio1" name="isview" class="custom-control-input" value="Y"  
											        <% if (kind.equals("up")) { if (bi.getBl_isview().equals("Y")) { %> checked="checked" <% }} %>/>
											        <label class="custom-control-label" for="customRadio5">게시</label>
											    </div>
											</div>
			                                <div class="btn waves-effect waves-light ml-3 mb-0">
											    <div class="custom-control custom-radio">
											        <input type="radio" id="customRadio2" name="isview" class="custom-control-input" value="N" 
											        <% if (kind.equals("up")) { if (bi.getBl_isview().equals("N")) { %> checked="checked" <% }} %>/>
											        <label class="custom-control-label" for="customRadio5">미게시</label>
											    </div>
											</div>
			                            </div>
			                            </div>
			                        </td> 
			                    </tr>
			                </tbody>
			            </table>
			            <div class="d-flex justify-content-center">
				            <button type="button" class="btn waves-effect waves-light btn-secondary mr-3" onclick="history.back();">취소</button>
				            <button type="submit" class="btn waves-effect waves-light btn-primary">
				            <% if (kind.equals("in")) { %> 등록 <% } 
				            else if (kind.equals("up")) { %> 수정 <% } %>
				            </button> 
			            </div>
        				</form>
        			</div>
    			</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>