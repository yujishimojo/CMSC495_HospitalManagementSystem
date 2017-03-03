document.addEventListener("DOMContentLoaded", function(){
    document.getElementById('cb-ambulance').addEventListener('click', function(){
        var a = document.getElementsByName('ambulance')[0].value;
        if (a == "off") {
        	document.getElementsByName('ambulance')[0].value = "on"
        } else if (a == "on") {
        	document.getElementsByName('ambulance')[0].value = "off"
        }
//        alert(a);
    });
}, false);

document.addEventListener("DOMContentLoaded", function(){
    document.getElementById('cb-medicine').addEventListener('click', function(){
        var m = document.getElementsByName('medicine_given')[0].value;
        if (m == "off") {
        	document.getElementsByName('medicine_given')[0].value = "on"
        } else if (m == "on") {
        	document.getElementsByName('medicine_given')[0].value = "off"
        }
//        alert(m);
    });
}, false);