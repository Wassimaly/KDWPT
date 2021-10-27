<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="../css/table.css">
	</head>
	<body>
	<div id="innerbody">
		<main>
			<div class="container">
				<form>
				<table class="searchable sortable"><thead>
				<tr><th>Name</th>
				<th> Check Out Date </th>
				<th> Check In Date </th>
				<th> Check Out?</th>
				<?php
				include('../php/selection_class.php');
				@session_start();

				foreach($_SESSION['Selections'] as $row){
					echo '<tr><td>' .
					$row->itemType . '</td><td>' .
					$row->checkOut . '</td><td>' .
					$row->checkIn . '</td><td>';
					echo '<input type="checkbox" name="' .
					$row->itemType . '" checked></td>';
					}
				?>
				</table>
				<button type="submit" id="submit" name="submit">Verify Selections</button>
				<form>
			</div>
		</main>
	</div>
	</body>
</html>