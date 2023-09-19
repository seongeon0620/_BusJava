<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
%>
<section class="probootstrap_section">
	<div class="container">
		<div class="row text-center mb-5 probootstrap-animate fadeInUp probootstrap-animated mb-0">
			<div class="col-md-12">
				<h2 class="border-bottom mb-5 probootstrap-section-heading">문의사항</h2>
			</div>
		</div>
        <div class="row">
			<div class="col-md-12">
	            <table class="table table-bordered">
					<colgroup>
						<col width="20%">
						<col width="*">
					</colgroup>
					<tbody class="text-center">
						<tr>
							<th class="text-center">분류<span class="text-danger">*</span></th>
							<td>
								<select class="form-control" id="category">
									<option>분류 선택</option>
									<option>예매</option>
									<option>결제</option>
									<option>건의</option>
									<option>기타</option>
								</select>
							</td>
						</tr>
						<tr>
							<th class="text-center align-middle">제목<span class="text-danger">*</span></th>
							<td><input type="text" id="title" name="title" class="form-control" placeholder="제목을 입력해주세요." maxlength="50" /></td>
						</tr>
						<tr>
							<th class="text-center align-middle">내용<span class="text-danger">*</span></th>
							<td>
								<textarea id="contents" name="contents" class="form-control" rows="10"></textarea>
								<p class="text-right mb-0"><small class="text-muted"><span id="textCnt">0</span> / 500자</small></p>
							</td>
						</tr>
						<tr>
							<th class="text-center align-middle">첨부파일</th>
							<td class="text-left">
								<div class="custom-file w-50">
								<input type="file" class="custom-file-input" id="file" required />
									<label class="custom-file-label overflow-hidden" for="file"></label>
								</div>
								<span class="text-muted ion-ios-information-outline mr-1"></span><small class="text-muted">첨부 파일형식 : jpg / jpeg / png / gif (3MB X 1개)</small>
							</td>
						</tr>
						<tr>
							<th class="text-center align-middle">비밀글 설정</th>
							<td class="text-left">
								<div class="form-check custom ml-0 mt-2">
					                <input class="form-check-input" type="checkbox" name="isSecret" id="isSecret">
					                <label class="form-check-label" for="isSecret">해당 문의글을 비밀글로 설정합니다.</label>
	            				</div>
							</td>
						</tr>
						<tr id="pwRow" style="display:none;">
							<th class="text-center align-middle">비밀번호</th>
							<td class="text-left">
								<input type="password" class="form-control" maxlength="15" />
								<span class="text-muted ion-ios-information-outline mr-1"></span><small class="text-muted">4-15자의 영문, 숫자, 특수문자로 입력해주세요.</small>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn-wrap">
					<button type="button" class="btn btn-secondary" onclick="">취소</button>
      				<button type="button" id="submitBtn" class="btn btn-primary">확인</button>
				</div>
			</div>
        </div>
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>
<script>
// 비밀글 체크박스 체크 여부에 따른 아래 비밀번호 row 설정
let isSecret = document.getElementById("isSecret");
isSecret.addEventListener("click", function (){
	let pwRow = document.getElementById("pwRow");
	if (isSecret.checked == true) {
		pwRow.style.display = "contents";
	} else {
		pwRow.style.display = "none";
	}
});

// 내용영역의 글자수 세기
let contents = document.getElementById("contents");
let textCnt = document.getElementById("textCnt");
contents.addEventListener("keyup", function() {
	if (this.value.length > 500) {
		alert("내용은 최대 500자까지 입력가능 합니다.");
		this.value = this.value.substring(0, 500);
	}
	
	textCnt.innerText = this.value.length;
	
});

// 파일의 텍스트 필드에 사용자가 선택한 파일명 보여줌
$("input[type='file']").on('change',function(){
	const selectedFile = event.target.files[0];
	const maxSize = 3 * 1024 * 1024;
	const fileSize = this.files[0].size;
	const reg = /(.*?)\.(jpg|gif|jpeg|png)$/;

	if (selectedFile.name != "" && (selectedFile.name.match(reg) == null || !reg.test(selectedFile.name))) {
		$(this).val("");
		alert("이미지 파일 형식만 첨부 가능합니다.");
		return;
	}
	
	if (fileSize > maxSize) {
		$(this).val("");
		alert("3MB이내의 이미지만 업로드 가능합니다.");
		return;
	}
	
	$(this).next().html(event.target.files[0].name);
});

// 파일 확장자만 가져오기
// return => string
GetFileExtention = function (str) {
 return (str.indexOf(".") < 0) ? "" : str.substring(str.lastIndexOf(".") + 1, str.length);
}

$("#submitBtn").click(function() {
	if ($("#category").val() == "분류 선택") {
		alert("분류를 선택해 주세요.");
		$("#category").focus();
		return;
	}
	
	if ($("#title").val() == "") {
		alert("제목을 입력해 주세요.");
		$("#title").focus();
		return;
	}
	
	if ($("#contents").val() == "") {
		alert("내용을 입력해 주세요.");
		$("#contents").focus();
		return;
	}
	
	// 첨부파일 확장자가 올바르지 않은 경우
	
	
});
</script>