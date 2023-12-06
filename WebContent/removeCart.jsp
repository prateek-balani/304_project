<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
String productId = request.getParameter("productId");

@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
if (productList != null && productList.containsKey(productId)) {
    productList.remove(productId);
}

// Redirect back to the cart page
response.sendRedirect("showcart.jsp");
%>
