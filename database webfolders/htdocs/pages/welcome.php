<?php
session_start();
	/*if(!isset($_SESSION['UserID'])){
		header('Location:login_user.html.php');
	}*/
	if(isset($_POST['submit'])){
		if(isset($_POST['library'])){
			$_SESSION['library'] = addslashes($_POST['library']);
			$library = $_SESSION['library'];
			header("Location:catalogue.php");
		}

	}
?>
<!--Build page:-->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="../css/table.css">
	</head>
	<body>
	<div id="innerbody">
		<main>
		
			<?php
				$user = $_SESSION['FirstName'];
				echo "Welcome, " . $user .".<br><br> Please select a library to use";
			?>
			<form method="post">
				<input type="radio" name="library" id="KSL" value="KSL">KDWPT State Library<br>
				<input type="radio" name="library" id="KSC" value="KSC">KDWPT Kansas City Library<br>
				
				<p id="KCLib" style="display:none">Important! The Kansas City Library does not provide shipping. If your address is outside the Kansas City Library delivery range, you will be expect to pick up your requested items in person.</p> <p>Please note: items checked out <strong>must</strong> be returned to their associated library. Neither the State Library nor the Kansas City Library will accept items owned by its sister library.</p>
				<input type="checkbox" name="agree" id="agree"> I have read, understood, and agree to abide by the terms of use.<br><br>
				<input type="submit" id = "submit" name="submit" disabled="disabled">
			</form>
		</main>
		</div>
		<script src="../js/welcome.js"></script>
	</body>
</html>