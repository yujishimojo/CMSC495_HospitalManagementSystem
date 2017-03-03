<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Page</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
<body>
    <% String login = (String)session.getAttribute("login"); %>
    <% String role = (String)session.getAttribute("role"); %>
    <%
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (role != "admin" && role != "staff") {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
        }
    %>
    <% String pathToHome = request.getContextPath() + "/Home"; %>
    <% HashMap<String,String> validationMap = (HashMap<String,String>)request.getAttribute("validationMap"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
        <h1>Hygieia</h1>
        <nav>
            <a href="#" onClick="location.href='<%=pathToHome%>'">Home</a>
            <%
                if (role == "admin" || role == "staff") {
                    out.println("<a href=\"NewPatient.jsp\">New Patient</a>");
                }
            %>
            <%
                if (role == "admin") {
                    out.println("<a href=\"NewStaff.jsp\">New Staff</a>");
                }
            %>
            <%
                if (role == "admin" || role == "staff") {
                    out.println("<a href=\"NewMedicalFile.jsp\">New Medical File</a>");
                }
            %>
            <%
                if (role == "admin") {
                    out.println("<a href=\"NewBed.jsp\">New Bed</a>");
                }
            %>
            <%
                if (role == "admin") {
                    out.println("<a href=\"NewRoom.jsp\">New Room</a>");
                }
            %>
            <%
                if (role == "admin" || role == "staff") {
                    out.println("<a href=\"Search.jsp\">Search</a>");
                }
            %>
        </nav>
        </div>
    </header>
    <% String pathToSearchUser = request.getContextPath() + "/SearchUser"; %>
    <% String pathToSearchMedicalFiles = request.getContextPath() + "/SearchMedicalFiles"; %>
    <form method="POST" action="<%=pathToSearchUser%>" id="searchForm">
    <table class='portrait'>
        <tr>
            <td>Search for</td>
            <td>
                <select name="search" id="searchOption" onchange="changeFormAction();">
                    <option value="user">user</option>
                    <option value="medical files">medical files</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>First Name:</td>
            <td><input type="text" name="firstname" size="32"></td>
        </tr>
        <%
            if (validationMap != null) {
                if (validationMap.get("firstname") == "illegal characters") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**First Name Field contains illegal characters.</font></em></small></th>");
                    out.println("</tr>");
                } else if (validationMap.get("firstname") == "empty") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                    out.println("</tr>");
                } else if (validationMap.get("firstname") == "too long") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 30 characters.</font></em></small></th>");
                    out.println("</tr>");
                }
            }
        %>
        <tr>
            <td>Last Name:</td>
            <td><input type="text" name="lastname" size="32"></td>
        </tr>
        <%
            if (validationMap != null) {
                if (validationMap.get("lastname") == "illegal characters") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**Last Name Field contains illegal characters.</font></em></small></th>");
                    out.println("</tr>");
                } else if (validationMap.get("lastname") == "empty") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                    out.println("</tr>");
                } else if (validationMap.get("lastname") == "too long") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 30 characters.</font></em></small></th>");
                    out.println("</tr>");
                }
            }
        %>
        <%
            if (validationMap != null) {
                if (validationMap.get("user") == "not found") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**There are no users that match your search.</font></em></small></th>");
                    out.println("</tr>");
                }
                if (validationMap.get("medical_file") == "not found") {
                    out.println("<tr>");
                    out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**There are no medical files that match your search.</font></em></small></th>");
                    out.println("</tr>");
                }
            }
        %>
        <tr>
            <td><input type="submit" value="search"></td>
            <td><input type="reset" value="reset"></td>
        </tr>
    </table>
    </form>
    <script>
        function changeFormAction() {
            var array = new Array("<%=pathToSearchUser%>","<%=pathToSearchMedicalFiles%>");
            var option = document.getElementById("searchOption").selectedIndex;
            var form = document.getElementById("searchForm");
            form.setAttribute("action", array[option]);
        }
    </script>
</body>
</html>
