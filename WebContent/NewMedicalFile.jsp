<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CMSC 495 - Group 4</title>
    <link rel="stylesheet" href="css/styles.css"/>
    <script src="js/validateForms.js"></script>
    <script src="js/changeNameAttributes.js"></script>
</head>
<body onload="defaultDate('vdate')">

    <!-- Check whether logged in and user type -->
    <% String login = (String)session.getAttribute("login"); %>
    <% String role = (String)session.getAttribute("role"); %>
    <%
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (role != "admin" && role != "staff") {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        }
    %>

    <% String pathToHome = request.getContextPath() + "/Home"; %>
    <% HashMap<String,String> validationMap = (HashMap<String,String>)request.getAttribute("validationMap"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
           <h1>Hygieia</h1>
            <nav>
                <a href="#" onClick="location.href='<%=pathToHome%>'">Home</a>
                <%
                    if (role == "admin" || role == "staff") {
                       out.println("<a href=\"NewPatient.jsp\">New Patient</a>");
                    }
                %>
                <%
                    if (role == "admin") {
                        out.println("<a href=\"NewStaff.jsp\">New Staff</a>");
                    }
                %>
                <%
                    if (role == "admin" || role == "staff") {
                        out.println("<a href=\"NewMedicalFile.jsp\">New Medical File</a>");
                    }
                %>
                <%
                    if (role == "admin") {
                        out.println("<a href=\"NewBed.jsp\">New Bed</a>");
                    }
                %>
                <%
                    if (role == "admin") {
                        out.println("<a href=\"NewRoom.jsp\">New Room</a>");
                    }
                %>
                <%
                    if (role == "admin" || role == "staff") {
                        out.println("<a href=\"Search.jsp\">Search</a>");
                    }
                %>
            </nav>
        </div>
    </header>

    <h2>New Medical File</h2>

    <p><small>* required</small><br>
        <span class="error-message" id="error-message">
            <span id="errors1"></span>
            <span id="errors2">
                <!-- jsp errors go here -->

                <!-- start each line with <br> -->

                <!-- Check for valid patient id, bed name, and start date -->
                <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    boolean errorFound = false;
                    if (validationMap.get("patient_id") == "invalid format") {
                        out.println("<br>The patient ID is not a valid format. The field must be a proper patient ID number.");
                        errorFound = true;
                    }
                    if (validationMap.get("patient_id") == "not found") {
                        out.println("<br>The patient ID is not found.");
                        errorFound = true;
                    }
                    if (validationMap.get("bed_name") == "not found") {
                        out.println("<br>Bed name is not found.");
                        errorFound = true;
                    }
                    if (validationMap.get("bed_name") == "empty") {
                        out.println("<br>Bed name is requied for inpatients.");
                        errorFound = true;
                    }
                    if (validationMap.get("start_date") == "empty") {
                        out.println("<br>Start bed date is requied for inpatients.");
                        errorFound = true;
                    }

                    if(!errorFound){
                        out.println("<br>Unknown Error");
                    }
                }
                %>
            </span>
        </span>
    </p>
    
    <% String pathToNewMedicalFile = request.getContextPath() + "/NewMedicalFile"; %>
    <form name="newmedfile"  action="<%=pathToNewMedicalFile%>" method="POST" onsubmit="return newMedicalFileValidation(this);">
        <div class="columns">
        
        <div class="field">
            Patient ID *<br>
            <input type="text" name="patient_id" value="" required>
        </div>
        
        <div class="field">
            Visit Date *<br>
            <input id="vdate" type="text" name="vdate" required>
        </div>
        
        <div class="field">
            <input type="hidden" name="ambulance" value="off">
            <input type="checkbox" id="cb-ambulance" name="ambulance" value="on"> Ambulance Service Used
        </div>
        
        <div class="field">
            Bed Name<br>
            <input type="text" name="bed_name" value="">
        </div>
        
        <div class="field">
            Start Bed Date <br>
            <input id="date" type="text" name="start_date">
        </div>
        
        <div class="field">
            End Bed Date<br>
            <input id="date" type="text" name="end_date">
        </div>
        
        <div class="field">
            Disease Name *<br>
            <input type="text" name="disease" value="" required>
        </div>
        
        <div class="field">
            Treatment *<br>
            <textarea type="text" name="treatment" rows="3" required></textarea>
        </div>
        
        <div class="field">
            Medicine Name<br>
            <input type="text" name="medicine_name" value="">
            <small><input type="hidden" name="medicine_given" value="off">
            <input type="checkbox" id="cb-medicine" name="medicine_given" value="on"> Administered</small>
        </div>
        <!-- 
        <div class="field">
            Medicine Given<br>
            <input type="hidden" name="medicine_given" value="off">
            <input type="checkbox" name="medicine_given" value="on"> Medicine Given
        </div>
        -->
        
        <div class="field">
            Medical Notes <br>
            <textarea type="text" name="notes" rows="3"></textarea>
        </div>
        
        <div class="field">
            Billing Amount *<br>
            <input type="number" name="billing_amount" min="0" value="0" step="0.01" required>
        </div>
        
        <br>
        
        </div> <!-- End of Columns -->
        
        <input type="submit" value="Submit">
        
    </form>

    <% String pathToLogout = request.getContextPath() + "/Logout"; %>
    <input type="button" value="Logout" align="right" onClick="location.href='<%=pathToLogout%>'">

</body>
</html>
