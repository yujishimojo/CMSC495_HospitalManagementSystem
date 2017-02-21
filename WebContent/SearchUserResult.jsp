<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search User Result</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
<body>
    <% String login = (String)session.getAttribute("login"); %>
    <% String loginUserRole = (String)session.getAttribute("role"); %>
    <%
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (loginUserRole != "admin" && loginUserRole != "staff") {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        }
    %>
    <% String pathToHome = request.getContextPath() + "/Home"; %>
    <% ArrayList<String> profile = (ArrayList<String>)request.getAttribute("profile"); %>
    <% ArrayList<String> shift = (ArrayList<String>)request.getAttribute("shift"); %>
    <% int searchUserRole = (int)request.getAttribute("role"); %>
    <% int doctor_id = (int)request.getAttribute("doctor_id"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
            <h1>Hygieia</h1>
            <nav>
                <a href="#" onClick="location.href='<%=pathToHome%>'">Home</a>
                <%
                    if (loginUserRole == "admin" || loginUserRole == "staff") {
                        out.println("<a href=\"NewPatient.jsp\">New Patient</a>");
                    }
                %>
                <%
                    if (loginUserRole == "admin") {
                        out.println("<a href=\"NewStaff.jsp\">New Staff</a>");
                    }
                %>
                <%
                    if (loginUserRole == "admin" || loginUserRole == "staff") {
                        out.println("<a href=\"NewMedicalFile.jsp\">New Medical File</a>");
                    }
                %>
                <%
                    if (loginUserRole == "admin" || loginUserRole == "staff") {
                        out.println("<a href=\"Search.jsp\">Search</a>");
                    }
                %>
            </nav>
        </div>
    </header>
    <%
        if (!profile.isEmpty()) {
            if (searchUserRole == 0) {   // administrator
                out.println("<table>");
                out.println("    <tr><th>Role:</th><td>" + profile.get(0) + "</td></tr>");
                out.println("    <tr><th>User ID:</th><td>" + profile.get(1) + "</td></tr>");
                out.println("    <tr><th>Login Name:</th><td>" + profile.get(2) + "</td></tr>");
                out.println("    <tr><th>First Name:</th><td>" + profile.get(3) + "</td></tr>");
                out.println("    <tr><th>Middle Name:</th><td>" + profile.get(4) + "</td></tr>");
                out.println("    <tr><th>Last Name:</th><td>" + profile.get(5) + "</td></tr>");
                out.println("    <tr><th>SSN:</th><td>" + profile.get(6) + "</td></tr>");
                out.println("    <tr><th>Address:</th><td>" + profile.get(7) + "</td></tr>");
                out.println("</table>");
            } else if (searchUserRole == 1) {   // medical staff
                out.println("<table>");
                out.println("    <tr><th>Role:</th><td>" + profile.get(0) + "</td></tr>");
                out.println("    <tr><th>Staff ID:</th><td>" + profile.get(1) + "</td></tr>");
                if (doctor_id != 0) {
                    out.println("    <tr><th>Doctor ID:</th><td>" + doctor_id + "</td></tr>");
                }
                out.println("    <tr><th>Login Name:</th><td>" + profile.get(2) + "</td></tr>");
                out.println("    <tr><th>First Name:</th><td>" + profile.get(3) + "</td></tr>");
                out.println("    <tr><th>Middle Name:</th><td>" + profile.get(4) + "</td></tr>");
                out.println("    <tr><th>Last Name:</th><td>" + profile.get(5) + "</td></tr>");
                out.println("    <tr><th>SSN:</th><td>" + profile.get(6) + "</td></tr>");
                out.println("    <tr><th>Address:</th><td>" + profile.get(7) + "</td></tr>");
                out.println("    <tr><th>Qualification:</th><td>" + profile.get(8) + "</td></tr>");
                out.println("    <tr><th>Certification expiration:</th><td>" + profile.get(9) + "</td></tr>");
                out.println("    <tr><th>Cell phone number:</th><td>" + profile.get(10) + "</td></tr>");
                out.println("    <tr><th>Email address:</th><td>" + profile.get(11) + "</td></tr>");
                out.println("    <tr><th>Payroll:</th><td>" + profile.get(12) + "</td></tr>");
                out.println("    <tr><th>Personal details:</th><td>" + profile.get(13) + "</td></tr>");
                if (!shift.isEmpty()) {
                    out.println("    <tr><th>Clock in time:</th><td>" + shift.get(0) + "</td></tr>");
                    out.println("    <tr><th>Clock out time:</th><td>" + shift.get(1) + "</td></tr>");
                    out.println("    <tr><th>Status:</th><td>" + shift.get(2) + "</td></tr>");
                }
                out.println("</table>");
            } else if (searchUserRole == 2) {   // patient
                out.println("<table>");
                out.println("    <tr><th>Role:</th><td>" + profile.get(0) + "</td></tr>");
                out.println("    <tr><th>Patient ID:</th><td>" + profile.get(1) + "</td></tr>");
                out.println("    <tr><th>Login Name:</th><td>" + profile.get(2) + "</td></tr>");
                out.println("    <tr><th>First Name:</th><td>" + profile.get(3) + "</td></tr>");
                out.println("    <tr><th>Middle Name:</th><td>" + profile.get(4) + "</td></tr>");
                out.println("    <tr><th>Last Name:</th><td>" + profile.get(5) + "</td></tr>");
                out.println("    <tr><th>SSN:</th><td>" + profile.get(6) + "</td></tr>");
                out.println("    <tr><th>Address:</th><td>" + profile.get(7) + "</td></tr>");
                out.println("    <tr><th>Admitted date:</th><td>" + profile.get(8) + "</td></tr>");
                out.println("    <tr><th>Doctor:</th><td>" + profile.get(9) + "  " + profile.get(10) + "</td></tr>");
                out.println("    <tr><th>Patient Type:</th><td>" + profile.get(11) + "</td></tr>");
                out.println("    <tr><th>Insurance:</th><td>" + profile.get(12) + "</td></tr>");
                out.println("</table>");
            }
        }
    %>
</body>
</html>