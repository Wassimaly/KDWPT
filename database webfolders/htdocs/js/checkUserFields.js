function validateForm(){
	console.log("Starting validation");
	var valid = true;
	var ErrorReport = document.getElementById('formError');
	var UserName = document.getElementById('str_UserName').value;
	var email = document.getElementById('str_Email').value;
	var vEmail = document.getElementById('str_vEmail').value;
	var passwrd = document.getElementById('str_UserPass').value;
	var vPasswrd = document.getElementById('str_vUserPass').value;
	var fname = document.getElementById('str_FirstName').value;
	var lname = document.getElementById('str_LastName').value;
	var phone = document.getElementById('str_UserName').value;
	var address = document.getElementById('str_UserName').value;
	var city = document.getElementById('str_UserName').value;
	var zip = document.getElementById('str_UserName').value;

	//Reset Error Report
	ErrorReport.innerHTML = "";
	if(UserName == ""){
		ErrorReport.innerHTML += "Please enter user name.<br>"
		event.preventDefault();
		valid = false;
	}
	if(email == ""){
		ErrorReport.innerHTML += "Please enter email address.<br>";
		event.preventDefault();
		valid = false;
	}
	if(email != vEmail){
		ErrorReport.innerHTML += "Email addresses do not match.<br>";
		event.preventDefault();
		valid = false;
	}
	if(passwrd == ""){
		ErrorReport.innerHTML += "Please enter a password.<br>";
		event.preventDefault();
		valid = false;
	}
	else if(passwrd != vPasswrd){
		ErrorReport.innerHTML += "Passwords do not match.<br>";
		event.preventDefault();
		valid = false;
	}
	if(fname == ""){
		ErrorReport.innerHTML += "Please enter first name.<br>";
		valid = false;
		event.preventDefault();
	}
	if(lname == ""){
		ErrorReport.innerHTML += "Please enter last name.<br>";
		valid = false;
		event.preventDefault();
	}
	if(phone == ""){
		ErrorReport.innerHTML += "Please enter phone number.<br>";
		valid = false;
		event.preventDefault();
	}
	if(address == ""){
		ErrorReport.innerHTML += "Please enter address.<br>";
		valid = false;
		event.preventDefault();
	}
	if(city == ""){
		ErrorReport.innerHTML += "Please enter city.<br>";
		valid = false;
		event.preventDefault();
	}
	if(zip == ""){
		ErrorReport.innerHTML += "Please phone zip code.<br>";
		valid = false;
	}
	return valid;
}
/*
//Perform Page startup tasks
function pageStartup(){
	document.getElementById("submit").addEventListener("click", validateForm, false);
}


//addEventListener() to trigger all code
window.addEventListener("load", pageStartup, false);
*/
