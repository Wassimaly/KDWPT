<!DOCTYPE html>
<html>
	<head>
		<title>KDWPT Library::Add Items to Database</title>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="../css/table.css">
	</head>

	<body>
		<div id="innerbody">
		<header>
			<h1>KDWPT Library</h1>
		</header>

				<form method="post">
					<div class="container">
						<label>Item Name:</label> <input type="text" name="str_TypeName" id="str_TypeName"><br>
						<label>Description:</label> <input type="text" name="str_description" id="str_description"><br>
						<label>Subject:</label> <input type="text" name="str_subject" id="str_subject"><br>
						<label>Media Type:</label><br>
						<?php 
			require('../connect.php');
			$table_name = "itemType";
			$column_name = "media";

			echo "<select name='str_media'>";
			
			$result = mysqli_query($dbc,"SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = '$table_name' AND COLUMN_NAME = '$column_name'")
			or die (mysqli_error());

			$row = mysqli_fetch_array($result);
			$enumList = explode(",", str_replace("'", "", substr($row['COLUMN_TYPE'], 5, (strlen($row['COLUMN_TYPE'])-6))));
			foreach($enumList as $value){
				echo "<option value='$value'>$value</option>";
			}
			echo "</select><br>";
		?>
					</div>
						<label>Part of Kit?</label> <input type="checkbox" name="kitCheckBox" id="kitCheckBox"><br>
						
						<!--Hidden Section for Kit Creation -->
						<div id = "kitDiv" style="display:none">
							<?php 
								require_once('../connect.php');
								if($dbc->connect_error){
									die("Custom Error Line 29: Connection failed: " . $dbc->connect_error);
								}
								$kitQuery = "CALL GetKitName()";
								mysqli_select_db($dbc, $kitQuery);
								$retKitVal = mysqli_query($dbc, $kitQuery);

							echo '<table class="subtable">
								<tr>
									<th>Select</th>
									<th>Kit Name</th>
								</tr>';

									while($row = @mysqli_fetch_array($retKitVal)){
										echo '<tr><td><input type="checkbox" id="' .
										$row['KitID'] . '" name="' .
										$row['KitID'] . '"></td><td>' .
										$row['KitName'] . '</td></tr>';
									}
									mysqli_close($dbc);
								?>
								</table><p class="clear">
								
								New Kit? <input type="checkbox" id="addNewKit" name="addNewKit"><br>
								<div class="container">
									<div id="newKit" style="display:none">
										Kit Name: <input type="text" name="str_KitName" id="str_KitName"><br><br>
									</div>
								</div>

						</div>
						<label>Add Items to Library? </label><input type="checkbox" name="addItems" id="addItems"><br>
						<div id="instances" style="display:none">
							<label>Not Listed for Checkout? </label><input type="checkbox" name="listItems" id="listItems"><br>
							<label>Number of items: </label><input type="number" name="itemCount" min="1"><br>
							<label>Library:</label>
								<select name="library">
								<option value="KS">KS</option>
								<option value="KCS">KCS</option>
								</select><br>
						</div>
						<button type="submit" name="submit" id="submit">Create Item</button>
						
				</form>
			</div>
	<?php
		//Create Connection
		require('../connect.php');
		if(isset($_POST['submit'])){
			


			

			//Check Connection
			if($dbc->connect_error){
				die("Custom Error Line 102: Connection failed: " . $dbc->connect_error);
			}
			
			//prep and bind
			if(!get_magic_quotes_gpc()){
				$TypeName = addslashes($_POST['str_TypeName']);
				$Description = addslashes($_POST['str_description']);
				$Media = addslashes($_POST['str_media']);
				$Subject = addslashes($_POST['str_subject']);
				$KitName = addslashes($_POST['str_KitName']);
			}
			else{
				$TypeName = $_POST['str_TypeName'];
				$Description = $_POST['str_description'];
				$Media = $_POST['str_media'];
				$Subject = $_POST['str_subject'];			
				$KitName = addslashes($_POST['str_KitName']);				
			}
				
			$query = "INSERT INTO ItemType". "(TypeName, description, media, TypeSubject)". "VALUES ('$TypeName','$Description','$Media','$Subject')";
			$retval = mysqli_query($dbc, $query);
			
			if(! $retval){
				die('Custom Error Line 125: Could not enter data: ' . mysqli_error($dbc));
			} 
			
			mysqli_close($dbc);
			require('../connect.php');		
			
			//Check if item will be added to kit.
			if(isset($_POST['kitCheckBox'])){
				echo 'Test Update: Checkbox checked.<br>';
				$kitQuery = "CALL GetKitName()";
				$kitTable = mysqli_query($dbc, $kitQuery);
				
				//Check which existing kits get item and create kit relation
				while($row = @mysqli_fetch_array($kitTable)){
					$nameHolder = $row['KitName'];
					if(isset($_POST[$nameHolder])){
						mysqli_close($dbc);
						require('../connect.php');		
						$newKitRelQuery = "CALL NewKitRelation('$nameHolder','$TypeName')";
						$sendVal = mysqli_query($dbc, $newKitRelQuery);
						
						if(! $sendVal){
							die('Custom Error Line 147: Could not enter data: ' . mysqli_error($dbc) . '<br>');
						}
						echo 'Item added to ' . $nameHolder . ' <br>';
					}else{
						echo $nameHolder . ' not set<br>';
					} 
				}
				mysqli_close($dbc);
				require('../connect.php');
				$output = 'Database connection established.'; 
				
				//Create new kit and add item to it.
				if(isset($_POST['addNewKit'])){
					$newKitQuery = "CALL NewKit('$KitName')";
					$makeNewKit = mysqli_query($dbc, $newKitQuery);
				
					if(! $makeNewKit){
						die('Custom Error Line 164: Could not enter data: ' . mysqli_error($dbc) . '<br>');
					}
					echo 'New kit added.<br>';
					mysqli_close($dbc);
					
					//Add relation for new kit
					require('../connect.php');	
					$newKitRelQuery = "CALL NewKitRelation('$KitName','$TypeName')";
					$sendVal = mysqli_query($dbc, $newKitRelQuery);
					if(! $sendVal){
						die('Custom Error Line 174: Could not enter data: ' . mysqli_error($dbc) . '<br>');
					}
					else{
						echo 'Item added to ' . $KitName . '<br>';
					}
				} else{
					echo 'Test Output: Add New kit checkbox not set.<br>';
				}
			} 
			//If checkbox not set for a kit.
			else{
				echo 'Kit checkbox not set. <br>';
			}
				echo 'Entered data successfully.<br>';
				mysqli_close($dbc);
				echo 'Connection closed';
				
				if(isset($_POST['addItems'])){
					if(isset($_POST['itemCount'])){
						$count = $_POST['itemCount'];
						require('../connect.php');
						$query = "SELECT itemTypeID FROM itemType WHERE TypeName = '$TypeName' LIMIT 1";
						$retVal = mysqli_query($dbc, $query);
						if(! $retVal){
							die('Custom Error Line 187: Could not enter data: ' . mysqli_error($dbc) . '<br>');
						}
						if(isset($_POST['listItems'])){
							$listItems = 2;
						}else{
							$listItems = 1;
						}

						$typeID = mysqli_fetch_field($retVal);
						for($i = '1'; $i<= $count; $i++){
							$itemID = $_POST['library'] . $TypeName . $i;
							echo $itemID . '<br>';
							$query = "CALL NewItem('$itemID','$TypeName', '$listItems')";
							require('../connect.php');
							$retVal = mysqli_query($dbc, $query);
								if(! $retVal){
							die('Custom Error Line 202: Could not enter data on attempt ' . $i . ' : ' . mysqli_error($dbc) . '<br>');
						}
							
						}
					}
				}
			}
		
	?>

		<script src="../js/newItem.js"></script>
	</body>
</html>