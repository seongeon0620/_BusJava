<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>

<section class="section">
      <div class="container">
        <div class="row text-center mb-5">
          <div class="col-md-12">
            <h2 class="display-5 border-bottom heading">비밀번호 입력</h2>
          </div>
        </div>
        <div class="row mb-4">
          <div class="col-md-4 m-auto">
            <form name="frmPwChk" id="frmPwChk" action="memberModify" method="post">
                <input type="password" class="form-control" id="mi_pw" name=mi_pw>
              <div class="btn-wrap">
                <button type="button" class="btn btn-secondary w-120p " onclick="history.back();">취소</button>
                <button type="submit" class="btn btn-primary w-120p ">확인</button>
              </div>
            </form>
          </div>
        </div>

    </div>
</section>
    
<%@ include file="../_inc/foot.jsp" %>