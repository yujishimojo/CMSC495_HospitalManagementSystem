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
</head>
<body onload="defaultDate('date')">
    
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
    
    <!-- Header customized by user type -->
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
    
    <h2>New Patient</h2>
    
    <p><small>* required</small><br>
        <span class="error-message" id="error-message">
            <span id="errors1"></span>
            <span id="errors2"></span>
            <span id="errors3">
                <!-- jsp errors go here -->
                
                <!-- start each line with <br> -->
                <!-- text here will be red, small, and italic by default (inline-styles not necessary) -->
                
                <!-- SSN checked -->
                <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("ssn") == "in use") {
                        out.println("<br>The SSN is already in use.");
                    }
                }
                %>
                
                <!-- Doctor name checked -->
                <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("doctor_firstname") == "not found" 
                            || validationMap.get("doctor_lastname") == "not found") {
                        out.println("<br>The doctor name is not found.");
                    }
                }
                %>
            </span> <!-- End of server-side errors -->
        </span> <!-- End of error messages -->
    </p>
    
    <% String pathToNewPatient = request.getContextPath() + "/NewPatient"; %>
    <form name="newpatient" action="<%=pathToNewPatient%>"  method="POST" onsubmit="return newPatientValidation(this);">
        <div class="columns">
        
        <div class="field">
            First Name *<br>
            <input type="text" name="firstname" value="" required>
        </div>
        
        <div class="field">
            Middle Name<br>
            <input type="text" name="middlename" value="">
        </div>
        
        <div class="field">
            Last Name *<br>
            <input type="text" name="lastname" value="" required>
        </div>
        
        <div class="field">
            SSN *
            <small><em>(FAKE ONE)</em></small><br>
            <input type="password" name="ssn" value="" required>
        </div>
        
        <div class="field">
            Admitted Date *<br>
            <input id="date" type="text" name="date" required>
        </div>
        
        <div class="field">
            Insurance *<br>
            <input type="text" name="insurance" value="" required>
        </div>
        
        
        
        <div class="field">
            Doctor's Name *<br>
            <input type="text" name="doctor_firstname" value="" placeholder="First" required><br>
            <input type="text" name="doctor_lastname" placeholder="Last" value="" required>
        </div>
        
        <div class="field">
            Patient Type *<br>
            <input type="radio" name="patienttypegroup" value="Inpatient" checked> Inpatient<br>
            <input type="radio" name="patienttypegroup" value="Outpatient"> Outpatient
        </div>
        
        <div class="field">
            Address<br>
            <textarea type="text" name="address" rows="2"></textarea>
        </div>
        
        <div class="field">
            New Password *<br>
            <input type="password" name="pass1" required><br>
            Retype Password *<br>
            <input type="password" name="pass2" required>
        </div>
        
        <br>
        
        </div> <!-- End of Columns -->
        
        <input type="submit" value="Submit">
    </form>
</body>
</html>