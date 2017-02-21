<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>New Patient Result</title>
<link rel="stylesheet" href="css/styles.css"/>
</head>
<body>
    <%
        String login = (String)session.getAttribute("login");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        }
    %>
    <% String role = (String)session.getAttribute("role");
        if (role != "admin" && role != "staff") {
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    %>
    <% String pathToHome = request.getContextPath() + "/Home"; %>
    <% ArrayList<String> list = (ArrayList<String>)request.getAttribute("list"); %>
    <header>
        <a href="index.html"><img src="images/logo_notext.png"></a>
        <div class="align-vertically">
            <h1>Hygieia</h1>
            <nav>
                <a href="#" onClick="location.href='<%=pathToHome%>'">Home</a>
                <%
                    if (role.equals("admin") || role.equals("staff")) {
                        out.println("<a href=\"NewPatient.jsp\">New Patient</a>");
                    }
                %>
                <%
                    if (role.equals("admin")) {
                        out.println("<a href=\"NewStaff.jsp\">New Staff</a>");
                    }
                %>
                <%
                    if (role.equals("admin") || role.equals("staff")) {
                        out.println("<a href=\"NewMedicalFile.jsp\">New Medical File</a>");
                    }
                %>
                <%
                    if (role.equals("admin") || role.equals("staff")) {
                        out.println("<a href=\"Search.jsp\">Search</a>");
                    }
                %>
            </nav>
        </div>
    </header>
    <h2>Registration Successful</h2>
    <!-- table version -->
	<table>
		<tr>
			<th>Patient ID:</th>
			<td><%out.print(list.get(0));%></td>
		</tr>
		<tr>
			<th>Login Name:</th>
			<td><%out.print(list.get(1));%></td>
		</tr>
		<tr>
			<th>Password:</th>
			<td><%out.print(list.get(2));%></td>
		</tr>
		<tr>
			<th>First Name:</th>
			<td><%out.print(list.get(3));%></td>
		</tr>
		<tr> 
			<th>Middle Name:</th>
			<td><%out.print(list.get(4));%></td>
		</tr>
		<tr>
			<th>Last Name:</th>
			<td><%out.print(list.get(5));%></td>
		</tr>
		<tr> <!-- I think we should consider not displaying this in the final version -->
			<th>SSN:</th>
			<td><%out.print(list.get(6));%></td>
		</tr>
		<tr>
			<th>Admitted Date:</th>
			<td><%out.print(list.get(7));%></td>
		</tr>
		<tr>
			<th>Doctor:</th>
			<td><%out.print(list.get(8));%> <%out.print(list.get(9));%></td>
		</tr>
		<tr>
			<th>Patient Type:</th>
			<td><%out.print(list.get(10));%></td>
		</tr>
		<tr>
			<th>Address:</th>
			<td><%out.print(list.get(11));%></td>
		</tr>
		<tr>
			<th>Insurance:</th>
			<td><%out.print(list.get(12));%></td>
		</tr>
	</table>
</body>
</html>