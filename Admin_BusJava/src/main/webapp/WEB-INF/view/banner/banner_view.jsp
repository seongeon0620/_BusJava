<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%@ page import="vo.*" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
BannerInfo bi = (BannerInfo) request.getAttribute("bi");
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/busjava_admin/login' ");
	out.println("</script>");
	out.close();
}
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">배너 상세</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/busjava_admin" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item"><a href="bannerList" class="text-muted">배너 목록</a></li>
		            <li class="breadcrumb-item text-muted active" aria-current="page">배너 상세</li>
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
			                    <col width="10%">
			                    <col width="10%">
			                    <col width="10%">
			                    <col width="10%">
			                    <col width="*">
			                </colgroup>
			                <tbody>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">배너명</th>
			                        <td><%=bi.getBl_name() %></td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary">내용</th>
			                        <td class="text-left" colspan="5"><%=bi.getBl_content() %></td>
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">이미지</th>
			                        <td class="text-left" colspan="5">
			                        	<div class="img-box">
			                                <img src="resources/images/banner/<%=bi.getBl_img().toLowerCase() %>" />
										</div>
			                        </td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center table-primary align-middle">게시여부</th>
			                        <td class="text-left" colspan="5">
			                            <div class="d-flex"><%=bi.getBl_isview() %></div>
			                        </td> 
			                    </tr>
			                </tbody>
			            </table>
			            <div class="d-flex justify-content-center">
				            <button type="button" class="btn waves-effect waves-light btn-secondary mb-2 mr-3" onclick="location.href='bannerList'">목록</button>
				            <button type="button" class="btn waves-effect waves-light btn-primary mb-2" onclick="location.href='bannerForm?kind=up&bl_idx=<%=bi.getBl_idx() %>'">수정</button>
			            </div>
		        	</div> 
		    	</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>