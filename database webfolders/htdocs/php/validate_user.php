<?php

	$UserIsValid = true;

	//Check if username is already in use in database
	$query = mysqli_query($dbc, "SELECT UserName FROM usertable WHERE UserName = $UserName");
	if($UserName == "" || !ctype_alnum($UserName) || strlen($UserName) < 6){
		echo "Please enter valid username: Usernames must contain only letters and/or numbers and be at least 6 characters long.<br>";
		$UserIsValid = false;
	}
	if($Email == ""){
		echo "Please enter an email address.<br>";
		$UserIsValid = false;
	}
	//Basic check on password length
	if(strlen($Password) < 8){
		echo "Password must be at least 8 characters long.<br>";
		$UserIsValid = false;
	}
	//Check if password matches verified password
	if($Password != $vPassword){
		echo "Passwords do not match.<br>";
		$UserIsValid = false;
	}
	
	if($FirstName == ""){
		echo "Please enter first name.<br>";
		$UserIsValid = false;
	}
	if($LastName == ""){
		echo "Please enter last name.<br>";
		$UserIsValid = false;
	}
	if($Phone == ""){
		echo "Please enter phone number.<br>";
		$UserIsValid = false;
	}
	if($Address == ""){
		echo "Please enter address.<br>";
		$UserIsValid = false;
	}
	if($City == ""){
		echo "Please enter city.<br>";
		$UserIsValid = false;
	}
	if($Zip == ""){
		echo "Please enter zip code.<br>";
		$UserIsValid = false;
	}
?>