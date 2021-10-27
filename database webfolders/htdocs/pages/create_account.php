<?php
		@session_start();
		//Test variable. Remove when not testing
		unset($_SESSION['login']);
		//Check if the user is logged in
		if(isset($_SESSION['login'])){
			//If so, redirect
			header("Location:../index.html");
		}
		//Otherwise, continue to creation
		else{
			require_once('../php/create_user.php');
		}
?>
