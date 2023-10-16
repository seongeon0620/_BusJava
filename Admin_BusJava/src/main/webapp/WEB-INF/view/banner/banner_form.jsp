<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%@ page import="vo.*"%>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
BannerInfo bi = (BannerInfo) request.getAttribute("bi");
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("location.href='/Admin_BusJava/login' ");
	out.println("</script>");
	out.close();
}
%>
<script>
$(document).ready(function() {
    $('form[name="frmIn"]').on('submit', function(event) {
        event.preventDefault();  // 기본 제출 동작 중지
        
        var radio1 = document.getElementById('customRadio1');
        var radio2 = document.getElementById('customRadio2');
        	
		if (!radio1.checked && !radio2.checked) {
			alert("게시여부를 선택해 주세요.");
			return;
		}
        
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
		<h3 class="page-title text-truncate text-dark font-weight-bold">배너 관리</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
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
							<input type="hidden" name="kind" value="<%=kind %>" /> <input type="hidden" name="bl_idx" <% if (kind.equals("up")) { %> value="<%=bi.getBl_idx() %>" <% } %> /> <input type="hidden" id="fileSrc" name="fileSrc" <% if (kind.equals("up")) { %> value="<%=bi.getBl_img() %>" <% } %> />
							<table class="table custom">
								<colgroup>
									<col width="15%">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="text-center table-primary align-middle">배너명<span class="text-danger">*</span></th>
										<td class="text-left" colspan="5">
											<input type="text" class="form-control" name="BannerName" maxlength="40" required <% if (kind.equals("up")) { %> value="<%=bi.getBl_name() %>" <% } %> />
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center table-primary">설명<span class="text-danger">*</span></th>
										<td class="text-left" colspan="5">
											<textarea class="form-control" name="content" style="width: 100%; height: 250px;" maxlength="150" placeholder="내용을 입력하세요." required><% if (kind.equals("up")) { %><%=bi.getBl_content() %><% } %></textarea>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center table-primary align-middle">이미지<span class="text-danger">*</span></th>
										<td class="text-left" colspan="5">
											<div class="input-group mb-1">
												<div class="input-group-prepend">
													<span class="input-group-text" id="inputGroupFileAddon01">파일첨부</span>
												</div>
												<div class="custom-file">
													<input type="file" class="custom-file-input" name="uploadFile" id="inputGroupFile01">
													<label class="custom-file-label custom" for="inputGroupFile01">
														<% if (kind.equals("up")) { 
												if (bi.getBl_img() == null) { %>
													선택된 파일 없음
												<% } else { %>
													<%=bi.getBl_img().toLowerCase() %>
												<% }
												}%>
													</label>
												</div>
											</div>
											<span class="mb-2">첨부 파일형식 : jpg / jpeg / png / gif (3MB X 1개)</span>
											
											<% if (kind.equals("up") && bi.getBl_img() != null) { %>
												<div class="file-img-wrap border">
													<img src="resources/images/banner/<%=bi.getBl_img().toLowerCase() %>" class="file-img" />
												</div>
											<% } else { %>
												<div class="file-img-wrap border d-none">
													<img src="" class="file-img"/>
												</div>	
											<% } %>
											
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center table-primary align-middle">게시여부<span class="text-danger">*</span></th>
										<td class="text-left d-flex" colspan="5">
											<div class="form-check form-check-inline mr-4">
												<div class="custom-control custom-radio">
													<input type="radio" id="customRadio1" name="isview" class="custom-control-input" value="Y" <% if (kind.equals("up")) { if (bi.getBl_isview().equals("Y")) { %> checked="checked" <% }} %> /> <label class="custom-control-label" for="customRadio1">게시</label>
												</div>
											</div>	
											<div class="form-check form-check-inline">
												<div class="custom-control custom-radio">
													<input type="radio" id="customRadio2" name="isview" class="custom-control-input" value="N" <% if (kind.equals("up")) { if (bi.getBl_isview().equals("N")) { %> checked="checked" <% }} %> /> <label class="custom-control-label" for="customRadio2">미게시</label>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="d-flex justify-content-center">
								<button type="button" class="btn waves-effect waves-light btn-secondary mr-3" onclick="history.back();">취소</button>
								<button type="submit" class="btn waves-effect waves-light btn-primary">
									<% if (kind.equals("in")) { %>
									등록
									<% } 
									else if (kind.equals("up")) { %>
									수정
									<% } %>
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp"%>
<script>
//파일의 텍스트 필드에 사용자가 선택한 파일명 보여줌
$("input[type='file']").on('change',function(){
	const selectedFile = event.target.files[0];
	const maxSize = 3 * 1024 * 1024;
	const fileSize = this.files[0].size;
	const reg = /(.*?)\.(jpg|gif|jpeg|png)$/;
	const preview = document.querySelector('.file-img');
	const imageSrc = URL.createObjectURL(selectedFile);
	
	if (selectedFile.name != "" && (selectedFile.name.match(reg) == null || !reg.test(selectedFile.name))) {
		$(this).val("");
		alert("이미지 파일 형식만 첨부 가능합니다.");
		preview.parentNode.classList.add('d-none');
		return;
	}
	
	if (fileSize > maxSize) {
		$(this).val("");
		alert("3MB이내의 이미지만 업로드 가능합니다.");
		return;
	}

	preview.parentNode.classList.remove('d-none');
	preview.src = imageSrc;
});
</script>