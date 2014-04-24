<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*" %>

<%
	PrintWriter o = response.getWriter();

	int logged_in = 0;
	String username = request.getParameter("username");
	//System.out.println("username= " + username + " " + username.length());
	if (username != null && username.length()>0) {
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
					//System.out.print("There is an entry already! " + rs.findColumn("name"));
					logged_in = 1; //match found
				}
				else
				{
					//System.out.print("good to go! " + rs.findColumn("name"));
					logged_in = 0;
				}
					
				if(logged_in==1)
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
	else
	{
		logged_in = 2;
	}
%>

<t:header title='Login'/>

	<% 
	if(logged_in==1){ 
	%>
		<h1>Signed In! Welcome <%= username %>!</h1>
		<h3>What would you like to do today?</h3>
		<a class="btn btn-default" href="/CSE135Project/index.jsp">Home</a>
		<a class="btn btn-default" href="/CSE135Project/categories.jsp">Go to Categories</a>
		<a class="btn btn-default" href=#>Go to Shopping Cart</a>
	<% 
	}
	
	else if(logged_in==2){ 
	%>
		<h1>You did not provide a username.</h1>
		<h3>Please provide a username and try again.</h3>	
	<% 
	}
	
	else
	{ 
	%>
		<h1>The provided name, <%= username %>, is not known.</h1>
		<h3>Please try again.</h3>
	<% 
	}
	%>
<t:footer/>
