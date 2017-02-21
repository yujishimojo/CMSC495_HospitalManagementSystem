<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>New Medical File Result</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
<body>
    <%
        String login = (String)session.getAttribute("login");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        }
    %>
    <% String pathToHome = request.getContextPath() + "/Home"; %>
    <% ArrayList<String> list = (ArrayList<String>)request.getAttribute("list"); %>
    <% ArrayList<String> bedUsage = (ArrayList<String>)request.getAttribute("bedUsage"); %>
    <% ArrayList<String> medicine = (ArrayList<String>)request.getAttribute("medicine"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
            <h1>Hygieia</h1>
            <nav>
                <a href="#" onClick="location.href='<%=pathToHome%>'">Home</a>
                <a href="NewPatient.jsp">New Patient</a>
                <a href="NewStaff.jsp">New Staff</a>
                <a href="NewMedicalFile.jsp">New Medical File</a>
                <a href="Search.jsp">Search</a>
            </nav>
        </div>
    </header>
    <h2>Registration Successful</h2>
   <%
        if (!list.isEmpty()) {
            out.println("<table>");
            out.println("    <tr><th>Patient ID:</th><td>" + list.get(0) + "</td></tr>");
            out.println("    <tr><th>Patient Name:</th><td>" + list.get(1) + "</td></tr>");
            out.println("    <tr><th>Date of Visit:</th><td>" + list.get(2) + "</td></tr>");
            out.println("    <tr><th>Bed Name:</th><td>" + list.get(3) + "</td></tr>");
            out.println("    <tr><th>Room Name:</th><td>" + list.get(4) + "</td></tr>");
            out.println("    <tr><th>Floor:</th><td>" + list.get(5) + "</td></tr>");
            out.println("    <tr><th>Start Bed Date:</th><td>" + bedUsage.get(0) + "</td></tr>");
            if (!bedUsage.get(1).equals(null) && !bedUsage.get(1).equals("")) {
                out.println("    <tr><th>End Bed Date:</th><td>" + bedUsage.get(1) + "</td></tr>");
            }
            out.println("    <tr><th>Bed Status:</th><td>" + bedUsage.get(2) + "</td></tr>");
            out.println("    <tr><th>Disease Name:</th><td>" + list.get(6) + "</td></tr>");
            out.println("    <tr><th>Treatment:</th><td>" + list.get(7) + "</td></tr>");
            out.println("    <tr><th>Medicine Given:</th><td>" + medicine.get(0) + "</td></tr>");
            if (medicine.get(0).equals("Yes")) {
                out.println("    <li>Medicine Name:</th><td>" + medicine.get(1) + "</td></tr>");
            }
            out.println("    <tr><th>Medical Notes:</th><td>" + list.get(10) + "</td></tr>");
            out.println("    <tr><th>Ambulance Service:</th><td>" + list.get(8) + "</td></tr>");
            out.println("    <tr><th>Billing Amount:</th><td>" + list.get(9) + "</td></tr>");
            out.println("</table>");
        }
    %>
</body>
</html>