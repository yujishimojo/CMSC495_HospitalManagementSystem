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
                    if (role == "admin" || role == "staff") {
                        out.println("<a href=\"Search.jsp\">Search</a>");
                    }
                %>
            </nav>
        </div>
    </header>
    <!-- action needs to be changed to another value to send info somewhere useful -->
    <!-- doing some client-side input validation before sending to database would be useful -->
    <% String pathToNewPatient = request.getContextPath() + "/NewMedicalFile"; %>
    <form name="newmedicalfile" action="<%=pathToNewPatient%>" method="POST" onsubmit="return validateForm()">
        <h2>New Medical File</h2>
        <table>
            <tr>
                <th>Patient ID:</th>
                <td><input type="text" name="patient_id" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("patient_id") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("patient_id") == "invalid format") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be a proper Patient ID number.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("patient_id") == "not found") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This patient ID is not found.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Date of Visit:</th>
                <td><input id="date" type="text" name="visit_date" required><td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("visit_date") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("visit_date") == "invalid format") {  // acceptable input format is MM/DD/YYYY
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'MM/DD/YYYY.'</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Bed Name:</th>
                <td><input type="text" name="bed_name" value=""></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                	if (validationMap.get("bed_name") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied for inpatients. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("bed_name") == "not found") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This bed name is not found.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("bed_name") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**You have entered an illegal character.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Start Bed Date:</th>
                <td><input id="date" type="text" name="start_date"><td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                	if (validationMap.get("start_date") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied for inpatients. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("start_date") == "invalid format") {  // acceptable input format is MM/DD/YYYY
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'MM/DD/YYYY.'</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>End Bed Date:</th>
                <td><input id="date" type="text" name="end_date"><td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("end_date") == "invalid format") {  // acceptable input format is MM/DD/YYYY
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This is not a valid format. The field must be 'MM/DD/YYYY.'</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Disease Name:</th>
                <td><input type="text" name="disease" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("disease") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("disease") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 500 characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("disease") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**You have entered an illegal character.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Treatment:</th>
                <td><textarea type="text" name="treatment" rows="3" required></textarea></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("treatment") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("treatment") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 1000 characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("treatment") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**You have entered an illegal character.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Medicine Given:</th>
                <td><input type="hidden" name="medicine_given" value="off">
                    <input type="checkbox" name="medicine_given" value="on"/> Medicine Given</td>
            </tr>
            <tr>
                <th>Medicine Name:</th>
                <td><input type="text" name="medicine_name" value=""></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("medicine_name") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 500 characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("medicine_name") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**You have entered an illegal character.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Medical Notes:</th>
                <td><textarea type="text" name="notes" rows="3"></textarea></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("notes") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 1000 characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("notes") == "illegal characters") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**You have entered an illegal character.</font></em></small></th>");
                        out.println("</tr>");
                    }
                }
            %>
            <tr>
                <th>Ambulance Service:</th>
                <td><input type="hidden" name="ambulance" value="off">
                    <input type="checkbox" name="ambulance" value="on"/> Ambulance Service</td>
            </tr>
            <tr>
                <th>Billing Amount:</th>
                <td><input type="text" name="billing_amount" value="" required></td>
            </tr>
            <%
                if (validationMap != null && validationMap.get("registration") == "failed") {
                    if (validationMap.get("billing_amount") == "empty") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field is requied. Please fill out the field.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("billing_amount") == "too long") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**This field must be under 30 characters.</font></em></small></th>");
                        out.println("</tr>");
                    } else if (validationMap.get("billing_amount") == "invalid format") {
                        out.println("<tr>");
                        out.println("    <th colspan=\"2\" style=\"text-align: center;\"><small><em><font color=\"red\">**Billing amount must only be numbers.</font></em></small></th>");
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
