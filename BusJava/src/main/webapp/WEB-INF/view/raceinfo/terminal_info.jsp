<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
List<TerminalInfo> areaList = (List<TerminalInfo>) request.getAttribute("areaList");
PageInfo pi = (PageInfo) request.getAttribute("pi");
List<TerminalInfo> terminalList = null;
if (request.getAttribute("terminalList") != null)
	terminalList = (List<TerminalInfo>) request.getAttribute("terminalList");
String keyword = "";
if (request.getParameter("keyword") != null)
	keyword = request.getParameter("keyword");
%>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d4810a9edd94fe69f6ce447419b9f4f6&libraries=services"></script>
<!-- JavaScript 키 -->
<style>
#map {
	height: 380px;
	display: none;
}
</style>
<section class="section">
	<div class="container">
		<div class="row text-center mb-5">
			<div class="col-md-12">
				<h2 class="border-bottom heading">터미널 안내</h2>
			</div>
		</div>
		<!-- 지역명으로 찾기 -->
		<div class="col-md-10 m-auto">
			<div class="row justify-content-between border-bottom pb-4">
				<div class="col-md-4">
					<h4>터미널명으로 찾기</h4>
				</div>
				<div class="col-md-5 p-0">
					<form name="frmTerName">
						<input type="hidden" name="cpage" value="1" />
						<div class="input-group">
							<input type="text" class="form-control form-control-lg" placeholder="터미널명을 입력하세요" name="keyword" value="<%=keyword%>">
							<button class="btn btn-primary" type="submit" id="button-addon2">검 색</button>
						</div>
					</form>
				</div>
			</div>
			<div class="mt-4">
				<h4>지역명으로 찾기</h4>
				<p class="text-muted">각 지역을 클릭하여 해당 지역의 터미널을 찾으실 수 있습니다.</p>

				<div>
					<div class="col-md-12">
						<form name="frmAreaName">
							<input type="hidden" name="cpage" value="1" />
							<%
							if (areaList.size() > 0) {
								for (int i = 0; i < areaList.size(); i++) {
									TerminalInfo ti = new TerminalInfo();
									ti = areaList.get(i);
									if (i == 0)
								out.println("<div class=\"row\">");
									if (i != 0 && i % 4 == 0)
								out.println("<div class=\"row mt-3\">");
							%>
							<div class="col text-center">
								<button type="submit" name="btarea" value="<%=ti.getBt_area()%>" class="btn btn-primary btn-lg btn-block"><%=ti.getBt_area()%></button>
							</div>
							<%
							if (i % 4 == 3)
								out.println("</div>");
							}
							%>
							<%} else {%>
							<div class="row">
								<div class="col-12 text-center">
									지역리스트를 불러오는데 실패했습니다.<br /> 다시 시도해주세요.
								</div>
							</div>
							<%}%>
						</form>
					</div>
				</div>
				<div class="row mt-3">
					<div class="col-md-12">
						<%
						if (terminalList != null && terminalList.size() > 0) {
							String pLink = ""; // 이전페이지
							String link = "";
							String nLink = "	"; // 다음페이지
						%>
						<table class="table" id="terminalList">
							<colgroup>
								<col width="10%">
								<col width="15%">
								<col width="30%">
								<col width="*">
							</colgroup>
							<thead class="bg-light">
								<th scope="col" class="text-center">구분</th>
								<th scope="col" class="text-center">지역</th>
								<th scope="col" class="text-center">터미널명</th>
								<th scope="col" class="text-center">주소</th>
							</thead>


							<%
							for (TerminalInfo ti : terminalList) {
								String code = ti.getBt_code() + "";
								String type = "고속";
								if (code.length() > 3)
									type = "시외";
							%>
							<tr>
								<td class="text-center"><%=type%></td>
								<td class="text-center"><%=ti.getBt_area()%></td>
								<td class="text-center">
									<a href="javascript:void(0);" onclick="getMap('<%=ti.getBt_name()%>', '<%=ti.getBt_addr()%>');"><%=ti.getBt_name()%></a>
								</td>
								<td><%=ti.getBt_addr()%></td>
							</tr>

							<%
							}
							%>
						</table>
						<!-- 페이지네이션 영역 -->
						<%
						if (pi != null && terminalList.size() > 0) {
						%>
						<%@ include file="../_inc/pagination.jsp"%>
						<%}%>
						
						<!-- 페이지네이션 영역 종료 -->
						<!-- 카카오맵 api 영역 시작 -->
						<div align="center" class="row">
							<div class="col border" id="map" tabindex="-1"></div>
						</div>
						<!-- 카카오맵 api 영역 종료 -->
						<%
						} else if (terminalList != null) { // 검색 결과가 없을 때만 노출
						%>
						<table>
							<tr height="50">
								<td>검색결과가 없습니다. 터미널명을 다시 확인해주세요.</td>
							</tr>
						</table>
						<%
						}
						%>
					</div>
				</div>
			</div>
		</div>

	</div>
</section>
<!-- END section -->

<%@ include file="../_inc/foot.jsp"%>
<script>
	function getMap(tname, addr) {
		if (addr == "") {
			return;
		} else {
			var mapContainer = document.getElementById('map'); // 지도를 표시할 div 
			mapContainer.style.display = 'block';
			var mapOption = {
				center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
				level : 3
			// 지도의 확대 레벨
			};
			// 지도를 생성
			var map = new kakao.maps.Map(mapContainer, mapOption);
			// 주소-좌표 변환 객체를 생성
			var geocoder = new kakao.maps.services.Geocoder();
			// 주소로 좌표를 검색
			geocoder
				.addressSearch(
					addr,
					function(result, status) {
						// 정상적으로 검색이 완료
						if (status === kakao.maps.services.Status.OK) {
							var coords = new kakao.maps.LatLng(
									result[0].y, result[0].x);
							// 결과값으로 받은 위치를 마커로 표시
							var marker = new kakao.maps.Marker({
								map : map,
								position : coords
							});
							// 인포윈도우로 장소에 대한 설명을 표시
							var infowindow = new kakao.maps.InfoWindow(
									{
										content : '<div style="width:150px;text-align:center; padding:6px 0";>'
												+ tname + '</div>'
									});
							infowindow.open(map, marker);

							// 지도의 중심을 결과값으로 받은 위치로 이동
							map.setCenter(coords);

							// 지도 div에 포커스를 주기
							var mapInfo = document
									.getElementById('map');
							mapInfo.focus();

						} else { // 주소가 정확하지 않아 검색이 되지 않을 경우
							mapContainer.style.display = 'none';
							alert('터미널 위치를 찾을 수 없습니다.');
						}
					});
		}
	}
</script>