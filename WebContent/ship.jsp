<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title> 107 Frogs Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
	String orderId = request.getParameter("orderId");
          
	// TODO: Check if valid order id in database
	// TODO: Start a transaction (turn-off auto-commit)
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)){
	con.setAutoCommit(false);
	
	
		// TODO: Retrieve all items in order with given id
		String sql = "SELECT * FROM orderproduct WHERE orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, orderId);
		ResultSet rs = pstmt.executeQuery();
		
		// TODO: Create a new shipment record.
		// TODO: For each item verify sufficient quantity available in warehouse 1.
		while(rs.next()) {
			String productId = rs.getString("productId");
			int quantity = rs.getInt("quantity");
			
			// Check inventory
			sql = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, productId);
			ResultSet rsInventory = pstmt.executeQuery();
			
			if(rsInventory.next()) {
				int inventoryQuantity = rsInventory.getInt("quantity");
				
				if(inventoryQuantity < quantity) {
					// Not enough inventory, rollback transaction
					con.rollback();
					out.println("Error: Not enough inventory for item " + productId);
					return;
				} else {
					// Update inventory
					sql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
					pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, quantity);
					pstmt.setString(2, productId);
					pstmt.executeUpdate();

					
					out.println("<b>"+"Ordered product: " + productId + " Qty: " + quantity + " Previous inventory: " + inventoryQuantity + " New inventory: " + (inventoryQuantity - quantity) + "<br/>");
				}
			}
		}
		
		// TODO: Auto-commit should be turned back on
		con.commit();
		con.setAutoCommit(true);
		out.println("Shipment processed successfully!");
		
	} catch(SQLException e) {
		// Error occurred, rollback transaction
		con.rollback();
		out.println("Error: " + e.getMessage());
	} 
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
