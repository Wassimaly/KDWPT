<?php
require_once('../connect.php');
session_start();

if($_SERVER["REQUEST_METHOD"] == "POST") {

    // username and password sent from form
    $UserName = addslashes($_POST['str_UserName']);
    $Password = addslashes($_POST['str_UserPass']);

    $query = "SELECT Username FROM usertable WHERE Username = '$UserName' and UserPass = Password('$Password')";
    $result = mysqli_query($dbc,$query);
    echo $query;
    $row = mysqli_fetch_array($result,MYSQLI_ASSOC);
//    $active = $row['active'];

    $count = mysqli_num_rows($result);

    // If result matched $UserName and $Password, table row must be = 1 row

    if($count == 1) {
//        session_register("UserName");
        $_SESSION['login_user'] = $UserName;
        echo "User info successful<br>";

//        header("location: welcome.php");
    }else {
        $error = "Your Login Name or Password is invalid";
    }
}
?>
<html>

<head>
    <title>Login Page</title>

    <style type = "text/css">
        body {
            font-family:Arial, Helvetica, sans-serif;
            font-size:14px;
        }
        label {
            font-weight:bold;
            width:100px;
            font-size:14px;
        }
        .box {
            border:#666666 solid 1px;
        }
    </style>

</head>

<body bgcolor = "#FFFFFF">

<div align = "center">
    <div style = "width:300px; border: solid 1px #333333; " align = "left">
        <div style = "background-color:#333333; color:#FFFFFF; padding:3px;"><b>Login</b></div>

        <div style = "margin:30px">

            <form action = "" method = "post">
                User Name: <input type="text" name="str_UserName" id="str_UserName"><br>
                Password: <input type="password" name="str_UserPass" id="str_UserPass"><br>
                <button onclick="location.href='https://localhost/php/create_user.html.php'" type="button">
                    Create New User</button>&nbsp;&nbsp;&nbsp;&nbsp;<input type = "submit" value = " Submit "/><br />
            </form>
            <div style = "font-size:11px; color:#cc0000; margin-top:10px"><?php if (!empty($error)) {
                    echo $error;
                } ?></div>

        </div>

    </div>

</div>

</body>
</html>