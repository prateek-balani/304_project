<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
String productId = request.getParameter("productId");
String quantityStr = request.getParameter("quantity");
int quantity = 0;

try {
    quantity = Integer.parseInt(quantityStr);
} catch (NumberFormatException e) {
    // Handle invalid quantity
}

if (quantity <= 0) {
    // Handle non-positive quantity
}

@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
if (productList != null && productList.containsKey(productId)) {
    ArrayList<Object> product = productList.get(productId);
    product.set(3, quantity); // Update the quantity
}

// Redirect back to the cart page
response.sendRedirect("showcart.jsp");
%>
