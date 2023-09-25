<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
LostInfo li = (LostInfo) request.getAttribute("li");
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">유실물 안내</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 text-center mb-5">
				<table class="table">
					<colgroup>
						<col width="*%">
						<col width="20%">
						<col width="30%">
					</colgroup>
					<tbody>
						<tr>
							<td rowspan="5" class="pt-0 border-top-0">
								<img src="${pageContext.request.contextPath}/resources/images/lost/<%=li.getLl_img() %>" style="width: 400px; height: 400px; object-fit: cover;" />
							</td>
							<th scope="row" class="text-left table-primary bg-light ">습득일</th>
							<td class="text-left"><%=li.getLl_getdate()%></td>
						</tr>
						<tr>
							<th scope="row" class="text-left table-primary bg-light">습득장소</th>
							<td class="text-left"><%=li.getLl_title()%></td>
						</tr>
						<tr>
							<th scope="row" class="text-left table-primary bg-light">보관장소</th>
							<td class="text-left"><%=li.getLl_tername()%></td>
						</tr>
						<tr>
							<th scope="row" class="text-left table-primary bg-light">유실물상태</th>
							<td class="text-left">보관중</td>
						</tr>
						<tr>
							<td colspan="2" rowspan="2" class="text-left"><%=li.getLl_content()%></td>
						</tr>
						<tr>

						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="d-flex justify-content-center">
			<button type="button" class="btn btn-primary" onclick="location.href='lostList${args }'">목록</button>
		</div>
	</div>
</section>
<%@ include file="../_inc/foot.jsp"%>
