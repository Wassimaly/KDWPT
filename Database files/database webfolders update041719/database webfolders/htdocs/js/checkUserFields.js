validateForm(){
	boolean valid = true;
	var ErrorReport = document.getElementById('formError');
	var UserName = document.getElementById('str_UserName').value;
	var email = document.getElementById('str_Email').value;
	var vEmail = document.getElementById('str_vEmail').value;
	var passwrd = document.getElementById('str_UserPass=').value;
	var vPasswrd = document.getElementById('str_vUserPass').value;
	var fname = document.getElementById('str_FirstName').value;
	var lname = document.getElementById('str_LastName').value;
	var phone = document.getElementById('str_UserName').value;
	var county = document.getElementById('County').value;
	var address = document.getElementById('str_UserName').value;
	var city = document.getElementById('str_UserName').value;
	var zip = document.getElementById('str_UserName').value;

	if(UserName == ""){
		ErrorReport.textContent += "Please enter user name."
		valid = false;
	}
}

//addEventListener() to trigger all code
window.addEventListener("load", pageStartup, false);