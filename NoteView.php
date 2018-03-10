<html>
	<head>
		<link
        		href = "./style.css"
        		type = "text/css"
        		rel  = "stylesheet">

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
			$USER = $_SESSION["uName"];
			
			echo "Signed in as: $USER";
			?>
		</div>
		
		<section class="panel notepanel">
		<div>
		<?php
			include("Config.php");
			
			$mcs = $_SESSION['mcs'];
			$note = $_GET['NoteID'];
			
			$mcs = mysqli_real_escape_string($db, $mcs);
			$note = mysqli_real_escape_string($db, $note);
			
			$sql = "SELECT * FROM Notes WHERE '$mcs' = patientMCS AND '$note' = noteID;";
			$result = mysqli_query($db, $sql);
			$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
			//<script>getvar();</script>
			
				echo"<form>
						Focus:<br>
						<textarea style='overflow:auto;resize:none' rows='3' cols='80' readonly name='comment' form='usrform'>"
						. $row['focus'] .
						"</textarea><br>
						Note:<br>
						<textarea style='overflow:auto;resize:none' rows='30' cols='80' readonly name='comment' form='usrform'>"
						.$row['contents'].
						"</textarea>
					</form>"
			?>
			
		</div>
		</section>

	</body>
	
</html>