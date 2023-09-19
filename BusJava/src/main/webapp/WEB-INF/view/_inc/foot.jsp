<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<footer>
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-center">
            <p class="probootstrap_font-15 mb-0">© 2023 <span class="text-primary">BUSJAVA</span>. All Rights Reserved.</p>
          </div>
        </div>
      </div>
    </footer>
	<button class="chat-wrap" onclick="openPopup()">
	    <img src="${pageContext.request.contextPath}/resources/images/ico-kakao.svg" alt="Kakao Chat Icon" />
	</button>
	<script>
	    function openPopup() {
	        window.open('http://pf.kakao.com/_xmhzxdG/chat', 'kakaoChat', 'width=600,height=800,resizable=yes,scrollbars=yes,status=yes');
	    }
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/popper.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/jquery.waypoints.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/jquery.easing.1.3.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/select2.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap-datepicker.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap-datepicker.kr.js" charset="UTF-8"></script>
</body>
</html>