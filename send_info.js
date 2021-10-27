var $ = function(id) {
	return document.getElementById(id);
};

function question2(){

	 var checkboxes=document.querySelectorAll("input[type='checkbox']")
	
	 for (var i = 0; i<checkboxes.length; i++){
		var info= []
		 if (checkboxes[i].checked) {
			var dOut = document.querySelector("#dateOut" + i )	
			var dIn = document.querySelector("#dateIn" + i )
			var d
			info.push(dOut.value)
			info.push(dIn.value)
				
				console.log(info)
				
		 }
	 }
	 
	}

 
  window.onload=function() {
	$("submitButton").onclick= question2;
	
};