
		function run() {	//On start up the function will load
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			
			Notes.style.display = "none";
			OrderHistory.style.display = "none";
			Medications.style.display = "none";
			Reports.style.display = "none";
			Laboratory.style.display = "none";
			Imaging.style.display = "none";
			Summary.style.display = "none";
		}
		
		function Notes_function() {	//Switches the disply to Notes on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			
			var NoteList = document.getElementById("NoteList");
			var NoteView = document.getElementById("NoteView");
			var NoteEntry = document.getElementById("NoteEntry");
			
			if (Notes.style.display === "none") {
				Notes.style.display = "block";
				OrderHistory.style.display = "none";
				Medications.style.display = "none";
				Reports.style.display = "none";
				Laboratory.style.display = "none";
				Imaging.style.display = "none";
				Summary.style.display = "none";
				
				NoteList.style.display = "block";
				NoteView.style.display = "none";
				NoteEntry.style.display = "none";
				
			}
			else
			{
				NoteList.style.display = "block";
				NoteView.style.display = "none";
				NoteEntry.style.display = "none";
			}
		}
		
		function OrderHistory_function() {	//Switches the disply to OrderHistory on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			
			if (OrderHistory.style.display === "none") {
				Notes.style.display = "none";
				OrderHistory.style.display = "block";
				Medications.style.display = "none";
				Reports.style.display = "none";
				Laboratory.style.display = "none";
				Imaging.style.display = "none";
				Summary.style.display = "none";
			}
		}
		
		function Medications_function() {	//Switches the disply to Medications on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			var Active = document.getElementById("Active");
			var Discontinued = document.getElementById("Discontinued");
			var All = document.getElementById("All");
			
			if (Medications.style.display === "none") {
				Notes.style.display = "none";
				OrderHistory.style.display = "none";
				Medications.style.display = "block";
				Reports.style.display = "none";
				Laboratory.style.display = "none";
				Imaging.style.display = "none";
				Summary.style.display = "none";
			}
			
			Active.style.display = "block";
			Discontinued.style.display = "none";
			All.style.display = "none";
		}
		
		function Reports_function() {	//Switches the disply to Reports on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			
			if (Reports.style.display === "none") {
				Notes.style.display = "none";
				OrderHistory.style.display = "none";
				Medications.style.display = "none";
				Reports.style.display = "block";
				Laboratory.style.display = "none";
				Imaging.style.display = "none";
				Summary.style.display = "none";
			}
		}
		
		function Laboratory_function() {	//Switches the disply to Laboratory on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Laboratory.style.display === "none") {
				Notes.style.display = "none";
				OrderHistory.style.display = "none";
				Medications.style.display = "none";
				Reports.style.display = "none";
				Laboratory.style.display = "block";
				Imaging.style.display = "none";
				Summary.style.display = "none";
			}
			
				Hematology.style.display = "block";
				Chemistry.style.display = "none";
				Urinalysis.style.display = "none";
				Coagulation.style.display = "none";
				Toxicology.style.display = "none";
				Serology.style.display = "none";
		}
		
		function Imaging_function() {	//Switches the disply to Laboratory on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			
			if (Imaging.style.display === "none") {
				Notes.style.display = "none";
				OrderHistory.style.display = "none";
				Medications.style.display = "none";
				Reports.style.display = "none";
				Laboratory.style.display = "none";
				Imaging.style.display = "block";
				Summary.style.display = "none";
			}
		}
		
		function Summary_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Notes = document.getElementById("Notes");
			var OrderHistory = document.getElementById("OrderHistory");
			var Medications = document.getElementById("Medications");
			var Reports = document.getElementById("Reports");
			var Laboratory = document.getElementById("Laboratory");
			var Imaging = document.getElementById("Imaging");
			var Summary = document.getElementById("Summary");
			var Contacts = document.getElementById("Contacts");
			var RiskLegal = document.getElementById("RiskLegal");
			var Providers = document.getElementById("Providers");
			var Demographics = document.getElementById("Demographics");
			
			if (Summary.style.display === "none") {
				Notes.style.display = "none";
				OrderHistory.style.display = "none";
				Medications.style.display = "none";
				Reports.style.display = "none";
				Laboratory.style.display = "none";
				Imaging.style.display = "none";
				Summary.style.display = "block";
			}
			
			Contacts.style.display = "block";
			RiskLegal.style.display = "none";
			Providers.style.display = "none";
			Demographics.style.display = "none";
		}
		
		//Medications
		function Active_function() {	//Switches the display to Medications on button click disabling all other screens
			var Active = document.getElementById("Active");
			var Discontinued = document.getElementById("Discontinued");
			var All = document.getElementById("All");
			
			if (Active.style.display === "none") {
				Active.style.display = "block";
				Discontinued.style.display = "none";
				All.style.display = "none";
			}
		}
		
		function Discontinued_function() {	//Switches the display to Medications on button click disabling all other screens
			var Active = document.getElementById("Active");
			var Discontinued = document.getElementById("Discontinued");
			var All = document.getElementById("All");
			
			if (Discontinued.style.display === "none") {
				Active.style.display = "none";
				Discontinued.style.display = "block";
				All.style.display = "none";
			}
		}
		
		function All_function() {	//Switches the display to Medications on button click disabling all other screens
			var Active = document.getElementById("Active");
			var Discontinued = document.getElementById("Discontinued");
			var All = document.getElementById("All");
			
			if (All.style.display === "none") {
				Active.style.display = "none";
				Discontinued.style.display = "none";
				All.style.display = "block";
			}
		}
		
		//Laboratory
		function Hematology_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Hematology.style.display === "none") {
				Hematology.style.display = "block";
				Chemistry.style.display = "none";
				Urinalysis.style.display = "none";
				Coagulation.style.display = "none";
				Toxicology.style.display = "none";
				Serology.style.display = "none";
			}
		}
		
		function Chemistry_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Chemistry.style.display === "none") {
				Hematology.style.display = "none";
				Chemistry.style.display = "block";
				Urinalysis.style.display = "none";
				Coagulation.style.display = "none";
				Toxicology.style.display = "none";
				Serology.style.display = "none";
			}
		}
		
		function Urinalysis_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Urinalysis.style.display === "none") {
				Hematology.style.display = "none";
				Chemistry.style.display = "none";
				Urinalysis.style.display = "block";
				Coagulation.style.display = "none";
				Toxicology.style.display = "none";
				Serology.style.display = "none";
			}
		}
		
		function Coagulation_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Coagulation.style.display === "none") {
				Hematology.style.display = "none";
				Chemistry.style.display = "none";
				Urinalysis.style.display = "none";
				Coagulation.style.display = "block";
				Toxicology.style.display = "none";
				Serology.style.display = "none";
			}
		}
		
		function Toxicology_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Toxicology.style.display === "none") {
				Hematology.style.display = "none";
				Chemistry.style.display = "none";
				Urinalysis.style.display = "none";
				Coagulation.style.display = "none";
				Toxicology.style.display = "block";
				Serology.style.display = "none";
			}
		}
		
		function Serology_function() {	//Switches the disply to Summary on button click dissabling all other screens
			var Hematology = document.getElementById("Hematology");
			var Chemistry = document.getElementById("Chemistry");
			var Urinalysis = document.getElementById("Urinalysis");
			var Coagulation = document.getElementById("Coagulation");
			var Toxicology = document.getElementById("Toxicology");
			var Serology = document.getElementById("Serology");
			
			if (Serology.style.display === "none") {
				Hematology.style.display = "none";
				Chemistry.style.display = "none";
				Urinalysis.style.display = "none";
				Coagulation.style.display = "none";
				Toxicology.style.display = "none";
				Serology.style.display = "block";
			}
		}
		
		//Summary
		function Contacts_function() {	//Switches the display to Medications on button click disabling all other screens
			var Contacts = document.getElementById("Contacts");
			var RiskLegal = document.getElementById("RiskLegal");
			var Providers = document.getElementById("Providers");
			var Demographics = document.getElementById("Demographics");
			
			if (Contacts.style.display === "none") {
				Contacts.style.display = "block";
				RiskLegal.style.display = "none";
				Providers.style.display = "none";
				Demographics.style.display = "none";
			}
		}
		
		function RiskLegal_function() {	//Switches the display to Medications on button click disabling all other screens
			var Contacts = document.getElementById("Contacts");
			var RiskLegal = document.getElementById("RiskLegal");
			var Providers = document.getElementById("Providers");
			var Demographics = document.getElementById("Demographics");
			
			if (RiskLegal.style.display === "none") {
				Contacts.style.display = "none";
				RiskLegal.style.display = "block";
				Providers.style.display = "none";
				Demographics.style.display = "none";
			}
		}
		
		function Providers_function() {	//Switches the display to Medications on button click disabling all other screens
			var Contacts = document.getElementById("Contacts");
			var RiskLegal = document.getElementById("RiskLegal");
			var Providers = document.getElementById("Providers");
			var Demographics = document.getElementById("Demographics");
			
			if (Providers.style.display === "none") {
				Contacts.style.display = "none";
				RiskLegal.style.display = "none";
				Providers.style.display = "block";
				Demographics.style.display = "none";
			}
		}
		
		function Demographics_function() {	//Switches the display to Medications on button click disabling all other screens
			var Contacts = document.getElementById("Contacts");
			var RiskLegal = document.getElementById("RiskLegal");
			var Providers = document.getElementById("Providers");
			var Demographics = document.getElementById("Demographics");
			
			if (Demographics.style.display === "none") {
				Contacts.style.display = "none";
				RiskLegal.style.display = "none";
				Providers.style.display = "none";
				Demographics.style.display = "block";
			}
		}
		
		
		function NoteClick() {	//Switches the disply to Notes on button click dissabling all other screens
			var NoteList = document.getElementById("NoteList");
			var NoteView = document.getElementById("NoteView");
			var NoteEntry = document.getElementById("NoteEntry");
			
			if (NoteView.style.display === "none") {
				NoteList.style.display = "none";
				NoteView.style.display = "block";
				NoteEntry.style.display = "none";

			}
		}
		
		function NoteEnrty(){
			var NoteList = document.getElementById("NoteList");
			var NoteView = document.getElementById("NoteView");
			var NoteEntry = document.getElementById("NoteEntry");
			
			if (NoteEntry.style.display === "none") {
				NoteList.style.display = "none";
				NoteView.style.display = "none";
				NoteEntry.style.display = "block";
			}
		}
		
		
		