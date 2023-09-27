<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<script>
	function ctgrAll(all) {
		var arr = document.frmSch.schctgr;

		for (var i = 0; i < arr.length; i++) {
			if (arr[i] !== all) { // '전체 선택' 체크박스 제외
				arr[i].checked = all.checked;
			}
		}
	}

	function ctgrOne(one) {
		var frm = document.frmSch;
		var all = frm.all;
		if (one.checked) {
			var arr = frm.schctgr;
			var isChk = true;

			for (var i = 0; i < arr.length; i++) {
				if (arr[i].checked == false && arr[i] !== all) { // '전체 선택' 체크박스를 제외하고 체크
					isChk = false;
					break;
				}
			}

			all.checked = isChk;
		} else {
			all.checked = false;
		}
	}

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
		var all = frm.checkall; // '전체 선택' 체크박스 객체
		if (one.checked) { // 특정 체크박스를 체크했을 경우
			var arr = frm.chk;
			var isChk = true;
			for (var i = 0; i < arr.length; i++) {
				if (arr[i].checked == false) {
					isChk = false;
					break;
				}
			}
			all.checked = isChk;
		} else { // 특정 체크박스를 체크 해체했을 경우
			all.checked = false;
		}
	}

	function chkChange(isview) {
		var flidx = getSelectedChk();

		if (flidx == "")
			alert("변경할 게시글을 선택하세요.");
		else
			statusChange(flidx, isview);
	}

	function getSelectedChk() {
		var frm = document.frm;
		var arr = frm.chk;
		var checkedChk = [];

		for (var i = 0; i < arr.length; i++) {
			if (arr[i].checked) {
				checkedChk.push(arr[i]);
			}
		}

		// 이제 checkedElements 배열에는 체크된 요소만 있습니다.
		// 만약 체크된 요소의 value 값을 얻고 싶다면 다음과 같이 할 수 있습니다.
		var flidx = "";
		for (var i = 0; i < checkedChk.length; i++) {
			flidx += "," + checkedChk[i].value;
		}

		return flidx.substring(1);
	}

	function statusChange(flidx, isview) {
		if (confirm("정말 변경하시겠습니까?")) {
			$.ajax({
				type : "POST",
				url : "./isviewChange",
				data : {
					"flidx" : flidx,
					"isview" : isview
				},
				success : function(chkRs) { // chkRs는 그냥 내가 정한 변수명
					if (chkRs == 0) {
						alert("변경에 실패하였습니다.\n 다시 시도하세요");
					}
					location.reload();
				}
			});
		}
	}
</script>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<h3 class="page-title text-truncate text-dark font-weight-bold">FAQ 관리</h3>
		<div class="d-flex align-items-center">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb m-0 p-0">
					<li class="breadcrumb-item"><a href="/Admin_BusJava" class="text-muted">홈</a></li>
					<li class="breadcrumb-item active" aria-current="page">FAQ 목록</li>
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
									<col width="10%">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">검색어</th>
										<td class="pr-0">
											<select class="form-control" name="schtype">
												<option value="">전체</option>
												<option value="title" <c:if test="${pi.getSchtype() == 'title' }">selected='selected'</c:if>>제목</option>
												<option value="content" <c:if test="${pi.getSchtype() == 'content' }">selected='selected'</c:if>>내용</option>
												<option value="tc" <c:if test="${pi.getSchtype() == 'tc' }">selected='selected'</c:if>>제목+내용</option>
											</select>
										</td>
										<td class="text-left">
											<input type="text" class="form-control" name="keyword" <c:if test="${pi.getKeyword() != '' }">value='${pi.getKeyword() }'</c:if> />
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">분류</th>
										<td colspan="2">
											<div class="d-table">
												<c:if test="${ctgrList.size() > 0 }">
													<c:set var="cleanedSchctgr" value="${fn:substringAfter(ctgrChk, '[')}" />
													<c:set var="count" value="${count + 1}" />
													<div class="form-check form-check-inline">
														<div class="custom-control custom-checkbox">
															<input type="checkbox" name="all" value="all" class="custom-control-input" id="all" onclick="ctgrAll(this);" <c:if test="${allChk == 'all'}">checked="checked"</c:if> /> <label class="custom-control-label" for="all">전체</label>
														</div>
													</div>
													<!-- 이제 각 체크박스의 상태를 결정합니다. -->
													<c:forEach items="${ctgrList}" var="cl" varStatus="status">
														<div class="form-check form-check-inline">
															<div class="custom-control custom-checkbox">
																<input type="checkbox" name="schctgr" value="${cl.getFl_ctgr()}" class="custom-control-input" id="${status.count}" onclick="ctgrOne(this);" <c:choose>
		                <c:when test="${fn:indexOf(cleanedSchctgr, cl.getFl_ctgr()) ne -1}">
		                    checked="checked"
		                </c:when>
		            </c:choose> /> <label class="custom-control-label" for="${status.count}">${cl.getFl_ctgr()}</label>
															</div>
														</div>
													</c:forEach>
												</c:if>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row" class="text-center bg-gray align-middle">게시여부</th>
										<td class="text-center">
											<select class="form-control w-auto" name="isview">
												<option value="" <c:if test="${pi.getIsview() == '' }">selected='selected'</c:if>>전체</option>
												<option value="Y" <c:if test="${pi.getIsview() == 'Y' }">selected='selected'</c:if>>게시</option>
												<option value="N" <c:if test="${pi.getIsview() == 'N' }">selected='selected'</c:if>>미게시</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="d-flex justify-content-center">
								<button type="button" class="btn waves-effect waves-light btn-light mb-2" onclick="location.href='faqList'">필터 초기화</button>
								<button type="submit" class="btn waves-effect waves-light btn-secondary mb-2 ml-2">
									검색 <i class="icon-magnifier"></i>
								</button>
							</div>
						</form>
						<form name="frm">
							<div class="text-right mt-2">
								<button type="button" class="btn waves-effect waves-light btn-primary" onclick="location.href='faqForm?kind=in'">글등록</button>
								<button type="button" class="btn waves-effect waves-light btn-secondary ml-2" onclick="chkChange('n');" value="">미게시로변경</button>
							</div>
							<input type="hidden" name="chk" value="" />
							<table id="table" class="table text-center mb-0 mt-3 table-sm">
								<colgroup>
									<col width="5%">
									<col width="10%">
									<col width="15%">
									<col width="*">
									<col width="20%">
									<col width="10%">
								</colgroup>
								<thead class="bg-primary text-white">
									<tr>
										<th scope="col" class="align-middle">
											<div class="custom-control custom-checkbox">
												<input type="checkbox" class="custom-control-input" id="checkall" name="checkall" onclick="chkAll(this);">
												<label class="custom-control-label" for="checkall"></label>
											</div>
										</th>
										<th scope="col" class="text-center">No</th>
										<th scope="col" class="text-center">분류</th>
										<th scope="col" class="text-center">제목</th>
										<th scope="col" class="text-center">작성일</th>
										<th scope="col" class="text-center">게시여부</th>
									</tr>
								</thead>
								<tbody class="text-center border">
									<c:if test="${faqList.size() > 0 }">
										<c:forEach items="${faqList }" var="fl" varStatus="status">
											<tr class="tr">
												<td class="align-middle">
													<div class="custom-control custom-checkbox">
														<input type="checkbox" class="custom-control-input" id="customCheck${fl.getFl_idx() }" name="chk" value="${fl.getFl_idx() }" onclick="chkOne(this);">
														<label class="custom-control-label" for="customCheck${fl.getFl_idx() }"></label>
													</div>
												</td>
												<td>${pi.getNum() - status.index}</td>
												<td>${fl.getFl_ctgr() }</td>
												<td class="text-left">
													<a href="faqView?flidx=${fl.getFl_idx() }${pi.getArgs() }">${fl.getFl_title() }</a>
												</td>
												<td>${fl.getFl_date()}</td>
												<td>${fl.getFl_isview() }</td>
											</tr>
										</c:forEach>
									</c:if>
									<c:if test="${faqList.size() == 0 }">
										<tr height="50">
											<td colspan="6" align="center">검색결과가 없습니다.</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</form>
						<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->
						<nav aria-label="Page navigation example m-auto" style="margin-top: 20px">
							<ul class="pagination justify-content-center">
								<c:if test="${faqList.size() > 0 }">
									<li class="page-item"><c:choose>
											<c:when test="${ pi.getCpage() == 1 }">
												<a class="page-link" href="faqList?cpage=1${pi.getSchargs()}" aria-label="Previous"> <span aria-hidden="true">«</span> <span class="sr-only">Previous</span>
												</a>
											</c:when>
											<c:when test="${ pi.getCpage() > 1 }">
												<a class="page-link" href="faqList?cpage=${pi.getCpage() - 1}${pi.getSchargs()}" aria-label="Previous"> <span aria-hidden="true">«</span> <span class="sr-only">Previous</span>
												</a>
											</c:when>
										</c:choose></li>
									<c:forEach var="i" begin="${pi.getSpage() }" end="${pi.getSpage() + pi.getBsize() - 1 <= pi.getPcnt() ? pi.getSpage() + pi.getBsize() - 1 : pi.getPcnt()}">
										<li class="page-item"><a class="page-link" href="faqList?cpage=${i }${pi.getSchargs() }">${i }</a></li>
									</c:forEach>
									<li class="page-item"><c:choose>
											<c:when test="${pi.getCpage() == pi.getPcnt()}">
												<a class="page-link" href="faqList?cpage=${pi.getCpage()}${pi.getSchargs() }" aria-label="Next"> <span aria-hidden="true">»</span> <span class="sr-only">Next</span>
												</a>
											</c:when>
											<c:when test="${pi.getCpage() <  pi.getPcnt()}">
												<a class="page-link" href="faqList?cpage=${pi.getCpage() + 1 }${pi.getSchargs() }" aria-label="Next"> <span aria-hidden="true">»</span> <span class="sr-only">Next</span>
												</a>
											</c:when>
										</c:choose></li>
								</c:if>
							</ul>
						</nav>
						<!-- 페이지 네이션 부분------------------------------------------------------------------------------------------------ -->

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../_inc/foot.jsp"%>