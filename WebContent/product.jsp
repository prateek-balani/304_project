<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>107 Grocery - Product Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
    String productId = request.getParameter("id");

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
            PreparedStatement pstmt = con.prepareStatement("SELECT productName, productPrice, productDesc, productImageURL FROM product WHERE productId = ?")) {

        pstmt.setString(1, productId);

        String productName = "";
        Double productPrice = 0.0;
        String productDesc = "";
        String productImageURL = "";

        ResultSet rst = pstmt.executeQuery();
        if (rst.next()) {
            productName = rst.getString("productName");
            productPrice = rst.getDouble("productPrice");
            productDesc = rst.getString("productDesc");
            productImageURL = rst.getString("productImageURL");
        }

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
%>

<div class="container mt-4">
    <div class="card">
        <div class="card-header">
            <h2><%= productName %></h2>
        </div>
        <div class="card-body">
            <%-- Display image from productImageURL if available --%>
            <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                <img src='<%= productImageURL %>' class="card-img-top" alt='Product Image'>
            <% } %>

            <img src='displayImage.jsp?id=<%= productId %>' class="card-img-top" alt=''>
            <h4 class="card-text">Description: <%= productDesc %></h4>
            <h4 class="card-text">Price: <%= currFormat.format(productPrice) %></h4>
            <a href='addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>' class='btn btn-success'>Add to Cart</a>
            <a href='listprod.jsp' class='btn btn-primary'>Continue Shopping</a>
        </div>
    </div>
</div>

<%
    } catch (SQLException e) {
        out.println("SQLException: " + e);
    }
%>

</body>
</html>