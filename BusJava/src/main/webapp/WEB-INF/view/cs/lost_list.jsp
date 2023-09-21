<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<LostInfo> lostList = (List<LostInfo>) request.getAttribute("lostList");
PageInfo pi = (PageInfo) request.getAttribute("pi");
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">유실물 안내</h2>
			</div>
		</div>
		<form name="frmSch">
			<div class="row mb-2 justify-content-end">
				<div class="col-md">
					<div class="form-group">
						<div class="probootstrap-date-wrap">
							<span class="icon ion-calendar"></span> <input type="text" id="sDate" value="<%=pi.getSdate()%>" name="sDate" class="form-control bg-white" readonly>
						</div>
					</div>
				</div>
				<div class="col-md">
					<div class="form-group">
						<div class="probootstrap-date-wrap">
							<span class="icon ion-calendar"></span> <input type="text" id="eDate" value="<%=pi.getEdate()%>" name="eDate" class="form-control bg-white" readonly>
						</div>
					</div>
				</div>
				<div class="col-md-2">
					<select class="form-control" name="schtype">
						<option value="all">검색조건</option>
						<option value="title" <%if (pi.getSchtype().equals("title")) {%> selected="selected" <%}%>>습득물명</option>
						<option value="tername" <%if (pi.getSchtype().equals("tername")) {%> selected="selected" <%}%>>보관장소</option>
					</select>
				</div>
				<div class="col-md-3">
					<div class="input-group">
						<input type="text" class="form-control" name="keyword" value="<%=pi.getKeyword()%>">
						<button class="btn btn-primary btn-sm click" type="submit" id="schBtn">검색</button>
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
						<col width="25%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead class="bg-light">
						<tr>
							<th class="text-center">No</th>
							<th class="text-left">습득물명</th>
							<th class="text-center">보관장소</th>
							<th class="text-center">유실물상태</th>
							<th class="text-center">습득일자</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (lostList.size() > 0) {
							int num = pi.getNum();
							for (LostInfo li : lostList) {
						%>
						<tr>
							<td><%=num%></td>
							<td class="text-left click" onclick="location.href='lostView?ll_idx=<%=li.getLl_idx() + pi.getArgs()%>';"><%=li.getLl_title()%></td>
							<td><%=li.getLl_tername()%></td>
							<td>보관중</td>
							<td><%=li.getLl_getdate()%></td>
						</tr>
						<%
						num--;
						}
						} else {
						%>
						<tr>
							<td colspan="5">검색 결과가 없습니다.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				<!-- 페이지네이션 영역 -->
				<%
				if (lostList.size() > 0) {
				%>
				<%@ include file="../_inc/pagination.jsp"%>
				<%
				}
				%>
				<!-- 페이지네이션 영역 끝 -->
</section>
<%@ include file="../_inc/foot.jsp"%>
<script>
	$("#sDate").datepicker({
		format : "yyyy.mm.dd",
		autoclose : true,
		startDate : "-1y",
		endDate : "0d",
		language : "kr",
		weekStart : 1,
	}).on("changeDate", function(e) {
		var startDate = new Date(e.date.valueOf());
		$("#eDate").datepicker("setStartDate", startDate);
	});

	$("#eDate").datepicker({
		format : "yyyy.mm.dd",
		autoclose : true,
		startDate : "-1y",
		endDate : "0d",
		language : "kr",
		weekStart : 1,
	}).on("changeDate", function(e) {
		var endDate = new Date(e.date.valueOf());
		$('#sDate').datepicker("setEndDate", endDate);
	});
</script>
