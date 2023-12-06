<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement pstmt = con.prepareStatement("SELECT userid FROM customer WHERE userid = ? AND password = ?")) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rst = pstmt.executeQuery();

            if (rst.next()) {
                retStr = rst.getString("userid");
            }

        } catch (SQLException ex) {
            out.println(ex);
        }

        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Invalid username or password.");
        }

        return retStr;
    }
%>