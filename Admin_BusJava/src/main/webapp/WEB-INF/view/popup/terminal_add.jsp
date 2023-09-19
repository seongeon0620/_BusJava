<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
request.setCharacterEncoding("utf-8");
String area = request.getParameter("area");
String kind = request.getParameter("kind");
%>
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon.png">
    <title>BUSJAVA ADMIN</title>
    <link href="${pageContext.request.contextPath}/resources/css/style.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/common.css" rel="stylesheet">
</head>
<script>
function chkTerminal(name) {
	var kind = "<%=kind%>";
	if (name.length >= 2) {
		$.ajax({
			type : "POST", url : "./chkTerminal", data : {"name" : name, "kind" : kind},
			success : function(chkRs){
				var msg = "";
				if (chkRs == 0) {
					msg = "<div class='valid-feedback text-left'>등록가능한 터미널입니다.</div>";
					$("#chkName").val("y");
					$("#bt_name").removeClass("is-invalid").addClass("is-valid");
				} else {
					msg = "<div class='valid-feedback text-left' style='color: red;'>이미 등록된 터미널입니다.</div>";
					$("#chkName").val("n");
					$("#bt_name").removeClass("is-valid").addClass("is-invalid");
				}
				$("#msg").html(msg); // .html : ()안의 태그를 바꿔라
			}
		});
		$("#chkName").val("y");
	} else {
		$("#msg").text("터미널명은 2자이상 입력해주세요."); // .text :()안의 내용을 바꿔라
		$("#chkName").val("n"); //기본적으로 val값이 "n"이지만  4자 이상 입력했다가 지웠을 경우를 대비해서 넣어줌
		$("#bt_name").removeClass("is-valid");
	}
}
</script>
<body>
<div class="modal-header">
<h5 class="modal-title" id="exampleModalLabel">터미널 등록</h5>
<button type="button" class="close" data-dismiss="modal" aria-label="Close">
	<span aria-hidden="true">&times;</span>
</button>
</div>
<form name="frm" action="terminalIn" method="post">
<input type="hidden" name="kind" id="kind" value="<%=kind %>" />
<input type="hidden" name="chkName" id="chkName" value="n" />
<input type="hidden" name="area" id="area" value="<%=area %>" />
<div class="modal-body">
<table class="table text-center">
	<colgroup>
		<col width="25%">
		<col width="*">
	</colgroup>
	<tbody>
	<tr>
		<th>지역</th>
		<td class="text-left"><%=area %></td>
	</tr>
	<tr>
		<th>터미널명</th>
		<td>
		<!-- form-control class가 is-valid => 성공, in-invalid => 실패 (테두리 색변화) -->
		<input type="text" class="form-control" id="bt_name" name="bt_name" required onkeyup="chkTerminal(this.value)">
		<div class="text-left" name="msg" id="msg"  >터미널명은 2자이상 입력해주세요.</div>
		</td>
	</tr>
	</tbody>
</table>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
<button type="submit" class="btn btn-primary">확인</button>
</div>
</form>
<%@ include file="../_inc/foot.jsp" %>