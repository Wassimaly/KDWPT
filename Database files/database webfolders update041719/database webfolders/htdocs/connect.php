<?php

$USER = 'root';
$DB_PASSWORD = 'root';
$DB = 'librarycheckout';
$HOST='localhost';

$dbc =  @mysqli_connect($HOST, $USER, $DB_PASSWORD, $DB) OR
	 die("Unable to connect to server");
$output = 'Database connection established.'; 

?>