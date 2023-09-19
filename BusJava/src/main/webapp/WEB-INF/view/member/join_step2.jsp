<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<!DOCTYPE html>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>
<script src="https://www.google.com/recaptcha/api.js"></script>
<script>
$(function() {
	$('#frmJoin').submit(function() {
			var captcha = 1;
			$.ajax({
	            url: 'VerifyRecaptcha',
	            type: 'post',
	            data: {
	                recaptcha: $("#g-recaptcha-response").val()
	            },
	            success: function(data) {
	                switch (data) {
	                    case 0:
	                    	// alert("자동 가입 방지 봇 통과");
	                        captcha = 0;
	                        $('#frmJoin').unbind('submit').submit();
	                		break;
	                    case 1:
	                        alert("자동 가입 방지 봇을 확인 한뒤 진행 해 주세요.");
	                        break;
	                    default:
	                        alert("자동 가입 방지 봇을 실행 하던 중 오류가 발생 했습니다. [Error bot Code : " + Number(data) + "]");
	                   		break;
	                }
	            }
	        });
			if(captcha != 0) {
				return false;
			} 
	});
});
/* 아이디 */
function restrictId(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9]/g, '');
}
function chkDupId(uid) {
	if (uid.length >= 4) {
		$.ajax({
			type : "POST", url : "./dupId", data : {"uid" : uid},
			success : function(chkRs){
				var msg = "";
				if (chkRs == 0) {
					msg = "<div class='valid-feedback text-left'>사용가능한 아이디 입니다.</div>";
					$("#idChk").val("Y");
					$("#mi_id").removeClass("is-invalid").addClass("is-valid");
				} else {
					msg = "<div class='valid-feedback text-left' style='color: red;'>이미 사용중인 아이디 입니다.</div>";
					$("#idChk").val("N");
					$("#mi_id").removeClass("is-valid").addClass("is-invalid");
				}
				$("#idMsg").html(msg); // .html : ()안의 태그를 바꿔라
			}
		});
		$("#idChk").val("Y");
	} else {
		$("#idMsg").text("아이디는 4 ~ 20자로 입력하세요."); // .text :()안의 내용을 바꿔라
		$("#idChk").val("N"); //기본적으로 val값이 "N"이지만  4자 이상 입력했다가 지웠을 경우를 대비해서 넣어줌
		$("#mi_id").removeClass("is-valid").addClass("is-invalid");
	}
}

/* 비밀번호 */
function restrictPw(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9!@#$%^&*()_+=\-[\]{}|\\:;"'<>,.?/~`]/g, '');
}

function checkPassword() {
	var passwordInput = document.getElementById("mi_pw");
	var passwordchkInput = document.getElementById("mi_pw2");
	var pwDup = document.getElementById("pwDup");
	
	var mi_pw = passwordInput.value;
	var mi_pw2 = passwordchkInput.value;
	var pwRed = document.getElementById("pwRed");

	if (mi_pw === mi_pw2) {
		if(mi_pw.length < 4 || mi_pw.length > 15) {
			
			pwDup.value = "N";
			passwordInput.focus();
		}else {
			pwRed.innerHTML = "<div class='valid-feedback text-left' >비밀번호가 일치합니다.</div>";
			$("#mi_pw").removeClass("is-invalid").addClass("is-valid");
			$("#mi_pw2").removeClass("is-invalid").addClass("is-valid");
			pwDup.value = "Y";
		}
	} else if (mi_pw.length < 4 || mi_pw2.length < 4 ){
		 pwRed.innerHTML = "<div class='valid-feedback text-left' style='color: red;' >4-15자의 영문, 숫자, 특수문자로 입력해주세요.</div>";
		 $("#mi_pw").removeClass("is-invalid").addClass("is-invalid");
		 $("#mi_pw2").removeClass("is-invalid").addClass("is-invalid");
		 pwDup.value = "N";
	} else {
		 pwRed.innerHTML = "<div class='valid-feedback text-left' style='color: red;' >비밀번호가 일치하지않습니다.</div>";
		 $("#mi_pw").removeClass("is-invalid").addClass("is-invalid");
		 $("#mi_pw2").removeClass("is-invalid").addClass("is-invalid");
		 pwDup.value = "N";
	}
}
/* 이메일 */
function restrictEm1(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9!#$%^&*()_+=\-[\]{}|\\:;"'<>,.?/~`]/g, '');
}
function restrictEm2(input) {
	input.value = input.value.replace(/[^a-zA-Z0-9.]/g, '');
}

$(document).ready(function() { // .ready : 문서가 다 읽힌 다음에 작동해라
	$("#e2").change(function() {
		if ($(this).val() == "") {
			$("#e3").val("");
		} else if ($(this).val() == "direct") {
			$("#e3").val("").prop("readonly", false).focus();
		} else {
			$("#e3").val($(this).val()).prop("readonly", true);
		}
	})
}); 


function mailButtonClick() {
  var e1Value = document.getElementById('e1').value;
  var e3Value = document.getElementById('e3').value;
  var mailChk = document.getElementById('mailChk');
  	if (e1Value === "" || e3Value === "") {
	    alert("이메일을 입력해주세요.");
	    mailChk.value = "N";
	    return;
	}
  chkDupMail(e1Value, e3Value); // 변수에 담은 값들을 함수에 전달
}


function chkDupMail(e1, e3) {
	if (e1 != null && e3 != null) {
		$.ajax({
			type : "POST", url : "./dupMail", data : {"e1" : e1, "e3" : e3 },
			success : function(chkRs){
				var msg = "";
				if (chkRs == 0) {
					msg = "<div class='valid-feedback text-left'>사용가능한 이메일 입니다.</div>";
					$("#mailChk").val("Y");
				} else {
					msg = "<div class='valid-feedback text-left' style='color: red;'>이미 등록된 이메일 입니다.</div>";
					$("#mailChk").val("N");
				}
				$("#mailMsg").html(msg); // .html : ()안의 태그를 바꿔라
			}
		});
		$("#mailChk").val("Y");
	} else {
		$("#mailChk").val("N"); //기본적으로 val값이 "N"이지만  4자 이상 입력했다가 지웠을 경우를 대비해서 넣어줌
	}
}

/* 전화번호 */
function phoneButtonClick() {
  var p2Value = document.getElementById('p2').value;
  var p3Value = document.getElementById('p3').value;
  var phoneChk = document.getElementById('phoneChk');
  	if (p2Value === "" || p3Value === "") {
	    alert("전화번호를 입력해주세요.");
	    phoneChk.value = "N";
	    return;
	} else if ((p2Value.length < 4 || p3Value.length < 4)){
		alert("전화번호를 확인 해주세요.");
		phoneChk.value = "N";
	    return;
	}
  	chkDupPhone(p2Value, p3Value); // 변수에 담은 값들을 함수에 전달
}


function chkDupPhone(p2, p3) {
	if (p2 != null && p3 != null) {
		$.ajax({
			type : "POST", url : "./dupPhone", data : {"p2" : p2, "p3" : p3 },
			success : function(chkRs){
				var msg = "";
				if (chkRs == 0) {
					msg = "<div class='valid-feedback text-left'>사용가능한 번호 입니다.</div>";
					$("#phoneChk").val("Y");
				} else {
					msg = "<div class='valid-feedback text-left' style='color: red;'>이미 등록된 번호 입니다.</div>";
					$("#phoneChk").val("N");
				}
				$("#phoneMsg").html(msg); // .html : ()안의 태그를 바꿔라
			}
		});
		$("#phoneChk").val("Y");
	} else {
		$("#phoneChk").val("N");
	}
}

/* 메일 변화 여부 */
function checkMchange(){
	var mailChk = document.getElementById('mailChk');
	mailChk.value = 'N';
	return;
}

/* 번호 숫자 4자리 여부 */
function checkPlength(){
	var p2 = document.getElementById('p2').value;
	var p3 = document.getElementById('p3').value;
	var phoneChk = document.getElementById('phoneChk');
	
	if (p2.length < 4 || p3.length < 4){
		phoneChk.value = 'N';
		return;
	}
}

/* 전체 점검 */
window.addEventListener('DOMContentLoaded', (event) => {
	document.getElementById('signIn').addEventListener('click', function(event) {

	    var idChk = document.getElementById('idChk').value;
	    var pwDup = document.getElementById('pwDup').value;
	    var mailChk = document.getElementById('mailChk').value;
	    var phoneChk = document.getElementById('phoneChk').value;
	    
	    
	 	if (!(idChk=== 'Y' && pwDup === 'Y' && mailChk === 'Y' && phoneChk === 'Y')) {
	        alert('중복검사를 확인하여주세요.');
	        event.preventDefault(); // 이벤트의 기본 동작(폼 제출)을 막음
	    }
	}); 
}); 

/* function joinIn() {
    var idChk = document.getElementById('idChk').value;
    var pwDup = document.getElementById('pwDup').value;
    var mailChk = document.getElementById('mailChk').value;
    var phoneChk = document.getElementById('phoneChk').value;

    if (!(idChk=== 'y' && pwDup === 'y' && mailChk === 'y' && phoneChk === 'y')) {
        alert('중복검사를 확인하여주세요.');
        return false; // 이벤트의 기본 동작(폼 제출)을 막음
    }
    return 
} */

</script>

<section class="probootstrap_section" id="section-city-guides">
<div class="container">
	<div class="row text-center mb-5 probootstrap-animate fadeInUp probootstrap-animated">
		<div class="col-md-12">
			<h2 class="display-5 border-bottom probootstrap-section-heading">회원가입</h2>
				<div class="col-md-8 m-auto">
					<div class="progress-bar-custom">
						<div class="progress-step">
							<div class="step-count"></div>
							<div class="step-description">약관 동의</div>
						</div>
						<div class="progress-step is-active">
							<div class="step-count"></div>
							<div class="step-description">정보입력</div>
						</div>
						<div class="progress-step">
						<div class="step-count"></div>
					<div class="step-description">가입완료</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
<form name="frmJoin" id="frmJoin" action=memberJoinStep2 method="post">
<input type="hidden" name="idChk" id="idChk" value="N" />
<input type="hidden" id="pwDup" name="pwDup" value="N" />
<input type="hidden" name="mailChk" id="mailChk" value="N" />
<input type="hidden" name="phoneChk" id="phoneChk" value="N" />
<input type="hidden" name="mi_type" id="mi_type" value="b" />
<div class="row">
	<div class="container">
		<div class="col-md-8 mb-3 m-auto">
			<table class="table text-center">
			<colgroup>
				<col width="25%">
				<col width="*">
			</colgroup>
			<tbody>
			<tr>
				<th>이름</th>
				<td><input type="text" class="form-control" id="mi_name" name="mi_name" required /></td>
			</tr>
			<tr>
			<th>아이디</th>
				<td><!-- form-control class가 is-valid => 성공, in-invalid => 실패 (테두리 색변화) -->
					<input type="text" class="form-control " name="mi_id" id="mi_id" 
					placeholder="4-15자의 영문, 숫자로 입력해주세요." onkeyup="chkDupId(this.value);" 
					oninput="restrictId(this)" required>
					<div class="valid-feedback text-left" id="idMsg" ></div>
					<!-- <div class="invalid-feedback text-left">이미 사용중인 아이디 입니다.</div> -->
				</td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<!--if조건줘야함 form-control class가 is-valid => 성공, in-invalid => 실패 (테두리 색변화) -->
					<input type="password" class="form-control " oninput="restrictPw(this)"
					onkeyup="checkPassword()" id="mi_pw" name="mi_pw"
					placeholder="4-15자의 영문, 숫자, 특수문자로 입력해주세요." required>
				</td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td>
				<!-- form-control class가 is-valid => 성공, in-invalid => 실패 (테두리 색변화) -->
					<input type="password" class="form-control " oninput="restrictPw(this)"
					onkeyup="checkPassword()" id="mi_pw2" name="mi_pw2"
					placeholder="4-15자의 영문, 숫자, 특수문자로 입력해주세요." required>
					<div id="pwRed" class="valid-feedback text-left"></div>
					<!-- <div class="invalid-feedback text-left">비밀번호가 일치하지 않습니다</div> -->
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td class="text-left">
					<div class="form-check custom">
						<input class="form-check-input " type="radio" name="mi_gender" value="남" id="male" checked> 
						<label class="form-check-label" for="male">남자</label>
					</div>
					<div class="form-check custom">
						<input class="form-check-input" " type="radio" name="mi_gender" value="여" id="fmale"> 
						<label class="form-check-label" for="fmale">여자</label>
					</div>
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<div class="form-row align-items-center justify-content-between">
						<div class="col-sm-3 my-1">
							<input type="text" class="form-control" name="e1" id="e1" oninput="restrictEm1(this)" onchange="checkMchange()">
						</div>
						<div class="col-sm-3 my-1">
							<div class="input-group">
								<div class="input-group-prepend d-flex align-items-center">
									<div class="input-group-text">@ </div>
								</div>
								<input type="text" class="form-control  bg-white" name="e3" id="e3" size="10" oninput="restrictEm2(this)" readonly>
							</div>
						</div>
						<select class="custom-select my-1 mr-sm-2" name="e2" id="e2" >
							<option value="" selected disabled>이메일 선택</option>
							<option value="gmail.com" >gmail.com</option>
							<option value="naver.com" >naver.com</option>
							<option value="daum.net" >daum.net</option>
							<option value="direct" >직접입력</option>
						</select>
						<div class="col-auto my-1" >
							<button type="button" class="btn btn-primary p-2" onclick="mailButtonClick()">중복검사</button>
						</div>
						<!-- <div class="invalid-feedback text-left">이미 등록된 이메일 입니다.</div> -->
					</div>
						<div class="valid-feedback text-left" id="mailMsg"></div>
				</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td>
					<div class="row align-items-center">
						<div class="col">
							<input type="text" class="form-control bg-white" placeholder="010" readonly>
						</div>
						-
						<div class="col">
							<input type="text" class="form-control" name="p2" id="p2" size="4" maxlength="4" onkeyup="checkPlength()" >
						</div>
						-
						<div class="col">
							<input type="text" class="form-control" name="p3" id="p3" size="4" maxlength="4" onkeyup="checkPlength()" >
						</div>
						<div class="col-auto my-1 pl-0">
							<button type="button" class="btn btn-primary p-2" onclick="phoneButtonClick();">중복검사</button>
						</div>
	
					</div>
					<div id="phoneMsg" class="valid-feedback text-left"></div>
					<!-- <div class="invalid-feedback text-left">이미 등록된 전화번호 입니다.</div> -->
				</td>
			</tr>
				
			</tbody>
		</table> 
	<!-- 	<button type="button" class="btn btn-primary btn-block" onclick="joinIn();">회원가입</button> -->
		<div class="g-recaptcha d-flex justify-content-center" data-sitekey="6Lc_X-4nAAAAAMaXDEuJpQzcwAysW83EAUAnI-Xj"></div>
		<button type="submit" class="btn btn-primary btn-block mt-4" id="signIn" name="signIn">회원가입</button>
		</div>
	</div>
</div>
</form>
</section>

<%@ include file="../_inc/foot.jsp"%>