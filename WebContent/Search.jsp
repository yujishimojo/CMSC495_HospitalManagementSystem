<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Page</title>
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
            <a href="NewPatient.jsp">New Patient</a>
            <a href="newstaff.html">New Staff</a>
            <a href="Search.jsp">Search</a>
        </nav>
        </div>
    </header>
    <% String pathToLogin = request.getContextPath() + "/Search"; %>
    <form method="POST" action="<%=pathToLogin%>" >
    <table>
<!--         <tr>
            <td>Search for</td>
            <td>
                <select name="role">
                    <option value="admin">admin</option>
                    <option value="staff">staff</option>
                    <option value="patient">patient</option>
                </select>
            </td>
        </tr> -->
        <tr>
        <tr>
            <td>First Name:</td>
            <td><input type="text" name="firstname" size="32"></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><input type="text" name="lastname" size="32"></td>
        </tr>
        <tr>
            <td><input type="submit" value="search"></td>
            <td><input type="reset" value="reset"></td>
        </tr>
    </table>
    </form>
</body>
</html>