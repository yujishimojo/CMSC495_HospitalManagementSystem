<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

    <ul>
        <li>Patient ID:</li>
        <li>Login Name:</li>
        <li>Password:</li>
        <li>First Name:</li>
        <li>Middle Name:</li>
        <li>Last Name:</li>
        <li>SSN:</li>
        <li>Admitted date:</li>
        <li>Doctor:</li>
        <li>Patient Type:</li>
        <li>Address:</li>
        <li>Insurance:</li>
    </ul>

    <% String pathToNewPatientJsp = request.getContextPath() + "/index.html"; %>
    <h3><a href="<%=pathToNewPatientJsp%>" target="_self"> Return to Home Page.</a></h3>

</body>
</html>