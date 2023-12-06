<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>

<%@ include file="header.jsp" %>

<div class="container mt-4">
    <h1>Your Shopping Cart</h1>

    <% 
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null) { 
        out.println("<H1>Your shopping cart is empty!</H1>");
        productList = new HashMap<String, ArrayList<Object>>();
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    %>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Product Id</th>
                <th>Product Name</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Subtotal</th>
                <th>Update Quantity</th>
                <th>Remove</th>
            </tr>
        </thead>
        <tbody>
            <% 
            double total = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) { 
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                double pr = Double.parseDouble(product.get(2).toString());
                int qty = Integer.parseInt(product.get(3).toString());
                total += pr * qty;
            %>
                <tr>
                    <td><%= product.get(0) %></td>
                    <td><%= product.get(1) %></td>
                    <td align="center">
                        <form method="post" action="updateCart.jsp">
                            <input type="number" name="quantity" value="<%= product.get(3) %>" min="1">
                            <input type="hidden" name="productId" value="<%= product.get(0) %>">
                            <input type="submit" value="Update" class="btn btn-primary">
                        </form>
                    </td>
                    <td><%= currFormat.format(pr) %></td>
                    <td><%= currFormat.format(pr * qty) %></td>
                    <td align="center">
                        <form method="post" action="removeCart.jsp">
                            <input type="hidden" name="productId" value="<%= product.get(0) %>">
                            <input type="submit" value="Remove" class="btn btn-danger">
                        </form>
                    </td>
                </tr>
            <% } %>
                <tr>
                    <td colspan="4" align="right"><b>Order Total: </b></td>
                    <td align="right"><%= currFormat.format(total) %></td>
                </tr>
        </tbody>
    </table>

    <% } %>

    <div class="d-flex justify-content-between mt-4">
        <a href="checkout.jsp" class="btn btn-primary">Check Out</a>
        <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
    </div>
</div>

</body>
</html>
