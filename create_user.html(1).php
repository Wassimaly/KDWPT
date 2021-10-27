<!DOCTYPE html>
<html>
<head>
    <title>KDWPT Library::Add Users Database</title>
    <meta charset="UTF-8">
</head>

<body>
<header>
    <h1>KDWPT Library: New User</h1>
</header>

<form method="post">
    User Name: <input type="text" name="str_UserName" id="str_UserName"><br>
    Email: <input type="email" name="str_Email" id="str_Email"><br>
	Verify Email: <input type="email" name="str_vEmail" id="str_vEmail"><br>
    Password: <input type="password" name="str_UserPass" id="str_UserPass"><br>
	Verify Password: <input type="password" name="str_vUserPass" id="str_vUserPass"><br>
    First Name: <input type="text" name="str_FirstName" id="str_FirstName"><br>
    Last Name: <input type="text" name="str_LastName" id="str_LastName"><br>
    Phone: <input type="tel" name="str_Phone" id="str_Phone"><br>
    County:
	<?php 
		require('../connect.php');
		$table_name = "userinfo";
		$column_name = "County";

		echo "<select name='$column_name'>";
		
		$result = mysqli_query($dbc,"SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = '$table_name' AND COLUMN_NAME = '$column_name'")
		or die (mysqli_error());

		$row = mysqli_fetch_array($result);
		$enumList = explode(",", str_replace("'", "", substr($row['COLUMN_TYPE'], 5, (strlen($row['COLUMN_TYPE'])-6))));

		foreach($enumList as $value)
			echo "<option value='$value'>$value</option>";

		echo "</select><br>";
	?>
    Address:<input type="text" name="str_Address" id="str_Address"><br>
    City:<input type="text" name="str_City" id="str_City"><br>
    Zip:<input type="text" name="str_Zip" id="str_Zip"><br>
    Organization:<input type="text" name="str_Organization" id="str_Organization"><br>

    <button type="submit" name="submit" id="submit">Create User</button>
</form>
<?php

//Create Connection

require_once('../connect.php');
if(isset($_POST['submit'])){



    //Check Connection
    if($dbc->connect_error){
        die("Connection failed: " . $dbc->connect_error);
    }
	echo 'Connection Established<br>';

    //prep and bind
    if(!get_magic_quotes_gpc()){
        $UserName = addslashes($_POST['str_UserName']);
        $Email = addslashes($_POST['str_Email']);
        $Password = addslashes($_POST['str_UserPass']);

        $FirstName = addslashes($_POST['str_FirstName']);
        $LastName = addslashes($_POST['str_LastName']);
        $Phone = addslashes($_POST['str_Phone']);
        $County = addslashes($_POST['County']);
        $Address = addslashes($_POST['str_Address']);
        $City = addslashes($_POST['str_City']);
        $Zip = addslashes($_POST['str_Zip']);
        $Organization = addslashes($_POST['str_Organization']);
    }
    else{
        $UserName = $_POST['str_UserName'];
        $Email = $_POST['str_Email'];
        $Password = $_POST['str_UserPass'];

        $FirstName = $_POST['str_FirstName'];
        $LastName = $_POST['str_LastName'];
		$Phone = $_Post('str_Phone');
        $County = $_POST['County'];
        $Address = $_POST['str_Address'];
        $City = $_POST['str_Address'];
        $Zip = $_POST['str_Zip'];
        $Organization = $_POST['str_Organization'];
    }

    {
		$query = "CALL NewUser('$UserName,', '$Password','$Email','$FirstName','$LastName','$Phone','$County', '$Address','$City','$Zip','$Organization')";
        $retval = mysqli_query($dbc, $query);
        if(! $retval){
            die('Could not enter data: ' . mysqli_error($dbc) . '<br>');
        }
        echo "Entered user info successfully<br>";
		mysqli_close($dbc);
    }
}
?>
<!--<script src="../js/checkUserFields.js"></script>-->
</body>
</html>