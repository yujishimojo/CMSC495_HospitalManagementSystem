<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
                <a href="newpatient.html">New Patient</a>
                <a href="newstaff.html">New Staff</a>
                <a href="search.html">Search</a>
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

    <!-- dl version -->
<%--     <dl>
        <dt>Patient ID:</dt>
        <dd><%out.print(list.get(0));%></dd>
        <dt>Login Name:</dt>
        <dd><%out.print(list.get(1));%></dd>
        <dt>Password:</dt>
        <dd><%out.print(list.get(2));%></dd>
        <dt>First Name:</dt>
        <dd><%out.print(list.get(3));%></dd>
        <dt>Middle Name:</dt>
        <dd><%out.print(list.get(4));%></dd>
        <dt>Last Name:</dt>
        <dd><%out.print(list.get(5));%></dd>
        <dt>SSN:</dt>
        <dd><%out.print(list.get(6));%></dd>
        <dt>Admitted date:</dt>
        <dd><%out.print(list.get(7));%></dd>
        <dt>Doctor:</dt>
        <dd><%out.print(list.get(8));%> <%out.print(list.get(9));%></dd>
        <dt>Patient Type:</dt>
        <dd><%out.print(list.get(10));%></dd>
        <dt>Address:</dt>
        <dd><%out.print(list.get(11));%></dd>
        <dt>Insurance:</dt>
        <dd><%out.print(list.get(12));%></dd>
    </dl> --%>

    <% String pathToNewPatientJsp = request.getContextPath() + "/index.html"; %>
    <h3><a href="<%=pathToNewPatientJsp%>" target="_self"> Return to Home Page.</a></h3>

</body>
</html>