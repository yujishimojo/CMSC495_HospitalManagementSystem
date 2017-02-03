function validateForm() {
    var x, y, z;
    var errorMessages = "Errors\:"+"\n";
    var valid = true;

    //Check name lengths
    x = document.forms["newpatient"]["firstname"].value;
    y = document.forms["newpatient"]["middlename"].value;
    z = document.forms["newpatient"]["lastname"].value;
    if(x.length > 30 || y.length > 30 || z.length > 30){
        errorMessages += "Name length may not exceed 30 characters."+"\n";
        valid = false;
    }
    
    //Check for valid ssn
    x = document.forms["newpatient"]["ssn"].value;
    x = x.replace(/[^0-9]/g, "");  //removes all non-numeric characters
    if (x.length != 9){
        errorMessages += "SSN should have exactly 9 numeric digits"+"\n";
        valid = false;
    }
    document.forms["newpatient"]["ssn"].value = x;

    //Check that passwords match
    if(document.forms["newpatient"]["pass1"].value 
                     != document.forms["newpatient"]["pass2"].value){
        errorMessages += "Passwords must match"+"\n";
        valid = false;
    }
    
    //Validate Date
    x = document.forms["newpatient"]["date"].value;
    y = x.split("/"); //separates parts of date
    z = new Date(); //current date
    if (y.length != 3 || y[0] > 12 || y[1] > 31 || y[2] > d.getFullYear()){
        errorMessages += "Invalid Date (MUST BE MM/DD/YYYY)"+"\n";
        valid = false;
    }

    //Validate address
    x = document.forms["newpatient"]["address"].value;
    if(x.length > 100){
        errorMessages += "Address length may not exceed 100 characters."+"\n";
        valid = false;
    }

    //Display and return results
    if (valid == false){
        alert(errorMessages);
        return false;
    }
}