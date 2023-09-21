<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<NoticeInfo> aNoticeList = (List<NoticeInfo>) request.getAttribute("aNoticeList");
List<NoticeInfo> noticeList = (List<NoticeInfo>) request.getAttribute("noticeList");
PageInfo pi = (PageInfo) request.getAttribute("pi");
String fullUrl = (String) request.getAttribute("fullUrl");
%>
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
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
			<div class="col-md-12 text-center mb-5">
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
						<!-- 				<div v-for="(item, index) in arrANotiList" v-bind:key="item.nlidx">
					<a-noti-list v-bind:object="item"></a-noti-list>
				</div> -->
						<%
						if (aNoticeList != null && aNoticeList.size() > 0) {
							for (NoticeInfo ani : aNoticeList) {
						%>
						<tr>
							<td>
								<span class="badge rounded-pill bg-primary">중요</span>
							</td>
							<td class="text-left click" onclick="location.href='noticeView?nlidx=<%=ani.getNl_idx() + pi.getArgs()%>';"><%=ani.getNl_title()%></td>
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
							<td class="text-left click" onclick="location.href='noticeView?nlidx=<%=ni.getNl_idx() + pi.getArgs()%>';"><%=ni.getNl_title()%></td>
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
		</ul>
		</nav>
		<!-- 페이지네이션 영역 끝 -->
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>

<script>
<%-- var aNotiList = {
	props: ["object"], 
	template: `
		<tr>
			<td><span class="badge rounded-pill bg-primary">중요</span></td>
			<td class="text-left click" v-on:click="location.href='noticeView?nlidx={{object.nlidx}}<%=pi.getArgs()%>';">{{object.nltitle}}</td>
			<td>{{object.nldate}}</td>
			<td>{{object.nlread}}</td>
		</tr>	
	`
}

new Vue({
	el: "#app", 
	data: {
		aNotiList: [
<%if (aNoticeList != null && aNoticeList.size() > 0) {
	for (int i = 0 ; i < aNoticeList.size() ;  i++) {
		NoticeInfo ani = new NoticeInfo();
		ani = aNoticeList.get(i); %>
		{
			nlidx: <%=ani.getNl_idx() %>, no:<%=pi.getNum() %>, 
			nltitle:"<%=ani.getNl_title() %>", nldate:"<%=ani.getNl_date() %>", nlread:<%=ani.getNl_read() %>
		}<%if (i < aNoticeList.size() - 1) {%>,<%} %>
<%	}
}%>			
		]
	}, 
	components: {
		"a-noti-list":ANotiList
	}
}); --%>

$("#schBtn").click(function(event) {
	var schtype = $("select[name='schtype']").val();
	var keyword = $("input[name='keyword']").val();
	if (schtype == "" && keyword != "") {
		alert("검색조건을 선택하세요.");
		event.preventDefault(); // 이벤트 기본 동작을 막음
	}
});
</script>
