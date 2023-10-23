<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
List<TerminalInfo> areaList = (List<TerminalInfo>)request.getAttribute("areaList"); 
%>
<section class="section">
<div class="container">
	<div class="row text-center mb-5">
		<div class="col-md-12">
		<h2 class="border-bottom heading">도착시간 안내</h2>
		</div>
	</div>
	<div class="row">
		<div class="col-md-8 m-auto">
		<form name="frmArrivaltime" method="post" class="custom-form">
			<div class="d-flex">
				<div class="form-group col-md">
					<label for="departureArea">출발 지역</label>
					<select id="departureArea" class="form-control">
						<option value="" selected disabled>지역 선택</option>
<%if (areaList.size() > 0) {
	for (TerminalInfo ti : areaList) {	
%>
						<option value="<%=ti.getBt_area() %>"><%=ti.getBt_area() %></option>
<%
	}
}%>
					</select>
				</div>
				<div class="form-group col-md">
					<label for="departureTerminal">출발 터미널</label>
					<select id="departureTerminal" name="departureTerminal" class="form-control">
						<option value="" selected disabled>터미널 선택</option>
					</select>
				</div>
			</div>
			<div class="d-flex align-items-end">
				<div class="form-group col-md mb-0">
					<label for="arrivalTerminal" name="arrivalTerminal">도착 터미널</label>
					<select id="arrivalTerminal" class="form-control">
						<option value="" selected disabled>터미널 선택</option>
					</select>
				</div>
				<div class="col-md">
					<button type="button" id="schBtn" class="btn btn-primary btn-block pt-2 pb-2">조회하기</button>
				</div>
			</div> 
		</form>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12 text-center mb-5" style="display: none;" id="timetable-container">
			<div id="timetable">
				
			</div>
		</div>
	<div class="row mb-3">
		<ul>
			<li>도착예정 시간은 차량의 실제 도착시간과 다소 차이가 발생할 수 있습니다.</li>
			<li>도착예정 2시간 이전 혹은 도착완료 30분 이내 차량에 한하여 서비스가 지원됩니다.</li>
			<li>고속버스 시간표 조회를 위해서는 시간표 조회 메뉴를 이용하시기 바랍니다.</li>
		</ul>
	</div>
	</div>
</div>
</section>
<!-- END section -->

<%@ include file="../_inc/foot.jsp" %>
<script>
$(document).ready(function() {
	$("#departureArea").change(function() {
        // 선택된 출발 지역 값을 가져옴
        const selectedArea = $(this).val();
        
        // 출발 지역이 변경되면 출발 터미널과 도착 터미널을 "터미널 선택"으로 초기화
        $("#departureTerminal").empty().append("<option value='' selected disabled>터미널 선택</option>");
        $("#arrivalTerminal").empty().append("<option value='' selected disabled>터미널 선택</option>");
        
        $.ajax({
            type: "POST",
            url: "../getDepartureTerminal",
            data: { selectedArea : selectedArea },
            dataType: "json",
            success: function(data) {
            	console.log(data);
            	if (data.length > 0 ) {
					$("#departureTerminal").children('option:not(:first)').remove();
					data.forEach(function(terminal) {
						var btcode = terminal.bt_code + "";
						if (terminal.bt_code < 100)	btcode = "0" + terminal.bt_code;	// btcode 규격화
						$("#departureTerminal").append("<option id='" + terminal.bt_name + "'value='" + btcode + "'>" + terminal.bt_name + "</option>");
            		});
            	} else {
					alert("조회된 시간표가 없습니다.");
            	}
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", error);
            }
        });
    });

	$("#departureTerminal").change(function() {
        // 선택된 출발 터미널 값을 가져옴
        const selectedTerminal = $(this).val();
        if (selectedTerminal == "터미널 선택") return;
        
        $.ajax({
            type: "POST",
            url: "../getArrTerminal",
            data: { selectedTerminal : selectedTerminal },
            dataType: "json",
            success: function(data) {
            	if (data.length > 0 ) {
					$("#arrivalTerminal").children('option:not(:first)').remove();
					data.forEach(function(terminal) {
						var btcode = terminal.bt_code + "";
						if (terminal.bt_code < 100)	btcode = "0" + terminal.bt_code;	// btcode 규격화
						$("#arrivalTerminal").append("<option value='" + btcode + "'>" + terminal.bt_name + "</option>");
            		});
            	} else {
					alert("조회된 시간표가 없습니다.");
            	}
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", error);
            }
        });
    });
	
	$("#schBtn").click(function(e) {
		// 도착 터미널의 코드로 도착시간 api 호출
		
		const departureArea = $("#departureArea").val();
		const departureTerminal = $("#departureTerminal").val();
		const arrivalTerminal = $("#arrivalTerminal").val();

	    if (!departureArea || departureArea === "지역 선택" || !departureTerminal || departureTerminal === "터미널 선택" || 
	    		!arrivalTerminal || arrivalTerminal === "터미널 선택") {
	    	alert("터미널을 선택해주세요.");
	        e.preventDefault(); // 이벤트 기본 동작 취소
	        
	    } else {
		    const departureTerminal = $("#departureTerminal option:selected").attr("id");	// 출발 터미널 이름(bt_name)	
		    const arrivalTerminal = $("#arrivalTerminal").val();		// 도착 터미널 코드(bt_code) api 호출용

		    $.ajax({
		        type: "POST", 
		        url: "../getArrivalTimeInfo",
		        data: { departureTerminal: departureTerminal, arrivalTerminal: arrivalTerminal },
		        dataType: "json",
		        success: function(data) {
					let tableHTML = "<table class='table'>" + 
										"<colgroup><col width='15%'><col width='10%'><col width='15%'><col width='15%'>" +
										"<col width='15%'><col width='15%'><col width='15%'></colgroup>" + 
										"<thead class='bg-light'><tr>" + 
										"<th scope='col' class='text-center'>출발시간</th><th scope='col' class='text-center'>고속사</th>" + 
										"<th scope='col' class='text-center'>등급</th><th scope='col' class='text-center'>차량번호</th>" + 
										"<th scope='col' class='text-center'>도착예정시간</th><th scope='col' class='text-center'>남은시간</th>" + 
										"<th scope='col' class='text-center'>상태</th></tr></thead><tbody>";
		            if (data.length > 0) {
		                data.forEach(function(table) {
		                	if (table.status == "도착") {
		                		table.status = "<span class='badge rounded-pill bg-secondary text-white font-weight-normal'>도착</span>";
		                	} else if (table.status == "운행중") {
		                		table.status = "<span class='badge rounded-pill bg-primary text-white font-weight-normal'>운행중</span>";
		                	}
		                    tableHTML += "<tr>";
		                    tableHTML += "<td>" + table.stime + "</td>";
		                    tableHTML += "<td>" + table.com + "</td>";
		                    tableHTML += "<td>" + table.grade + "</td>";
		                    tableHTML += "<td>" + table.num + "</td>";
		                    tableHTML += "<td>" + table.etime + "</td>";
		                    tableHTML += "<td>" + table.ltime + "</td>";
		                    tableHTML += "<td class='align-middle'>" + table.status + "</td>";
		                    tableHTML += "</tr>";
		                });
		                tableHTML += "</tbody></table>";
		                
		            } else { // 데이터가 없는 경우
		            	tableHTML += "<tr><td colspan='8'>조회된 시간표가 없습니다.</td></tr></tbody></table>"
		            }
		            
		            $("#timetable").html(tableHTML);
	                $("#timetable-container").show();
		        },
		        error: function(xhr, status, error) {
		            console.error("AJAX Error:", error);
		        }
		    });
	    }
	});
});
</script>