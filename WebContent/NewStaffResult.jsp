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
    <%
        String login = (String)session.getAttribute("login");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        }
    %>
    <% ArrayList<String> profile = (ArrayList<String>)request.getAttribute("profile"); %>
    <% ArrayList<String> shift = (ArrayList<String>)request.getAttribute("shift"); %>
    <% int doctor_id = (int)request.getAttribute("doctor_id"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
            <h1>Hygieia</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="NewPatient.jsp">New Patient</a>
                <a href="NewStaff.jsp">New Staff</a>
                <a href="NewMedicalFile.jsp">New Medical File</a>
                <a href="Search.jsp">Search</a>
            </nav>
        </div>
    </header>
    <h2>Registration Successful</h2>
   <%
        if (!profile.isEmpty()) {
            out.println("<ul>");
            out.println("    <li>Staff ID: &nbsp;&nbsp;&nbsp; " + profile.get(0) + "</li>");
            out.println("    <li>Staff Type: &nbsp;&nbsp;&nbsp; " + profile.get(14) + "</li>");
            if (doctor_id != 0) {
                out.println("    <li>Doctor ID: &nbsp;&nbsp;&nbsp; " + doctor_id + "</li>");
            }
            out.println("    <li>Login Name: &nbsp;&nbsp;&nbsp; " + profile.get(1) + "</li>");
            out.println("    <li>Password: &nbsp;&nbsp;&nbsp; " + profile.get(2) + "</li>");
            out.println("    <li>First Name: &nbsp;&nbsp;&nbsp; " + profile.get(3) + "</li>");
            out.println("    <li>Middle Name: &nbsp;&nbsp;&nbsp; " + profile.get(4) + "</li>");
            out.println("    <li>Last Name: &nbsp;&nbsp;&nbsp; " + profile.get(5) + "</li>");
            out.println("    <li>SSN: &nbsp;&nbsp;&nbsp; " + profile.get(6) + "</li>");
            out.println("    <li>Address: &nbsp;&nbsp;&nbsp; " + profile.get(7) + "</li>");
            out.println("    <li>Qualification: &nbsp;&nbsp;&nbsp; " + profile.get(8) + "</li>");
            out.println("    <li>Certification expiration: &nbsp;&nbsp;&nbsp; " + profile.get(9) + "</li>");
            out.println("    <li>Cell phone number: &nbsp;&nbsp;&nbsp; " + profile.get(10) + "</li>");
            out.println("    <li>Email address: &nbsp;&nbsp;&nbsp; " + profile.get(11) + "</li>");
            out.println("    <li>Payroll: &nbsp;&nbsp;&nbsp; " + profile.get(12) + "</li>");
            out.println("    <li>Personal details: &nbsp;&nbsp;&nbsp; " + profile.get(13) + "</li>");
            if (!shift.isEmpty()) {
                out.println("    <li>Clock in time: &nbsp;&nbsp;&nbsp; " + shift.get(0) + "</li>");
                out.println("    <li>Clock out time: &nbsp;&nbsp;&nbsp; " + shift.get(1) + "</li>");
                out.println("    <li>Status: &nbsp;&nbsp;&nbsp; " + shift.get(2) + "</li>");
            }
            out.println("</ul>");
        }
    %>
</body>
</html>