<!DOCTYPE html>
<html>
	<head>
		<title>KDWPT::Library Catalogue</title>
		<link rel="stylesheet" href="../css/table.css">
	</head>
	<body>
	<form method="post">
	<?php
		session_start();
		//Test variable: Comment out on when not testing
		require_once('../php/test_session.php');
		//If the user isn't logged in, boot them back to the login page.
		if(!isset($_SESSION['UserID'])){
			header("Location:login_user.html.php");
		}
		else{
			require_once('../php/display_catalogue.php');
			create_table();
		}
	?>
	
	</body>
</html>