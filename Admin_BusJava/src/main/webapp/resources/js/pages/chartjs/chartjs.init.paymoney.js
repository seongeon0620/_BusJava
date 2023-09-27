$(function() {
	const ctgrTop = JSON.parse(ctgrTopJson);
	const ctgrToplabels = ctgrTop.map(item => item.payment);
	const ctgrTopdata = ctgrTop.map(item => item.salse);

	"use strict";

	new Chart(document.getElementById("ctgrTopPie"), {
		type: 'pie',
		data: {
			labels: ctgrToplabels,
			datasets: [{
				label: "Population (millions)",
				backgroundColor: ["#5e73da", "#5f76e8", "#b1bdfa"],
				data: ctgrTopdata
			}]
		},
		options: {
			title: {
				display: false
			}
		}
	});

	new Chart(document.getElementById("salseLine"), {
		type: 'line',
		data: {
			labels: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
			datasets: [{
				data: salseOld,
				label: "2022년",
				borderColor: "#5f76e8",
				fill: false
			}, {
				data: salse,
				label: "2023년",
				borderColor: "#768bf4",
				fill: false
			}
			]
		},
		options: {
			title: {
				display: true
			}
		}
	});



}); 