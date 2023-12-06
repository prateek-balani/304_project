<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
<%@ include file="header.jsp" %>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>



<br><h3>Or </h3><br>
<h3> Create An Account</h3>

<form name="registrationForm" method="post" action="registerUser.jsp">
    <table style="display:inline">
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">First Name:</font></div></td>
            <td><input type="text" name="firstName" size=30 maxlength=40 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Last Name:</font></div></td>
            <td><input type="text" name="lastName" size=30 maxlength=40 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email:</font></div></td>
            <td><input type="email" name="email" size=30 maxlength=50 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Phone Number:</font></div></td>
            <td><input type="tel" name="phoneNum" size=30 maxlength=20 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Address:</font></div></td>
            <td><input type="text" name="address" size=30 maxlength=50 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">City:</font></div></td>
            <td><input type="text" name="city" size=30 maxlength=40 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">State:</font></div></td>
            <td><input type="text" name="state" size=30 maxlength=20 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Postal Code:</font></div></td>
            <td><input type="text" name="postalCode" size=30 maxlength=20 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Country:</font></div></td>
            <td><input type="text" name="country" size=30 maxlength=40 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">User ID:</font></div></td>
            <td><input type="text" name="userId" size=30 maxlength=20 required></td>
        </tr>
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
            <td><input type="password" name="password" size=30 maxlength=30 required></td>
        </tr>
    </table>
    <br/>
    <input class="submit" type="submit" name="Submit2" value="Create Account">
</form>

</div>

</body>
</html>

