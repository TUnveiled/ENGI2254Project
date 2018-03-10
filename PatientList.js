function run() {
	var url = window.location.href;
	var default_url = "http://localhost/PatientList.html"
	var Unit = ""
	
	if(url == default_url + "?Unit2A"){
		Unit = "2A";
    }
	else if(url == default_url + "?Unit2B"){
		Unit = "2B";
    }
	else if(url == default_url + "?Unit3A"){
		Unit = "3A";
    }
	else if(url == default_url + "?Unit3B"){
		Unit = "3B";
    }
	else if(url == default_url + "?Unit4A"){
		Unit = "4A";
    }
	else if(url == default_url + "?Unit4B"){
		Unit = "4B";
    }
	else if(url == default_url + "?Unit5A"){
		Unit = "5A";
    }
	else if(url == default_url + "?Unit5B"){
		Unit = "5B";
    }
	//else{
	//	document.write("ERROR - Unit not Found");
	//}
	//document.write(Unit);
	window.location.href = "PatientList.php?Units=" + Unit;
}

function CalcAge(birthday) { // birthday is a date
			var ageDifMs = Date.now() - birthday.getTime();
			var ageDate = new Date(ageDifMs); // miliseconds from epoch
			//return Math.abs(ageDate.getUTCFullYear() - 1970);
			return 6;
		}
