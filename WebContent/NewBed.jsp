<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>CMSC 495 - Group 4</title>
    <link rel="stylesheet" href="css/styles.css"/>
    <script src="js/validate-form.js"></script>
</head>
<body>
    <% String login = (String)session.getAttribute("login"); %>
    <% String role = (String)session.getAttribute("role"); %>
    <%
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (role != "admin") {
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
    <% String pathToNewBed = request.getContextPath() + "/NewBed"; %>
    <form name="newbed" action="<%=pathToNewBed%>" method="POST" onsubmit="return validateForm()">
        <h2>New Bed</h2>
        <table class="portrait">
            <tr>
                <th>Room ID:</th>
                <td><input type="text" name="room_id" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("room_id") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("room_id") == "invalid format") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be a proper Room ID number.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("room_id") == "not found") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This room ID is not found.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Bed Name:</th>
                <td><input type="text" name="bed_name" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("bed_name") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**Bed Name Field contains illegal characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("bed_name") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("bed_name") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 30 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
        </table>
        <br/>
        <input type="submit" value="Submit" />
        <% String pathToLogout = request.getContextPath() + "/Logout"; %>
        <input type="button" value="Logout" align="right" onClick="location.href='<%=pathToLogout%>'">
    </form>
    <script>
        //Get Current date and set as default value in date field
        var d = new Date();
        document.getElementById("date").value = d.getMonth()+"/"+d.getFullDate()+"/"+d.getFullYear();
    </script>
</body>
</html>