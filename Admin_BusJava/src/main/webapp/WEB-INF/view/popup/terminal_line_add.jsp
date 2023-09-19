<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
request.setCharacterEncoding("utf-8");
String bt_name = request.getParameter("bt_name");
List<TerminalInfo> terminalList = (List<TerminalInfo>)request.getAttribute("terminalList");
String kind = request.getParameter("kind");
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<title>BUSJAVA</title>
		<meta name="description" content="Free Bootstrap 4 Theme by ProBootstrap.com">
		<meta name="keywords" content="free website templates, free bootstrap themes, free template, free bootstrap, free website template">

		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/select2.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/helpers.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">


	</head>
<script>
function areaChange() {
	var inputStateValue = document.getElementById('area').value;
	var terminalOptions = document.getElementById('terminal').options;
	
	for (var i = 0; i < terminalOptions.length; i++) {
		var option = terminalOptions[i];
		var option2 = option.value;
		var arrOption = option2.split(":");
	    if (inputStateValue == '' || arrOption[0] == inputStateValue) {
	    	option.style.display = 'block';
	    } else {
	    	option.style.display = 'none';
		}
		
	}
}

function adultGyesan(sale) {
	var adult = document.getElementById("adult");
	var teenager = document.getElementById("teenager");
	var children = document.getElementById("children");
	var numericSale = parseInt(sale.replace(/,/g, ''), 10); // 쉼표 제거 후 정수로 변환
	
	// 쉼표(,)를 모두 제거한 숫자 문자열을 생성
	var numericSale = parseInt(sale.replace(/,/g, ''), 10);
	
	if (!isNaN(numericSale)) { // 숫자가 아닌 경우(NaN)를 체크
	  adult.value = numericSale.toLocaleString('ko-KR');
	  teenager.value = Math.floor(numericSale * 0.8).toLocaleString('ko-KR');
	  children.value = Math.floor(numericSale * 0.5).toLocaleString('ko-KR');
	} else {
	  adult.value = '';
	  teenager.value = '';
	  children.value = '';
	}
}

function restrictAdult(input) {
	input.value = input.value.replace(/[^0-9]/g, '');
}
</script>
	<body>
    <div class="modal-header">
      <h5 class="modal-title" id="exampleModalLabel">노선 등록</h5>
      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <form name="frm" action="AddLine" method="post">
    <div class="modal-body">
    <input type="hidden" name="kind" value="<%=kind %>"/>
    <input type="hidden" name="bt_sidx" value="<%=request.getParameter("bt_idx") %>"/>
    <input type="hidden" name="bt_name" value="<%=bt_name %>"/>
      <table class="table text-center">
        <colgroup>
          <col width="25%">
          <col width="*">
        </colgroup>
        <tbody>
          <tr>
            <th>출발지</th>
            <td class="text-left"><%=bt_name %></td>
          </tr>
          <tr>
            <th>도착지</th>
            <td class="text-left">
            <div class="form-group pl-0">
                <select id="area" class="form-control select-size mr-5" onchange="areaChange();">
                  <option value="">지역</option>
                  <option>서울</option>
                  <option>경기도</option>
                  <option>강원도</option>
                  <option>경상북도</option>
                  <option>경상남도</option>
                </select>
                <select id="terminal" name="bt_eidx" class="form-control select-size">
                  <option value="">터미널</option>
<% for (TerminalInfo ti : terminalList ) { %>
                  <option value="<%= ti.getBt_area() %>:<%=ti.getBt_idx() %>"><%=ti.getBt_name() %></option>
<% } %>
                </select>
            </div>
            </td>
          </tr>
          <tr>
            <th>성인 요금</th>
            <td>
              <input type="text" class="form-control" name="adult" id="adult" oninput="restrictAdult(this)" 
              onkeyup="adultGyesan(this.value);" required>
            </td>
          </tr>
          <tr>
            <th>청소년 요금</th>
            <td>
              <input type="text" class="form-control" id="teenager" value="" readonly>
            </td>
          </tr>
          <tr>
            <th>아동 요금</th>
            <td>
              <input type="text" class="form-control" id="children" readonly>
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
	</body>
</html>