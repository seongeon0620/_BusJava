<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="org.json.simple.*" %>
<%@ include file="../_inc/pop_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
JSONArray joArr = (JSONArray)request.getAttribute("joArr");
JSONObject jo = (JSONObject)joArr.get(0);
String bigImg = jo.get("firstimage").toString();
%>
<div class="modal-header">
	<h5 class="modal-title text-center" id="exampleModalLabel"><%=jo.get("title") %></h5>
	<input type="text" id="ctgrTxt" class="text-right" style="border:0;" readonly="readonly" value="" />
</div>
<div class="modal-body">
	<table class="table">
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>
	<tr>
	<td><img src="<% if(bigImg.equals("")) { %>${pageContext.request.contextPath}/resources/images/travel/noimg.png
					 <% } else out.print(bigImg); %>" id="bigImg" style="width:400px; height:400px" /></td>
	<td class="border-0" rowspan="2">
	<div class="scroll-box border-0 p-0" style="height:<% if (!jo.get("tel").equals("")) { %>500px;<% } else { %>400px;<% } %>">
		<h5><%=jo.get("title") %></h5>
		<%=jo.get("addr1") %><br /><br />
		<div class="fs-3">
			<%=jo.get("overview") %>
		</div>
	</div>
	</td>
	</tr>
	<% if (!jo.get("tel").equals("")) { %>
		<tr>
		<td class="p-0">
			<img src="<%=jo.get("tel") %>" style="width:100px; height:100px;" onclick="swapImg(this);" />
		<% if (!jo.get("telname").equals("")) { %>
			<img src="<%=jo.get("telname") %>" style="width:100px; height:100px;" onclick="swapImg(this);" />
		<% } %>
		<% if (!jo.get("homepage").equals("")) { %>
			<img src="<%=jo.get("homepage") %>" style="width:100px; height:100px;" onclick="swapImg(this);" />
		<% } %>
		<% if (!jo.get("booktour").equals("")) { %>
			<img src="<%=jo.get("booktour") %>" style="width:100px; height:100px;" onclick="swapImg(this);" />
		<% } %>
		</td>
		<td>
		</td>
		</tr>
	<% } %>
	</table>
</div>
<div class="modal-footer">
  <button type="button" id="submitBtnP" class="btn btn-primary" onclick="endClick();" data-dismiss="modal" >확인</button>
</div>
<script>
function swapImg(img){
	var bigImg = document.getElementById("bigImg"); //큰 이미지를 보여주는 img태그를 big이라는 이름의 객체로 받아옴
	var tempSrc = bigImg.src;
	bigImg.src = img.src;
	img.src = tempSrc;
}
function endClick() {
	var ctgr = document.getElementById('ctgrTxt').value;
	var code = document.getElementById('code').value;
	
	document.getElementById('mainCtgr').value = ctgr;
	document.getElementById('mainCode').value = code;
	$('#ViewModal').modal('hide');
}
</script>