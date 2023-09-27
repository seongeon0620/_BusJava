<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">유실물 보기</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item"><a href="travelList" class="text-muted">유실물 목록</a></li>
		            <li class="breadcrumb-item active" aria-current="page">유실물 상세</li>
		        </ol>
		    </nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
		    <div class="col-lg-12">
		        <div class="card">
		        	<div class="card-body">
		        		<input type="hidden" name="kind" value="up" />
			            <table class="table">
			                <colgroup>
			                    <col width="10%">
			                    <col width="20%">
			                    <col width="10%">
			                    <col width="*">
			                </colgroup>
			                <tbody>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">보관장소</th>
			                        <td class="text-left">${li.getLl_tername() }</td>
			                        <th scope="row" class="text-center table-primary">습득물명</th>
			                        <td>${li.getLl_title() }</td>
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">내용</th>
			                        <td class="text-left" colspan="3">${li.getLl_content() }</td>
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">이미지</th>
			                        <td class="text-left" colspan="3">
			                        	<div class="img-box">
			                                <img src="resources/images/lost/${li.getLl_img() }" />
										</div>
			                        </td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">상태</th>
			                        <td class="text-left border-bottom">
			                        	<c:if test="${li.getLl_status() == 'A' }" >보관중</c:if><c:if test="${li.getLl_status() == 'B' }" >수령완료</c:if>
			                        </td>
			                        <th scope="row" class="text-center table-primary align-middle">습득일자</th>
			                        <td class="text-left border-bottom">${li.getLl_date() } ${li.getLl_time() }</td>
			                    </tr>
			                </tbody>
			            </table>
			            <div class="d-flex justify-content-center">
				            <button type="button" class="btn waves-effect waves-light btn-secondary mb-2 mr-3" onclick="location.href='lostList'">목록</button>
				            <button type="button" class="btn waves-effect waves-light btn-primary mb-2" onclick="location.href='lostForm?kind=up&ll_idx=${li.getLl_idx()}'">수정</button>
			            </div>
		        	</div> 
		    	</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>