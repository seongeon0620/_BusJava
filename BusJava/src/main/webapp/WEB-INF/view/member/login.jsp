<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5 animate fadeInUp animated">
			<div class="col-md-12">
				<h2 class="display-5 border-bottom heading">로그인</h2>
			</div>
		</div>
		<div class="row mb-4">
			<div class="col-md-4 m-auto">
				<form name="frmLogin" action="memberLogin" method="post">
					<input type="hidden" name="returnUrl" value="${param.returnUrl}" />
					<div class="form-group">
						<label for="mi_id">아이디</label>
						<input type="text" class="form-control" id="mi_id" name="mi_id" value="test1">
					</div>
					<div class="form-group">
						<label for="mi_pw">비밀번호</label>
						<input type="password" class="form-control" id="mi_pw" name="mi_pw" value="1234">
					</div>
					<button type="submit" class="btn btn-primary btn-block">로그인</button>
				</form>
				<div class="d-flex justify-content-center mt-2">
					<a href="memberJoinStep1" class="mr-3">회원가입</a>
					<a href="memberFind">아이디/비밀번호 찾기</a>
				</div>
				<div class="d-flex justify-content-center mt-2">
					<% String kakaoLogin = "https://kauth.kakao.com/oauth/authorize?client_id=be7adf36fd8efa4f57b4b83208a0b9f6&redirect_uri=http://localhost:8086/busjavaf/kakaoLoginProc&response_type=code"; 
					String naverLogin = "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=gd01GYXHHa_j2i1TDt8V&state=STATE_STRING&redirect_uri=http://localhost:8086/busjavaf/naverLoginProc"; %>
					<a href="<%=kakaoLogin%>" class="btn-social kakao">
						<img src="${pageContext.request.contextPath}/resources/images/ico-kakao.svg" />
						<span class="text-center w-100">카카오 로그인</span>
					</a>
				</div>
				<div class="d-flex justify-content-center mt-2">
					<a href="<%=naverLogin%>" class="btn-social naver">
						<img src="${pageContext.request.contextPath}/resources/images/ico-naver.svg" />
						<span class="text-center w-100">네이버 로그인</span>
					</a>
				</div>
			</div>
		</div>
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>