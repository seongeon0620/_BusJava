<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
%>
<section class="probootstrap_section">
    <div class="container">
        <div class="row text-center mb-5 probootstrap-animate fadeInUp probootstrap-animated mb-0">
          <div class="col-md-12">
            <h2 class="border-bottom mb-5 probootstrap-section-heading">건의사항</h2>
          </div>
       
        </div>
        <div class="row">
          <div class="col-md-12">
          	<div class="d-flex justify-content-end mb-2">
		      <button type="button" class="btn btn-primary" onclick="">글작성</button>
      		</div>
            <table class="table table-hover">
              <colgroup>
                  <col width="5%">    
                  <col width="15%">
                  <col width="*">
                  <col width="10%">
                  <col width="15%">
              </colgroup>
              <thead>
              <tr>
                  <th scope="col" class="text-center">No</th>
                  <th scope="col" class="text-center">분류</th>
                  <th scope="col" class="text-center">제목</th>
                  <th scope="col" class="text-center">작성자</th>
                  <th scope="col" class="text-center">작성일</th>
              </tr>
              </thead>
              <tbody class="text-center">
              <tr>
              </tr>
              </tbody>
          </table>

          <nav aria-label="Page navigation example" class="mt-4">
            <ul class="pagination justify-content-center">    
              <li class="page-item">
                  <span class="page-link" aria-hidden="true">&laquo;</span>
              </li>
			 <li class="page-item">
			 	<span class="page-link" aria-hidden="true">»</span>
              </li>
            </ul>
          </nav>
          </div>
        </div>
    </div>

</section>
<%@ include file="../_inc/foot.jsp"%>