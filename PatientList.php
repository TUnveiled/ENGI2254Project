<html>
	<head>
		<link
        		href = "./style.css"
        		type = "text/css"
        		rel  = "stylesheet">
	<script type="text/javascript" src="jquery.js"></script>
	<script>
		$(document).ready(function() {

		$('#Main tr').click(function() {
			var href = $(this).find("a").attr("href");
			if(href) {
				window.location = href;
			}
		});

	});
	</script>
	</head>
	<body bgcolor="#BFF1EF">
		<form action="Units.php">
				<input type="submit" value="Main Menu">
		</form> 
		<form class="logout" action="Logout.php">
				<input type="submit" value="Logout">
		</form> 
		<div id="User">
			<?php
			session_start();
			$USER = $_SESSION['uName'];
			
			echo "Signed in as: $USER";
			?>
		</div>
		<?php
		//error_reporting(E_ERROR | E_PARSE);
		include("config.php");

		$Unit = $_GET['Units'];
		
		if($Unit == "Search")
		{
			$Unit = "";
			
			$result = mysqli_query($db, $_SESSION['pSearch']);
		}
		
		else
		{
			$Unit = mysqli_real_escape_string($db, $Unit);
			$sql = "SELECT *, TIMESTAMPDIFF(YEAR, patientDateOfBirth, CURDATE()) AS age FROM Patient natural join ResidesIn natural join Room natural join DiagnosedWith natural join Conditions natural join IsProvidedForBy natural join Doctor WHERE '$Unit' = unitCode AND role='Attending Physician' ORDER BY roomNumber;";
			$result = mysqli_query($db,$sql);
		} 
		 

		echo "<table border='1' id='Main'>"; // start a table tag in the HTML

		echo "<tr>
				<td>" . $Unit . " Patient List</td>
			</tr>";
		echo "<tr>
				<td>Room Number</td>
				<td>Name/Age/Gender/Patient Number</td>
				<td>Attending Physician</td>
			</tr>";

		if($result !== FALSE)
		{
			while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) //Creates a loop to loop through results
			{
				echo "<tr>
						<td><a href='Main.php?Patientmcs=" . $row['patientMCS'] . "'>" . $row['roomNumber'] . "<sub>" . $row['bedNumber'] ."</sub></a></td>
						<td border='none'> 
							<table border='none'>
								<tr>
									<td>" . $row['patientLastName'] . ", " . $row['patientFirstName'] . "</td>
									<td>Age: ". $row['age'] ." </td>
									<td>Diagnosis: " . $row['conditionName'] . "</td>
								</tr>
								<tr>
									<td>" . $row['patientGender'] . "</td>
									<td>" . $row['patientMCS'] . "</td>
								</tr>
							</table>
						</td>
						<td>Dr. " . $row['doctorLastName'] . "</td>
					</tr>";  
			
				//$row['index'] the index here is a field name
			}
		}
		
		else
		{
			
		}

		echo "</table>"; //Close the table in HTML*/
		?>
	</body>
	
</html>