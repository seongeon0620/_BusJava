<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
NoticeInfo ni = (NoticeInfo)request.getAttribute("ni");
String accent = "";
if (ni.getNl_accent().equals("Y")) {
	accent = "<span class='badge rounded-pill bg-primary ml-2 mr-3'>중요</span>";
}
%>
<style>
.click { cursor: pointer; }
</style>
<section class="probootstrap_section">
	<div class="container">
	<form class="probootstrap-form">
		<div class="row mt-10">
		<div class="col-md-12 text-center mb-5">
			<table class="table">
				<colgroup>
	                <col width="15%">
	                <col width="50%">
	                <col width="15%">
	                <col width="*">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="text-center table-primary bg-light">제목</th>
						<td colspan="3" class="text-left"><%=accent %><%=ni.getNl_title() %></td>
					</tr>
					<tr>
						<th scope="row" class="text-center table-primary bg-light">등록일</th>
						<td><%=ni.getNl_date() %></td>
						<th scope="row" class="text-center table-primary bg-light">조회수</th>
						<td><%=ni.getNl_read() %></td>
					</tr>
					<tr>
						<th scope="row" class="text-center table-primary bg-light">내용</th>
						<td colspan="3" class="text-left"><%=ni.getNl_content() %></td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>		
	<div class="d-flex justify-content-center">
		<button type="button" class="btn btn-primary" onclick="location.href='noticeList${args }'">목록</button>
	</div>
	</div>		
</section>
<%@ include file="../_inc/foot.jsp"%>

<script>

</script>
