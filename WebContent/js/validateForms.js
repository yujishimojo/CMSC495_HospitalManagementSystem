function defaultDate(id){
	// Get Current date and set as default value in date field
	var d = new Date();
	var m = d.getMonth()+1;
	var date = d.getDate()
	
	if (m<10){
		m = "0" + m;
	}
	if (date<10){
		date = "0" + date;
	}
	
	document.getElementById(id).value = m +"/"+date+"/"+d.getFullYear();
}

function checkCharacters(str){
	// Check for invalid characters
    if (str.indexOf(";") > -1 || str.indexOf("'") > -1){
        return false;
    }
    return true;
}

function validDate(x){
	var y, z; // Temporary variables to store form input
	var re = /^((0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2})*$/;
	
    if (x != "" && !(x.match(re))){
        return false;
	}
    return true;
}

function generalValidation(form){
	// Remove errors from previous validation (this method should run before any other)
	var errorMessages = ""; 
    var valid = true;
	
	var x, y, z;  // Temporary variables to store form input
	
	// No need to check for blank required fields
	// There is a required attribute being used on the forms themselves
	
	// Get names
    x = form.firstname.value;
    y = form.middlename.value;
    z = form.lastname.value;
    
    // Check name length
    if(x.length > 30 || y.length > 30 || z.length > 30){
        errorMessages += "<br> Name lengths may not exceed 30 characters.";
        valid = false;
    }
    // Check names for invalid characters
    if (!(checkCharacters(x) && checkCharacters(y) && checkCharacters(z))){
    	errorMessages += "<br> Input cannot contain ' or ;";
    	valid = false;
    }
	
    // Check for valid ssn
    x = form.ssn.value;  // get ssn
    x = x.replace(/[^0-9]/g, "");  // removes all non-numeric characters
    if (x.length != 9){  // checks that there are 9 digits
        errorMessages += "<br> SSN should have exactly 9 numeric digits";
        valid = false;
    }
    form.ssn.value = x; // replace original input with purely numeric ssn 

    // Validate address
    x = form.address.value;
    if(x.length > 100){
        errorMessages += "<br> Address length may not exceed 100 characters.";
        valid = false;
    }
    
    if(form.pass1.value != form.pass2.value){
    	form.pass1.value = "";  // clear old passwords
    	form.pass2.value = "";
        errorMessages += "<br> Passwords must match";
        valid = false;
    }
    // Do we want any additional password requirements? 
    
    
	// Display results on page
	if (valid == false){
    	document.getElementById("error-message").style.display = "block";
    	document.getElementById("errors1").innerHTML = errorMessages;
	} else {
    	document.getElementById("errors1").innerHTML = "";
    	document.getElementById("error-message").style.display = "none";
	}
	// Form will only submit if valid
	return valid;
}

function newPatientValidation(form){
	var valid = generalValidation(form);
	// Do not remove error message from previous validation
	var errorMessages = "";
	var x, y, z; //Temporary variables to store form input
	
    // Validate Date
	if (!validDate(form.date.value)){
		errorMessages += "<br> Invalid Date (MUST BE MM/DD/YYYY)";
        valid = false;
	}
	
    // Display results on page
    if (valid == false){
    	document.getElementById("error-message").style.display = "inline-block";
    	document.getElementById("errors2").innerHTML = errorMessages;
	} else {
    	document.getElementById("error-message").style.display = "none";
    	document.getElementById("errors2").innerHTML = "";
    	// alert("Valid input entered."+"\n"+"Form will be submitted");
	}
	return valid;
}


function newStaffValidation(form){
	var valid = generalValidation(form);
	// Do not remove error message from previous validation
	var errorMessages = "";
	var x, y, z; //Temporary variables to store form input
	
	// Check for valid date
	if (!validDate(form.certexpiration.value)){
		errorMessages += "<br> Invalid Date (MUST BE MM/DD/YYYY)";
        valid = false;
	}

	if (form.qualification.value.length > 50){
		errorMessages += "<br> Qualification must be under 50 characters";
        valid = false;
	}

	if (form.cell.value.length > 20){
		errorMessages += "<br> Cell must be under 20 characters";
        valid = false;
	}

	if (form.email.value.length > 50){
		errorMessages += "<br>Email must be under 50 characters";
        valid = false;
	}

	if (form.payroll.value.length > 30){
		errorMessages += "<br> Payroll must be under 30 characters";
        valid = false;
	}
	if (form.details.value.length > 500){
		errorMessages += "<br> Personal details must be under 500 characters";
        valid = false;
	}

	// Regular expression to match required time format
    var re = /^\d{1,2}:\d{2}:\d{2}$/;
    if ((form.clockin.value != "" && !(form.clockin.value.match(re))) || 
    		(form.clockout.value != "" && !(form.clockout.value.match(re)))){
		errorMessages += "<br> Invalid time format (hh:mm:ss)";
        valid = false;
	}

    // Clockout value must be blank if clockin is blank
    if (form.clockout.value != "" && form.clockin.value == ""){
    	errorMessages += "<br> Clock out time may not be entered without clock in time";
        valid = false;
    }

    // Display results on page
    if (valid == false){
    	document.getElementById("error-message").style.display = "block";
    	document.getElementById("errors2").innerHTML = errorMessages;
	} else {
    	document.getElementById("error-message").style.display = "none";
    	document.getElementById("errors2").innerHTML = "";
    	// alert("Valid input entered."+"\n"+"Form will be submitted");
	}
	return valid;
}

function newMedicalFileValidation(form){
	// Remove errors from previous validation (this method should run before any other)
	var errorMessages = ""; 
    var valid = true;

	// Regular expression to match required patient ID format
    var re = /^\d{1,}$/;
    if ((form.patient_id != "" && !(form.patient_id.value.match(re)))){
		errorMessages += "<br> Patient ID must be a number.";
        valid = false;
	}

    // Check for valid dates
	if (!(validDate(form.vdate.value) && validDate(form.start_date.value)
			&& validDate(form.start_date.value))){
		errorMessages += "<br> Invalid Date (MUST BE MM/DD/YYYY)";
        valid = false;
	}

    // End bed date value must be blank if start bed date is blank
    if (form.end_date.value != "" && form.start_date.value == ""){
    	errorMessages += "<br> End bed date may not be entered without start bed date";
        valid = false;
    }

	if (form.disease.value.length > 500){
		errorMessages += "<br> Disease must be under 500 characters";
        valid = false;
	}

	if (form.treatment.value.length > 1000){
		errorMessages += "<br> Treatment must be under 1000 characters";
        valid = false;
	}

	if(!(checkCharacters(form.treatment.value) && checkCharacters(form.medicine_name.value)
			 && checkCharacters(form.notes.value))){
		errorMessages += "<br> Input cannot contain ' or ;";
    	valid = false;
	}

	if (form.medicine_name.value.length > 500){
		errorMessages += "<br> Medicine name must be under 500 characters";
        valid = false;
	}

    // Administered checkbox must be checked if medicine name is not blank
    if (form.medicine_name.value != "" && form.medicine_given[1].checked == false){
    	errorMessages += "<br> Administered must be checked if medicine name is entered";
        valid = false;
    }

	if (form.notes.value.length > 1000){
		errorMessages += "<br> Notes must be under 1000 characters";
        valid = false;
	}

	if (form.billing_amount.value.length > 30){
		errorMessages += "<br> Billing amount must be under 30 characters";
        valid = false;
	}

    // Display results on page
    if (valid == false){
    	document.getElementById("error-message").style.display = "inline-block";
    	document.getElementById("errors2").innerHTML = errorMessages;
	} else {
    	document.getElementById("error-message").style.display = "none";
    	document.getElementById("errors2").innerHTML = "";
    	// alert("Valid input entered."+"\n"+"Form will be submitted");
	}
	return valid;
}