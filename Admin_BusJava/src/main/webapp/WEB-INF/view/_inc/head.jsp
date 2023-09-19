<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.time.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="vo.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
boolean isLogin = false;
AdminInfo loginInfo = (AdminInfo)session.getAttribute("loginInfo");
if (loginInfo != null)	isLogin = true;

if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='login?returnUrl=faqForm'; ");
	out.println("</script>");
	out.close();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
	<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon.png">
	<title>BUSJAVA ADMIN</title>
	<link href="${pageContext.request.contextPath}/resources/css/style.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap-datepicker.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/js/jquery.timepicker.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/common.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.timepicker.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.timepicker.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
</head>
<script>
function onlyNum(obj) {
	if (isNaN(obj.value)) {	// 숫자가 아니면
		obj.value = "";
	}
}
</script>
<body>
	<div class="preloader">
		<div class="lds-ripple">
			<div class="lds-pos"></div>
			<div class="lds-pos"></div>
		</div>
    </div>
	<div id="main-wrapper" data-theme="light" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed" data-boxed-layout="full">
		<header class="topbar" data-navbarbg="skin6">
            <nav class="navbar top-navbar navbar-expand-md">
				<div class="navbar-header" data-logobg="skin6">
					<a class="nav-toggler waves-effect waves-light d-block d-md-none" href="javascript:void(0)"><i class="ti-menu ti-close"></i></a>
					<div class="navbar-brand">
						<a href="/busjava_admin">
							<span class="logo-text">
								<img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="homepage" class="dark-logo" width="95%" />
							</span>
						</a>
					</div>
					<a class="topbartoggler d-block d-md-none waves-effect waves-light" href="javascript:void(0)" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><i class="ti-more"></i></a>
				</div>
				<div class="navbar-collapse collapse justify-content-end p-3" id="navbarSupportedContent">
					<ul class="navbar-nav float-right">
						<li class="nav-item">
							<div class="d-flex">
								<% if (!isLogin) { %>	
								<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='login'">로그인</button>
								<% } else { %>
								<a class="nav-link" style="pointer-events: none;" >
									<span class="ml-2 d-none d-lg-inline-block"><span class="text-dark">안녕하세요, <%=loginInfo.getAi_id() %>님</span>
								</a>
								<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='logout'">로그아웃</button>
								<% }%>
							</div>
						</li>
					</ul>
				</div>
			</nav>
		</header>
		<aside class="left-sidebar" data-sidebarbg="skin6">
			<div class="scroll-sidebar" data-sidebarbg="skin6">
				<nav class="sidebar-nav">
					<ul id="sidebarnav">
						<li class="sidebar-item">
							<a class="sidebar-link" href="memberList" aria-expanded="false">
								<i data-feather="users" class="feather-icon"></i>
								<span class="hide-menu">회원 관리</span>
							</a>
						</li>
						<li class="sidebar-item">
							<a class="sidebar-link sidebar-link" href="bannerList" aria-expanded="false">
								<i data-feather="grid" class="feather-icon"></i>
								<span class="hide-menu">배너 관리</span>
							</a>
						</li>
						<li class="sidebar-item">
							<a class="sidebar-link" href="ticketList" aria-expanded="false">
								<i data-feather="edit" class="feather-icon"></i>
								<span class="hide-menu">예매 관리</span>
							</a>
						</li>
						<li class="sidebar-item">
							<a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
								<i data-feather="repeat" class="feather-icon"></i>
								<span class="hide-menu">터미널 관리</span>
							</a>
							<ul aria-expanded="false" class="collapse  first-level base-level-line">
								<li class="sidebar-item">
									<a href="terminal?kind=h" class="sidebar-link">
										<span class="hide-menu">고속버스 관리</span>
									</a>
								</li>
								<li class="sidebar-item">
									<a href="terminal?kind=s" class="sidebar-link">
										<span class="hide-menu">시외버스 관리</span>
									</a>
								</li>
							</ul>
						</li>
						<li class="sidebar-item">
							<a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
								<i data-feather="message-square" class="feather-icon"></i>
								<span class="hide-menu">고객지원 관리</span>
							</a>
							<ul aria-expanded="false" class="collapse  first-level base-level-line">
							<li class="sidebar-item">
								<a href="faqList" class="sidebar-link">
									<span class="hide-menu">FAQ 관리</span>
								</a>
							</li>
							<li class="sidebar-item">
								<a href="noticeList" class="sidebar-link">
									<span class="hide-menu">공지사항 관리</span>
								</a>
							</li>
							<li class="sidebar-item">
								<a href="lostList" class="sidebar-link">
									<span class="hide-menu"> 유실물 관리</span>
								</a>
							</li>
							</ul>
						</li>
						<li class="sidebar-item">
							<a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
								<i data-feather="bar-chart" class="feather-icon"></i>
								<span class="hide-menu">매출 현황 </span>
							</a>
							<ul aria-expanded="false" class="collapse  first-level base-level-line">
							<li class="sidebar-item">
								<a href="salesList" class="sidebar-link">
									<span class="hide-menu">전체 매출</span>
								</a>
							</li>
							<li class="sidebar-item">
								<a href="paymoneyList" class="sidebar-link">
									<span class="hide-menu"> 페이머니 매출</span>
								</a>
							</li>
						</ul>
						</li>
					</ul>
		        </nav>
		    </div>
		</aside>