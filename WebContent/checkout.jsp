<html>
<head>
<title>Checkout</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
<%@ include file="header.jsp" %>

<h1>Enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
<table>
<tr><td>Customer ID:</td><td><input type="text" name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
<tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
</table>
</form>

</body>
</html>

