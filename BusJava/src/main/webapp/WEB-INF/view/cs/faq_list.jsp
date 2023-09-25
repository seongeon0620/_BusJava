<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>
<script>
	$(document).ready(function() {
		$(".btn-link").click(function() {
			$(this).find(".arrow-top").toggle(".arrow-bottom");
		});

		$(".btn-link").click(function() {
			$(this).find(".arrow-bottom").toggle(".arrow-top");
		});
	});

	function qaChange() {
		document.getElementById('schfrm').submit();
	}
</script>
<section class="section">
	<div class="container">
		<div class="row text-center mb-3">
			<div class="col-md-12">
				<h2 class="border-bottom heading">자주하는 질문</h2>
			</div>
		</div>
		<div class="row align-items-center justify-content-center">
			<form id="schfrm" action="schFaqList" method="post">
				<select id="schtype" name="schtype" class="form-control mr-12" onchange="qaChange();">
					<option selected="selected" value="">전체</option>
					<option value="예매" <c:if test="${pi.getSchtype() == '예매' }"> selected="selected"</c:if>>예매</option>
					<option value="회원" <c:if test="${pi.getSchtype() == '회원' }"> selected="selected"</c:if>>회원</option>
					<option value="결제" <c:if test="${pi.getSchtype() == '결제' }"> selected="selected"</c:if>>결제</option>
					<option value="조회/변경/취소" <c:if test="${pi.getSchtype() == '조회/변경/취소' }"> selected="selected"</c:if>>조회/변경/취소</option>
					<option value="고속/시외버스 운행" <c:if test="${pi.getSchtype() == '고속/시외버스 운행' }"> selected="selected"</c:if>>고속/시외버스 운행</option>
					<option value="기타" <c:if test="${pi.getSchtype() == '기타' }"> selected="selected"</c:if>>기타</option>
				</select>
			</form>
		</div>
		<div class="row mt-3">
			<c:if test="${faqList.size() > 0 }">
				<c:forEach items="${faqList }" var="fl" varStatus="status">
					<div class="accordion col-md-8 m-auto">
						<div class="card">
							<div class="card-header p-1" id="headingTwo">
								<button class="faq btn btn-link btn-block text-left collapsed text-dark shadow-none text-decoration-none" type="button" data-toggle="collapse" data-target="#${fl.getFl_idx() }" aria-expanded="false" aria-controls="collapseTwo">
									${fl.getFl_title() }
								</button>
							</div>
							<div id="${fl.getFl_idx() }" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
								<div class="card-body">${fl.getFl_content().replace(".", "<br/>")}</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:if>
			<c:if test="${faqList.size() == 0 }">
				<div class="card-body" style="text-align: center;">검색된 내용이 없습니다.</div>
			</c:if>
		</div>
	</div>


</section>
<%@ include file="../_inc/foot.jsp"%>