<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
MemberInfo mi = (MemberInfo)session.getAttribute("loginInfo");
%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>
<script>
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
			$("#e3").val("").prop("disabled", false).focus();
		} else {
			$("#e3").val($(this).val()).prop("disabled", true);
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
		$("#mailChk").val("Y"); //기본적으로 val값이 "N"이지만  4자 이상 입력했다가 지웠을 경우를 대비해서 넣어줌
	}
}

/* 메일 변화 여부 */
function checkMchange(){
	var mailChk = document.getElementById('mailChk');
	mailChk.value = 'N';
	return;
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


function memberDel(){
	
}

/* 전체 점검 */
window.addEventListener('DOMContentLoaded', (event) => {
    document.getElementById('pwChange').addEventListener('click', function(event) {
        var pwDup = document.getElementById('pwDup').value;
        if (pwDup === 'N'){
        	alert("비밀번호를 확인해주세요");
        	event.preventDefault();
        }
        
    });
});

window.addEventListener('DOMContentLoaded', (event) => {
    document.getElementById('mailChange').addEventListener('click', function(event) {
        var mailChk = document.getElementById('mailChk').value;
        if (mailChk === 'N'){
        	alert("메일을 중복검사 확인해주세요");
        	event.preventDefault();
        }
        
    });
});

window.addEventListener('DOMContentLoaded', (event) => {
    document.getElementById('phoneChange').addEventListener('click', function(event) {
        var phoneChk = document.getElementById('phoneChk').value;
        if (phoneChk === 'N'){
        	alert("전화번호를 중복검사 해주세요");
        	event.preventDefault();
        }
        
    });
});

</script>

<section class="probootstrap_section" id="section-city-guides">
<div class="container">
	<div class="row text-center mb-5 probootstrap-animate fadeInUp probootstrap-animated">
		<div class="col-md-12">
			<h2 class="display-5 border-bottom probootstrap-section-heading">내 정보</h2>
			<div class="col-md-8 m-auto">
				<div class="progress-bar-custom">
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-8 mb-3 m-auto">
		<table class="table text-center">
		<colgroup>
			<col width="25%">
			<col width="*">
			<col width="10">
		</colgroup>
		<tbody>
		<tr>
			<th>이름</th>
			<td><input type="text" class="form-control" value="<%=mi.getMi_name() %>" readonly  /></td>
		</tr>
		<tr>
		<th>아이디</th>
			<td><!-- form-control class가 is-valid => 성공, in-invalid => 실패 (테두리 색변화) -->
				<input type="text" class="form-control" value="<%=mi.getMi_id() %>" readonly >
			</td>
		</tr>
		<tr>
			<th>비밀번호</th>
			<td>
				<!--if조건줘야함 form-control class가 is-valid => 성공, in-invalid => 실패 (테두리 색변화) -->
				<input type="password" class="form-control" value="<%=mi.getMi_pw() %>" readonly >
			</td>
			<td>
				<button type="button" class="btn btn-primary" id="change_pw" name="change_pw" onclick="changePw();">변경</button>
			</td>
		</tr>
		<form name="frmUpPw" action=memberUpPw method="post">
		<input type="hidden" id="pwDup" name="pwDup" value="N" />
		<tr id="pwChangeform1" style="display: none;">
			<th>새 비밀번호</th>
			<td>
				<input type="password" class="form-control" oninput="restrictPw(this)" onkeyup="checkPassword()" id="mi_pw" name="mi_pw" 
				placeholder="4-15자의 영문, 숫자, 특수문자로 입력해주세요." >
			</td>
		</tr>
		<tr id="pwChangeform2" style="display: none;">
			<th>새 비밀번호확인</th>
			<td>
				<input type="password" class="form-control" oninput="restrictPw(this)" onkeyup="checkPassword()" id="mi_pw2" name="mi_pw2"
				placeholder="4-15자의 영문, 숫자, 특수문자로 입력해주세요." >
				<div id="pwRed" class="valid-feedback text-left"></div>
				<div class="invalid-feedback text-left"></div>
			</td>
		</tr>
		<tr id="pwChangeform3" style="display: none;">
			<td colspan="3">
			<button type="button" class="btn btn-primary" onclick="changePw();">취소</button>
			<button type="submit" id="pwChange" class="btn btn-primary" >확인</button>
			</td>
		</tr>
		</form> 
	
		<tr>
			<th>성별</th>
			<td><input type="text" class="form-control" value="<%=mi.getMi_gender() %>" readonly  /></td>
		</tr>
		<tr>
			<th>이메일</th>
			<td><input type="text" class="form-control" value="<%=mi.getMi_email() %>" readonly  /></td>
			<td>
				<button type="button" class="btn btn-primary" id="change_mail" name="change_mail" onclick="changeEmail();">변경</button>
			</td>
		</tr>
		<form name="frmUpMail" action=memberUpMail method="post">
		<input type="hidden" name="mailChk" id="mailChk" value="N" />
		<tr id="mailChangeform1" style="display: none;">
			<th>이메일</th>
			<td>
				<div class="form-row align-items-center justify-content-between">
					<div class="col-sm-3 my-1">
						<input type="text" class="form-control" name="e1" id="e1" oninput="restrictEm1(this)" onchange="checkMchange()">
					</div>
					<div class="col-sm-3 my-1">
						<div class="input-group">
							<div class="input-group-prepend d-flex align-items-center">
								<div class="input-group-text">@ &nbsp;&nbsp;&nbsp;</div>
							</div>
							<input type="text" class="form-control" name="e3" id="e3" size="10" oninput="restrictEm2(this)" disabled>
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
						<button type="button" class="btn btn-primary" 
						onclick="mailButtonClick()">중복검사</button>
					</div>
					<!-- <div class="invalid-feedback text-left">이미 등록된 이메일 입니다.</div> -->
				</div>
					<div class="valid-feedback text-left" id="mailMsg"></div>
			</td>
		</tr>
		<tr id="mailChangeform2" style="display: none;">
			<td colspan="3">
			<button type="button" class="btn btn-primary" onclick="changeEmail();">취소</button>
			<button type="submit" id="mailChange" class="btn btn-primary" >확인</button>
			</td>
		</tr> 
		</form>
		<tr>
			<th>전화번호</th>
			<td><input type="text" class="form-control" id="mi_phone" name="mi_phone" value="<%=mi.getMi_phone() %>" readonly  /></td>
			<td>
				<button type="button" class="btn btn-primary" id="change_pw" name="change_pw" onclick="changePhone();">변경</button>
			</td>
		</tr>
		<form name="frmUpPhone" action=memberUpPhone method="post">
		<input type="hidden" name="phoneChk" id="phoneChk" value="N" />
		<tr id="phoneChangeform1" style="display: none;">
			<th>전화번호</th>
			<td>
				<div class="row align-items-center">
					<div class="col">
						<input type="text" class="form-control" placeholder="010"
							readonly>
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
						<button type="button" class="btn btn-primary" onclick="phoneButtonClick();">중복검사</button>
					</div>

				</div>
				<div id="phoneMsg" class="valid-feedback text-left"></div>
				<!-- <div class="invalid-feedback text-left">이미 등록된 전화번호 입니다.</div> -->
			</td>
		</tr>
		<tr id="phoneChangeform2" style="display: none;">
			<td colspan="3">
			<button type="button" class="btn btn-primary" onclick="changePhone();">취소</button>
			<button type="submit" id="phoneChange" class="btn btn-primary" >확인</button>
			</td>
		</tr> 
		</form>
		</tbody>
	</table> 
	<div class="btn-wrap">
	<button type="button" class="btn btn-primary w-120p " onclick="location.href='memberMypage'">취소</button>
    <button type="button" class="btn btn-secondary w-120p " onclick="memberDel();" >회원탈퇴</button>
    </div>
	</div>
</div>
</section>

<script>
function memberDel() {
	
    if(confirm("정말 탈퇴하시겠습니까?")) {
    	location.href='memberDelPwChk';// "확인선택";
    } else {
    	event.preventDefault(); // "취소선택";
    }
}


function changePw() {
	 var pwChangeForm1 = document.getElementById('pwChangeform1');
	 var pwChangeForm2 = document.getElementById('pwChangeform2');
	 var pwChangeform3 = document.getElementById('pwChangeform3');
	 var mi_pw = document.getElementById('mi_pw');
	 var mi_pw2 = document.getElementById('mi_pw2');
	 var pwDup = document.getElementById('pwDup');

	 if (pwChangeForm1.style.display === 'none') {
			pwChangeForm1.style.display = 'revert';
			pwChangeForm2.style.display = 'revert';
			pwChangeform3.style.display = 'revert';
		} else if (pwChangeForm1.style.display === 'revert') {
			pwChangeForm1.style.display = 'none';
			pwChangeForm2.style.display = 'none';
			pwChangeform3.style.display = 'none';
			mi_pw.value = "";
			mi_pw2.value = "";
			pwDup.value = "N";
		}
}

function changeEmail() {
	var mailChangeform1 = document.getElementById('mailChangeform1');
	var mailChangeform2 = document.getElementById('mailChangeform2');
	var e1 = document.getElementById('e1');
	var e2 = document.getElementById('e2');
	var e3 = document.getElementById('e3');
	var mailChk = document.getElementById('mailChk');

	if (mailChangeform1.style.display === 'none') {
		mailChangeform1.style.display = 'revert';
		mailChangeform2.style.display = 'revert';
	} else if (mailChangeform1.style.display === 'revert') {
		mailChangeform1.style.display = 'none';
		mailChangeform2.style.display = 'none';
		e1.value = "";
		e2.value = "";
		e3.value = "";
		mailChk.value = "N";
	}
}

function changePhone() {
	var phoneChangeform1 = document.getElementById('phoneChangeform1');
	var phoneChangeform2 = document.getElementById('phoneChangeform2');
	var p2 = document.getElementById('p2');
	var p3 = document.getElementById('p3');
	 var phoneChk = document.getElementById('phoneChk');
	
	if (phoneChangeform1.style.display === 'none') {
		phoneChangeform1.style.display = 'revert';
		phoneChangeform2.style.display = 'revert';
	} else if (phoneChangeform1.style.display === 'revert') {
		phoneChangeform1.style.display = 'none';
		phoneChangeform2.style.display = 'none';
		p2.value = "";
		p3.value = "";
		phoneChk.value = "N";
	}
}
</script>

<%@ include file="../_inc/foot.jsp"%>
