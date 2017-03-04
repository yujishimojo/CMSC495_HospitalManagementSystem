<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>New Staff</title>
    <link rel="stylesheet" href="css/styles.css"/>
    <script src="js/validateForms.js"></script>
</head>
<body>

    <!-- Check whether logged in and user type -->
    <% String login = (String)session.getAttribute("login"); %>
    <% String role = (String)session.getAttribute("role"); %>
    <%
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (role != "admin") {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        }
    %>

    <!-- Set the path for Home servlet class -->
    <% String pathToHome = request.getContextPath() + "/Home"; %>

    <!-- Get attributes forwarded by NewStaff servlet -->
    <% HashMap<String,String> validationMap = (HashMap<String,String>)request.getAttribute("validationMap"); %>

    <!-- Header customized by user type -->
    <header>
        <a href="#" onClick="location.href='<%=pathToHome%>'"><img src="images/logo_notext.png"></a>
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
    <h2>New Staff</h2>
    
    <p><small>* required</small><br>
        <span class="error-message" id="error-message">
            <span id="errors1"></span>
            <span id="errors2">
                <!-- jsp errors go here -->

                <!-- start each line with <br> -->

                <!-- name and SSN checked -->
                <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    boolean errorFound = false;
                    if (validationMap.get("name") == "in use") {
                        out.println("<br>First and Last Names are already in use.");
                        errorFound = true;
                    }
                    if (validationMap.get("ssn") == "in use") {
                        out.println("<br>SSN is already in use.");
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
    
    <% String pathToNewStaff = request.getContextPath() + "/NewStaff"; %>
    <form name="newstaff" action="<%=pathToNewStaff%>" method="POST" onsubmit="return newStaffValidation(this);">
        <div class="columns">
        
        <div class="field">
            First Name *
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
            Staff Type *<br>
            <input type="radio" name="stafftypegroup" value="doctor"> Doctor<br>
            <input type="radio" name="stafftypegroup" value="staff" checked> Staff
        </div>
        
        <div class="field">
            Address<br>
            <textarea type="text" name="address" rows="2"></textarea>
        </div>
        
        <div class="field">
            Qualification *<br>
            <input type="text" name="qualification" value="" required>
        </div>
        
        <div class="field">
            Certification Expiration<br>
            <input type="text" name="certexpiration" value="">
        </div>
        
        <div class="field">
            Cell Number<br>
            <input type="text" name="cell" value="">
        </div>
        
        <div class="field">
            Email Address *<br>
            <input type="email" name="email" value="" required>
        </div>
        
        <div class="field">
            Payroll *<br>
            <input type="text" name="payroll" value="" required>
        </div>
        
        <div class="field">
            Personal Details<br>
            <textarea type="text" name="details" rows="3"></textarea>
        </div>
        
        <div class="field">
            New Password *<br>
            <input type="password" name="pass1" required>
            Retype Password *<br>
            <input type="password" name="pass2" required>
        </div>
        
        <div class="field">
            Clock In Time<br>
            <input type="text" name="clockin" value="">
        </div>
        
        <div class="field">
            Clock Out time<br>
            <input type="text" name="clockout" value="">
        </div>
        
        <div class="field">
            Status *<br>
            <input type="radio" name="statusgroup" value="normal" checked> Normal<br>
            <input type="radio" name="statusgroup" value="emergency"> Emergency
        </div>
        
        <br>
        
        </div> <!-- End of Columns -->
        
        <input type="submit" value="Submit">
    </form>

    <!-- Set the path for Logout servlet -->
    <% String pathToLogout = request.getContextPath() + "/Logout"; %>
    <input type="button" value="Logout" align="right" onClick="location.href='<%=pathToLogout%>'">
</body>
</html>