<?php
	session_start();
	if(!isset($_SESSION['id']))
	{
		header("Location: http://localhost/Login.html");
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<link
        		href = "./style.css"
        		type = "text/css"
        		rel  = "stylesheet">
		<title>MCS-Desktop</title>
		<script type="text/javascript" src="jquery.js"></script>
		<script>
			$(document).ready(function() {

			$('#Units tr').click(function() {
				var href = $(this).find("a").attr("href");
				if(href) {
					window.location = href;
				}
			});
 
		});
		</script>
	</head>
	<body bgcolor="#BFF1EF">
		<form action = "Logout.php">
				<input type="submit" value="Logout">
		</form> 
		<div id="User">
			<?php
			$USER = $_SESSION["uName"];
			
			echo "Signed in as: $USER";
			?>
		<div>
		<?php
		include("config.php");

		$sql = "SELECT * FROM Unit;";
		

		$result = mysqli_query($db,$sql);
		


		echo "<table id='Units'>"; // start a table tag in the HTML

		echo "<tr>
				<td>Medical Care System</td>
			</tr>";

		while($row = mysqli_fetch_array($result, MYSQLI_ASSOC))
		{   //Creates a loop to loop through results
			echo "<tr>
				<td><a class='not-active' href='/PatientList.php?Units=" . $row['unitCode'] . "'>Unit " . $row['unitCode'] . "</a></td>
				<td>" . $row['unitName'] . "</td>
			</tr>";  
			
		}
		echo "</table>"; //Close the table in HTML*/
		?>
		<form class="logout" action="PatientSearch.html">
				<input type="submit" value="Patient Search">
		</form> 
		
	</body>
</html>