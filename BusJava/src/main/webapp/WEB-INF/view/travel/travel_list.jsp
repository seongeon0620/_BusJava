<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="vo.*"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
JSONArray joItem = (JSONArray)request.getAttribute("joItem");
PageInfo pi = (PageInfo)request.getAttribute("pi");
%>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">추천 여행지</h2>
				<p>여행지를 고민중이신가요? 버스자바가 도와드릴게요!</p>
			</div>
		</div>
		<div class="row">
			<form name="frm">
				<div class="d-flex mb-3">
					<input type="hidden" id="mainCode" name="mainCode" id="mainCode" value="<%=request.getAttribute("code") %>" />
					<div class="col-md-8 d-flex">
						<input type="text" class="form-control bg-white" readonly="readonly" id="mainCtgr" name="mainCtgr" value="<%=request.getAttribute("name") %>" />
						<button type="button" class="btn btn-primary" onclick="openModal();">서비스 분류선택</button>
					</div>
					<div class="col-md-10 d-flex p-0">
						<input type="text" class="form-control" placeholder="가고싶은 여행지를 입력하세요." name="keyword" value="${param.keyword }">
						<button class="btn btn-primary">검색</button>
					</div>
				</div>
			</form>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="card-deck custom">
					<%
if (joItem != null && joItem.size() > 0) {
	for (int i = 0 ; i < joItem.size() ; i++) {
		JSONObject jo = (JSONObject)joItem.get(i);
		String img = jo.get("firstimage").toString();
%>
					<div class="card h-100" onclick="imgModal('<%=jo.get("contentid") %>');">
						<img src="<% if(img.equals("")) { %>${pageContext.request.contextPath}/resources/images/travel/noimg.png
					 <% } else out.print(img); %>" class="card-img-top" alt="..." />
						<div class="card-body">
							<span class="badge badge-primary mb-2 text-white font-weight-normal"><%=jo.get("cat1") %></span>
							<h5 class="card-title"><%=jo.get("addr1") %>
								<%=jo.get("addr2") %></h5>
							<p class="card-text"><%=jo.get("title") %></p>
						</div>
					</div>
					<%	
	}
} else {
	out.println("<p>데이터가 없습니다. 검색내용을 확인해주세요.</p>");
}
%>
				</div>
			</div>
		</div>
		<!-- 페이지네이션 영역 -->
		<nav aria-label="Page navigation example" class="mt-4">
			<ul class="pagination justify-content-center">
				<% if (joItem != null && joItem.size() > 0) { %>
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
				<% } %>
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
	$('#ImgModal .modal-content').load("/BusJava/detaile?id=" + id);
	$('#ImgModal').modal('show');
}
</script>
<%@ include file="../_inc/foot.jsp"%>