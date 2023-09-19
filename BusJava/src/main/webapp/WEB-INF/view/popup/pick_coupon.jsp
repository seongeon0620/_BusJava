<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setCharacterEncoding("utf-8");
List<UserResourceInfo> couponList = (ArrayList<UserResourceInfo>)request.getAttribute("couponList");
%>
<div class="modal-header">
	<h5 class="modal-title">쿠폰 적용</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">
	<div class="d-flex flex-wrap justify-content-between coupon-wrap">
	<c:choose>
		<c:when test="${ couponList.size() > 0 }">
			<c:forEach items="${couponList}" var="cl" varStatus="status">
				<label for="${cl.getCoupon_id()}">
				<input type="radio" name="coupon" id="${cl.getCoupon_id()}" value="${cl.getCoupon_id()}">
				<div class="coupon mb-3">
					<div class="center">
						<div>
							<h2 class="mb-0">예매 1회 무료</h2>
							<h3 class="mb-0">Coupon</h3>
							<p class="mb-0 couponDateP${cl.getCoupon_id()}">${ cl.getDate()}</p>
						</div>
					</div>
					<div class="right">
						<div>-----</div>
					</div>
				</div>
				</label>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<p class="w-100 text-center text-muted mt-5 mb-5">보유중인 쿠폰이 없습니다.</p>
		</c:otherwise>
	</c:choose>
	</div>
</div>
<div class="modal-footer">
  <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
  <c:choose>
		<c:when test="${ couponList.size() > 0 }">
			<button type="button" id="PopBtnCoupon" class="btn btn-primary">선택</button>
		</c:when>
		<c:otherwise>
			<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
		</c:otherwise>
  </c:choose>
</div>