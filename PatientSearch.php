<?php
function fixStr($str)
{
	$str = trim($str);
	$str = preg_replace("/[^A-Za-z0-9 ]/", "", $str);
	$str = str_replace(" ", "", $str);
	return $str;
}

include("config.php");
$array = array_fill(0, 10, -1);
$flag = FALSE;
$First = $_POST['First'];
$Last = $_POST['Last'];
$City = $_POST['City'];
$StreetName = $_POST['StreetName'];
$StreetNumber = $_POST['StreetNumber'];
$Address;
$Postal = $_POST['Postal'];
$PID = $_POST['PID'];
$Phone = $_POST['Phone'];
$SIN = $_POST['SIN'];
$HCN = $_POST['HCN'];

$sql = "SELECT *, TIMESTAMPDIFF(YEAR, patientDateOfBirth, CURDATE()) AS age FROM Patient natural join ResidesIn natural join Room natural join DiagnosedWith natural join Conditions natural join IsProvidedForBy natural join Doctor WHERE role='Attending Physician' AND";

if ($First != NULL && trim($First) != "")
{
	$First = fixStr($First);
	$array[0] = 1;
}

if ($Last != NULL && trim($Last) != "")
{
	$Last = fixStr($Last);
	$array[1] = 1;
}

if ($City != NULL && trim($City) != "")
{
	$array[2] = 1;
}

if ($StreetName != NULL && trim($StreetName) != "")
{
	$array[3] = 1;
}

if ($StreetNumber != NULL && trim($StreetNumber) != "")
{
	$StreetNumber = fixStr($StreetNumber);
	$array[4] = 1;
}

if ($Postal != NULL && trim($Postal) != "")
{
	$Postal = fixStr($Postal);
	$array[5] = 1;
}

if ($PID != NULL && trim($PID) != "")
{
	$PID = fixStr($PID);
	$array[6] = 1;
}

if ($Phone != NULL && trim($Phone) != "")
{
	$Phone = fixStr($Phone);
	$array[7] = 1;
}

if ($SIN != NULL && trim($SIN) != "")
{
	$SIN = fixStr($SIN);
	$array[8] = 1;
}

if ($HCN != NULL && trim($HCN) != "")
{
	$HCN = fixStr($HCN);
	$array[9] = 1;
}


if($array[0] == 1)
{
	$First = mysqli_real_escape_string($db, $First);
	$sql .= " '$First' = patientFirstName";
	
	for($i = 1; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[1] == 1)
{
	$Last = mysqli_real_escape_string($db, $Last);
	$sql .= " '$Last' = patientLastName";
	
	for($i = 2; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[2] == 1)
{
	$City = mysqli_real_escape_string($db, $City);
	$sql .= " '$City' = patientCity";
	
	for($i = 3; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[3] == 1 && $array[4] == 1)
{
	$StreetNumber = trim($StreetNumber);
	$StreetName = trim($StreetName);
	$Address = $StreetNumber . " " . $StreetName;
	
	$Address = mysqli_real_escape_string($db, $Address);
	$sql .= " '$Address' = patientAddress";
	
	for($i = 5; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[5] == 1)
{
	$Postal = mysqli_real_escape_string($db, $Postal);
	$sql .= " '$Postal' = patientPostalCode";
	
	for($i = 6; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[6] == 1)
{
	$PID = mysqli_real_escape_string($db, $PID);
	$sql .= " '$PID' = patientMCS";
	
	for($i = 7; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[7] == 1)
{
	$Phone = mysqli_real_escape_string($db, $Phone);
	$sql .= " '$Phone' = patientPhoneNumber";
	
	for($i = 8; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[8] == 1)
{
	$SIN = mysqli_real_escape_string($db, $SIN);
	$sql .= " '$SIN' = patientSIN";
	
	for($i = 9; $i < 10; $i++)
	{
		if($array[$i] == 1)
		{
			$Flag = TRUE;
		}
	}
	
	if ($Flag)
	{
		$sql .= " AND";
	}
	
	$Flag = FALSE;
}

if($array[9] == 1)
{
	$HCN = mysqli_real_escape_string($db, $HCN);
	$sql .= " '$HCN' = patientHealthCard";
}

$sql .= ";";
session_start();
$_SESSION['pSearch'] = $sql;
header("Location: http://localhost/PatientList.php?Units=Search");
?>