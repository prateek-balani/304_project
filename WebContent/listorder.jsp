<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>107 Frogs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-4">
	    <a href="customer.jsp" class="btn btn-primary">Customer Info</a>
        <a href="admin.jsp" class="btn btn-primary">Sales Report</a>
        <br></br><br>

        <%
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try {
                // Load driver class
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    if (con != null) {
                        String query = "SELECT os.orderId, os.orderDate, c.customerId, c.firstName, c.lastName, os.totalAmount FROM ordersummary os JOIN customer c ON os.customerId = c.customerId";

                        try (PreparedStatement pmt = con.prepareStatement(query)) {
                            try (ResultSet rst = pmt.executeQuery()) {
                                out.println("<h2>Order Summary Information:</h2><br></br>");
                                out.println("<div class='table-responsive'>");
                                out.println("<table class='table table-bordered table-striped'>");
                                out.println("<thead class='thead-dark'><tr><th>Order ID</th><th>Customer ID</th><th>Order Date</th><th>First Name</th><th>Last Name</th><th>Total Amount</th></tr></thead>");

                                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                                while (rst.next()) {
                                    int orderId = rst.getInt("orderId");
                                    int customerId = rst.getInt("customerId");
                                    java.sql.Date orderDate = rst.getDate("orderDate");
                                    String firstName = rst.getString("firstName");
                                    String lastName = rst.getString("lastName");
                                    double totalAmount = rst.getDouble("totalAmount");

                                    out.println("<tr>");
                                    out.println("<td>" + orderId + "</td>");
                                    out.println("<td>" + customerId + "</td>");
                                    out.println("<td>" + orderDate + "</td>");
                                    out.println("<td>" + firstName + "</td>");
                                    out.println("<td>" + lastName + "</td>");
                                    out.println("<td>" + currFormat.format(totalAmount) + "</td>");
                                    out.println("</tr>");
                                }
                                out.println("</table>");
                                out.println("</div>");
                            }
                        }
                    }
                }
            } catch (java.lang.ClassNotFoundException | SQLException e) {
                out.println("Error: " + e.getMessage());
            }
        %>

    </div>

</body>
</html>