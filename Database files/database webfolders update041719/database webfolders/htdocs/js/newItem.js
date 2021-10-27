function displayKits(){
	var checkBox = document.getElementById("kitCheckBox");
	var kitDiv = document.getElementById("kitDiv");
	
	if(checkBox.checked == true){
		kitDiv.style.display = "block";
	}else{
		kitDiv.style.display = "none";
	}
}

function addKit(){
	var checkBox = document.getElementById("addNewKit");
	var newKit = document.getElementById("newKit");
	
	if(checkBox.checked == true){
		newKit.style.display = "block";
	}else{
		newKit.style.display = "none";
	}
}
function addItems(){
	var checkBox = document.getElementById("addItems");
	var instances = document.getElementById("instances");
	
	if(checkBox.checked == true){
		instances.style.display = "block";
	}else{
		instances.style.display = "none";
	}
}

//Perform Page startup tasks
function pageStartup(){
	document.getElementById("kitCheckBox").addEventListener("click", displayKits, false);
	document.getElementById("addNewKit").addEventListener("click", addKit, false);
	document.getElementById("addItems").addEventListener("click", addItems, false);
}

//addEventListener() to trigger all code
window.addEventListener("load", pageStartup, false);
