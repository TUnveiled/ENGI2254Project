<?php
include("Config.php");

session_start();
date_default_timezone_set("America/Toronto");

$mcs = mysqli_real_escape_string($db, $_SESSION['mcs']);
$focus = mysqli_real_escape_string($db, $_POST['focus']);
$contents = mysqli_real_escape_string($db, $_POST['note']);
$date = mysqli_real_escape_string($db, date("Y-m-d"));
$time = mysqli_real_escape_string($db, date("H:i:s"));
$uname = mysqli_real_escape_string($db, $_SESSION['uName']);
$title = mysqli_real_escape_string($db, $_SESSION['title']);

$result = mysqli_query($db, "SELECT * FROM Notes;");
$id = mysqli_real_escape_string($db, (mysqli_num_rows($result) + 1));




$sql = "INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('$mcs', '$focus', '$contents', '$date', '$time', '$uname', '$title', '$id');";

$result = mysqli_query($db, $sql);

header("Location: http://localhost/Main.php?Patientmcs=" . $mcs);
?>