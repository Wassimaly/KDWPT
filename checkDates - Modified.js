

var $ = function(id) {
	return document.getElementById(id);
};
	
	function checkDates(){
    var date = new Date();
	date.setDate(date.getDate() + 3);
	return formatDate(date);
	}
	
	function formatDate(date) {
		var day = date.getDate();
		var month = date.getMonth() + 1;
		var year = date.getFullYear();
		if (month < 10) month = "0" + month;
		if (day < 10) day = "0" + day;

		var today = year + "-" + month + "-" + day ; 

		return today;
	}

	console.log(checkDates());
	 var checkboxes=document.querySelectorAll("input[type='checkbox']")
	
	 for (var i = 0; i<checkboxes.length; i++){
		//variables for the Dateboxes
		let dOut = document.querySelector("#dateOut" + i );	
		let dIn = document.querySelector("#dateIn" + i );
		//make the Checkout datebox 3 days from today
		dOut.setAttribute("min", checkDates());
		//make checkin datebox ranged between the checkout date and 14 days from it
		dOut.addEventListener("change", function(){
			//make the minimum date the checkout date		
			var minDate= new Date(dOut.value);
			minDate.setDate(minDate.getDate() + 1 );
			var mindate= formatDate(minDate);
			dIn.setAttribute('min', mindate);
			//make the maximum date 14 days from the checkout date
			var maxDate= new Date(dOut.value);
			maxDate.setDate(maxDate.getDate() + 365);
			var oneyear= formatDate(maxDate);
			dIn.setAttribute('max', oneyear);
			
			//Prevent choosing of weekends
			var selectdate= new Date(dOut.value);
			var selectedday= selectdate.getDay();
			console.log(selectedday);
			if (selectedday == 5 || selectedday == 6 ){
				selectdate.setDate(selectdate.getDate() + 8-selectedday);
				dOut.value = formatDate(selectdate);
				window.alert("You cannot choose weekends for check out or return dates.");
			}
			//Set default of 2 weeks for return date
			if(dIn.value == ""){
				selectdate.setDate(selectdate.getDate()+15);
				dIn.value = formatDate(selectdate);
			}
		});
		
		dIn.addEventListener("change", function(){
			var selectdate= new Date(dIn.value);
			var selectedday= selectdate.getDay();
			console.log(selectedday);
			
			//Disallow weekends
			if (selectedday == 5 || selectedday == 6 ){
				selectdate.setDate(selectdate.getDate() + 8-selectedday);
				dIn.value = formatDate(selectdate);
				window.alert("You cannot choose weekends for check out or return dates.");
			}
		})
		checkboxes[i].onclick=function(){
		
			dOut.disabled=!dOut.disabled;
			dIn.disabled=!dIn.disabled;
		}
		
		if (checkboxes[i].checked) {
	 }
			else{
				dIn.disabled=true;
				dOut.disabled=true;
			
			}	
	 }
function checkSubmit(){
	let subbtn = document.getElementById("submit");
	var checkboxes=document.querySelectorAll("input[type='checkbox']");
	let legal = true;
	
	for(var i = 0; i < checkboxes.length; i++){
		if(checkboxes[i].checked == true){
			let dOut = document.querySelector("#dateOut" + i );	
			let dIn = document.querySelector("#dateIn" + i );
			if(dOut.value == "" || dIn.value == ""){
				legal = false;
				break;
			}
		}
	}
	if(legal){
		subbtn.disabled= false;
	}
	else subbtn.disabled = true;
}
function pageStartup(){
	document.addEventListener("click", checkSubmit, false);
	document.addEventListener("change", checkSubmit, false);
}
window.addEventListener("load", pageStartup, false);