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
	<script LANGUAGE=Javascript type="text/javascript" src="Main.js"></script>

	</head>
	<body bgcolor="#BFF1EF"  onload="run()";>
	
	<div id="User">
		<?php
		$USER = $_SESSION["uName"];
		
		echo "Signed in as: $USER";
		?>
	</div>
	
	<div id="client_info">
		<?php 
		include("config.php");
		
		$PMCS = $_GET['Patientmcs'];
		
		$PMCS = mysqli_real_escape_string($db, $PMCS);
		$sql = "SELECT * FROM Patient natural join Room natural join ResidesIn
						WHERE '$PMCS' = Patientmcs;";
		
		$result = mysqli_query($db,$sql);

		echo "<table border='1' id='Main'>"; // start a table tag in the HTML
		
		while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
		$inc = $row['patientHeight']%12;
		$feet = floor( $row['patientHeight']/12);
		$height = $feet . "' " . $inc . "\" ";
		echo "<tr>
				<td class='bold'>" . $row['patientLastName'] . ", " . $row['patientFirstName'] . "</td>
				<td>DOB: " . $row['patientDateOfBirth'] . " " . $row['patientGender'] . "</td>
			</tr>
			
			<tr>
				<td>" . "Ht: " . $height . " / Wt: " . $row['patientWeight'] . "lb" . "</td>
				<td>" . "ID: " . $row['patientMCS'] . "</td>
			</tr>
			
			<tr>
				<td>" . "Allergy/AdvReaction: " . $row['patientAllergies'] . "</td>
				<td>" . "Room Number: " . $row['roomNumber'] . " <sub>" . $row['bedNumber'] . "</sub></td>
			<tr>
			";  
			
				//$row['index'] the index here is a field name
		}
		echo "</table>" 
		?>
	</div>
		
	<div id="Buttons">
			<button class="sidebutton" onclick="Notes_function()">Notes</button><br>
			<button class="sidebutton" onclick="OrderHistory_function()">Order History</button><br>
			<button class="sidebutton" onclick="Medications_function()">Medications</button><br>
			<button class="sidebutton" onclick="Reports_function()">Reports</button><br>
			<button class="sidebutton" onclick="Laboratory_function()">Laboratory</button><br>
			<button class="sidebutton" onclick="Imaging_function()">Imaging</button><br>
			<button class="sidebutton" onclick="Summary_function()">Summary</button>
			<br><br>
			<form action="Units.php">
				<input class="sidebutton" type="submit" value="Main Menu">
			</form>
			<form action="Logout.php">
				<input class="sidebutton" type="submit" value="Logout"><br>
			</form>
	</div>

	<section class="panel mainpanel">
		<div id="Notes">
			<div id="NoteList">
				<?php
					$PMCS = $_GET['Patientmcs'];
					$_SESSION['mcs'] = $PMCS;
					$_SESSION['link'] = "Main.php?=" . $PMCS;
					
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join Notes
									WHERE '$PMCS' = Patientmcs;";
		
					$result = mysqli_query($db,$sql);

					echo "<table border='1' id='noteview'>"; // start a table tag in the HTML

					echo "<tr>
							<td>Date</td>
							<td>Time</td>
							<td>User</td>
							<td>Title</td>
							<td>Note ID</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['dateOfReport'] . "</td>
							<td>" . $row['timeOfReport'] . "</td>
							<td>" . $row['userName'] . "</td>
							<td>" . $row['userTitle'] . "</td>
							<td> <a href='NoteView.php?NoteID=" . $row['noteID'] . "'</a>" . $row['noteID'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
				<button class="panelbutton" onclick="NoteEnrty()">Note Entry</button>
			</div>
			<div id="NoteEntry">
				<form method="post" action="NoteEntry.php">
					Focus:<br>
					<textarea style="overflow:auto;resize:none" rows="3" cols="80" name="focus"></textarea><br>
					Note:<br>
					<textarea style="overflow:auto;resize:none" rows="30" cols="80" name="note"></textarea>
					<br>
					<input class="panelbutton" type="submit" value="Save Note">
				</form>
				
			</div>
			<div id="NoteView">
			
			</div>
		</div>
		<div id="OrderHistory">
			<?php
					
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join Orders natural join Doctor
									WHERE '$PMCS' = Patientmcs;";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>Order Date</td>
							<td>Order Time</td>
							<td>Service Date</td>
							<td>Service Time</td>
							<td>Ordered By</td>
							<td>Procedure</td>
							<td>Status</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['orderDate'] . "</td>
							<td>" . $row['orderTime'] . "</td>
							<td>" . $row['serviceDate'] . "</td>
							<td>" . $row['serviceTime'] . "</td>
							<td>Dr. " . $row['doctorLastName'] . "</td>
							<td>" . $row['procedureName'] . "</td>
							<td>" . $row['orderStatus'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
					
				?>
		</div>
		<div id="Medications">
			<button class="panelbutton" onclick="Active_function()">Active</button>
			<button class="panelbutton" onclick="Discontinued_function()">Discontinued</button>
			<button class="panelbutton" onclick="All_function()">All</button><br>
			<div id="Active">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join Takes natural join Medications
									WHERE '$PMCS' = patientMCS 
									AND medStatus = 'Active';";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>
								Medication <br>
								Ordered <br>
								Generic Name <br>
								************** <br>
								Trade Name
							</td>
							<td>Dose Ordered</td>
							<td>
								SIG/SCH <br>
								************** <br>
								Route
							</td>
							<td>
								Start <br>
								************** <br>
								Stop
							</td>
							<td>Status</td>
							<td>
								Last Admin <br>
								************** <br>
								Dose Admin
							</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['genericName'] . "<br>(" . $row['tradeName'] . ")</td>
							<td>" . $row['dosage'] . "</td>
							<td>" . $row['sigSch'] . "<br>" . $row['route'] . "</td>
							<td>" . $row['startDate'] . "<br>" . $row['stopDate'] . "</td>
							<td>" . $row['medStatus'] . "</td>
							<td>" . $row['lastAdmin'] . "<br>" . $row['doseAdmin'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Discontinued">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join Takes natural join Medications
									WHERE '$PMCS' = patientMCS 
									AND medStatus = 'Discontinued';";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>
								Medication <br>
								Ordered <br>
								Generic Name <br>
								************** <br>
								Trade Name
							</td>
							<td>Dose Ordered</td>
							<td>
								SIG/SCH <br>
								************** <br>
								Route
							</td>
							<td>
								Start <br>
								************** <br>
								Stop
							</td>
							<td>Status</td>
							<td>
								Last Admin <br>
								************** <br>
								Dose Admin
							</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['genericName'] . "<br>(" . $row['tradeName'] . ")</td>
							<td>" . $row['dosage'] . "</td>
							<td>" . $row['sigSch'] . "<br>" . $row['route'] . "</td>
							<td>" . $row['startDate'] . "<br>" . $row['stopDate'] . "</td>
							<td>" . $row['medStatus'] . "</td>
							<td>" . $row['lastAdmin'] . "<br>" . $row['doseAdmin'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="All">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join Takes natural join Medications
									WHERE '$PMCS' = patientMCS;";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>
								Medication <br>
								Ordered <br>
								Generic Name <br>
								************** <br>
								Trade Name
							</td>
							<td>Dose Ordered</td>
							<td>
								SIG/SCH <br>
								************** <br>
								Route
							</td>
							<td>
								Start <br>
								************** <br>
								Stop
							</td>
							<td>Status</td>
							<td>
								Last Admin <br>
								************** <br>
								Dose Admin
							</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['genericName'] . "<br>(" . $row['tradeName'] . ")</td>
							<td>" . $row['dosage'] . "</td>
							<td>" . $row['sigSch'] . "<br>" . $row['route'] . "</td>
							<td>" . $row['startDate'] . "<br>" . $row['stopDate'] . "</td>
							<td>" . $row['medStatus'] . "</td>
							<td>" . $row['lastAdmin'] . "<br>" . $row['doseAdmin'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
		</div>
		<div id="Reports">
			<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Report natural join Patient natural join Doctor
									WHERE '$PMCS' = patientMCS
									AND reportType = 'report';";
		
					$result = mysqli_query($db,$sql);

					$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
					
					echo "Exam Date: " . $row['examDate'] . "";
					echo"<form>
						Report:<br>
						<textarea style='overflow:auto;resize:none' rows='30' cols='80' readonly name='comment' form='usrform'>"
						.$row['contents'].
						"</textarea>
					</form>";
				?>
		</div>
		<div id="Laboratory">
			<button class="panelbutton" onclick="Hematology_function()">Hematology</button>
			<button class="panelbutton" onclick="Chemistry_function()">Chemistry</button>
			<button class="panelbutton" onclick="Urinalysis_function()">Urinalysis</button><br>
			<button class="panelbutton" onclick="Coagulation_function()">Coagulation</button>
			<button class="panelbutton" onclick="Toxicology_function()">Toxicology</button>
			<button class="panelbutton" onclick="Serology_function()">Serology</button><br>
			<div id="Hematology">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join HematologyResults
									WHERE '$PMCS' = patientMCS";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>   </td>
							<td>WBC</td>
							<td>RBC</td>
							<td>Hgb</td>
							<td>Hct</td>
							<td>Pit Count</td>
							<td>Neutrophils %</td>
							<td>Lymphocytes %</td>
							<td>Monocytes %</td>
							<td>Eosinophils %</td>
							<td>Basophils %</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['labDateTime'] . "</td>
							<td>" . $row['WBC'] . "</td>
							<td>" . $row['RBC'] . "</td>
							<td>" . $row['HGB'] . "</td>
							<td>" . $row['HCT'] . "</td>
							<td>" . $row['pitCount'] . "</td>
							<td>" . $row['neutrophils'] . "</td>
							<td>" . $row['lymphocytes'] . "</td>
							<td>" . $row['monocytes'] . "</td>
							<td>" . $row['eosinophils'] . "</td>
							<td>" . $row['basophils'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Chemistry">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join ChemistryResults
									WHERE '$PMCS' = patientMCS";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>   </td>
							<td>Sodium</td>
							<td>Potassium</td>
							<td>Chloride</td>
							<td>BUN</td>
							<td>Creatinine</td>
							<td>Estimated GFR</td>
							<td>Calcium</td>
							<td>Total Bilirubin</td>
							<td>AST</td>
							<td>ALT</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['labDateTime'] . "</td>
							<td>" . $row['sodium'] . "</td>
							<td>" . $row['potassium'] . "</td>
							<td>" . $row['chloride'] . "</td>
							<td>" . $row['BUN'] . "</td>
							<td>" . $row['creatinine'] . "</td>
							<td>" . $row['estimatedGFR'] . "</td>
							<td>" . $row['calcium'] . "</td>
							<td>" . $row['totalBilirubin'] . "</td>
							<td>" . $row['AST'] . "</td>
							<td>" . $row['ALT'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Urinalysis">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join UrinalysisResults
									WHERE '$PMCS' = patientMCS";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>   </td>
							<td>Colour</td>
							<td>Appearance</td>
							<td>Specific Gravity</td>
							<td>pH</td>
							<td>Protein</td>
							<td>Glucose</td>
							<td>Ketones</td>
							<td>Erythrocytes</td>
							<td>Nitrate</td>
							<td>Leukocyte <br> Esterase</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['labDateTime'] . "</td>
							<td>" . $row['colour'] . "</td>
							<td>" . $row['appearance'] . "</td>
							<td>" . $row['specificGravity'] . "</td>
							<td>" . $row['pH'] . "</td>
							<td>" . $row['protein'] . "</td>
							<td>" . $row['glucose'] . "</td>
							<td>" . $row['elythrocytes'] . "</td>
							<td>" . $row['leukocyteEsterase'] . "</td>
							<td>" . $row['nitrite'] . "</td>
							<td>" . $row['kestones'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Coagulation">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join CoagulationResults
									WHERE '$PMCS' = patientMCS";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>   </td>
							<td>INR</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['labDateTime'] . "</td>
							<td>" . $row['INR'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Toxicology">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join ToxicologyResults
									WHERE '$PMCS' = patientMCS";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>   </td>
							<td>Marijuana</td>
							<td>THC</td>
							<td>Cocaine</td>
							<td>Opiates</td>
							<td>Oxycodone</td>
							<td>Amphetamines</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['labDateTime'] . "</td>
							<td>" . $row['Marijuana'] . "</td>
							<td>" . $row['THC'] . "</td>
							<td>" . $row['cocaine'] . "</td>
							<td>" . $row['opiates'] . "</td>
							<td>" . $row['oxycodone'] . "</td>
							<td>" . $row['amphetamines'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Serology">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient natural join SerologyResults
									WHERE '$PMCS' = patientMCS";
		
					$result = mysqli_query($db,$sql);

					echo "<table id='Main' border='1'>"; // start a table tag in the HTML

					echo "<tr>
							<td>   </td>
							<td>HIV</td>
							<td>Hepatitis A</td>
							<td>Hepatitis B</td>
							<td>Hepatitis C</td>
						</tr>";

					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
					echo "<tr>
							<td>" . $row['labDateTime'] . "</td>
							<td>" . $row['HIV'] . "</td>
							<td>" . $row['HepatitisA'] . "</td>
							<td>" . $row['HepatitisB'] . "</td>
							<td>" . $row['HepatitisC'] . "</td>
						</tr>";  
					}

					echo "</table>"; //Close the table in HTML
				?>
			</div>
		</div>
		<div id="Imaging">
			<?php
					
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Report natural join Doctor natural join Patient
									WHERE '$PMCS' = patientMCS
									AND reportType = 'imaging';";
		
					$result = mysqli_query($db,$sql);

					$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
					echo "Exam Date: " . $row['examDate'] . "<br>";
					echo "<a class='bold'>" . $row['procedureName'] . "</a><br>";
					echo"<form>
						<textarea style='overflow:auto;resize:none' rows='30' cols='80' readonly name='comment' form='usrform'>"
						.$row['contents'].
						"</textarea>
					</form>";
					echo "Electronically Signed by: " . $row['radiologist'] . "<br>";
					echo "" . $row['reportSubmissionDate'];
				?>
		</div>
		<div id="Summary">
			<button class="panelbutton" onclick="Contacts_function()">Contacts</button>
			<button class="panelbutton" onclick="RiskLegal_function()">Risk/Legal</button><br>
			<button class="panelbutton" onclick="Providers_function()">Providers</button>
			<button class="panelbutton" onclick="Demographics_function()">Demographics</button><br>
			<div id="Contacts">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Contacts
									WHERE '$PMCS' = patientMCS;";
		
					$result = mysqli_query($db,$sql);
					echo "<br>";
			
					while($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){   //Creates a loop to loop through results
						echo "Name: " . $row['contactName'] . "<br>";
						echo "Address: " . $row['contactAddress'] . "<br>";
						echo "City: " . $row['contactCity'] . "<br>";
						echo "Postal Code: " . $row['contactPostalCode'] . "<br>";
						echo "Phone #: " . $row['contactPhoneNumber'] . "<br>";
						echo "Relationship: " . $row['contactRelationship'] . "";
						echo "<br><br>";
					}
				?>
			</div>
			<div id="RiskLegal">
				<?php					
					$PMCS = $_GET['Patientmcs'];
		
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient
									WHERE '$PMCS' = Patientmcs;";
		
					$result = mysqli_query($db,$sql);

					echo "<table border='1' id='Main'>"; // start a table tag in the HTML
					echo "<br>";

					$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
					echo "<tr>
							<td>Advanced<br>Directive</td>
							<td>" . $row['patientAdvancedDirective'] . "</td>
							<td>" . $row['patientAdvDirDate'] . "</td>
						</tr>";  
					echo "<tr>
							<td>Advanced<br>Directive on<br>File</td>
							<td>" . $row['patientAdvDirOnFile'] . "</td>
							<td>" . $row['patientAdvDirDate'] . "</td>
						</tr>";  	
					

					echo "</table>"; //Close the table in HTML
				?>
			</div>
			<div id="Providers">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM IsProvidedForBy natural join Doctor
									WHERE '$PMCS' = patientMCS
									AND role = 'Family Doctor';";
									
		
					$result = mysqli_query($db,$sql);
			
					$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
					
					echo "<br>Family Physician: Dr. " . $row['doctorFirstName'] . " " . $row['doctorLastName'] . "<br>";
					
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM IsProvidedForBy natural join Doctor
									WHERE '$PMCS' = patientMCS
									AND role = 'Attending Physician';";
		
					$result = mysqli_query($db,$sql);
			
					$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
					
					echo "Attending Physician: Dr. " . $row['doctorFirstName'] . " " . $row['doctorLastName'] . "<br>";
					
				?>
			</div>
			<div id="Demographics">
				<?php
					$PMCS = mysqli_real_escape_string($db, $PMCS);
					$sql = "SELECT * FROM Patient
									WHERE '$PMCS' = patientMCS;";
		
					$result = mysqli_query($db,$sql);
			
					$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
					
					echo "<br>Name: " . $row['patientFirstName'] . " " . $row['patientLastName'] . "<br>";
					echo "Address: " . $row['patientAddress'] . "<br>";
					echo "City: " . $row['patientCity'] . "<br>";
					echo "Postal Code: " . $row['patientPostalCode'] . "<br>";
					echo "Phone #: " . $row['patientPhoneNumber'] . "<br>";
					echo "Health Card #: " . $row['patientHealthCard'] . "";
				?>
			</div>
		</div>
		
		
	</section>

	</body>
</html>