<%@ page import="java.sql.*" %>
<%
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phoneNum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {

        Statement st = con.createStatement();
        ResultSet rs;
        rs = st.executeQuery("SELECT * FROM customer WHERE email='" + email + "' OR userId='" + userId + "'");

        if (rs.next()) {
            session.setAttribute("registrationMessage", "Email or User ID is already in use.");
            response.sendRedirect("login.jsp");
            return;
        }

        String query = "INSERT INTO customer(firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId, password) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setString(1, firstName);
        pst.setString(2, lastName);
        pst.setString(3, email);
        pst.setString(4, phoneNum);
        pst.setString(5, address);
        pst.setString(6, city);
        pst.setString(7, state);
        pst.setString(8, postalCode);
        pst.setString(9, country);
        pst.setString(10, userId);
        pst.setString(11, password); 
        int rowCount = pst.executeUpdate();

        if (rowCount > 0) {
            session.setAttribute("registrationMessage", "Registration successful. Please login.");
        } else {
            session.setAttribute("registrationMessage", "Registration failed. Please try again.");
        }

        response.sendRedirect("login.jsp");
    }
%>
