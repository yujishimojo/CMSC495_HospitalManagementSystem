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
    <% ArrayList<String> list = (ArrayList<String>)request.getAttribute("list"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
            <h1>Hygieia</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="NewPatient.jsp">New Patient</a>
                <a href="newstaff.html">New Staff</a>
                <a href="Search.jsp">Search</a>
            </nav>
        </div>
    </header>
    <h2>Registration Successful</h2>
    <!-- ul version -->
    <ul>
        <li>Patient ID: &nbsp;&nbsp;&nbsp; <%out.print(list.get(0));%></li>
        <li>Login Name: &nbsp;&nbsp;&nbsp; <%out.print(list.get(1));%></li>
        <li>Password: &nbsp;&nbsp;&nbsp; <%out.print(list.get(2));%></li>
        <li>First Name: &nbsp;&nbsp;&nbsp; <%out.print(list.get(3));%></li>
        <li>Middle Name: &nbsp;&nbsp;&nbsp; <%out.print(list.get(4));%></li>
        <li>Last Name: &nbsp;&nbsp;&nbsp; <%out.print(list.get(5));%></li>
        <li>SSN: &nbsp;&nbsp;&nbsp; <%out.print(list.get(6));%></li>
        <li>Admitted date: &nbsp;&nbsp;&nbsp; <%out.print(list.get(7));%></li>
        <li>Doctor: &nbsp;&nbsp;&nbsp; <%out.print(list.get(8));%>  <%out.print(list.get(9));%></li>
        <li>Patient Type: &nbsp;&nbsp;&nbsp; <%out.print(list.get(10));%></li>
        <li>Address: &nbsp;&nbsp;&nbsp; <%out.print(list.get(11));%></li>
        <li>Insurance: &nbsp;&nbsp;&nbsp; <%out.print(list.get(12));%></li>
    </ul>
</body>
</html>