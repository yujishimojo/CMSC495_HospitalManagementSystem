/**
 * 
 */

function defaultDate(id){
	//Get Current date and set as default value in date field
	var d = new Date();
	var m = d.getMonth()+1;
	document.getElementById(id).value = m +"/"+d.getDate()+"/"+d.getFullYear();
}

function checkCharacters(str){
	//Check for invalid characters
    if (str.indexOf(";") > -1 || str.indexOf("'") > -1){
        return false;
    }
    return true;
}

function validDate(x){
	var y, z; //Temporary variables to store form input

	//Field will only be black if not required
	//So blank date fields are valid
	if (x=="") {
		return true;
	}
	
    //Validate Date
    y = x.split("/"); //separates parts of date
    z = new Date(); //current date
    if (y.length != 3 || y[0] > 12 || y[1] > 31){
        return false;
    }
    return true;
}

function generalValidation(form){
	//Remove errors from previous validation (this method should run before any other)
	var errorMessages = ""; 
    var valid = true;
	
	var x, y, z; //Temporary variables to store form input
	
	//No need to check for blank required fields
	//There is a required attribute being used on the forms themselves
	
	//Get names
    x = form.firstname.value;
    y = form.middlename.value;
    z = form.lastname.value;
    
    //Check name length
    if(x.length > 30 || y.length > 30 || z.length > 30){
        errorMessages += "<br> Name lengths may not exceed 30 characters.";
        valid = false;
    }
    //Check names for invalid characters
    if (!(checkCharacters(x) && checkCharacters(y) && checkCharacters(z))){
    	errorMessages += "<br> Input cannot contain ' or ;";
    	valid = false;
    }
	
    //Check for valid ssn
    x = form.ssn.value; //Get ssn
    x = x.replace(/[^0-9]/g, "");  //removes all non-numeric characters
    if (x.length != 9){//checks that there are 9 digits
        errorMessages += "<br> SSN should have exactly 9 numeric digits";
        valid = false;
    }
    form.ssn.value = x; //replace original input with purely numeric ssn 

    //Validate address
    x = form.address.value;
    if(x.length > 100){
        errorMessages += "<br> Address length may not exceed 100 characters.";
        valid = false;
    }
    
    if(form.pass1.value != form.pass2.value){
    	form.pass1.value = "";//clear old passwords
    	form.pass2.value = "";
        errorMessages += "<br> Passwords must match";
        valid = false;
    }
    //Do we want any additional password requirements? 
    
    
	//Display results on page
	if (valid == false){
    	document.getElementById("error-message").style.display = "block";
    	document.getElementById("errors1").innerHTML = errorMessages;
	} else {
    	document.getElementById("errors1").innerHTML = "";
    	document.getElementById("error-message").style.display = "none";
	}
	//Form will only submit if valid
	return valid;
}

function newPatientValidation(form){
	var valid = generalValidation(form);
	//Do not remove error message from previous validation
	var errorMessages = "";
	var x, y, z; //Temporary variables to store form input
	
    //Validate Date
	if (!validDate(form.date.value)){
		errorMessages += "<br> Invalid Date (MUST BE MM/DD/YYYY)";
        valid = false;
	}
	
    //Display results on page
    if (valid == false){
    	document.getElementById("error-message").style.display = "inline-block";
    	document.getElementById("errors2").innerHTML = errorMessages;
    	//alert("Invalid Input");
	} else {
    	document.getElementById("error-message").style.display = "none";
    	document.getElementById("errors2").innerHTML = "";
    	alert("Valid input entered."+"\n"+"Form will be submitted");
	}
	return valid;
}


function newStaffValidation(form){
	var valid = generalValidation(form);
	//Do not remove error message from previous validation
	var errorMessages = "";
	var x, y, z; //Temporary variables to store form input
	
	//Check for valid date
	if (!validDate(form.certexpiration.value)){
		errorMessages += "<br> Invalid Date (MUST BE MM/DD/YYYY)";
        valid = false;
	}
	
    //Display results on page
    if (valid == false){
    	document.getElementById("error-message").style.display = "block";
    	document.getElementById("errors2").innerHTML = errorMessages;
    	//alert("Invalid Input");
	} else {
    	document.getElementById("error-message").style.display = "none";
    	document.getElementById("errors2").innerHTML = "";
    	alert("Valid input entered."+"\n"+"Form will be submitted");
	}
	return valid;
}

function newMedicalFileValidation(form){
	//Remove errors from previous validation (this method should run before any other)
	var errorMessages = ""; 
    var valid = true;
	
	var x, y, z; //Temporary variables to store form input
	
	
	//Check for valid date
	if (!validDate(form.vdate.value)){
		errorMessages += "<br> Invalid Date (MUST BE MM/DD/YYYY)";
        valid = false;
	}
	
    //Display results on page
    if (valid == false){
    	document.getElementById("error-message").style.display = "inline-block";
    	document.getElementById("errors1").innerHTML = errorMessages;
    	//alert("Invalid Input");
	} else {
    	document.getElementById("error-message").style.display = "none";
    	document.getElementById("errors1").innerHTML = "";
    	alert("Valid input entered."+"\n"+"Form will be submitted");
	}
	return valid;
}