//Definte variable
var earliest = new Date();
var dd = earliest.getDate()+3;
var mm = earliest.getMonth()+1;
var yyyy = earliest.getFullYear();

earliest = mm + '/' + dd + '/' + yyyy;

//Check the dates together. Don't allow submission if they don't work.
function checkDates(){
	
	//Variables
	var holder = document.getElementsByTagName("input");
	var canSubmit = true;
	var submitBtn = document.getElementById("submit");
	
	for(i = 0; i < holder.length; i++){
		if(holder[i].name == "dateOut" + i){
			var dt = new date();
			var dt2 = new date();
			dt = holder[i].value;
			dt2 = holder[i+1].value;
			if (dt < earliest){
				canSubmit = false;
				//Complain that the first date is too early. Must be at least 3 days in the future.
			} 
			if(dt <= dt2){
				canSubmit = false;
				//Complain that the checkout has to be before the checkin.
			}
		}
	}
	if(canSubmit){
		submitBtn.disabled = false;
	}
	else{
		submitBtn.disabled = true;
	}
}

//All the default listeners go here
function pageStartup(){
	document.getElementsByTagName("input").addEventListener("click", checkDates, false);
}

window.addEventListener("load", pageStartup, false);