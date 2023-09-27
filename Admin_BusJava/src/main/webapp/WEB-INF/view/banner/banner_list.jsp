<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/busjava_admin/login' ");
	out.println("</script>");
	out.close();
}
List<BannerInfo> bannerList = (List<BannerInfo>) request.getAttribute("bannerList");
PageInfo pi = (PageInfo)request.getAttribute("pi");
%>
<script>
function chkAll(all) {
	// 검색창의 전체 체크박스 클릭시
		var arr = document.frm.chk;

		for (var i = 0; i < arr.length; i++) {
			arr[i].checked = all.checked;
		}
	}

function chkOne(one) {
	// 검색창의 특정 체크박스(전체 체크박스 제외) 클릭시
		var frm = document.frm;
		var all = frm.checkall;	// '전체 선택' 체크박스 객체
		if (one.checked) {	// 특정 체크박스를 체크했을 경우
			var arr = frm.chk;
			var isChk = true;
			for (var i = 0; i < arr.length; i++) {
				if (arr[i].checked == false) {
					isChk = false;		break;
				}
			}
			all.checked = isChk;
		} else {	// 특정 체크박스를 체크 해체했을 경우
			all.checked = false;
		}
	} 

	function chkChange(isview){
		var blidx = getSelectedChk();
		
		if (blidx == "")	alert("변경할 게시글을 선택하세요.");
		else				statusChange(blidx, isview);
	}

	function getSelectedChk() {
		// 체크박스들 중 선택된 체크박스들의 값(value)들을 쉼표로 구분하여 문자열로 리턴하는 함수
			var chk = document.frm.chk;
			var blidx = "";	// chk컨트롤 배열에서 선택된 체크박스의 값들을 누적 저장할 변수
			for (var i = 0 ; i < chk.length ; i++) {
				if (chk[i].checked) blidx += "," + chk[i].value;
			}
			return blidx.substring(1);
		}

	function statusChange(blidx, isview) {
		if ('${fi.getFl_isview() }' == 'N') {
			alert('이미 미게시 상태인 게시글입니다.');
		} else {
			if (confirm("정말 변경하시겠습니까?")) {
				$.ajax({
					type : "POST",
					url : "./BisviewChange",
					data : { "blidx" : blidx, "isview" : isview },
					success : function(chkRs) { // chkRs는 그냥 내가 정한 변수명
						if (chkRs == 0) {
							alert("변경에 실패하였습니다.\n 다시 시도하세요");
						}
						location.reload();
					}
				});
			}
		}
	}
</script>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">배너 관리</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item active" aria-current="page">배너 목록</li>
		        </ol>
		    </nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<form name="frmSch">
				            <table class="table table-sm custom">
				                <colgroup>
				                    <col width="20%">
				                    <col width="*">
				                </colgroup>
				                <tbody>
				                    <tr>
				                        <th scope="row" class="text-center bg-gray align-middle">배너명</th>
				                        <td class="text-left">
				                            <div class="d-flex">
				                                <input type="text" name="keyword" value="<%=pi.getKeyword() %>" class="form-control">
				                            </div>
				                        </td> 
				                    </tr>
				                    <tr>
				                        <th scope="row" class="text-center bg-gray align-middle">게시여부</th>
				                        <td class="text-left">
				                            <div class="d-flex">
				                                <select class="form-control w-auto" name="isview" id="">
				                                    <option value="" <% if (pi.getIsview().equals("")) { %> selected="selected" <% } %>>전체</option>
				                                    <option value="Y" <% if (pi.getIsview().equals("Y")) { %> selected="selected" <% } %>>게시</option>
				                                    <option value="N" <% if (pi.getIsview().equals("N")) { %> selected="selected" <% } %>>미게시</option>
				                                </select>
				                            </div>
				                        </td> 
				                    </tr>
				                </tbody>
				            </table>
				            <div class="d-flex justify-content-center">
				            	<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2" >검색
				            	<i class="icon-magnifier"></i></button>
				            </div>
            			</form>
            			<form name="frm">
				            <div class="text-right mt-2">
								<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='bannerForm?kind=in'">글등록</button>
								<button type="button" class="btn waves-effect waves-light btn-secondary ml-2" onclick="chkChange('n');" value="">미게시로변경</button>
							</div>
							<table id="table" class="table text-center table-hover mt-3 mb-0 table-sm">
			                <colgroup>
			                    <col width="5%">
								<col width="10%">
								<col width="*%">
								<col width="20%">
								<col width="10%">
			                </colgroup>
			                <thead class="bg-primary text-white">
			                <tr>
			                    <th class="align-middle">
			                    	<div class="custom-control custom-checkbox">
										<input type="checkbox" class="custom-control-input" id="checkall" name="checkall" onclick="chkAll(this);">
										<label class="custom-control-label" for="checkall"></label>
									</div>
			                    </th>
			                    <th>No</th>
			                    <th>배너명</th>
			                    <th>등록일</th>
			                    <th>게시여부</th>
			                </tr>
			            	</thead>  
							<tbody class="border">
<% if (bannerList.size() > 0) {
	int num = pi.getRcnt() - (pi.getPsize() * (pi.getCpage() - 1));
	for (BannerInfo bi : bannerList) { %>				
					                <tr class="tr">
					                    <td class="align-middle">
					                    	<div class="custom-control custom-checkbox">
                                        		<input type="checkbox" class="custom-control-input" id="customCheck<%=bi.getBl_idx() %>" name="chk" value="<%=bi.getBl_idx() %>" onclick="chkOne(this);">
                                        		<label class="custom-control-label" for="customCheck<%=bi.getBl_idx() %>"></label>
                                    		</div>
					                    </td>
					                    <td><%=num %></td>
					                    <td class="text-left"><a href="bannerView?bl_idx=<%=bi.getBl_idx() %>"><%=bi.getBl_name() %></a></td>
										<td><%=bi.getBl_date() %></td>
										<td><%=bi.getBl_isview() %></td>
					                </tr>
					           		
<%			num--;
		}
	} else { %>
					                <tr>
					                    <td colspan="7">검색결과가 없습니다.</td>
					                </tr>
<% } %>
							</tbody>
							</table>
<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->
							<% if (bannerList.size() > 0) { %>
							<%@ include file="../_inc/pagination.jsp" %>
							<% } %>
<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->   
        				</form>
        			</div> 
				</div>
    		</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>