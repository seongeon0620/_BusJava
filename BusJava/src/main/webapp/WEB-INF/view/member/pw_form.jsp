<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-3">
			<div class="col-md-12">
				<h2 class="border-bottom heading">비밀번호 입력</h2>
			</div>
		</div>
		<div class="row mb-4">
			<div class="col-md-4 m-auto">
				<form name="frmPwChk" id="frmPwChk">
					<input type="password" class="form-control" id="mi_pw" name="mi_pw">
					<div class="btn-wrap">
						<button type="button" class="btn btn-secondary btn-block mt-2" onclick="history.back();">취소</button>
						<button type="button" id="submitBtn" class="btn btn-primary btn-block">확인</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</section>
<script>
	$("#submitBtn").click(function() {
		var passwordInput = document.getElementById("mi_pw");
		var mi_pw = passwordInput.value;
		
		
		$.ajax({
			type : "POST", url : "chkPw", data : {"mi_pw" : mi_pw},
			success : function(data){
				if (data == 1)
				location.href = 'mypage/myInfo';
			}
		});
	});
</script>
<%@ include file="../_inc/foot.jsp"%>