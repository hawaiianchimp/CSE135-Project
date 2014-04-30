<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*" %>

<%
	PrintWriter o = response.getWriter();

	boolean success = false;
	String name = request.getParameter("username");
	if (name != null) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
		//Add cart information
		PreparedStatement pscart = null;
		String sqlcart = null;
		PreparedStatement psuid = null;
		ResultSet rsuid = null;
		String sqluid = null;
	
		String age = request.getParameter("age");
		String role = request.getParameter("role");
		String state = request.getParameter("state");

		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database using DriverManager
			conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly
			
			if (name != null) {
				// Create the statement
				
				Statement statement = conn.createStatement();
				// Insert the user into table users, only if it does not already exist
				sql =	"INSERT INTO users (name, role, age, state) " +
						"SELECT ?,?,?,? " +
						"WHERE NOT EXISTS (SELECT name FROM users WHERE name = ?);" ;
				//System.out.print(sql + "\n");	
											
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, name);
				pstmt.setString(2, role);
				pstmt.setInt(3, Integer.parseInt(age));
				pstmt.setString(4, state);
				pstmt.setString(5, name);

				int count = pstmt.executeUpdate();
				//out.println("<h1>" + "test" + "</h1>");
				//if no rows have been updated, that is because the name already exists.
				if(count>0)
					success=true;
				
				sqlcart = "INSERT INTO carts (uid) VALUES (?)";
				pscart = conn.prepareStatement(sqlcart);
				
				sqluid = "SELECT uid FROM users WHERE name = ?";
				psuid = conn.prepareStatement(sqluid);
				psuid.setString(1, name);
				rsuid = psuid.executeQuery();
				rsuid.next();
				pscart.setInt(1, rsuid.getInt("uid")); 
				pscart.executeUpdate();
				
				pscart.close();
				psuid.close();
				rsuid.close();
				
				statement.close();
				conn.close();
			}
		} catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>" + "Shit happened" + "</h1>");
            
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			out.println("<h1>org.postgresql.Driver Not Found</h1>");
		}
	}
%>

<t:header title='Registration Confirmation'/>

	<% 
	if(success)
	{ 
	%>
		<h1>Registration Successful!</h1>
		<h3>Thank you for signing up with us!</h3>
		<%
		String role = ""+session.getAttribute("role");
		if(role.equals("Owner")) { %>
			<a class="btn btn-default" href="/CSE135Project/categories.jsp">Go to Categories</a>
		<% }
		if(role.equals("Customer")) { %>
			<a class="btn btn-default" href="/CSE135Project/product_browsing.jsp" >Go to Product Browsing</a>
		<%}%>
		
		<a class="btn btn-default" href="/CSE135Project/login.jsp" >Go to Log In</a>
		
	<% }
	
	else{ %>
		<h1>Your signup failed!</h1>
		<!-- <h3>Unfortunately, someone else is using your username. Please go back and choose another username</h3> -->
		<a class="btn btn-default" href="/CSE135Project/signup.jsp">Go
		Back</a>
	<% } %>
<t:footer/>
