$(function () {
	
	const hTopLine = JSON.parse(hTopLineJson);
	const hToplabels = hTopLine.map(item => item.line_name);
	const hTopdata = hTopLine.map(item => item.count);
	
	const sTopLine = JSON.parse(sTopLineJson);
	const sToplabels = sTopLine.map(item => item.line_name);
	const sTopdata = sTopLine.map(item => item.count);
	
    "use strict";
    
	new Chart(document.getElementById("hTopPie"), {
		type: 'pie',
		data: {
		  labels: hToplabels,
		  datasets: [{
			label: "Population (millions)",
			backgroundColor: ["#5e73da", "#b1bdfa","#5f76e8","#8fa0f3"],
			data: hTopdata
		  }]
		},
		options: {
		  title: {
			display: false
		  }
		}
	});

	new Chart(document.getElementById("sTopPie"), {
		type: 'pie',
		data: {
		  labels: sToplabels,
		  datasets: [{
			label: "Population (millions)",
			backgroundColor: ["#5e73da", "#b1bdfa","#5f76e8","#8fa0f3"],
			data: sTopdata
		  }]
		},
		options: {
		  title: {
			display: false
		  }
		}
	});
	
	new Chart(document.getElementById("hTopSales"), {
	    type: 'bar',
	    data: {
	      datasets: [{
	        type: 'bar',
	        label: '2022년',
	        data: hSalesQuarterLast,
	        backgroundColor: "#b1bdfa",
	      },
	      {
	        type: 'bar',
	        label: '2023년',
	        data: hSalesQuarterNow,
	        backgroundColor: "#5e73da",
	      }],
	      labels: ['1분기', '2분기', '3분기', '4분기']
	    }
	});

	new Chart(document.getElementById("sTopSales"), {
	    type: 'bar',
	    data: {
	      datasets: [{
	        type: 'bar',
	        label: '2022년',
	        data: sSalesQuarterLast,
	        backgroundColor: "#b1bdfa",
	      },
	      {
	        type: 'bar',
	        label: '2023년',
	        data: sSalesQuarterNow,
	        backgroundColor: "#5e73da",
	      }],
	      labels: ['1분기', '2분기', '3분기', '4분기']
	    }
	});

	

	
}); 