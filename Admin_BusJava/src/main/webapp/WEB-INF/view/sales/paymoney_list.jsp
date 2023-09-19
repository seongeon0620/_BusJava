<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%@ page import="java.util.Calendar, java.text.SimpleDateFormat" %>
<%
request.setCharacterEncoding("utf-8");
List<PaymoneyInfo> paymoneyList = (List<PaymoneyInfo>)request.getAttribute("paymoneyList");
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">매출 현황</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item text-muted active" aria-current="page">페이머니 매출</li>
		        </ol>
		    </nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
		    <div class="col-lg-12">
		        <div class="card">
					<div class="card-body">
<c:if test="${paymoneyList.size() > 0 }">
	<c:forEach items="${paymoneyList}" var="pl" varStatus="status">
	<c:set var="allCount" value="${allCount + pl.getCard_salse() + pl.getBank_salse() + pl.getMobile_salse()}" />
	</c:forEach>
</c:if>
		        	<h4 class="card-title">총 매출 금액 : <span id=""><fmt:formatNumber value="${allCount }" type="number" groupingUsed="true" /> </span></h4>
				    <form name="frm">
	        			<input type="hidden" name="chk" value="" />
	            		<table id="table" class="table text-center padding-size-sm mt-3 mb-0">
			                <colgroup>
			                    <col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
			                </colgroup>
	                		<thead class="bg-primary text-white">
				                <tr>
				                    <th>카드</th>
				                    <th>무통장입금</th>
				                    <th>간편결제</th>
				                    <th>총매출금액</th>
				                    <th>기간</th>
				                </tr>
	            			</thead>  
			            	<c:if test="${paymoneyList.size() > 0 }">
								<c:forEach items="${paymoneyList}" var="pl" varStatus="status">
<c:set var="year" value="${pl.getPh_date().substring(0, 4) }" />
<c:set var="month" value="${pl.getPh_date().substring(6) }" /> <!-- 9월을 예제로 사용하며, 필요한 월을 지정하십시오 -->
<%
Calendar cal = Calendar.getInstance();
cal.set(Calendar.YEAR, Integer.parseInt((pageContext.getAttribute("year")).toString()));
cal.set(Calendar.MONTH, Integer.parseInt((pageContext.getAttribute("month")).toString()) - 1);
cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
String lastDayOfMonth = sdf.format(cal.getTime());
%>
								
					                <tbody class="border border-primary">
					                <tr class="tr">
					                    <td><fmt:formatNumber value="${pl.getCard_salse() }" type="number" groupingUsed="true" /></td>
					                    <td><fmt:formatNumber value="${pl.getBank_salse() }" type="number" groupingUsed="true" /></td>
					                    <td><fmt:formatNumber value="${pl.getMobile_salse() }" type="number" groupingUsed="true" /></td>
					                    <td><fmt:formatNumber value="${pl.getCard_salse() + pl.getBank_salse() + pl.getMobile_salse() }" type="number" groupingUsed="true" /></td>
					                    <td>${pl.getPh_date() }-01 ~ <%=lastDayOfMonth %></td>
					                </tr>
					           		</tbody>
					           	</c:forEach>
							</c:if>
			           		<c:if test="${paymoneyList.size() == 0 }">
								<tbody class="border border-primary">
					                <tr>
					                    <td colspan="5">매출내역이 없습니다.</td>
					                </tr>
					           	</tbody>
							</c:if>
	            		</table>
	        		</form>   
			        </div>
		        </div>
		    </div>
		</div>
	</div>
</div>
<c:set var="allCount" value="0" />
<%@ include file="../_inc/foot.jsp" %>