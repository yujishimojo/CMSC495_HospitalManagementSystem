<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
                <a href="newpatient.html">New Patient</a>
                <a href="newstaff.html">New Staff</a>
                <a href="search.html">Search</a>
            </nav>
        </div>
    </header>

    <!-- action needs to be changed to another value to send info somewhere useful -->
    <!-- doing some client-side input validation before sending to database would be useful -->
    <% String pathToNewPatient = request.getContextPath() + "/NewPatient"; %>
    <form name="newpatient" action="<%=pathToNewPatient%>" method="POST" onsubmit="return validateForm()">
        <h2>New Patient</h2>

        <table>
            <!-- Automatically generate patient id??? -->

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
                <td><input type="text" name="ssn" value="111223333" required></td>
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
                <th>Admitted date:</th>
                <td><input id="date" type="text" name="date" required><td>
            </tr>

            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("date") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("date") == "invalid format") {  // acceptable input format is MM/DD/YYYY
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'MM/DD/YYYY.'</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>

            <!-- Maybe change to a dropdown menu to prevent non-existent doctors from being selected -->

            <tr>
                <th>Doctor First Name:</th>
                <td><input type="text" name="doctor_firstname" value="" required></td>
            </tr>

            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("doctor_firstname") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("doctor_firstname") == "not found") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This doctor name is not found.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>

            <tr>
                <th>Doctor Last Name:</th>
                <td><input type="text" name="doctor_lastname" value="" required></td>
            </tr>

            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("doctor_lastname") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("doctor_lastname") == "not found") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This doctor name is not found.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>

            <tr>
                <th>Patient Type:</th>
                <td><input type="radio" name="patienttypegroup" value="Inpatient" checked/> Inpatient<br/>
                <input type="radio" name="patienttypegroup" value="Outpatient"/> Outpatient</td>
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
                <th>Insurance:</th>
                <td><input type="text" name="insurance" value=""/></td>
            </tr>

            <%
                if (validationMap != null) {
                    if (validationMap.get("insurance") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 100 characters.</font></em></small></th>");
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
