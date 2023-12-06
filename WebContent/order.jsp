<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Group 107 Grocery Order Processing</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>

<%@ include file="header.jsp" %>

<% 
// Get customer id
String custId = request.getParameter("customerId");
String password = request.getParameter("password");
String shippingAddress = request.getParameter("address");

if (custId == null || custId.isEmpty() || password == null || password.isEmpty()) {
    out.println("<h1>Please fill in all fields.</h1>");
    return;
}

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message
// Make connection

if (productList == null || productList.isEmpty()) {
    out.println("<h1>Your shopping cart is empty!</h1>");
	return;
} 
int customerId;
try {
    customerId = Integer.parseInt(custId);
} catch (NumberFormatException e) {
    out.println("<h1>Invalid customer id.</h1>");
	return;
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pstmt = con.prepareStatement("SELECT * FROM customer WHERE customerId = ? and password = ? ")) {

    pstmt.setInt(1, customerId);
	pstmt.setString(2, password) ;
	


    try (ResultSet rst = pstmt.executeQuery()) {
        if (!rst.next()) {
            out.println("<h1>Invalid id</h1>");
            return;
        }
    }

    PreparedStatement osstmnt = con.prepareStatement("INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)", Statement.RETURN_GENERATED_KEYS);
    osstmnt.setInt(1, customerId);
	
    osstmnt.executeUpdate();

    ResultSet keys = osstmnt.getGeneratedKeys();
    keys.next();
    int orderId = keys.getInt(1);

    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    double totalAmount = 0; 

    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();
        String productId = (String) product.get(0);
        String price = (String) product.get(2);
        double pr = Double.parseDouble(price);
        int qty = ((Integer) product.get(3)).intValue();

        PreparedStatement opstmnt = con.prepareStatement("INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");
        opstmnt.setInt(1, orderId);
        opstmnt.setString(2, productId);
        opstmnt.setInt(3, qty);
        opstmnt.setDouble(4, pr);
        opstmnt.executeUpdate();

        double subtotal = pr * qty;
        totalAmount += subtotal;
    }
    
    PreparedStatement updateTotalAmount = con.prepareStatement("UPDATE OrderSummary SET totalAmount = ? WHERE orderId = ?");
    updateTotalAmount.setDouble(1, totalAmount);
    updateTotalAmount.setInt(2, orderId);
    updateTotalAmount.executeUpdate();

	String firstName = "";
	String lastName = "";
	PreparedStatement cstmnt = con.prepareStatement("SELECT firstName, lastName, address FROM customer WHERE customerId = ?");
	cstmnt.setInt(1, customerId);
	ResultSet crst = cstmnt.executeQuery();
	if (crst.next()) {
		firstName = crst.getString("firstName");
		lastName = crst.getString("lastName");
		shippingAddress = crst.getString("address");
	}

	out.println("<h1>Your Order Summary</h1>");
	out.println("<table>");
	out.println("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

	double total = 0;
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) {
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = entry.getValue();
		if (product.size() < 4) {
			out.println("Expected product with four entries. Got: " + product);
			continue;
		}

		out.print("<tr><td>" + product.get(0) + "</td>");
		out.print("<td>" + product.get(1) + "</td>");

		out.print("<td align=\"center\">" + product.get(3) + "</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;

		try {
			pr = Double.parseDouble(price.toString());
		} catch (Exception e) {
			out.println("Invalid price for product: " + product.get(0) + " price: " + price);
		}
		try {
			qty = Integer.parseInt(itemqty.toString());
		} catch (Exception e) {
			out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
		}

		out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
		out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td></tr>");
		total = total + pr * qty;
	}

	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+ "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
	out.println("</table>");

	out.println("<h1>Order completed. Will be shipped soon...</h1>");
	out.println("<h1>Your order reference number is: " + orderId + "</h1>");
	out.println("<h1>Shipping to customer: " + customerId + " Name: " + firstName + " " + lastName + "</h1>");
	out.println("<h1>Shipping Address: " + shippingAddress + "</h1>");

	session.removeAttribute("productList");

} catch (SQLException e) {
    out.println("SQLException: " + e);
}
%>
</body>
</html>