<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>New Bed</title>
    <link rel="stylesheet" href="css/styles.css"/>
</head>
<body>

    <!-- Check whether logged in and user type -->
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

    <!-- Set the path for Home servlet class -->
    <% String pathToHome = request.getContextPath() + "/Home"; %>

    <!-- Get attributes forwarded by NewBed servlet -->
    <% HashMap<String,String> validationMap = (HashMap<String,String>)request.getAttribute("validationMap"); %>

    <!-- Header customized by user type -->
    <header>
        <a href="#" onClick="location.href='<%=pathToHome%>'"><img src="images/logo_notext.png"></a>
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

    <!-- Set the path for NewBed servlet -->
    <% String pathToNewBed = request.getContextPath() + "/NewBed"; %>

    <form name="newbed" action="<%=pathToNewBed%>" method="POST">
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
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">");
                        out.println("    **This field is requied. Please fill out the field.");
                        out.println("    </font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("room_id") == "invalid format") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">");
                        out.println("    **This is not a valid format. The field must be a proper room ID number.");
                        out.println("    </font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("room_id") == "not found") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">");
                        out.println("    **This room ID is not found.");
                        out.println("    </font></em></small></th>");
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
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">");
                        out.println("    **This field contains illegal characters.");
                        out.println("    </font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("bed_name") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">");
                        out.println("    **This field is requied. Please fill out the field.");
                        out.println("    </font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("bed_name") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">");
                        out.println("    **This field must be under 30 characters.");
                        out.println("    </font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
        </table>
        <br/>
        <input type="submit" value="Submit" />
        <!-- Set the path for Logout servlet -->
        <% String pathToLogout = request.getContextPath() + "/Logout"; %>
        <input type="button" value="Logout" align="right" onClick="location.href='<%=pathToLogout%>'">
    </form>
    <script>
        // Get Current date and set as default value in date field
        var d = new Date();
        document.getElementById("date").value = d.getMonth()+"/"+d.getFullDate()+"/"+d.getFullYear();
    </script>
</body>
</html>