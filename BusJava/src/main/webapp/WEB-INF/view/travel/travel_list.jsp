<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="vo.*"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
JSONArray joItem = (JSONArray) request.getAttribute("joItem");
PageInfo pi = (PageInfo) request.getAttribute("pi");
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">추천 여행지</h2>
				<p>여행지를 고민중이신가요? 버스자바가 도와드릴게요!</p>
			</div>
		</div>
		<div class="row justify-content-end mb-3">
			<form name="frm">
				<div class="d-flex mb-3 ">
					<input type="hidden" id="mainCode" name="mainCode" id="mainCode" value="<%=request.getAttribute("code")%>" />
					<div class="col-md-6">
						<div class="input-group">
							<input type="text" class="form-control bg-white" readonly="readonly" id="mainCtgr" name="mainCtgr" value="<%=request.getAttribute("name")%>" />
							<button type="button" class="btn btn-primary" onclick="openModal();">분류선택</button>
						</div>
					</div>
					<div class="col-md-6 pl-0">
						<div class="input-group">
							<input type="text" class="form-control" placeholder="가고싶은 여행지를 입력하세요." name="keyword" value="${param.keyword }">
							<button class="btn btn-primary">검색</button>
						</div>
					</div>
				</div>
			</form>
		</div>
		<div class="row">
			<%
					if (joItem != null && joItem.size() > 0) {
						for (int i = 0; i < joItem.size(); i++) {
							JSONObject jo = (JSONObject) joItem.get(i);
							String img = jo.get("firstimage").toString();
							System.out.println(img);
					%>
			<div class="col-md-3 mb-4">
				<div class="card h-100" onclick="imgModal('<%=jo.get("contentid")%>');">
					<% if(img.equals("")) { %>
					<div class="card-img noimg embed-responsive embed-responsive-4by3"></div>
					<% } else { %>
					<div class='card-img embed-responsive embed-responsive-4by3' style='background-image: url(<%=img%>)'></div>
					<% } %>
					<div class="card-body">
						<span class="badge badge-primary mb-2 text-white font-weight-normal"><%=jo.get("cat1")%></span>
						<h5 class="card-title"><%=jo.get("title")%></h5>
						<p class="card-text"><%=jo.get("addr1")%>
							<%=jo.get("addr2")%></p>
					</div>
				</div>
			</div>
			<%
					}
					} else {
					out.println("<p>데이터가 없습니다. 검색내용을 확인해주세요.</p>");
					}
					%>
		</div>
		<!-- 페이지네이션 영역 -->
		<nav aria-label="Page navigation example" class="mt-4">
			<ul class="pagination justify-content-center">
				<%
				if (joItem != null && joItem.size() > 0) {
				%>
				<li class="page-item"><c:choose>
						<c:when test="${ pi.getCpage() == 1 }">
							<a class="page-link" href="javascript:void(0);" aria-label="Previous">
						</c:when>
						<c:when test="${ pi.getCpage() > 1 }">
							<a class="page-link" href="travelList?cpage=${pi.getCpage() - 1}${pi.getSchargs()}" aria-label="Previous">
						</c:when>
					</c:choose> <span aria-hidden="true">«</span> <span class="sr-only">Previous</span> </a></li>
				<c:forEach var="i" begin="${pi.getSpage() }" end="${pi.getSpage() + pi.getBsize() - 1 <= pi.getPcnt() ? pi.getSpage() + pi.getBsize() - 1 : pi.getPcnt()}">
					<li class="page-item <c:if test='${pi.getCpage() == i }'>active</c:if>"><a class="page-link" href="travelList?cpage=${i }${pi.getSchargs() }">${i }</a></li>
				</c:forEach>
				<li class="page-item"><c:choose>
						<c:when test="${pi.getCpage() == pi.getPcnt()}">
							<a class="page-link" href="javascript:void(0);" aria-label="Next">
						</c:when>
						<c:when test="${pi.getCpage() <  pi.getPcnt()}">
							<a class="page-link" href="travelList?cpage=${pi.getCpage() + 1 }${pi.getSchargs() }" aria-label="Next">
						</c:when>
					</c:choose> <span aria-hidden="true">»</span> <span class="sr-only">Next</span> </a></li>
				<%
				}
				%>
			</ul>
		</nav>
</section>
<!-- Modal -->
<div class="modal fade" id="ViewModal" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content"></div>
	</div>
</div>

<div class="modal fade" id="ImgModal" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg  modal-dialog-centered" role="document">
		<div class="modal-content"></div>
	</div>
</div>

<script>
	function openModal() {
		$('#ViewModal .modal-content').load("/BusJava/serviceCtgr");
		$('#ViewModal').modal('show');
	}

	function imgModal(id) {
		$('#ImgModal .modal-content').load("/BusJava/detail?id=" + id);
		$('#ImgModal').modal('show');
	}
</script>
<%@ include file="../_inc/foot.jsp"%>