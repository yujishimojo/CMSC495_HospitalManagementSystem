<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>New Patient Result</title>
    <link rel="stylesheet" href="css/styles.css"/>
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
    <% ArrayList<String> profile = (ArrayList<String>)request.getAttribute("profile"); %>
    <% ArrayList<String> shift = (ArrayList<String>)request.getAttribute("shift"); %>
    <% int doctor_id = (int)request.getAttribute("doctor_id"); %>

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
    <h2>Registration Successful</h2>
    <%
         if (!profile.isEmpty()) {
             out.println("<table class='portrait'>");
             out.println("    <tr><th>Staff ID:</th><td>" + profile.get(0) + "</td></tr>");
             out.println("    <tr><th>Staff Type:</th><td>" + profile.get(13) + "</td></tr>");
             if (doctor_id != 0) {
                 out.println("    <tr><th>Doctor ID:</th><td>" + doctor_id + "</td></tr>");
             }
             out.println("    <tr><th>Login Name:</th><td>" + profile.get(1) + "</td></tr>");
             out.println("    <tr><th>Password:</th><td>" + profile.get(2) + "</td></tr>");
             out.println("    <tr><th>First Name:</th><td>" + profile.get(3) + "</td></tr>");
             out.println("    <tr><th>Middle Name:</th><td>" + profile.get(4) + "</td></tr>");
             out.println("    <tr><th>Last Name:</th><td>" + profile.get(5) + "</td></tr>");
             out.println("    <tr><th>Address:</th><td>" + profile.get(6) + "</td></tr>");
             out.println("    <tr><th>Qualification:</th><td>" + profile.get(7) + "</td></tr>");
             out.println("    <tr><th>Certification expiration:</th><td>" + profile.get(8) + "</td></tr>");
             out.println("    <tr><th>Cell phone number:</th><td>" + profile.get(9) + "</td></tr>");
             out.println("    <tr><th>Email address:</th><td>" + profile.get(10) + "</td></tr>");
             out.println("    <tr><th>Payroll:</th><td>" + profile.get(11) + "</td></tr>");
             out.println("    <tr><th>Personal details:</th><td>" + profile.get(12) + "</td></tr>");
             if (!shift.isEmpty()) {
                 out.println("    <tr><th>Clock in time:</th><td>" + shift.get(0) + "</td></tr>");
                 out.println("    <tr><th>Clock out time:</th><td>" + shift.get(1) + "</td></tr>");
                 out.println("    <tr><th>Status:</th><td>" + shift.get(2) + "</td></tr>");
             }
             out.println("</table>");
         }
    %>
</body>
</html>