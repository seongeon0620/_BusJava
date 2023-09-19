<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용해 주세요.'); location.href='/adminbusj/login' ");
	out.println("</script>");
	out.close();
}
List<BusLineInfo> busLineList = (List<BusLineInfo>)request.getAttribute("busLineList");
List<BusInfo> busInfo = (List<BusInfo>)request.getAttribute("busInfo");
String kind = request.getParameter("kind");
String tmp11 = "고속";
if (!kind.equals("h"))
	tmp11 = "시외";
%>
<script>
function delLine(lineNum) {
	var bt_idx = <%=request.getParameter("bt_idx") %>;
	var bt_name = "<%=request.getParameter("bt_name") %>";
	var kind = "<%=kind%>";
	if(confirm("해당 노선을 정말 삭제하시겠습니까?\n삭제 후 복구 불가능합니다.")){
		location.href="LineDel?kind=" + kind + "&bt_idx=" + bt_idx + "&bt_name=" + bt_name + "&lineNum=" + lineNum;
	}
}

function openModal(area) {
	var bt_name = "<%=request.getParameter("bt_name") %>";
	var kind = "<%=kind%>";
	$('#AddLine .modal-content').load("/adminbusj/popUpLineAdd?kind=" + kind + "&bt_idx=" + 
	<%=request.getParameter("bt_idx")%> + "&bt_name=" + bt_name);
	$('#AddLine').modal();
}

function companyChange(num){
	var inputStateValue = document.getElementById("company"+ num).value;
	var numberOptions = document.getElementById("number"+ num).options;

	for (var i = 0; i < numberOptions.length; i++) {
		var option = numberOptions[i];
		var option2 = option.value;
		var arrOption = option2.split(":");
	    if (inputStateValue == '' || arrOption[0] == inputStateValue) {
	    	option.style.display = 'block';
	    	
	    } else {
	    	option.style.display = 'none';
		}
		
	}
}

var chk = true;
var n1 = 0, n2 = 0, n3 = 0;
function numberChange(blidx) {
	var number = document.getElementById('number' + blidx).value;
	var arr = number.split(":");
	var carId = arr[1];
	var kind = "<%=kind%>";

	if (carId != "") {
		$.ajax({
			type: "POST",
			url: "./changeLevel",
			data: { "number": carId, "kind": kind },
			success: function (chkRs) {
				var msg = "";
				if (chkRs == 0) {
					msg = "<input type='text' class='text-center mt-1' id='level' style='width:100px; border:0; text-align:center' value='우등' readonly='readonly' />";
					if (kind == 'h') {
						if (!chk) {
							updateValues(blidx, kind, 1/1.5);
							chk = true;
						}
					} else {
						if (!chk) {
							updateValues(blidx, kind, 1.5);
							chk = true;
						}
					}
					
				} else {
					if (kind == 'h') {
						msg = "<input type='text' class='text-center mt-1' id='level' style='width:100px; border:0; text-align:center' value='프리미엄' readonly='readonly' />";
						if (chk) {
							updateValues(blidx, kind, 1.5);
							chk = false;
						}
					} else {
						msg = "<input type='text' class='text-center mt-1' id='level' style='width:100px; border:0; text-align:center' value='일반' readonly='readonly' />";
						if (chk) {
							updateValues(blidx, kind, 1/1.5);
							chk = false;
						} 
					}
				}
				$("#msg" + blidx).html(msg);
			}
		});
	}
}

function updateValues(blidx, kind, factor) {
	if (chk) {
		n1 =  parseFloat(document.getElementById("common" + blidx).value.replace(",", ""));	
		n2 =  parseFloat(document.getElementById("teenager" + blidx).value.replace(",", ""));
		n3 =  parseFloat(document.getElementById("child" + blidx).value.replace(",", ""));
	}
	var sale1Value = parseFloat(document.getElementById("common" + blidx).value.replace(",", ""));
	var sale2Value = parseFloat(document.getElementById("teenager" + blidx).value.replace(",", ""));
	var sale3Value = parseFloat(document.getElementById("child" + blidx).value.replace(",", ""));
	sale1Value = Math.round(sale1Value);
	sale2Value = Math.round(sale2Value);
	sale3Value = Math.round(sale3Value);
	document.getElementById('common' + blidx).value = formatNumber("c", sale1Value, factor) + "원";
	document.getElementById('teenager' + blidx).value = formatNumber("t", sale2Value, factor) + "원";
	document.getElementById('child' + blidx).value = formatNumber("d", sale3Value, factor) + "원";
}


function formatNumber(type, number, factor) {
	if (!chk) {
		if (type == "c") {
			number = Math.ceil(n1);	
		} else if (type == "t") {
			number = Math.ceil(n2);
		} else {
			number = Math.ceil(n3);
		}
		
	}else {
		number = Math.ceil(number * factor / 100) * 100;
	}
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function delShcedule(bsidx) {
	if(confirm('정말 삭제하시겠습니까?')) {
		$.ajax({
			type : "POST", 				
			url : "./delShcedule", 
			data : {"bsidx" : bsidx}, 		
			success : function(chkRs){	
				if (chkRs == 1) {	
					location.reload();
				} else {	
					alert('삭제에 실패했습니다.');
				}
			}
		});
	}
	event.preventDefault(); // form 액션 실행을 막음
}

function scheduleAdd(blidx){
	var tbodyElement = document.getElementById("disAdd" + blidx);
		if (tbodyElement) {
		tbodyElement.style.display = "";
	}
}
</script>
<style>
.paddingRL { padding:10px 30px; }
</style>
<div class="page-wrapper">
	<div class="page-breadcrumb">
		<div class="d-flex justify-content-between">
		<h3 class="page-title text-truncate text-dark font-weight-bold"><%=request.getParameter("bt_name") %> <%=tmp11 %>버스 터미널 시간표 관리</h3>
		<button type="button" class="btn waves-effect waves-light btn-primary ml-5" 
			onclick="openModal();">노선추가</button>
		</div>	
		<div class="d-flex align-items-center">
		    <nav aria-label="breadcrumb">
		        <ol class="breadcrumb m-0 p-0">
		            <li class="breadcrumb-item"><a href="/adminbusj" class="text-muted">홈</a></li>
<% if (tmp11.equals("고속")) { %>
					<li class="breadcrumb-item"><a href="terminal?kind=h" class="text-muted">고속버스 터미널 관리</a></li>
<% } else { %>
					<li class="breadcrumb-item"><a href="terminal?kind=s" class="text-muted">시외버스 터미널 관리</a></li>
<% } %>
		            <li class="breadcrumb-item text-muted active" aria-current="page"><%=request.getParameter("bt_name") %> <%=tmp11 %>버스 터미널 시간표 관리</li>
		        </ol>
		    </nav>
		</div>
	</div>
<div class="container-fluid">
<% if(busLineList.size() == 0) {
	
%>
	<div class="col-lg-12">
		<div class="d-flex justify-content-between p-1 align-items-center">
			<p class="h3 text-primary">등록된 노선이 없습니다.</p>
		</div>
	</div>
<% } %>
<% for (BusLineInfo bl : busLineList) { %>
	<div class="row">
		<div class="col-lg-12">
		<div class="card">
			<div class="card-body">
				<div class="d-flex justify-content-between align-items-center mb-2">
				<p class="h3 font-weight-bold mb-0"><%=bl.getBt_name() %><%=tmp11 %>버스터미널</p>
				<div class="d-flex justify-content-between float_right">
				<button type="button" class="btn float-right btn-danger mr-2" id="bl_idx" 
				value="<%=bl.getBl_idx() %>" onclick="delLine(this.value);">노선삭제</button>
				<button type="button" class="btn waves-effect waves-light btn-primary" id="scheduleAd" value="<%=bl.getBl_idx() %>"
				 onclick="scheduleAdd(this.value);">시간표 추가</button>
				</div>		
		</div>
		<form name="frmIn" action="scheduleAdd" method="post">
		<input type="hidden" name="kind" value="<%=kind %>" />
		<input type="hidden" name="bl_idx" value="<%=bl.getBl_idx() %>" />
		<input type="hidden" name="bt_idx" value="<%=request.getParameter("bt_idx") %>" />
		<input type="hidden" name="bt_name" value="<%=request.getParameter("bt_name") %>" />
		<input type="hidden" name="adult<%=bl.getBl_idx() %>" value="<%=bl.getBl_adult() %>" />
		<table class="table text-center mb-0 padding-size-sm">
			<colgroup>
				<col width="10%">
				<col width="10%">
				<col width="12%">
				<col width="*">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="12%">
			</colgroup>
            <thead class="bg-primary text-white">
                <tr>
                    <th>출발시간</th>
                    <th>도착시간</th>
                    <th>회사명</th>
                    <th>차량번호</th>
                    <th>등급</th>
                    <th>성인요금</th>
                    <th>청소년요금</th>
                    <th>아동요금</th>
                    <th>삭제</th>
                </tr>
            </thead>
<% 
	if (bl.getBusScheduleInfo().size() > 0) {
		for (BusScheduleInfo bs : bl.getBusScheduleInfo()) {
			
%>
            
            <tbody class="border border-primary ">
                <tr>
                    <td><input type="text" class="text-center" name="stime" style="width:100px; border:0;"  
                    value="<%=bs.getBs_stime() %>" readonly="readonly" /></td>
                    <td><input type="text" class="text-center" name="etime" style="width:100px; border:0;"  
                    value="<%=bs.getBs_etime() %>" readonly="readonly" /></td>
                    <td><input type="text" class="text-center" name="bc_name" style="width:100px; border:0;" 
                    value="<%=bs.getBc_name() %>고속" readonly="readonly" /></td>
                    <td><input type="text" class="text-center" name="bi_num" style="width:100px; border:0;"  
                    value="<%=bs.getBi_num() %>" readonly="readonly" /></td>
                    <td><input type="text" class="text-center" name="bi_level" style="width:100px; border:0;" 
                    value="<%=bs.getBi_level() %>" readonly="readonly" /></td>
<% 
String tmp = "";
String tmp1 = "";
String tmp2 = "";

if (!bs.getBi_level().equals("우등")) {
    if (kind.equals("h")) {
        tmp += Math.ceil(bl.getBl_adult() * 1.5 * 0.8 / 100) * 100;
        tmp1 += Math.ceil((bl.getBl_adult() * 1.5) / 100) * 100;
        tmp2 += Math.ceil(bl.getBl_adult() * 1.5 * 0.5 / 100) * 100;
    } else {
        tmp += Math.ceil(bl.getBl_adult() / 1.5 * 0.8 / 100) * 100;
        tmp1 += Math.ceil(bl.getBl_adult() / 1.5 / 100) * 100;
        tmp2 += Math.ceil(bl.getBl_adult() / 1.5 * 0.5 / 100) * 100;
    }

} else {
    tmp += Math.ceil(bl.getBl_adult() * 0.8 / 100) * 100;
    tmp1 += Math.ceil(bl.getBl_adult() / 100) * 100;
    tmp2 += Math.ceil(bl.getBl_adult() * 0.5 / 100) * 100;
}
	
StringBuffer sb = new StringBuffer();
StringBuffer sb1 = new StringBuffer();
StringBuffer sb2 = new StringBuffer();

int tmpInt = (int) Math.ceil(Double.parseDouble(tmp));
int tmp1Int = (int) Math.ceil(Double.parseDouble(tmp1));
int tmp2Int = (int) Math.ceil(Double.parseDouble(tmp2));


sb.append(tmpInt);
if (sb.length() < 5)
	sb.insert(1, ",");
else 
	sb.insert(2, ",");

sb1.append(tmp1Int);
if (sb1.length() < 5)
	sb1.insert(1, ",");
else 
	sb1.insert(2, ",");

sb2.append(tmp2Int);
if (sb2.length() < 5)
	sb2.insert(1, ",");
else 
	sb2.insert(2, ",");


%>
					<td><input type="text" class="text-center" style="width:100px; border:0;" 
                    value="<%=sb1 %>원" readonly="readonly" /></td>
					<td><input type="text" class="text-center" style="width:100px; border:0;" 
                    value="<%=sb %>원" readonly="readonly" /></td>
                    <td><input type="text" class="text-center" style="width:100px; border:0;" 
                    value="<%=sb2 %>원" readonly="readonly" /></td>
                    <td style="padding:5px;">
                    <button class="btn waves-effect waves-light btn-outline-secondary" value="<%=bs.getBs_idx() %>"
                    onclick="delShcedule(this.value);">삭제</button>
                    </td>
                </tr>
            </tbody>
<%
		} 
	} else {
%>
			<tbody class="border border-primary">
            	<tr>
            		<td colspan="8">운행중인 시간표가 없습니다.</td>
            	</tr>
            </tbody>
<%	} %>
			
			<tbody id="disAdd<%=bl.getBl_idx() %>" style="display:none;" class="border border-primary">
                <tr style="" id="dis">
                    <td>
                    	<div class="custom-date">
                    		<span><i class="icon-clock"></i></span>
    						<input type="text" name="time1" id="time1" class="form-control timepicker text-center" oninput="updateTime2Options(this.value);" >
    					</div>
				    </td>
                    <td>
                    	<input type="text" name="time2" id="time2" class="form-control timepicker" >
                    </td>
                    <td style="padding:10px 20px;">
                    <select class="form-control text-center" id="company<%=bl.getBl_idx() %>" name="company" onchange="companyChange(<%=bl.getBl_idx() %>);">
                    	<option value="">회사명</option>
                    	<option value="금호">금호고속</option>
                    	<option value="동부">동부고속</option>
                    	<option value="동양">동양고속</option>
                    	<option value="중앙">중앙고속</option>
                    </select>
                    </td>
                    <td style="padding:10px 50px;">
                    <select class="form-control text-center" id="number<%=bl.getBl_idx() %>" name="number" onchange="numberChange(<%=bl.getBl_idx() %>);">
                    	<option value="">차량번호</option>
<% for (BusInfo bi : busInfo) { %>
						<option value="<%=bi.getBc_name() %>:<%=bi.getBi_num() %>"><%=bi.getBi_num() %></option>
<% } %>
                    </select>
                    </td>
                    <td style="padding:10px 20px;">
                    <span id="msg<%=bl.getBl_idx()%>"><input type='text' class='text-center mt-1' id='level' style='width:100px; border:0; text-align:center' value='우등' readonly='readonly' /></span>
                    </td>
<%
String tmp = "";
String tmp1 = "";
String tmp2 = "";

tmp += Math.ceil(bl.getBl_adult() * 0.8 / 100) * 100;
tmp1 += Math.ceil(bl.getBl_adult() / 100) * 100;
tmp2 += Math.ceil(bl.getBl_adult() * 0.5 / 100) * 100;
	
StringBuffer sb = new StringBuffer();
StringBuffer sb1 = new StringBuffer();
StringBuffer sb2 = new StringBuffer();

int tmpInt = (int) Math.ceil(Double.parseDouble(tmp));
int tmp1Int = (int) Math.ceil(Double.parseDouble(tmp1));
int tmp2Int = (int) Math.ceil(Double.parseDouble(tmp2));


sb.append(tmpInt);
if (sb.length() < 5)
	sb.insert(1, ",");
else 
	sb.insert(2, ",");

sb1.append(tmp1Int);
if (sb1.length() < 5)
	sb1.insert(1, ",");
else 
	sb1.insert(2, ",");

sb2.append(tmp2Int);
if (sb2.length() < 5)
	sb2.insert(1, ",");
else 
	sb2.insert(2, ",");

%>
                    <td><input type="text" id="common<%=bl.getBl_idx() %>" class="text-center mt-1" style="width:100px; border:0; text-align:center" 
                    value="<%=sb1 %>원" readonly="readonly" /></td>
                    <td><input type="text" id="teenager<%=bl.getBl_idx() %>" class="text-center mt-1" style="width:100px; border:0; text-align:center" 
                    value="<%=sb %>원" readonly="readonly" /></td>
                    <td><input type="text" id="child<%=bl.getBl_idx() %>" class="text-center mt-1" style="width:100px; border:0; text-align:center" 
                    value="<%=sb2 %>원" readonly="readonly" /></td>
                    <td><input class="btn waves-effect waves-light btn-primary" type="submit" value="등록" /></td>
                </tr>
            </tbody>
        </table>
        </form>
		</div>
		</div>
		</div>
	</div>
<% } %>
	
</div>
</div>
<div class="modal fade" id="AddLine" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
        </div>
    </div>
</div>
</section>
<script>

$(function () {
    $(".timepicker").timepicker({
        timeFormat: 'HH:mm',
        interval: 10,
        minTime: '00:00',
        maxTime: '23:59',
        defaultTime: '06:00',
        startTime: '06:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
        /*
        change: function (time) {
            var from_time = $("#time1").val(); // time1에서 선택한 값
            $("#time2").timepicker('option', 'minTime', from_time); // time2의 minTime 변경

            // time2가 time1보다 작은 경우, time2를 time1과 동일하게 설정
            if ($("#time2").val() && $("#time2").val() < from_time) {
                $("#time2").timepicker('setTime', from_time);
            }
        }*/
        
    });
      
/*
    $("#time2").timepicker({
        timeFormat: 'HH:mm',
        interval: 10,
        minTime: '00:00',
        maxTime: '23:59',
        defaultTime: '07:00',
        startTime: '07:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
        
    });*/
    
});

</script>
<%@ include file="../_inc/foot.jsp" %>