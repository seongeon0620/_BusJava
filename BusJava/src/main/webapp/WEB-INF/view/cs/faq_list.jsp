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

<!--   <section class="probootstrap_section pb-4">
    <div class="overlay"></div>
    <div class="container">
      <div class="row align-items-center justify-content-center">
        <div class="col-md-8 probootstrap-animate">
          <h2 class="border-bottom mb-5 text-center probootstrap-section-heading">자주하는 질문</h2>
        </div>
      </div>
    </div>
  </section> -->

  <section class="probootstrap_section">
    <div class="container">
    	<div class="row text-center mb-5 probootstrap-animate fadeInUp probootstrap-animated">
			<div class="col-md-12">
				<h2 class="border-bottom probootstrap-section-heading">자주하는 질문</h2>
			</div>
		</div>
      <div class="row align-items-center justify-content-center">
      <form id="schfrm" action="schFaqList" method="post">
        <select id="schtype" name="schtype" class="custom-select select-size mr-12"  onchange="qaChange();">
          <option selected="selected" value="">전체</option>
          <option value="예매" <c:if test="${pi.getSchtype() == '예매' }"> selected="selected"</c:if> >예매</option>
          <option value="회원" <c:if test="${pi.getSchtype() == '회원' }"> selected="selected"</c:if> >회원</option>
          <option value="결제" <c:if test="${pi.getSchtype() == '결제' }"> selected="selected"</c:if> >결제</option>
          <option value="조회/변경/취소" <c:if test="${pi.getSchtype() == '조회/변경/취소' }"> selected="selected"</c:if> >조회/변경/취소</option>
          <option value="고속/시외버스 운행" <c:if test="${pi.getSchtype() == '고속/시외버스 운행' }"> selected="selected"</c:if> >고속/시외버스 운행</option>
          <option value="기타" <c:if test="${pi.getSchtype() == '기타' }"> selected="selected"</c:if> >기타</option>
        </select>
        </form>
      </div>
    </div>

<c:if test="${faqList.size() > 0 }">
<c:forEach items="${faqList }" var="fl" varStatus="status">
	<div class="accordion col-md-6 m-auto" id="accordionExample">
	  <div class="card">
	    <div class="card-header" id="headingTwo">
	        <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#${fl.getFl_idx() }" aria-expanded="false" aria-controls="collapseTwo">
	         ${fl.getFl_title() }
	        <img class="arrow-bottom" style="display: none; width:15px; height:15px;" alt="" align="right" src="${pageContext.request.contextPath}/resources/images/up_arrow.png" >
	        <img class="arrow-top" alt="" align="right" src="${pageContext.request.contextPath}/resources/images/down_arrow.png" style="width:15px; height:15px;" >
	        </button>
	    </div>
	    <div id="${fl.getFl_idx() }" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
	      <div class="card-body">
	      	${fl.getFl_content().replace(".", "<br/>")}
	        <!-- 예매 가능일자와 관련하여 따로 정해진 기간은 없으며, 배차 정보가 입력되어 있는 경우에 조회/예매가 가능합니다.<br/>
			배차정보는 각 출발지 터미널에서 입력합니다. 다음달 배차정보는 전월 20일경에 입력하고 있으나, 출발지 터미널에 따라 기간이 달라질 수 있습니다.<br/>
			명절의 경우 접속과다로 인한 부하를 방지하기 위하여 특송기간 전용 홈페이지로 전환하여 운영하지만 예매 기간은 동일하게 적용됩니다.<br/>
			배차정보에 관한 더 자세한 사항은 출발지 터미널에 문의해주시기 바랍니다.<br/> -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>
</c:if>
<c:if test="${faqList.size() == 0 }"> 
	<div class="card-body" style="text-align:center;">
	검색된 내용이 없습니다.      
	</div>
</c:if>

</section>
<%@ include file="../_inc/foot.jsp"%>