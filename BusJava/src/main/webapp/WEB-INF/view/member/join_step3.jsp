<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<% 
String mi_id = (String)request.getAttribute("mi_id");
String mi_name = (String)request.getAttribute("mi_name");
%>
 <section class="probootstrap_section" id="section-city-guides">
    <div class="container">
      <div class="row text-center mb-5 ">
        <div class="col-md-12">
          <h2 class="display-5 border-bottom probootstrap-section-heading probootstrap-animate">회원가입</h2>
          <div class="row">
            <div class="col-md-8 mb-3 m-auto">
              <table class="table text-center">
                <colgroup>
                  <col width="25%">
                  <col width="*">
                </colgroup>
                <div class="col-md-8 m-auto">
                  <div class="progress-bar-custom">
                    <div class="progress-step">
                      <div class="step-count"></div>
                      <div class="step-description">약관 동의</div>
                    </div>
                    <div class="progress-step">
                      <div class="step-count"></div>
                      <div class="step-description">정보입력</div>
                    </div>
                    <div class="progress-step is-active">
                      <div class="step-count"></div>
                      <div class="step-description">가입완료</div>
                    </div>
                  </div>
                </div>
                <h1><a class="join" ><img src="${pageContext.request.contextPath}/resources/images/welcome.svg" /></a></h1>
               
                <div class="col-md-12">
                  <h3><p><span><%=mi_name %>(<%=mi_id.substring(0,4) + "***" %>)님</span></p></h3>
                  <h3><p>회원가입을 축하드립니다.</p></h3>
                </div>
              </table>
              <div class="btn-wrap">
              <button type="button" onclick="location.href='memberLogin'" class="btn btn-primary btn-block w-120p m-auto">로그인</button>
              </div>
            </div>
          </div>
        </div>
      </div>
  </section>
  <%@ include file="../_inc/foot.jsp"%>