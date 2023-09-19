<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>
<script>
/* 아이디 찾기 */
function restrictEm1(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9!#$%^&*()_+=\-[\]{}|\\:;"'<>,.?/~`]/g, '');
}
function restrictEm2(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9.]/g, '');
}

$(document).ready(function() { // .ready : 문서가 다 읽힌 다음에 작동해라
	$("#idE2").change(function() {
		if ($(this).val() == "") {
			$("#idE3").val("");
		} else if ($(this).val() == "direct") {
			$("#idE3").val("").prop("disabled", false).focus();
		} else {
			$("#idE3").val($(this).val()).prop("disabled", true);
		}
	})
}); 

/* 비밀번호 찾기 */
function restrictId(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9]/g, '');
}

$(document).ready(function() { // .ready : 문서가 다 읽힌 다음에 작동해라
	$("#pwE2").change(function() {
		if ($(this).val() == "") {
			$("#pwE3").val("");
		} else if ($(this).val() == "direct") {
			$("#pwE3").val("").prop("disabled", false).focus();
		} else {
			$("#pwE3").val($(this).val()).prop("disabled", true);
		}
	})
}); 
</script>
<section class="probootstrap_section" id="section-city-guides">
  <div class="container">
    <div class="row text-center mb-5 probootstrap-animate">
      <div class="col-md-12">
        <h2 class="display-5 border-bottom probootstrap-section-heading">아이디 찾기</h2>
      </div>
    </div>
    <div class="row mb-4">
      <div class="col-md-6 m-auto">
        <form name="frmFindId" action="memberFindId" method="post">
        <tr>
			<th>이메일</th>
			<td>
				<div class="form-row align-items-center justify-content-between">
					<div class="col-sm-3 my-1">
						<input type="text" class="form-control" name="idE1" id="idE1" oninput="restrictEm1(this)">
					</div>
					<div class="col-sm-4 my-1">
						<div class="input-group">
							<div class="input-group-prepend d-flex align-items-center">
								<div class="input-group-text">@ &nbsp;&nbsp;&nbsp;</div>
							</div>
							<input type="text" class="form-control" name="idE3" id="idE3" size="10" oninput="restrictEm2(this)" disabled>
						</div>
					</div>
					<select class="custom-select my-1 mr-sm-2" name="idE2" id="idE2" >
						<option value="" selected disabled>이메일 선택</option>
						<option value="gmail.com" >gmail.com</option>
						<option value="naver.com" >naver.com</option>
						<option value="daum.net" >daum.net</option>
						<option value="direct" >직접입력</option>
					</select>
				</div>
			</td>
		</tr>
        <button type="submit" id="findId" class="btn btn-primary btn-block" >전송</button>
        </form>
      </div>
    </div>
    <div class="row text-center mb-5 probootstrap-animate">
      <div class="col-md-12">
      <br /><br /><br />
        <h2 class="display-5 border-bottom probootstrap-section-heading">비밀번호 찾기</h2>
      </div>
    </div>
    <div class="row mb-4">
      <div class="col-md-6 m-auto">
        <form name="frmFindPw" action="memberFindPw" method="post">
        <tr>
		<th>아이디</th>
			<td>
				<input type="text" class="form-control" name="mi_id" id="mi_id" oninput="restrictId(this)" required>
			</td>
		</tr>
		<tr>
			<th>이메일</th>
			<td>
				<div class="form-row align-items-center justify-content-between">
					<div class="col-sm-3 my-1">
						<input type="text" class="form-control" name="pwE1" id="pwE1" oninput="restrictEm1(this)" onchange="checkMchange()">
					</div>
					<div class="col-sm-4 my-1">
						<div class="input-group">
							<div class="input-group-prepend d-flex align-items-center">
								<div class="input-group-text">@ &nbsp;&nbsp;&nbsp;</div>
							</div>
							<input type="text" class="form-control" name="pwE3" id="pwE3" size="10" oninput="restrictEm2(this)" disabled>
						</div>
					</div>
					<select class="custom-select my-1 mr-sm-2" name="pwE2" id="pwE2" >
						<option value="" selected disabled>이메일 선택</option>
						<option value="gmail.com" >gmail.com</option>
						<option value="naver.com" >naver.com</option>
						<option value="daum.net" >daum.net</option>
						<option value="direct" >직접입력</option>
					</select>
				</div>
			</td>
		</tr>
        <button type="submit" id="findPw" class="btn btn-primary btn-block" >전송</button>
        </form>
      </div>
    </div>
  </div>
</section>

<%@ include file="../_inc/foot.jsp"%>