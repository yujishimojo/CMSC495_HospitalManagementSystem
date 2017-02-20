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
            <a href="NewStaff.jsp">New Staff</a>
            <a href="NewMedicalFile.jsp">New Medical File</a>
            <a href="Search.jsp">Search</a>
        </nav>
        </div>
    </header>
    <% String pathToSearchUser = request.getContextPath() + "/SearchUser"; %>
    <form method="POST" action="<%=pathToSearchUser%>">
    <table>
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