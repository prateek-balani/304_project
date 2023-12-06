<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
</head>
<body>
<%@ include file="header.jsp" %>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%> 

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%

// TODO: Write SQL query that prints out total order amount by day
String sql = "";
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pstmt = con.prepareStatement("SELECT CONVERT(VARCHAR, orderDate, 23) AS orderDay, SUM(totalAmount) AS totalAmount " +
                                                        "FROM ordersummary " +
                                                        "GROUP BY CONVERT(VARCHAR, orderDate, 23)")) {

    ResultSet rst = pstmt.executeQuery();

    out.println("<h2>Administrator Sales Report by Day</h2>");
    out.println("<table border=\"1\">");
    out.println("<tr>");
    out.println("<th>Order Date</th>");
    out.println("<th>Total Order Amount</th>");
    out.println("</tr>");

    while (rst.next())
    {
        String orderDate = rst.getString("orderDay");
        double totalAmount = rst.getDouble("totalAmount");
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        out.println("<tr>");
        out.println("<td>" + orderDate +"</td>");
        out.println("<td>" + currFormat.format(totalAmount) + "</td>");
        out.println("</tr>");
    }

} catch (SQLException e) {
    out.println("SQLException: " + e);
}

%>

</body>
</html>
