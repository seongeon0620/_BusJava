<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
List<TicketInfo> ticketList = (List<TicketInfo>) request.getAttribute("ticketList");
List startList = (List<String>) request.getAttribute("startList");
List endList = (List<String>) request.getAttribute("endList");
PageInfo pi = (PageInfo)request.getAttribute("pi");
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">예매 관리</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="Admin_BusJava" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item active" aria-current="page">예매 목록</li>
		        </ol>
			    </nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<form name="frmSch">
				            <table class="table table-sm custom">
				                <colgroup>
				                    <col width="20%">
				                    <col width="20%">
				                    <col width="15%">
				                    <col width="*">
				                </colgroup>
				                <tbody>
				                    <tr>
				                        <th scope="row" class="text-center bg-gray align-middle">버스구분</th>
				                        <td class="text-left" colspan="3">
				                            <div class="d-flex">
				                                <select class="form-control w-auto" name="linetype">
				                                	<option value="">전체</option>
				                                	<option <% if (pi.getKeyword().equals("고속")) { %>selected="selected"<% } %>>고속</option>
				                                	<option <% if (pi.getKeyword().equals("시외")) { %>selected="selected"<% } %>>시외</option>
				                                </select>
				                            </div>
				                        </td> 
				                    </tr>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">노선</th>
										<td class="text-left" colspan="3">
											<div class="d-flex">
												<div class="col-lg-2 pl-0">
					                                <div class="form-group mb-0">
				                                	<select class="form-control w-100" name="start" onchange="getEnd(this.value);">
				                                	<option value="">전체</option>
<% for (int i = 0; i < startList.size(); i++) { %>
<option <% if (pi.getStart().equals(startList.get(i))) { %>selected="selected"<% } %>><%=startList.get(i) %></option>
<% } %>
					                                </select>
					                                </div>
					                            </div>
				                            	<span style="line-height: 2.2;"> ~ </span>
				                            	<div class="col-lg-2">
					                                <div class="form-group mb-0">
					                                	<select class="form-control w-100" name="end" id="end">
					                                		<option value="">전체</option>
<% for (int i = 0; i < endList.size(); i++) { %>
<option <% if (pi.getEnd().equals(endList.get(i))) { %>selected="selected"<% } %>><%=endList.get(i) %></option>
<% } %>
					                                	</select>
					                                </div>
					                            </div>
											</div>
										</td>
									</tr>    
				                    <tr>
				                        <th scope="row" class="text-center bg-gray align-middle">출발일자</th>
				                        <td class="text-left">
				                            <div class="d-flex">
				                            	<div class="form-group mb-0 custom-input-icon">
				                                	<span><i class="icon-calender"></i></span>
				                                	<input type="text" id="Date" class="form-control" value="<%=pi.getDate() %>" readonly name="date">
				                                </div>
				                            </div>
				                        </td>
				                        <th scope="row" class="text-center bg-gray align-middle">상태</th>
				                        <td>
				                        <div class="form-group mb-0">
		                                	<select class="form-control w-auto" name="status">
			                                	<option value="">전체</option>
			                                	<option <% if (pi.getIsview().equals("예매")) { %>selected="selected"<% } %>>예매</option>
			                                	<option <% if (pi.getIsview().equals("예매취소")) { %>selected="selected"<% } %>>예매취소</option>
			                                	<option <% if (pi.getIsview().equals("사용완료")) { %>selected="selected"<% } %>>사용완료</option>
			                                </select>
		                                </div>
				                        </td>
				                    </tr>
				                </tbody>
				            </table>
				            <div class="d-flex justify-content-center">
				            	<button type="button" class="btn waves-effect waves-light btn-light mb-2" onclick="location.href='ticketList'">필터 초기화</button>
				            	<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2 ml-2">검색
				            	<i class="icon-magnifier"></i></button>
				            </div>
						</form>
						<form name="frm">
							<table id="table" class="table text-center table-sm mt-3 mb-0 table-hover">
			                <colgroup>
			                    <col width="*">
								<col width="7%">
								<col width="15%">
								<col width="15%">
								<col width="18%">
								<col width="10%">
								<col width="18%">
			                </colgroup>
			                <thead class="bg-primary text-white">
			                <tr>
			                    <th>예매번호</th>
			                    <th>버스구분</th>
			                    <th>출발지</th>
			                    <th>도착지</th>
			                    <th>출발일시</th>
			                    <th>상태</th>
			                    <th>예매일시</th>
			                </tr>
			            	</thead>
<% if (ticketList.size() > 0) {
	for (TicketInfo ti : ticketList) {
%>
								
				                <tbody class="border tr" onclick="location.href='ticketView?idx=<%=ti.getRi_idx() %>'">
				                	<td><%=ti.getRi_idx() %></td>
				                	<td><%=ti.getRi_line_type() %></td>
				                	<td><%=ti.getRi_fr() %></td>
				                	<td><%=ti.getRi_to() %></td>
				                	<td><%=ti.getRi_frdate() %></td>
				                	<td><%=ti.getRi_status() %></td>
				                	<td><%=ti.getRi_date() %></td>
				           		</tbody>
<%	}
} else { %>
								<tbody class="border border-primary">
					                <tr >
					                    <td colspan="9">검색결과가 없습니다.</td>
					                </tr>
					           	</tbody>
					         <% } %>
							</table>
<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->
<% if (ticketList.size() > 0) { %>
<%@ include file="../_inc/pagination.jsp" %>
<% } %> 
<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->   
        				</form>
        			</div> 
				</div>
    		</div>
		</div>
	</div>
</div>
<script>
$(document).ready(function() {
	$("#Date").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "-1y",
		
		endDate: "+1y",
		language: "kr",
		showMonthAfterYear: true,
		weekStart: 1,
	})
});

function getEnd(start) {
	$.ajax({
        type: "POST",
        url: "./getEnd",
        data: { start : start },
        success: function(data) {
        	let endHTML = '<option value="">전체</option>';
        	let end = "<%=pi.getEnd() %>";
        	for (var i = 0; i < data.length; i++) {
        		let tmp = "";
        		if (end == data[i]) {
        			tmp = 'selected="selected"';
        		}
        		endHTML += '<option ' + tmp + '>' + data[i] + '</option>';
        	}
        	$("#end").html(endHTML);
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
            // 오류 처리 로직을 추가할 수도 있음
        }
    });
}
</script>
<%@ include file="../_inc/foot.jsp" %>