<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="modal-header">
	<h5 class="modal-title" id="exampleModalLabel">페이머니 충전</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">
	<form name="frm" action="" method="">
		<label for="chagePay" class="font-weight-bold">충전 금액</label>
		<div class="probootstrap-date-wrap">
			<span id="resetVal" class="icon ion-android-close"></span> 
			<input type="text" id="chargeFluid" class="form-control form-control-lg" required maxlength="8">
		</div>
		<div class="mt-2">
			<button type="button" class="btn-success btn-sm plus-charge" value="10000">+1만</button>
			<button type="button" class="btn-success btn-sm plus-charge" value="50000">+5만</button>
			<button type="button" class="btn-success btn-sm plus-charge" value="100000">+10만</button>
			<button type="button" class="btn-success btn-sm plus-charge" value="500000">+50만</button>
		</div>
	    <div class="mt-2 d-flex justify-content-between">
			<span>결제 금액</span><span id="realAmount"></span>
	    </div>
	    <div class="d-flex justify-content-between">
			<span>추가 적립(<span id="bonusVal"></span>%)</span><span id="bonusAmount"></span>
	    </div>
	    <hr class="mt-0"/>
	    <div class="mt-2 d-flex justify-content-between">
			<p class="h6">충전 예정 페이머니</p><p class="h6" id="totalPoint"></p>
	    </div>
	    <p class="font-weight-bold mt-2 mb-1">결제 방법</p>
	    <div>
			<div class="form-check custom ml-0">
				<input class="form-check-input" type="radio" name="payment" id="card" value="card" checked />
				<label class="form-check-label" for="card">카드</label>
			</div>
			<div class="form-check custom">
				<input class="form-check-input" type="radio" name="payment" id="bankbook" value="bankbook" />
				<label class="form-check-label" for="bankbook">무통장입금</label>
			</div>
			<div class="form-check custom">
				<input class="form-check-input" type="radio" name="payment" id="simplepay" value="simplepay" />
				<label class="form-check-label" for="simplepay">간편결제</label>
			</div>
	    </div>
	    <div class="form-check custom ml-0">
			<input class="form-check-input" type="checkbox" id="agreeP">
			<label class="form-check-label" for="agreeP"><span class="text-danger">[필수]</span> 상품, 가격, 결제 전 주의사항 확인</label>
	    </div>
	</form>
</div>
<div class="modal-footer">
  <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
  <button type="button" id="PopBtnPaymoney" class="btn btn-primary">충전</button>
</div>
<script>
	
	const chargeFluid = document.getElementById("chargeFluid");
	const bonusVal = 10;		// 추가적립율
	const maxFluid = 1000000;	// 1회 충전 최대금액
	let flag = true;	 // 무한 alert을 방지하기위한 boolean 변수
	
	// 할인율 설정
	document.querySelector("#bonusVal").innerText = bonusVal;
	
	chargeFluid.addEventListener("keyup", function(e) {
		let value = e.target.value;
		value = Number(value.replaceAll(',', ''));
		chargeFluid.value = value.toLocaleString("ko-KR");
	});
	
	chargeFluid.addEventListener("blur", function(e) {
		let value = e.target.value;
		if (!(value.length > 5) && flag) {
			alert("최소 충전 금액은 10,000원입니다.");
			flag = false;
		} else if (value.length > 8) {	// 백만 단위일 경우 1회 최대 100만원까지 
			value = Number(value.replaceAll(',', ''));
			if (value > maxFluid) {
				alert("최대 충전 금액은 1,000,000원입니다.");
				chargeFluid.value = maxFluid.toLocaleString("ko-KR");
			}
		} else {
			flag = true;
			value = Number(value.replaceAll(',', ''));
			value = Math.floor(value / 10000) * 10000
			chargeFluid.value = value.toLocaleString("ko-KR");
		}
		
		changePay();
	});
	
	// 초기화 버튼
	document.querySelector('#resetVal').addEventListener('click', function() {
		chargeFluid.value = "";
		document.getElementById("realAmount").innerHTML = "";
		document.getElementById("bonusAmount").innerHTML = "";
		document.getElementById("totalPoint").innerHTML = ""; 
	});
	
	// 각 금액 추가버튼 클릭시 호출 함수
	const addAmount = function(amount) {
		let value = Number(chargeFluid.value.replaceAll(',', ''));
		if (value > maxFluid) {
			alert("최대 충전 금액은 1,000,000원입니다.");
			chargeFluid.value = maxFluid.toLocaleString("ko-KR");
			return;
		}
		console.log(value+Number(amount));
		chargeFluid.value = (value+Number(amount)).toLocaleString("ko-KR");
	}
	
	// 금액 추가 버튼에 event listener 등록
	const PLUS_CHARGE = document.querySelectorAll(".plus-charge");
	PLUS_CHARGE.forEach(function(button) {
	    button.addEventListener("click", function() {
	        const buttonVal = button.getAttribute("value");
	        addAmount(buttonVal);
	        changePay();
	    });
	});

	const successModal = function(chargeAmount) {
		// 팝업 내용이 모두 로드된후 값이 보이도록 콜백함수 지정
		$("#PayMoneyModal .modal-content").load("/busjavaf/pmoneyCharge2", function() {
			document.getElementById("resultAmount").innerHTML = chargeAmount.toLocaleString("ko-KR");
			document.getElementById("resultBonus").innerHTML = (chargeAmount * (bonusVal / 100)).toLocaleString("ko-KR");
			document.getElementById("resultTotal").innerHTML = (chargeAmount + chargeAmount * (bonusVal / 100)).toLocaleString("ko-KR");
			document.getElementById("bonusVal").innerText = bonusVal;
		});
		
	  }
	
	let realAmount = 0;
	// 결제금액, 추가적립금액, 총 충전금액 계산함수
	const changePay = function () {
		realAmount = Number(chargeFluid.value.replaceAll(',', ''));
		const totalPoint = realAmount + realAmount * (bonusVal / 100);
		
		document.getElementById("realAmount").innerHTML = chargeFluid.value;
		document.getElementById("bonusAmount").innerHTML = (realAmount * (bonusVal / 100)).toLocaleString("ko-KR");
		document.getElementById("totalPoint").innerHTML = totalPoint.toLocaleString("ko-KR"); 
	}
	
	$("#PopBtnPaymoney").on("click", function() {
		let payment = $("input[type=radio][name=payment]:checked").val();	// 충전방식
		let agreeP = document.getElementById("agreeP");
		
		if (chargeFluid.value == "") {
			alert("충전할 금액을 입력해 주세요.");
			return;
		}

		if (!agreeP.checked) {
			alert("약관에 동의해 주세요.");
			return;
		}
		changePay();
		
		$.ajax({
		      url: "/busjavaf/chargePaymoney",
		      type: "POST",
		      data: {
		        realAmount: Number(chargeFluid.value.replaceAll(',', '')),
		        payment: payment
		      },	
		      dataType: "json",
		      success: function(data) { 
		    	  successModal(realAmount);
		      },
		      error: function(xhr, status, error) {
		    	  alert("페이머니 충전에 실패했습니다.");
		    	  return;
		      }
		});
	});
</script>