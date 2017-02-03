<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login Page</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
<body>

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

    <% String pathToLogin = request.getContextPath() + "/Login"; %>
    <form method="POST" action="<%=pathToLogin%>" >
    <table>
        <tr>
            <td>Login Name:</td>
            <td><input type="text" name="user" size="32"></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password" name="pass" size="32"></td>
        </tr>
        <tr>
            <td><input type="submit" value="login"></td>
            <td><input type="reset" value="reset"></td>
        </tr>
    </table>
    </form>
</body>
</html>