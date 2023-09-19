<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
request.setCharacterEncoding("utf-8");
List<TerminalInfo> terminalList = (List<TerminalInfo>) request.getAttribute("terminalList");
%>
<div class="modal-header">
	<h5 class="modal-title" id="exampleModalLabel">터미널 선택</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">
	<div class="input-group mb-3">
		<input type="text" id="keyword" name="keyword" class="form-control focus-none" placeholder="터미널 이름을 입력하세요." value="${param.keyword}" />
		<div class="input-group-append"><button type="button" id="schBtnPop" class="btn btn-primary">검색</button></div>
	</div>
	<ul id ="keywordArea">
	</ul>
		<div class="col-md-12 mb-3 p-0">
			<input type="text" class="form-control form-control-lg focus-none active bg-white" id="sPointPop" name="sPointPop" readonly>
		</div>
		<div class="row" id="go">
			<div class="col-2 scroll-box border-0 pt-0 pb-0">
				<div class="nav flex-column nav-pills" role="tablist" aria-orientation="vertical">
					<button class="nav-link active p-1" data-toggle="pill" data-target="#all1" role="tab">전체</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#seoul1" role="tab">서울</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#gyeong1" role="tab">경기</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#incheon1" role="tab">인천</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#gang1" role="tab">강원</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#daejeon1" role="tab">대전</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#chungnam1" role="tab">충남</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#chungbuk1" role="tab">충북</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#gwangju1" role="tab">광주</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#jeonnam1" role="tab">전남</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#jeonbuk1" role="tab">전북</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#busan1" role="tab">부산</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#gyeongnam1" role="tab">경남</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#daegu1" role="tab">대구</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#gyeongbuk1" role="tab">경북</button>
					<button class="nav-link p-1" data-toggle="pill" data-target="#ulsan1" role="tab">울산</button>
				</div>
			</div>
			<div class="col-10">
				<div class="tab-content" id="v-pills-tabContent">		
					<ul class="tab-pane scroll-box t-list active" id="all1" role="tabpanel">
<%
	if (terminalList.size() > 0) { // 터미널 목록이 있는경우
		for (int i = 0; i < terminalList.size(); i++) { // 전체목록
			TerminalInfo ti = terminalList.get(i);
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="seoul1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 서울
		if (ti.getBh_area().startsWith("서울")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="gyeong1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 경기
		if (ti.getBh_area().startsWith("경기")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="incheon1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 인천
		if (ti.getBh_area().startsWith("인천")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="gang1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 강원
		if (ti.getBh_area().startsWith("강원")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="daejeon1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 대전
		if (ti.getBh_area().startsWith("대전")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="chungnam1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 충남
		if (ti.getBh_area().indexOf("충") == 0 && ti.getBh_area().indexOf("남") == 2) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="chungbuk1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 충북
		if (ti.getBh_area().indexOf("충") == 0 && ti.getBh_area().indexOf("북") == 2) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="gwangju1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 광주
		if (ti.getBh_area().startsWith("광주")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="jeonnam1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 전남
		if (ti.getBh_area().indexOf("전") == 0 && ti.getBh_area().indexOf("남") == 2) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="jeonbuk1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 전북
		if (ti.getBh_area().indexOf("전") == 0 && ti.getBh_area().indexOf("북") == 2) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="busan1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 부산
		if (ti.getBh_area().startsWith("부산")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="gyeongnam1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 경남
		if (ti.getBh_area().indexOf("경") == 0 && ti.getBh_area().indexOf("남") == 2) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="daegu1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 대구
		if (ti.getBh_area().startsWith("대구")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="gyeongbuk1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 경북
		if (ti.getBh_area().indexOf("경") == 0 && ti.getBh_area().indexOf("북") == 2) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
<%
		}
	}
%>
					</ul>
					<ul class="tab-pane scroll-box t-list" id="ulsan1" role="tabpanel">
<%
	for (TerminalInfo ti: terminalList) { // 울산
		if (ti.getBh_area().startsWith("울산")) {
%>
						<li><button type="button" class="tem_nam"><%=ti.getBh_name()%></button></li>
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
</div>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	<button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
</div>