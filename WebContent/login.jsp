<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*" %>

<%
	PrintWriter o = response.getWriter();

	boolean logged_in = false;
	String username = request.getParameter("username");
	if (username != null) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database using DriverManager
			conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly
			
			if (username != null) {
				// Create the statement
				Statement statement = conn.createStatement();
				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				pstmt = conn
						.prepareStatement("SELECT * FROM users WHERE name=?"); //TODO: Change accordingly
				pstmt.setString(1, username);
				rs = pstmt.executeQuery();
				//out.println("<h1>" + "test" + "</h1>");
				if (rs.next())
				{
					System.out.print("There is an entry already! " + rs.findColumn("name"));
					logged_in = true; //match found
				}
				else
				{
					System.out.print("good to go! " + rs.findColumn("name"));
					logged_in = false;
				}
					
				if(logged_in)
				{
					session.setAttribute("name", username);
				}

				// Close the ResultSet
				rs.close();
				// Close the Statement
				statement.close();
				// Close the Connection
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

<t:header title='Login'/>

	<% if(logged_in){ %>
		<h3>Signed In! Welcome <%= username %>!</h3>
		<a class="btn btn-default" href="/CSE135Project/categories.jsp">Go to Categories</a>
	<% }
	
	else{ %>
		<h1>Unable to find username, please try again.</h1>
	<% } %>
<t:footer/>
