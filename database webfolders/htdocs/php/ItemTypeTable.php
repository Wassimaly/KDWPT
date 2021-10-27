<!DOCTYPE html>
<html>
	<head>
		<title>Item Types</title>
		<link rel="stylesheet" href="../css/table.css">
	</head>
	<body>
<?php

require_once('../connect.php');
$query = "SELECT * FROM ItemType";
$response = @mysqli_query($dbc,$query);

if($response){
	echo '<div class="container">';
	echo '<table>
	<tr><th>Item ID</th><th>Name</th><th>Description</th><th>Media Type</th><th>Subject Type</th></tr>';
	while($row = @mysqli_fetch_array($response)){
		echo '<tr><td>' .
		$row['itemTypeID'] . '</td><td>' .
		$row['TypeName'] . '</td><td>' .
		$row['description'] . '</td><td>' .
		$row['media'] . '</td><td>' .
		$row['TypeSubject'] . '</td>';
	}
	echo '</table></div>';
		
	
}else{
	echo 'Could not complete database query.';
	echo mysqli_error($dbc);
}
mysqli_close($dbc);

?>
	</body>
</html>