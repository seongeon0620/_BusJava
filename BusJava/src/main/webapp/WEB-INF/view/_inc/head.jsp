<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	boolean isLogin = false;
	MemberInfo loginInfo = (MemberInfo) session.getAttribute("loginInfo");
	String memName = "";
	if (loginInfo != null) {
		isLogin = true;
		String type = loginInfo.getMi_type(); 
		if (type.equals("b")) memName = loginInfo.getMi_id();
		if (type.equals("k")) memName = loginInfo.getMi_name();
		if (type.equals("n")) memName = loginInfo.getMi_email().substring(0,loginInfo.getMi_email().indexOf("@"));
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>BusJava</title>
<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon.png">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap-datepicker.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">

<script>
	function openPopup() {
		window.open('http://pf.kakao.com/_xmhzxdG/chat', 'kakaoChat', 'width=600,height=800,resizable=yes,scrollbars=yes,status=yes');
	}
</script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/owl.carousel.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.easing.1.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/select2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap-datepicker.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap-datepicker.kr.js" charset="UTF-8"></script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark custom_navbar p-0">
	<div class="container justify-content-end">
		<ul class="nav top-nav">
<%
	if (isLogin) {	// 로그인 상태
%>
			<span class="mb-0"><%=memName %>님</span>
			<li class="nav-item"><a href="/BusJava/memberMypage" class="nav-link px-2">마이페이지<i class="bi bi-person-circle ml-1"></i></a></li>
			<li class="nav-item"><a href="/BusJava/memberLogout" class="nav-link px-2">로그아웃<i class="bi bi-box-arrow-right ml-1"></i></a></li>
<%
	} else {
%>
			<li class="nav-item"><a href="/BusJava/memberJoinStep1" class="nav-link px-2">회원가입<i class="bi bi-person-plus-fill ml-1"></i></a></li>
			<li class="nav-item"><a href="/BusJava/memberLogin" class="nav-link px-2">로그인<i class="bi bi-person-fill ml-1"></i></a></li>
<%
	}
%>
		</ul>
	</div>
	<div class="container">
		<h1><a class="navbar-brand" href="/BusJava"><img src="${pageContext.request.contextPath}/resources/images/logo.png" /></a></h1>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#main-menu" aria-controls="main-menu" aria-expanded="false" aria-label="Toggle navigation">
			<span><i class="bi bi-list"></i></span>
		</button>
		<div class="collapse navbar-collapse justify-content-end" id="main-menu">
			<ul class="navbar-nav">
				<li class="nav-item dropdown ${activeTicket}">
					<a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown">버스예매</a>
					<div class="dropdown-menu">
						<a class="dropdown-item" href="/BusJava/ticket/step01?type=h">고속버스 예매</a>
						<a class="dropdown-item" href="/BusJava/ticket/step01?type=s">시외버스 예매</a>
					</div>
				</li>
				<li class="nav-item"><a class="nav-link" href="/BusJava/booking">예매 내역</a></li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown">운행정보</a>
					<div class="dropdown-menu">
						<a class="dropdown-item" href="/BusJava/schedule">시간표 조회</a>
						<a class="dropdown-item" href="/BusJava/arrivaltime">도착시간 안내</a>
						<a class="dropdown-item" href="/BusJava/terminalPlace">터미널 안내</a>
					</div>
				</li>
				<li class="nav-item"><a class="nav-link" href="/BusJava/travelList">추천 여행지</a></li>
				<li class="nav-item"><a class="nav-link" href="/BusJava/pmoneyInfo">페이머니 구매</a></li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown">고객지원</a>
					<div class="dropdown-menu">
						<a class="dropdown-item" href="/BusJava/noticeList">공지사항</a>
						<a class="dropdown-item" href="/BusJava/faqList">자주하는질문</a>
						<a class="dropdown-item" href="/BusJava/lostList">유실물 안내</a>
					</div>
				</li>
			</ul>
		</div>
	</div>
	</nav>