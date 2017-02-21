<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login Page</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
    <%
        String login = (String)session.getAttribute("login");
        if (login == "OK") {
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    %>
    <% String pathToHome = request.getContextPath() + "/Home"; %>
<body>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
        <h1>Hygieia</h1>
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
        <%
            String status = (String)session.getAttribute("status");
                if (status == "Not Auth") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**Invalid Login Name or Password. Please try it again.</font></em></small></th>");
                    out.println("</tr>");
                }
        %>
        <tr>
            <td><input type="submit" value="login"></td>
            <td><input type="reset" value="reset"></td>
        </tr>
    </table>
    </form>
</body>
</html>