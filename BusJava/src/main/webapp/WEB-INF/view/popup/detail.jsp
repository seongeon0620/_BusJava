<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="org.json.simple.*"%>
<%
request.setCharacterEncoding("utf-8");
JSONArray joArr = (JSONArray) request.getAttribute("joArr");
JSONObject jo = (JSONObject) joArr.get(0);
String bigImg = jo.get("firstimage").toString();
%>
<div class="modal-header">
	<h5 class="modal-title text-center"><%=jo.get("title")%></h5>
</div>
<div class="modal-body">
	<div class="row">
		<div class="col">
			<% if (bigImg.equals("")) { %>
			<div class='card-img noimg embed-responsive embed-responsive-4by3' id="bigImg"></div>
			<% } else { %>
			<div class='card-img embed-responsive embed-responsive-4by3' id="bigImg" style='background-image: url(<%=bigImg%>)'></div>
			<% } %>
			<div class="d-flex">
				<%
				if (!jo.get("tel").equals("")) {
				%>
				<div class="col-3 p-0 card-img">
					<div class='card-img embed-responsive embed-responsive-1by1' style='background-image: url(<%=jo.get("tel")%>)' onclick="swapImg(this);"></div>
				</div>
				<%
					if (!jo.get("telname").equals("")) {
					%>
				<div class="col-3 p-0">
					<div class='card-img embed-responsive embed-responsive-1by1' style='background-image: url(<%=jo.get("telname")%>)' onclick="swapImg(this);"></div>
				</div>
				<%
					}
					%>
				<%
					if (!jo.get("homepage").equals("")) {
					%>
				<div class="col-3 p-0">
					<div class='card-img embed-responsive embed-responsive-1by1' style='background-image: url(<%=jo.get("homepage")%>)' onclick="swapImg(this);"></div>
				</div>
				<%
					}
					%>
				<%
					if (!jo.get("booktour").equals("")) {
					%>
				<div class="col-3 p-0">
					<div class='card-img embed-responsive embed-responsive-1by1' style='background-image: url(<%=jo.get("booktour")%>)' onclick="swapImg(this);"></div>
				</div>
				<%
					}
					%>
				<%
				}
				%>
			</div>
		</div>
		<div class="col">
			<div class="mh-400 overflow-auto">
				<h5><%=jo.get("title")%></h5>
				<%=jo.get("addr1")%><br /> <br />
				<div class="fs-3">
					<%=jo.get("overview")%>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal-footer">
	<button type="button" id="submitBtnP" class="btn btn-primary" onclick="endClick();" data-dismiss="modal">확인</button>
</div>
<script>
	function swapImg(img) {
		var bigImg = document.getElementById("bigImg"); //큰 이미지를 보여주는 img태그를 big이라는 이름의 객체로 받아옴
		console.log(bigImg.style.backgroundImage);
		var tempSrc = bigImg.style.backgroundImage;
		bigImg.style.backgroundImage = img.style.backgroundImage;
		img.style.backgroundImage = tempSrc;
	}
	function endClick() {
		var ctgr = document.getElementById('ctgrTxt').value;
		var code = document.getElementById('code').value;

		document.getElementById('mainCtgr').value = ctgr;
		document.getElementById('mainCode').value = code;
		$('#ViewModal').modal('hide');
	}
</script>