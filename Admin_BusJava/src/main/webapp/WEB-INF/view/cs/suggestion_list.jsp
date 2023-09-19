<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
%>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">고객지원 관리</h3>
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
		            <li class="breadcrumb-item text-muted active" aria-current="page">건의사항 관리</li>
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
				        <input type="hidden" id="hiddenCtgr" name="hiddenCtgr" value="" />
						<table class="table table-sm custom">
			                <colgroup>
			                    <col width="20%">
			                    <col width="*">
			                </colgroup>
							<tbody>
			                	<tr>
			                        <th scope="row" class="text-center bg-gray align-middle">회원ID</th>
			                        <td class="text-left">
										<input type="text" class="form-control" name="mi_id" />
			                        </td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center bg-gray align-middle">상태</th>
			                        <td class="text-left">
			                            <div class="d-flex">
			                        <div class="form-check form-check-inline">
			                            <div class="custom-control custom-checkbox">
			                                <input type="checkbox" class="custom-control-input" value="all" id="all" name="chk" onclick="chkAll(this);" checked="checked">
			                                <label class="custom-control-label" for="all">전체</label>
			                            </div>
			                        </div>
			                        <div class="form-check form-check-inline">
			                            <div class="custom-control custom-checkbox">
			                                <input type="checkbox" class="custom-control-input" value="휴면" id="customCheck2" name="chk" checked="checked">
			                                <label class="custom-control-label" for="customCheck2">질문취소</label>
			                            </div>
			                        </div>
			                        <div class="form-check form-check-inline">
			                            <div class="custom-control custom-checkbox">
			                                <input type="checkbox" class="custom-control-input" value="정상" id="customCheck1" name="chk" checked="checked">
			                                <label class="custom-control-label" for="customCheck1">답변대기</label>
			                            </div>
			                        </div>
			                        <div class="form-check form-check-inline">
			                            <div class="custom-control custom-checkbox">
			                                <input type="checkbox" class="custom-control-input" value="휴면" id="customCheck2" name="chk" checked="checked">
			                                <label class="custom-control-label" for="customCheck2">답변완료</label>
			                            </div>
			                        </div>
			                        <div class="form-check form-check-inline">
			                            <div class="custom-control custom-checkbox">
			                                <input type="checkbox" class="custom-control-input" value="휴면" id="customCheck2" name="chk" checked="checked">
			                                <label class="custom-control-label" for="customCheck2">답변거절</label>
			                            </div>
			                        </div>
			                        </div>
			                        </td> 
			                    </tr>
			                    <tr>
			                        <th scope="row" class="text-center bg-gray align-middle">기간</th>
			                        <td class="text-left">
			                        	<div class="d-flex align-center">
				                        	<div class="col-lg-2 pl-0">
				                                <div class="form-group mb-0 custom-date">
				                                	<span><i class="icon-calender"></i></span>
				                                	<input type="text" id="sDate1-2" class="form-control" value="" readonly>
				                                </div>
				                            </div>
			                            	<span style="line-height: 2.2;"> ~ </span>
			                            	<div class="col-lg-2">
				                                <div class="form-group mb-0 custom-date">
				                                	<span><i class="icon-calender"></i></span>
				                                	<input type="text" id="sDate1-2" class="form-control" value="" readonly>
				                                </div>
				                            </div>
			                            </div>
			                        </td> 
			                    </tr>
							</tbody>
						</table>
			            <div class="d-flex justify-content-center">
			            	<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2">검색
				        	<i class="icon-magnifier"></i></button>
			            </div>
		            </form>
					<table id="table" class="table text-center padding-size-sm mt-3 mb-0">
		                <colgroup>
			                <col width="5%">
			                <col width="5%">
		                    <col width="10%">
		                    <col width="10%">
							<col width="*">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="5%">
		                </colgroup>
		                <thead class="bg-primary text-white">
			                <tr>
			                	<th class="align-middle"><input type="checkbox" name="chechkall" style="width:18px; height:18px;" onclick="chkAll(this);" /></th>
			                	<th>No</th>
			                	<th>회원ID</th>
			                    <th>분류</th>
			                    <th>제목</th>
			                    <th>건의일시</th>
			                    <th>답변일시</th>
			                    <th>답변 어드민ID</th>
			                    <th>상태</th>
			                </tr>
		            	</thead>
						<tbody class="border border-primary">
							<tr>

			                </tr>
							<tr>
			                    <td colspan="8">매출내역이 존재하지 않습니다.</td>
			                </tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp" %>
<script>
$(document).ready(function() {
	
	$("#sDate1-2").datepicker({
		format: "yyyy.mm.dd",
		autoclose: true,
		startDate: "0d",
		
		endDate: "+30d",
		language: "kr",
		showMonthAfterYear: true,
		weekStart: 1,
		}).datepicker("setDate",'now')
		.on('changeDate', function(e) {
			console.log(1);
 			$("#sDate1-1").val($(this).val());

	});
	
});

$("#schBtn").click(function() {
	
});
</script>