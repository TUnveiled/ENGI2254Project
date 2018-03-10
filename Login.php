<?php
include("config.php");

$loginPass = mysqli_real_escape_string($db, $_POST['Password']);
$loginUser = mysqli_real_escape_string($db, $_POST['User']);
 
$sql = "SELECT * FROM login WHERE '$loginPass' = pass AND loginid = '$loginUser';";

$result = mysqli_query($db,$sql);
$row = mysqli_fetch_array($result,MYSQLI_ASSOC);

$count = mysqli_num_rows($result);

if($count == 1)
{
	session_start();
	$_SESSION["id"] = openssl_random_pseudo_bytes(32);
	$_SESSION["uName"] = $row["username"];
	$_SESSION["title"] = $row["title"];
	header("Location: http://localhost/Units.php");
	die();
}

else
{
	header("Location: http://localhost/Login.html");
	die();
}
?>