<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
</head>
<body>
<%@ include file="header.jsp" %>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat,java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="jdbc.jsp" %>

<%
	if(userName == null )
		out.println("Error enter a valid Username") ;
else{

// TODO: Print Customer information
String sql = "SELECT customerId,firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid FROM customer WHERE userid = ? ";
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pstmt = con.prepareStatement(sql)){

	 pstmt.setString(1, userName);
    ResultSet rst = pstmt.executeQuery();
	out.println("<table border='1'>");

	int customerId =  0;
	while(rst.next())	{ 

		customerId = rst.getInt("customerId");
        
        out.println("<h2>Customer Profile</h2>");
        out.println("<table class='table table-striped'>");
        out.println("<tr><td><b>Customer ID:</b></td><td>" + customerId + "</td></tr>");
        out.println("<tr><td><b>First Name:</b></td><td>" + rst.getString("firstName") + "</td></tr>");
        out.println("<tr><td><b>Last Name:</b></td><td>" + rst.getString("lastName") + "</td></tr>");
        out.println("<tr><td><b>Email:</b></td><td>" + rst.getString("email") + "</td></tr>");
        out.println("<tr><td><b>Phone Number:</b></td><td>" + rst.getString("phonenum") + "</td></tr>");
        out.println("<tr><td><b>Address:</b></td><td>" + rst.getString("address") + "</td></tr>");
        out.println("<tr><td><b>City:</b></td><td>" + rst.getString("city") + "</td></tr>");
        out.println("<tr><td><b>State:</b></td><td>" + rst.getString("state") + "</td></tr>");
        out.println("<tr><td><b>Postal Code:</b></td><td>" + rst.getString("postalCode") + "</td></tr>");
        out.println("<tr><td><b>Country:</b></td><td>" + rst.getString("country") + "</td></tr>");
        out.println("<tr><td><b>User ID:</b></td><td>" + rst.getString("userid") + "</td></tr>");
        out.println("</table>");
	}
	

	String ordersSql = "SELECT orderId, orderDate, totalAmount FROM ordersummary WHERE customerId = ?";
    PreparedStatement ordersPstmt = con.prepareStatement(ordersSql);
    ordersPstmt.setInt(1, customerId);
    ResultSet ordersRst = ordersPstmt.executeQuery();

    out.println("<h2>Orders:</h2>");
    out.println("<table class='table table-striped'>");
    out.println("<tr><th>Order ID</th><th>Order Date</th><th>Total</th></tr>");

    while(ordersRst.next()) {
        out.println("<tr>");
        out.println("<td>" + ordersRst.getInt("orderId") + "</td>");
        out.println("<td>" + ordersRst.getDate("orderDate") + "</td>");
        out.println("<td>" + ordersRst.getDouble("totalAmount") + "</td>");
        out.println("</tr>");
    }

    out.println("</table>");



		} catch (SQLException e) {
			out.println("Error: " + e.getMessage());
		}
		


}
// Make sure to close connection
%>




</body>
</html>