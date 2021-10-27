<!DOCTYPE html>
<html>
	<head>
		<title>Check Out Page</title>
		<link rel="stylesheet" href="../css/table.css">
	</head>
	<body>

	<!--<form action="create_table.php" method="post" id="nameform">
	Item ID <input type="radio" name="itemTypeID"> </br>
	TypeName <input type="radio" name= "TypeName"> </br>
	Description <input type="radio" name= "description"> </br>
	MediaType <input type="radio" name= "media"> </br>
	TypeSubject <input type="radio" name= "TypeSubject"> </br>
	<button type="submit" form="nameform" value="submit"> Submit </button>
	</form>
-->
<?php




function create_table() {
	
	require_once('../connect.php');
	$query = "SELECT * FROM ItemType";
	$response = @mysqli_query($dbc,$query);
	if($response){
		
	echo '<div class="container">';
	echo '<table>
	<tr><th>Item ID</th>
	<th>Name</th>
	<th>Description</th>
	<th>Media Type</th>
	<th>Subject Type</th>
	<th> Check out Date </th>
	<th> Check in Date </th>
	<th> Check Out</th>
	
	</tr>';
	$count=0;
	while($row = @mysqli_fetch_array($response)){
		echo '<tr><td>' .
		$row['itemTypeID'] . '</td><td>' .
		$row['TypeName'] . '</td><td>' .
		$row['description'] . '</td><td>' .
		$row['media'] . '</td><td>' .
		$row['TypeSubject'] . '</td><td>' ;
		//echo '<input type="checkbox name="' . $row['itemTypeID'] . '">' . '</td><td>' ;
		echo '<input type="date" id="dateIn' . 
		$count . '">' . '</td><td>' ;		
		echo '<input type="date" id="dateOut' .
		$count . '">' . '</td><td>' ; 
		echo '<input type="checkbox" id="' .
		$row['itemTypeID'] . '"></td>'  ;
		
		$count++;
	}
	echo '</table></div>';
	}	
	else{
	echo 'Could not complete database query.';
	echo mysqli_error($dbc);

	}
mysqli_close($dbc);

}
function send_info(){
	echo '<button type="submit" id="submitButton" value="submit"> Submit </button>';
	echo '<script src="send_info.js"></script>';
	 $info = array();
		//for ($x=0; $x <$count; $x++){
			
			
			
			
	// echo mysqli_query( "Select * from ItemType");
	
}
create_table();
send_info();

?>



</body>
</html>