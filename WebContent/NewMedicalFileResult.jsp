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
    <% ArrayList<String> list = (ArrayList<String>)request.getAttribute("list"); %>
    <% ArrayList<String> bedUsage = (ArrayList<String>)request.getAttribute("bedUsage"); %>
    <% ArrayList<String> medicine = (ArrayList<String>)request.getAttribute("medicine"); %>
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
        if (!list.isEmpty()) {
            out.println("<ul>");
            out.println("    <li>Patient ID: &nbsp;&nbsp;&nbsp; " + list.get(0) + "</li>");
            out.println("    <li>Patient Name: &nbsp;&nbsp;&nbsp; " + list.get(1) + "</li>");
            out.println("    <li>Date of Visit: &nbsp;&nbsp;&nbsp; " + list.get(2) + "</li>");
            out.println("    <li>Bed Name: &nbsp;&nbsp;&nbsp; " + list.get(3) + "</li>");
            out.println("    <li>Room Name: &nbsp;&nbsp;&nbsp; " + list.get(4) + "</li>");
            out.println("    <li>Floor: &nbsp;&nbsp;&nbsp; " + list.get(5) + "</li>");
            out.println("    <li>Start Bed Date: &nbsp;&nbsp;&nbsp; " + bedUsage.get(0) + "</li>");
            if (!bedUsage.get(1).equals(null) && !bedUsage.get(1).equals("")) {
                out.println("    <li>End Bed Date: &nbsp;&nbsp;&nbsp; " + bedUsage.get(1) + "</li>");
            }
            out.println("    <li>Bed Status: &nbsp;&nbsp;&nbsp; " + bedUsage.get(2) + "</li>");
            out.println("    <li>Disease Name: &nbsp;&nbsp;&nbsp; " + list.get(6) + "</li>");
            out.println("    <li>Treatment: &nbsp;&nbsp;&nbsp; " + list.get(7) + "</li>");
            out.println("    <li>Medicine Given: &nbsp;&nbsp;&nbsp; " + medicine.get(0) + "</li>");
            if (medicine.get(0).equals("Yes")) {
                out.println("    <li>Medicine Name: &nbsp;&nbsp;&nbsp; " + medicine.get(1) + "</li>");
            }
            out.println("    <li>Medical Notes: &nbsp;&nbsp;&nbsp; " + list.get(10) + "</li>");
            out.println("    <li>Ambulance Service: &nbsp;&nbsp;&nbsp; " + list.get(8) + "</li>");
            out.println("    <li>Billing Amount: &nbsp;&nbsp;&nbsp; " + list.get(9) + "</li>");
            out.println("</ul>");
        }
    %>
</body>
</html>