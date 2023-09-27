<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<MemberInfo> memberList = (List<MemberInfo>) request.getAttribute("memberList");
PageInfo pi = (PageInfo) request.getAttribute("pi");

String cb = (String) request.getAttribute("schctgr");
if (cb == null)
	cb = "all:정상:휴면:탈퇴";
String[] arrcb = cb.split(":");
%>
<script>
	function chkAll() {
		var allCheckbox = document.getElementById("all");
		var checkboxes = document.getElementsByName("chk");

		if (allCheckbox.checked) {
			for (var i = 0; i < checkboxes.length; i++) {
				checkboxes[i].checked = true;
			}
			allCheckbox.closest(".allchkbox").classList.add("active");
		} else {
			for (var i = 0; i < checkboxes.length; i++) {
				checkboxes[i].checked = false;
			}
			allCheckbox.closest(".allchkbox").classList.remove("active");
		}
	}

	document.addEventListener("click", function(e) {
		if (e.target && e.target.name === "chk") {
			var checkboxes = document.getElementsByName("chk");
			var chksChecked = 0;
			for (var i = 0; i < checkboxes.length; i++) {
				var checkbox = checkboxes[i];
				if (checkbox.checked) {
					chksChecked++;
				}
			}
			var allCheckbox = document.getElementById("all");

			if (checkboxes.length === chksChecked) {
				allCheckbox.checked = true;
				allCheckbox.closest(".allchkbox").classList.add("active");
			} else {
				allCheckbox.checked = false;
				allCheckbox.closest(".allchkbox").classList.remove("active");
			}
		}
	});

	window.onload = function() {
		document.getElementById('schForm').addEventListener('submit',
				function(event) {

					function chkval() {
						var frm = document.schForm;
						var chk = frm.chk; //schtype라는 이름이 2개이상이면 배열로 들어감 
						var isChecked = false;
						for (var i = 0; i < chk.length; i++) {
							if (chk[i].checked) {
								isChecked = true;
								break;
							}
						}
						return true;
					}

					function makeCtgr() {
						// 검색폼의 조건들을 쿼리스트링 sch의 값으로 만듦
						var frm = document.schForm;
						var sch = "";
						// 브랜드 조건
						var arr = frm.chk;
						var isFirst = true;
						for (var i = 0; i < arr.length; i++) {
							if (arr[i].checked) {
								if (isFirst) {
									isFirst = false;
									sch += arr[i].value;
								} else {
									sch += ":" + arr[i].value;
								}
							}
						}

						// sch 값을 출력

						document.schForm.hiddenCtgr.value = sch;
						// hiddenCtgr 필드의 값을 출력
					}

					if (!chkval()) {
						event.preventDefault();
						return;
					}

					makeCtgr();
				});
	};
</script>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">회원 관리</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
					<li class="breadcrumb-item active" aria-current="page">회원 목록</li>
				</ol>
			</nav>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<form id="schForm" name="schForm" onsubmit="">
							<input type="hidden" id="hiddenCtgr" name="hiddenCtgr" value="" />
							<table class="table table-sm custom">
								<colgroup>
									<col width="20%">
									<col width="10%">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">검색어</th>
										<td class="pr-0">
											<select class="form-control" id="" name="schtype">
												<option value="all" <%if (pi.getSchtype() == "all") {%> selected="selected" <%}%>>전체</option>
												<option value="id" <%if (pi.getSchtype() == "id") {%> selected="selected" <%}%>>아이디</option>
												<option value="email" <%if (pi.getSchtype() == "email") {%> selected="selected" <%}%>>이메일</option>
											</select>
										</td>
										<td>
											<input type="text" class="form-control" name="keyword" value="<%=pi.getKeyword()%>" />
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray">분류</th>
										<td class="text-left" colspan="2">
											<div class="d-flex">
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="all" id="all" name="chk" onclick="chkAll(this);" <%for (int k = 0; k < arrcb.length; k++) {
	if (arrcb[k].equals("all")) {%> checked="checked" <%}
	}%>> <label class="custom-control-label" for="all">전체</label>
													</div>
												</div>
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="정상" id="customCheck1" name="chk" <%for (int k = 0; k < arrcb.length; k++) {
	if (arrcb[k].equals("정상")) {%> checked="checked" <%}
}%>> <label class="custom-control-label" for="customCheck1">정상</label>
													</div>
												</div>
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="휴면" id="customCheck2" name="chk" <%for (int k = 0; k < arrcb.length; k++) {
	if (arrcb[k].equals("휴면")) {%> checked="checked" <%}
}%>> <label class="custom-control-label" for="customCheck2">휴면</label>
													</div>
												</div>
												<div class="form-check form-check-inline">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" value="탈퇴" id="customCheck3" name="chk" <%for (int k = 0; k < arrcb.length; k++) {
	if (arrcb[k].equals("탈퇴")) {%> checked="checked" <%}
}%>> <label class="custom-control-label" for="customCheck3">탈퇴</label>
													</div>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="d-flex justify-content-center">
								<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2">
									검색 <i class="icon-magnifier"></i>
								</button>
							</div>
						</form>
						<table id="table" class="table text-center mb-0 mt-3 table-sm">
							<colgroup>
								<col width="5%">
								<col width="10%">
								<col width="20%">
								<col width="20%">
								<col width="8%">
							</colgroup>
							<thead class="bg-primary text-white">
								<tr>
									<th scope="col" class="text-center">No</th>
									<th scope="col" class="text-center">아이디</th>
									<th scope="col" class="text-center">이메일</th>
									<th scope="col" class="text-center">가입일시</th>
									<th scope="col" class="text-center">상태</th>
								</tr>
							</thead>
							<tbody class="text-center border">
								<%
								if (memberList.size() > 0) {
									int j = 0;
									for (MemberInfo mi : memberList) {
										if (mi.getMi_id() == null)
									mi.setMi_id("-");
										if (mi.getMi_pw() == null)
									mi.setMi_pw("-");
										if (mi.getMi_email() == null)
									mi.setMi_email("-");
										if (mi.getMi_name() == null)
									mi.setMi_name("-");
										if (mi.getMi_gender() == null)
									mi.setMi_gender("-");
										if (mi.getMi_phone() == null)
									mi.setMi_phone("-");
										if (mi.getMi_date() == null)
									mi.setMi_date("-");
								%>
								<tr onclick="getUserInfo(this);">
									<td><%=memberList.size() - j%></td>
									<td class="mi_id"><a href="javascript:void(0);"><%=mi.getMi_id()%></a></td>
									<td><%=mi.getMi_email()%></td>
									<td><%=mi.getMi_date().substring(0, 16).replace("-", ".")%></td>
									<td><%=mi.getMi_status()%></td>
								</tr>
								<%
								j++;
								}
								} else {
								%>
								<tr height="50">
									<td colspan="5" align="center">검색결과가 없습니다.</td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
						<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->
						<nav aria-label="Page navigation example" class="mt-4">
							<ul class="pagination justify-content-center">
								<%
								if (memberList.size() > 0) {
								%>
								<%
								if (pi.getCpage() == 1) {
								%>
								<li class="page-item"><span class="page-link" aria-hidden="true">&laquo;</span></li>
								<%
								} else if (pi.getCpage() > 1) {
								%>
								<li class="page-item"><a class="page-link" href="memberList?cpage=<%=pi.getCpage() - 1%>" aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
								</a></li>
								<%
								}
								int endPage = (pi.getSpage() + pi.getBsize() - 1 <= pi.getPcnt()) ? pi.getSpage() + pi.getBsize() - 1 : pi.getPcnt();
								for (int i = pi.getSpage(); i <= endPage; i++) {
								if (i == pi.getCpage()) {
								%>
								<li class="page-link"><%=i%></li>
								<%
								} else if (i != pi.getCpage()) {
								%>
								<li class="page-item"><a class="page-link" href="memberList?cpage=<%=i%>"><%=i%></a></li>
								<%
								}
								}
								%>
								<%
								if (pi.getCpage() < pi.getPcnt()) {
								%>
								<li class="page-item"><a class="page-link" href="memberList?cpage=<%=pi.getCpage() + 1%>" aria-label="Next"> <span aria-hidden="true">&raquo;</span>
								</a></li>
								<%
								} else if (pi.getCpage() == pi.getPcnt()) {
								%>
								<li class="page-item"><span class="page-link" aria-hidden="true">&raquo;</span></li>
								<%
								}
								}
								%>
							</ul>
						</nav>
						<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->

						<form name="frmMemUp" action="memberUp" method="post">
							<div class="row">
								<div class="col-md-12 text-center" style="display: none;" id="memberDetail-container">
									<div id="memberDetail"></div>
								</div>
							</div>
						</form>
						<!-- ajax -->
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	function getUserInfo(elem) {
		const uid = elem.querySelector(".mi_id").innerText;
		$.ajax({
			type : "POST",
			url : "./memberDetail",
			data : {
				"uid" : uid
			},
			dataType : "json",
			success : function(data) {
				if (data.length > 0) {
					let tableHTML = "<table class='table table-sm' algin='center' >"
							+ "<colgroup><col width='20%'><col width='30%'><col width='20%'><col width='*'>"
							+ "</colgroup>" +
							"<tbody>";

					data.forEach(function(table) {
						if (table.mi_id == null)
							table.mi_id = "-";
						if (table.mi_pw == null)
							table.mi_pw = "-";
						if (table.mi_email == null)
							table.mi_email = "-";
						if (table.mi_name == null)
							table.mi_name = "-";
						if (table.mi_gender == null)
							table.mi_gender = "-";
						if (table.mi_phone == null)
							table.mi_phone = "-";
						if (table.mi_date == null)
							table.mi_date = "-";
							tableHTML += "<tr><th scope='col' class='text-center bg-light'>아이디</th>";
							tableHTML += "<td class='align-middle'>" + table.mi_id + "</td>";
							tableHTML += "<input type='hidden' name='mi_id' value='" + table.mi_id + "' />" ;
							tableHTML += "<th scope='col' class='text-center bg-light'>비밀번호</th>";
							tableHTML += "<td class='align-middle'>" + table.mi_pw + "</td><tr>";
							tableHTML += "<tr><th scope='col' class='text-center align-middle bg-light'>이메일</th>";
							tableHTML += "<td class='align-middle'>" + table.mi_email + "</td>";
							tableHTML += "<th scope='col' class='text-center align-middle bg-light'>상태</th>";
							tableHTML += "<td><select class='form-control w-auto' name='mi_status' style='margin:0 auto'><option " + (table.mi_status === '정상' ? "selected='selected'" : "") + ">정상</option><option " + (table.mi_status === '휴면' ? "selected='selected'" : "") + ">휴면</option><option " + (table.mi_status === '탈퇴' ? "selected='selected'" : "") + ">탈퇴</option></select></td>";
							tableHTML += "<tr><th scope='col' class='text-center bg-light'>이름/성별</th>";
							tableHTML += "<td class='align-middle'>" + table.mi_name + "/" + table.mi_gender + "</td>";
							tableHTML += "<th scope='col' class='text-center bg-light'>번호</th>";
							tableHTML += "<td class='align-middle'>" + table.mi_phone + "</td>";
							tableHTML += "<tr><th scope='col' class='text-center bg-light'>보유페이머니</th>";
							tableHTML += "<td>" + table.mi_pmoney.toLocaleString("ko-kr") + "</td>";
							tableHTML += "<th scope='col' class='text-center bg-light'>보유 스탬프</th>";
							tableHTML += "<td>" + table.mi_stamp + "</td>";
							tableHTML += "<tr><th scope='col' class='text-center bg-light'>보유 쿠폰</th>";
							tableHTML += "<td class='border-bottom'>" + table.mi_coupon + "</td>";
							tableHTML += "<th scope='col' class='text-center align-middle bg-light'>가입일시</th>";
							tableHTML += "<td class='border-bottom'>" + table.mi_date + "</td>";
							tableHTML += "</tr>";
					});
					tableHTML += "</tbody></table><div class='d-flex justify-content-center'>";
					tableHTML += "<button type='submit' class='btn waves-effect waves-light btn-secondary' >수정</button>";
					tableHTML += "<button type='button' class='btn waves-effect waves-light btn-primary ml-3' onclick='location.href=\"memberList\"'>확인</button></div>";

					$("#memberDetail").html(tableHTML);
					$("#memberDetail-container").show();
				} else {
					// 데이터가 없는 경우
					alert("회원이 없습니다.");
					$("#memberDetail").empty();
					$("#memberDetail-container").hide();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.error("AJAX Error: " + textStatus);
				console.error("HTTP Error: " + errorThrown);
				console.error("Server Response: " + jqXHR.responseText);
			}
		});
	};
</script>
<%@ include file="../_inc/foot.jsp"%>