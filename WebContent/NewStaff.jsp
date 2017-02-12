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
    <%
        String login = (String)session.getAttribute("login");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        }
    %>
    <% HashMap<String,String> validationMap = (HashMap<String,String>)request.getAttribute("validationMap"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
           <h1>Hygieia</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="NewPatient.jsp">New Patient</a>
                <a href="NewStaff.jsp">New Staff</a>
                <a href="Search.jsp">Search</a>
            </nav>
        </div>
    </header>
    <!-- action needs to be changed to another value to send info somewhere useful -->
    <!-- doing some client-side input validation before sending to database would be useful -->
    <% String pathToNewPatient = request.getContextPath() + "/NewStaff"; %>
    <form name="newstaff" action="<%=pathToNewPatient%>" method="POST" onsubmit="return validateForm()">
        <h2>New Staff</h2>
        <table>
            <tr>
                <th>First Name:</th>
                <td><input type="text" name="firstname" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
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
                <th>Middle Name:</th>
                <td><input type="text" name="middlename" value=""/></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("middlename") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**Middle Name Field contains illegal characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("middlename") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 30 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Last Name:</th>
                <td><input type="text" name="lastname" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
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
            <!-- If we include SSN in an online form we MUST make sure the site is secure. Otherwise remove it -->
            <tr>
                <th colspan="2" style="text-align: center;"><small><em>**If we include this in an online form we MUST make sure the site is secure. Otherwise remove it<br/>DO NOT USE REAL SSN FOR TESTING!</em></small> </th></tr>
            <tr>
                <th>SSN:</th>
                <td><input type="text" name="ssn" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("ssn") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**Social Security Number contains illegal characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("ssn") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("ssn") == "invalid format") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be 9 numeric digits.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("ssn") == "in use") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is already in use.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Staff Type:</th>
                <td><input type="radio" name="stafftypegroup" value="Staff" checked/> Staff<br/>
                <input type="radio" name="stafftypegroup" value="Doctor"/> Doctor</td>
            </tr>
            <!--
             May later add separate fields for street, city, state, and zip.
             I would like to have a dropdown menu to select state instead of having them type it to prevent errors.
             -->
            <tr>
                <th>Address:<br/></th>
                <td><textarea type="text" name="address" rows="3"></textarea></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("address") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 100 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Qualification:</th>
                <td><input type="text" name="qualification" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("qualification") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("qualification") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 50 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Certification expiration:</th>
                <td><input id="date" type="text" name="expiration"><td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("expiration") == "invalid format") {  // acceptable input format is MM/DD/YYYY
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'MM/DD/YYYY.'</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Cell number:</th>
                <td><input type="text" name="cell" value=""></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("cell") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 20 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Email address:</th>
                <td><input type="text" name="email" value=""></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("email") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 50 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Payroll:</th>
                <td><input type="text" name="payroll" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("payroll") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("payroll") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 30 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Personal details:<br/></th>
                <td><textarea type="text" name="details" rows="3"></textarea></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("details") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 500 characters.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>New Password:</th>
                <td><input type="password" name="pass1" size="32" required></td>
            </tr>
            <tr>
                <th>Retype Password:</th>
                <td><input type="password" name="pass2" size="32" required></td>
            </tr>
            <!-- Shift -->
            <tr>
                <th>Clock in time:</th>
                <td><input type="text" name="clock_in_time" value=""></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("clock_in_time") == "invalid formart") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'hh:mm:ss.'</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("clock_in_time") == "missing") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be filled out along with clock out time. Please fill out the clock out time field.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Clock out time:</th>
                <td><input type="text" name="clock_out_time" value=""></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("clock_out_time") == "invalid formart") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'hh:mm:ss.'</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("clock_out_time") == "missing") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be filled out along with clock in time. Please fill out the clock in time field.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Status:</th>
                <td><input type="radio" name="status" value="Normal" checked/> Normal<br/>
                <input type="radio" name="status" value="Emergency"/> Emergency</td>
            </tr>
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
