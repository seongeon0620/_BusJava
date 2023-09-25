<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
request.setCharacterEncoding("utf-8");
String typeCode = (String)request.getAttribute("typeCode");
List<TerminalInfo> terminalList = (List<TerminalInfo>) request.getAttribute("terminalList");
%>
<div class="modal-header">
	<h5 class="modal-title">출/도착지 선택</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">
	<div class="input-group mb-3">
		<input type="hidden" name="typeCode" value="<%=typeCode %>" />
		<input type="text" id="keyword" name="keyword" class="form-control focus-none form-control-lg" placeholder="터미널 이름을 입력하세요." value="${param.keyword}" />
		<div class="input-group-append"><button type="button" id="schBtnPop" class="btn-primary btn-lg btn pl-3">검색</button></div>
	</div>
	<ul id ="keywordArea">
	</ul>
	<form name="frmPoint">
		<div class="form-row">
			<div class="col-md-6 mb-3">
				<label for="sPointPop">출발지</label>
				<input type="text" class="form-control form-control-lg focus-none active bg-white" id="sPointPop" name="sPointPop" readonly>
			</div>
			<div class="col-md-6 mb-3">
				<label for="ePointPop">도착지</label>
				<input type="text" class="form-control form-control-lg focus-none bg-white" id="ePointPop" name="ePointPop" readonly>
			</div>
		</div>
	</form>
	<div class="row" id="go">
		<div class="col-2 scroll-box border-0 pt-0 pb-0">
			<div class="nav flex-column nav-pills" role="tablist" aria-orientation="vertical">
				<button class="nav-link active" data-toggle="pill" data-target="#all1" role="tab">전체</button>
				<button class="nav-link" data-toggle="pill" data-target="#seoul1" role="tab">서울</button>
				<button class="nav-link" data-toggle="pill" data-target="#gyeong1" role="tab">경기</button>
				<button class="nav-link" data-toggle="pill" data-target="#incheon1" role="tab">인천</button>
				<button class="nav-link" data-toggle="pill" data-target="#gang1" role="tab">강원</button>
				<button class="nav-link" data-toggle="pill" data-target="#daejeon1" role="tab">대전</button>
				<button class="nav-link" data-toggle="pill" data-target="#chungnam1" role="tab">충남</button>
				<button class="nav-link" data-toggle="pill" data-target="#chungbuk1" role="tab">충북</button>
				<button class="nav-link" data-toggle="pill" data-target="#gwangju1" role="tab">광주</button>
				<button class="nav-link" data-toggle="pill" data-target="#jeonnam1" role="tab">전남</button>
				<button class="nav-link" data-toggle="pill" data-target="#jeonbuk1" role="tab">전북</button>
				<button class="nav-link" data-toggle="pill" data-target="#busan1" role="tab">부산</button>
				<button class="nav-link" data-toggle="pill" data-target="#gyeongnam1" role="tab">경남</button>
				<button class="nav-link" data-toggle="pill" data-target="#daegu1" role="tab">대구</button>
				<button class="nav-link" data-toggle="pill" data-target="#gyeongbuk1" role="tab">경북</button>
				<button class="nav-link" data-toggle="pill" data-target="#ulsan1" role="tab">울산</button>
			</div>
		</div>
		<div class="col-10">
			<div class="tab-content" id="v-pills-tabContent">		
				<ul class="tab-pane scroll-box t-list active" id="all1" role="tabpanel">
<%
	if (terminalList.size() > 0) { // 터미널 목록이 있는경우
		for (int i = 0; i < terminalList.size(); i++) { // 전체목록
			TerminalInfo ti = terminalList.get(i);
		String btcode = ti.getBt_code() < 100 ? "0" + ti.getBt_code() : String.valueOf(ti.getBt_code());
%>
					<li><a href="<%=btcode%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="seoul1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 서울
		if (ti.getBt_area().startsWith("서울")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gyeong1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 경기
		if (ti.getBt_area().startsWith("경기")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="incheon1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 인천
		if (ti.getBt_area().startsWith("인천")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gang1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 강원
		if (ti.getBt_area().startsWith("강원")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="daejeon1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 대전
		if (ti.getBt_area().startsWith("대전")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="chungnam1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 충남
		if (ti.getBt_area().indexOf("충") == 0 && ti.getBt_area().indexOf("남") == 2) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="chungbuk1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 충북
		if (ti.getBt_area().indexOf("충") == 0 && ti.getBt_area().indexOf("북") == 2) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gwangju1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 광주
		if (ti.getBt_area().startsWith("광주")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="jeonnam1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 전남
		if (ti.getBt_area().indexOf("전") == 0 && ti.getBt_area().indexOf("남") == 2) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="jeonbuk1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 전북
		if (ti.getBt_area().indexOf("전") == 0 && ti.getBt_area().indexOf("북") == 2) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="busan1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 부산
		if (ti.getBt_area().startsWith("부산")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gyeongnam1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 경남
		if (ti.getBt_area().indexOf("경") == 0 && ti.getBt_area().indexOf("남") == 2) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="daegu1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 대구
		if (ti.getBt_area().startsWith("대구")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gyeongbuk1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 경북
		if (ti.getBt_area().indexOf("경") == 0 && ti.getBt_area().indexOf("북") == 2) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
				<ul class="tab-pane scroll-box t-list" id="ulsan1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 울산
		if (ti.getBt_area().startsWith("울산")) {
%>
					<li><a href="<%=ti.getBt_code()%>" class="text-decoration-none"><%=ti.getBt_name()%></a></li>
<%
		}
	}
%>
				</ul>
			</div>	
		<%
			}
		%>
			</div>
	</div>
	<div class="row" id="arrival" style="display: none;">
		<div class="col-2 scroll-box border-0 pt-0 pb-0">
			<div class="nav flex-column nav-pills" role="tablist" aria-orientation="vertical">
				<button class="nav-link active" data-toggle="pill" data-target="#all2" role="tab">전체</button>
				<button class="nav-link" data-toggle="pill" data-target="#seoul2" role="tab">서울</button>
				<button class="nav-link" data-toggle="pill" data-target="#gyeong2" role="tab">경기</button>
				<button class="nav-link" data-toggle="pill" data-target="#incheon2" role="tab">인천</button>
				<button class="nav-link" data-toggle="pill" data-target="#gang2" role="tab">강원</button>
				<button class="nav-link" data-toggle="pill" data-target="#daejeon2" role="tab">대전</button>
				<button class="nav-link" data-toggle="pill" data-target="#chungnam2" role="tab">충남</button>
				<button class="nav-link" data-toggle="pill" data-target="#chungbuk2" role="tab">충북</button>
				<button class="nav-link" data-toggle="pill" data-target="#gwangju2" role="tab">광주</button>
				<button class="nav-link" data-toggle="pill" data-target="#jeonnam2" role="tab">전남</button>
				<button class="nav-link" data-toggle="pill" data-target="#jeonbuk2" role="tab">전북</button>
				<button class="nav-link" data-toggle="pill" data-target="#busan2" role="tab">부산</button>
				<button class="nav-link" data-toggle="pill" data-target="#gyeongnam2" role="tab">경남</button>
				<button class="nav-link" data-toggle="pill" data-target="#daegu2" role="tab">대구</button>
				<button class="nav-link" data-toggle="pill" data-target="#gyeongbuk2" role="tab">경북</button>
				<button class="nav-link" data-toggle="pill" data-target="#ulsan2" role="tab">울산</button>
			</div>
		</div>
		<div class="col-10">
			<div class="tab-content" id="v-pills-tabContent">
				<ul class="tab-pane scroll-box t-list active" id="all2" role="tabpanel" aria-expanded="true">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="seoul2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gyeong2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="incheon2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gang2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="daejeon2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="chungnam2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="chungbuk2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gwangju2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="jeonnam2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="jeonbuk2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="busan2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gyeongnam2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="daegu2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="gyeongbuk2" role="tabpanel">
				</ul>
				<ul class="tab-pane scroll-box t-list" id="ulsan2" role="tabpanel">
				</ul>
				
			</div>
		</div>
	</div>
</div>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	<button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
</div>