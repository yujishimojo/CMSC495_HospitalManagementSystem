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
    <%
        String login = (String)session.getAttribute("login");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        }
    %>
    <% HashMap<Integer,String[]> map = (HashMap<Integer,String[]>)request.getAttribute("map"); %>
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
    <%
        if (!map.isEmpty()) {
            out.println("<table border=1>");
            out.println("    <tr>");
            out.println("        <th>Date of Visit</th>");
            out.println("        <th>Patient ID</th>");
            out.println("        <th>First Name</th>");
            out.println("        <th>Middle Name</th>");
            out.println("        <th>Last Name</th>");
            out.println("        <th>Bed Name</th>");
            out.println("        <th>Room Name</th>");
            out.println("        <th>Floor</th>");
            out.println("        <th>Start Bed Date</th>");
            out.println("        <th>End Bed Date</th>");
            out.println("        <th>Status</th>");
            out.println("        <th>Disease Name</th>");
            out.println("        <th>Treatment</th>");
            out.println("        <th>Medicine Given</th>");
            out.println("        <th>Medicine Name</th>");
            out.println("        <th>Ambulance Service</th>");
            out.println("        <th>Billing Amount</th>");
            out.println("        <th>Medical Notes</th>");
            out.println("    </tr>");
            out.println("    <tr>");
        for (int i = 0; i < map.size(); i++) {
            out.println("        <td>" + map.get(i)[0] + "</td>");
            out.println("        <td>" + map.get(i)[1] + "</td>");
            out.println("        <td>" + map.get(i)[2] + "</td>");
            out.println("        <td>" + map.get(i)[3] + "</td>");
            out.println("        <td>" + map.get(i)[4] + "</td>");
            out.println("        <td>" + map.get(i)[5] + "</td>");
            out.println("        <td>" + map.get(i)[6] + "</td>");
            out.println("        <td>" + map.get(i)[7] + "</td>");
            out.println("        <td>" + map.get(i)[8] + "</td>");
            out.println("        <td>" + map.get(i)[9] + "</td>");
            out.println("        <td>" + map.get(i)[10] + "</td>");
            out.println("        <td>" + map.get(i)[11] + "</td>");
            out.println("        <td>" + map.get(i)[12] + "</td>");
            out.println("        <td>" + map.get(i)[13] + "</td>");
            out.println("        <td>" + map.get(i)[14] + "</td>");
            out.println("        <td>" + map.get(i)[15] + "</td>");
            out.println("        <td>" + map.get(i)[16] + "</td>");
            out.println("        <td>" + map.get(i)[17] + "</td>");
        }
            out.println("    </tr>");
            out.println("</table>");
        }
    %>
</body>
</html>