<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="org.json.simple.*"%>
<%
request.setCharacterEncoding("utf-8");
JSONArray joItem = (JSONArray) request.getAttribute("joItem");
PageInfo pi = (PageInfo) request.getAttribute("pi");
%>
<div class="modal-header">
	<h5 class="modal-title" id="modalLabel">분류 선택</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">
	<form name="frm">
		<input type="hidden" name="code" id="code" value="" />
		<input type="hidden" id="ctgrTxt" disabled />
		<div class="container mh-400">
			<div class="row">
				<div class="col text-center nav flex-column nav-pills">
					<p class="text-gray">대분류</p>
					<%
					if (joItem.size() > 0) {
						for (int i = 0; i < joItem.size(); i++) {
							JSONObject jo = (JSONObject) joItem.get(i);
					%>
					<button type="button" class="over nav-link" value="<%=jo.get("code")%>" onclick="getCtgr('<%=jo.get("code")%>', 'big', '<%=jo.get("name")%>');"><%=jo.get("name")%></button>
					<%
					}
					}
					%>
				</div>
				<div class="col-4 text-center pl-0">
					<p class="text-gray">중분류</p>
					<div class="col-12 text-center nav flex-column nav-pills p-0" id="middle"></div>
				</div>
				<div class="col-4 text-center p-0">
					<p class="text-gray">소분류</p>
					<div class="col-12 text-center nav flex-column nav-pills p-0" id="small"></div>
				</div>
			</div>
		</div>
	</form>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	<button type="button" id="submitBtnP" class="btn btn-primary" onclick="endClick();" data-dismiss="modal">확인</button>
</div>
<script>
	$(document).on("click", ".over", function() {
		$(this).toggleClass("active");
		$(this).siblings(".over").removeClass("active");
	});

	function getCtgr(code, kind, name) {
		$
				.ajax({
					type : "POST",
					url : "./getCtgr",
					data : {
						code : code
					},
					dataType : "json",
					success : function(data) {
						if (data.length > 0) {
							let btnHTML = "";
							data
									.forEach(function(list) {
										if (kind == "big") {
											btnHTML += '<button type="button" class="over nav-link" onclick="getCtgr(\''
													+ list.code
													+ '\', \'middle\', \''
													+ list.name
													+ '\');" value="'
													+ list.code
													+ '" >'
													+ list.name + '</button>';
										} else {
											btnHTML += '<button type="button" class="over nav-link" value="'
													+ list.code
													+ '" onclick="changeTxt(\''
													+ list.name
													+ '\', \''
													+ list.code
													+ '\');">'
													+ list.name + '</button>';
										}
									});

							if (kind == "big") {
								$("#middle").html(btnHTML);
							} else {
								$("#small").html(btnHTML);
							}
						} else {
							alert("조회된 카테고리가 없습니다.");
						}
						$("#ctgrTxt").val(name);
						$("#code").val(code);
					},
					error : function(xhr, status, error) {
						console.error("AJAX Error:", error);
						// 오류 처리 로직을 추가할 수도 있음
					}
				});
	}

	function changeTxt(txt, code) {
		$("#ctgrTxt").val(txt)
		$("#code").val(code);
	}

	//확인 버튼을 눌렀을 때 실행되는 함수
	function endClick() {
		var ctgr = document.getElementById('ctgrTxt').value;
		var code = document.getElementById('code').value;

		document.getElementById('mainCtgr').value = ctgr;
		document.getElementById('mainCode').value = code;
		$('#ViewModal').modal('hide');
	}
</script>