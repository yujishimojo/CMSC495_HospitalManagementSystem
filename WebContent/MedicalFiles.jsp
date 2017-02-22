<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Medical Files</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
<body>
    <% String login = (String)session.getAttribute("login"); %>
    <% String role = (String)session.getAttribute("role"); %>
    <%
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (role != "patient") {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        }
    %>
    <% String pathToHome = request.getContextPath() + "/Home"; %>
    <% String pathToMedicalFiles = request.getContextPath() + "/MedicalFiles"; %>
    <% HashMap<String,String> validationMap = (HashMap<String,String>)request.getAttribute("validationMap"); %>
    <% HashMap<Integer,String[]> map = (HashMap<Integer,String[]>)request.getAttribute("map"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
            <h1>Hygieia</h1>
            <nav>
                <a href="#" onClick="location.href='<%=pathToHome%>'">Home</a>
                <%
                    if (role == "patient") {
                        out.println("<a href=\"#\" onClick=\"location.href=\'" + pathToMedicalFiles + "\'\" >Medical Files</a>");
                    }
                %>
            </nav>
        </div>
    </header>
    <%
        if (validationMap.get("medical_file") == "found") {
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
        } else if (validationMap.get("medical_file") == "not found") {
        	out.println("<h3>There are no medical files.</h3>");
        }
    %>
</body>
</html>