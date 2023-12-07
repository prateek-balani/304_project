<%@ page import="java.sql.*, java.io.*, java.util.*, java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Add New Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>
<div class="container mt-4">
    <h2>Add New Product<br></br></h2>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String productName = request.getParameter("productName");
            String productPrice = request.getParameter("productPrice");
            String productDesc = request.getParameter("productDesc");
            String categoryId = request.getParameter("categoryId");

            try {
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";

                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";

                    try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                        pstmt.setString(1, productName);
                        pstmt.setBigDecimal(2, new BigDecimal(productPrice));
                        pstmt.setString(3, productDesc);
                        pstmt.setInt(4, Integer.parseInt(categoryId));

                        pstmt.executeUpdate();
                    }
                }

                response.sendRedirect("listprod.jsp"); 
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
                e.printStackTrace(); // Print the full stack trace for debugging
            }
        }
    %>

    <form method="post" action="addprod.jsp">
        <div class="mb-3">
            <label for="productName" class="form-label">Product Name:</label>
            <input type="text" class="form-control" id="productName" name="productName" required>
        </div>

        <div class="mb-3">
            <label for="productPrice" class="form-label">Product Price:</label>
            <input type="text" class="form-control" id="productPrice" name="productPrice" required>
        </div>

        <div class="mb-3">
            <label for="productDesc" class="form-label">Product Description:</label>
            <textarea class="form-control" id="productDesc" name="productDesc" required></textarea>
        </div>

        <div class="mb-3">
            <label for="categoryId" class="form-label">Category ID:</label>
            <input type="text" class="form-control" id="categoryId" name="categoryId" required>
        </div>

        <a href="admin.jsp" class="btn btn-danger">Go Back</a>
        <button type="submit" class="btn btn-primary">Add Product</button>
    </form>
</div>

</body>
</html>
