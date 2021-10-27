function canSubmit(){
	var radio = document.getElementsByName("library");
	var isChecked = false;
	for(i = 0; i < radio.length; i++){
		if(radio[i].checked){
			isChecked = true;
			i = radio.length;
		}
	}
	var agree = document.getElementById("agree").checked;
	var submitBtn = document.getElementById("submit");
	if (isChecked == true && agree == true){
		submitBtn.disabled = false;
	}
	else{
		submitBtn.disabled = true;
	}
}
function showWarning(){
	var KSCRadio = document.getElementById("KSC");
	if(KSCRadio.checked){
		document.getElementById("KCLib").style.display = "block";
	}
	else{
		document.getElementById("KCLib").style.display = "none";
	}
}
function pageStartup(){
	document.getElementById("agree").addEventListener("click", canSubmit, false);
	document.addEventListener("click", showWarning, false);
}
window.addEventListener("load", pageStartup, false);