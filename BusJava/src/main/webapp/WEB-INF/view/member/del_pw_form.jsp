<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
MemberInfo mi = (MemberInfo)session.getAttribute("loginInfo");
%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.4.js"></script>

<section class="probootstrap_section" id="section-city-guides">
      <div class="container">
        <div class="row text-center mb-5 probootstrap-animate">
          <div class="col-md-12">
            <h2 class="display-5 border-bottom probootstrap-section-heading">비밀번호 입력</h2>
          </div>
        </div>
        <div class="row mb-4">
          <div class="col-md-4 m-auto">
            <form name="frmDelPwChk" id="frmDelPwChk" action="memberDel" method="post">
              <div class="form-group">
                <label for="exampleInputPassword1">비밀번호</label>
                <input type="password" class="form-control" id="mi_pw" name=mi_pw>
              </div>
              <div class="btn-wrap">
                <button type="button" class="btn btn-secondary w-120p " onclick="history.back();">취소</button>
                <button type="submit" id="del" class="btn btn-primary w-120p ">확인</button>
              </div>
            </form>
          </div>
        </div>
    </div>
</section>

<script>
window.addEventListener('DOMContentLoaded', (event) => { 
    document.getElementById('del').addEventListener('click', function(event) {
        if (<%=mi.getMi_pmoney() %> > 0){
            if(confirm("현재 " + <%=mi.getMi_pmoney() %> + "원  남아있습니다.\n회원탈퇴시 잔여 페이머니는 모두 소멸됩니다.\n정말 탈퇴하시겠습니까?")) {
                // "확인선택";
            } else {
            	event.preventDefault();
                history.back(); // "취소선택";
            }
        }
    });
});
</script>
    
<%@ include file="../_inc/foot.jsp" %>