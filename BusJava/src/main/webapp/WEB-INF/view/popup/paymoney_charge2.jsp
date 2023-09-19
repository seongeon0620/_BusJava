<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="modal-header">
	<h5 class="modal-title" id="exampleModalLabel">페이머니 충전</h5>
	<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>
<div class="modal-body">
	<div class="circle-complete">
		<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="#ffffff" class="bi bi-check2" viewBox="0 0 16 16">
           <path d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z" />
		</svg>
	</div>
	<p class="text-center">충전 완료</p>
	<img src="">
	<div class="mt-2 d-flex justify-content-between">
		<span>결제 금액</span><span id="resultAmount">0</span>
	</div>
	<div class="d-flex justify-content-between">
		<span>추가 적립(<span id="bonusVal">10</span>%)
		</span><span id="resultBonus"></span>
	</div>
	<hr class="mt-0" />
	<div class="mt-2 d-flex justify-content-between">
		<p class="h6">페이머니</p>
		<p class="h6" id="resultTotal"></p>
	</div>
</div>
<div class="modal-footer">
	<button type="button" id="lastBtn" class="btn btn-primary btn-block" data-dismiss="modal" onclick="location.href='payMoney'">확인</button>
</div>