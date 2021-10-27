<?php
session_start();
function create_table() {
	require_once('../connect.php');
	$library = $_SESSION['library'];
	$query = "CALL GetLibrary ('$library')";
	$results = array();
	$response = @mysqli_query($dbc,$query);
	if($response){
		echo '<div class="container">';
		echo '<table class="searchable sortable"><thead>
		<tr><th>Name</th>
		<th>Description</th>
		<th>Media Type</th>
		<th>Subject Type</th>
		<th> Check out Date </th>
		<th> Check in Date </th>
		<th> Check Out</th>
		
		</tr></thead>';
		$count=0;
		while($row = mysqli_fetch_array($response)){
			$results[] = $row;
			echo '<tr><td>' .
			$row['TypeName'] . '</td><td>' .
			$row['description'] . '</td><td>' .
			$row['media'] . '</td><td>' .
			$row['TypeSubject'] . '</td><td>' ;
			echo '<input type="date" name="dateOut' . 
			$count . '">' . '</td><td>' ;		
			echo '<input type="date" name="dateIn' .
			$count . '">' . '</td><td>' ; 
			echo '<input type="checkbox" name="' .
			$row['itemTypeID'] . '"></td>'  ;
			$count++;
		}
		$_SESSION['itemTypeList'] = $results;
		echo '</table></div>';
		echo '<br><button type="submit" name="submit" id="submit">Make Selection</button></form>';
	}	
	else{
	echo 'Could not complete database query.';
	echo mysqli_error($dbc);

	}
mysqli_close($dbc);

}

//Save selection to session prior to submission.
function save_selection(){
	require_once('selection_class.php');
	$itemTable = $_SESSION['itemTypeList'];
	echo "Save selection running.<br>";
	
	//Create count
	$i = 0;
	$itemsSelected = array();
	foreach($itemTable as $row){
		echo "Iteration " . $i . "<br>";
		
		//Save the checkbox name.
		$nameHolder = $row['itemTypeID'];
		$checkIn = 'dateIn' . $i;
		$checkOut = 'dateOut' . $i;

		//Check if item is selected
		if(isset($_POST[$nameHolder])){ 

			//Save the item as selected with dates
			$itemsSelected[] = new Selection($row['TypeName'], $_POST[$checkIn], $_POST[$checkOut]);
			echo $row['TypeName'] . ' saved.<br>';
		}
		$i++;


	}
	$_SESSION['Selections'] = $itemsSelected;
	
}

if(isset($_POST['submit'])){	
	echo '<br>Submitted.<br>';
	save_selection();
	
	echo 'SELECTION LIST<br>';
	foreach($_SESSION['Selections'] as $row){
		echo $row->itemType . ' selected for ' . $row->checkOut . " to " . $row->checkIn . "<br>";
	}
		echo 'END OF SELECT LIST<br>';
}
?>
