<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Group 107 Frogs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container mt-4">
    <h2>Search for frogs:</h2>
    <br>
    <form method="get" action="listprod.jsp">
        <div class="row">
            <div class="col-md-8">
                <input type="text" class="form-control" name="productName" placeholder="Enter species name">
            </div>
            <div class="col-md-2">
                <select class="form-control" id="category" name="category">
                    <!-- Add your categories here -->
                    <option value="all">All</option>
                    <option value="1">Aquatic</option>
                    <option value="2">Arboreal</option>
                    <option value="3">Terrestrial</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">Search</button>
                <button type="reset" class="btn btn-secondary">Reset</button>
            </div>
        </div>
    </form>

    <%
        String name = request.getParameter("productName");
        String category = request.getParameter("category");
        String displayTxt;

        try
        {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        }
        catch (java.lang.ClassNotFoundException e)
        {
            out.println("ClassNotFoundException: " + e);
        }

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw))
        {
            String query;

            if (name != null && !name.isEmpty() && category != null && !category.equals("all")) {
                query = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE productName LIKE ? AND categoryId = ?";
                displayTxt = "Products containing '" + name + "'";
            } 
            else if (name != null && !name.isEmpty()) {
                query = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE productName LIKE ?";
                displayTxt = "Products containing '" + name + "'";
            } 
            else if (category != null && !category.equals("all")) {
                query = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE categoryId = ?";
                displayTxt = "Products in category '" + category + "'";
            }
            else {
                // Display top-selling products
                query = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, SUM(op.quantity) AS totalSales " +
                        "FROM product p " +
                        "LEFT JOIN orderproduct op ON p.productId = op.productId " +
                        "GROUP BY p.productId, p.productName, p.productPrice, p.productImageURL " +
                        "ORDER BY totalSales DESC";
                displayTxt = "All Species <br></br>";
            }

            try (PreparedStatement pstmnt = con.prepareStatement(query))
            {
                if (name != null && !name.isEmpty() ) {
                    pstmnt.setString(1, "%" + name + "%");

                    if (!category.equals("all")) {
                        pstmnt.setInt(2, Integer.parseInt(category));
                    }
                }
                else if (name != null && !name.isEmpty()) {
                    pstmnt.setString(1, "%" + name + "%");
                } else if (category != null && !category.equals("all")) {
                    pstmnt.setInt(1, Integer.parseInt(category));
                }

                try (ResultSet rst = pstmnt.executeQuery())
                {
                    out.println("<h2>" + displayTxt + "</h2>");
                    out.println("<div class='row'>");

                    while (rst.next())
                    {
                        int productId = rst.getInt("productId");
                        String productName = rst.getString("productName");
                        double productPrice = rst.getDouble("productPrice");
                        String productImageURL = rst.getString("productImageURL");
                        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                        out.println("<div class='col-md-4 mb-4'>");
                        out.println("<div class='card'>");
                        out.println("<img src='" + productImageURL + "' class='card-img-top img-thumbnail' alt='Product Image' style='max-height: 150px;'>");
                        out.println("<div class='card-body'>");
                        out.println("<h5 class='card-title'>" + productName + "</h5>");
                        out.println("<p class='card-text'>Price: " + currFormat.format(productPrice) + "</p>");
                        out.println("<a href='product.jsp?id=" + productId + "' class='btn btn-primary'>View Details</a>");
                        out.println("<a href='addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + "' class='btn btn-success'>Add to Cart</a>");
                        out.println("<br></br><br></br>");
                        out.println("</div>");
                        out.println("</div>");
                        out.println("</div>");                      
                    }

                    out.println("</div>");
                }
            }
        }
        catch (SQLException e)
        {
            out.println("SQLException: " + e);
        }
    %>

</div>

</body>
</html>