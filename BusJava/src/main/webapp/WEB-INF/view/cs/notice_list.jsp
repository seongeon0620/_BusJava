<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<NoticeInfo> aNoticeList = (List<NoticeInfo>) request.getAttribute("aNoticeList");
List<NoticeInfo> noticeList = (List<NoticeInfo>) request.getAttribute("noticeList");
PageInfo pi = (PageInfo) request.getAttribute("pi");
String fullUrl = (String) request.getAttribute("fullUrl");
%>
<section class="section">
	<div class="container" id="app">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">공지사항</h2>
			</div>
		</div>
		<form name="frmSch">
			<div class="row mb-3 justify-content-end">
				<div>
					<select class="form-control" name="schtype">
						<option value="title" <%if (pi.getSchtype().equals("title")) {%> selected="selected" <%}%>>제목</option>
						<option value="content" <%if (pi.getSchtype().equals("content")) {%> selected="selected" <%}%>>내용</option>
						<option value="tc" <%if (pi.getSchtype().equals("tc")) {%> selected="selected" <%}%>>제목+내용</option>
					</select>
				</div>
				<div class="col-md-4">
					<div class="input-group">
						<input type="text" class="form-control" name="keyword" value="<%=pi.getKeyword()%>">
						<button class="btn btn-primary btn-sm pl-4 pr-4" type="submit" id="schBtn">검색</button>
					</div>
				</div>
			</div>
		</form>
		<div class="row">
			<div class="col-md-12 text-center">
				<table class="table">
					<colgroup>
						<col width="10%">
						<col width="*">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<thead class="bg-light">
						<tr>
							<th class="text-center">No</th>
							<th class="text-center">제목</th>
							<th class="text-center">작성일</th>
							<th class="text-center">조회수</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (aNoticeList != null && aNoticeList.size() > 0) {
							for (NoticeInfo ani : aNoticeList) {
						%>
						<tr>
							<td class="align-middle">
								<span class="badge rounded-pill bg-primary text-white font-weight-normal">중요</span>
							</td>
							<td class="text-left"><a class="text-dark" href="noticeView?nlidx=<%=ani.getNl_idx() + pi.getArgs()%>"><%=ani.getNl_title()%></a></td>
							<td><%=ani.getNl_date()%></td>
							<td><%=ani.getNl_read()%></td>
						</tr>
						<%
						}
						}
						%>
						<%
						if (noticeList.size() > 0) {
							int num = pi.getNum();
							for (NoticeInfo ni : noticeList) {
						%>
						<tr>
							<td><%=num%></td>
							<td class="text-left"><a class="text-dark" href="noticeView?nlidx=<%=ni.getNl_idx() + pi.getArgs()%>"><%=ni.getNl_title()%></a></td>
							<td><%=ni.getNl_date()%></td>
							<td><%=ni.getNl_read()%></td>
						</tr>
						<%
						num--;
						}
						} else {
						%>
						<tr>
							<td colspan="4">검색 결과가 없습니다.</td>
						</tr>
						<%}%>
					</tbody>
				</table>
			</div>
		</div>
		<!-- 페이지네이션 영역 -->
		<%
		if (noticeList.size() > 0 || aNoticeList != null && aNoticeList.size() > 0) {
		%>
		<%@ include file="../_inc/pagination.jsp"%>
		<%}%>
		<!-- 페이지네이션 영역 끝 -->
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>
<script>
$("#schBtn").click(function(event) {
	var schtype = $("select[name='schtype']").val();
	var keyword = $("input[name='keyword']").val();
	if (schtype == "" && keyword != "") {
		alert("검색조건을 선택하세요.");
		event.preventDefault(); // 이벤트 기본 동작을 막음
	}
});
</script>
