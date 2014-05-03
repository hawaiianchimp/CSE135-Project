<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*" %>

<%
	PrintWriter o = response.getWriter();

	boolean success = false;
	
	/* fetches all parameters of the form */
	String name = request.getParameter("username");
	String age = request.getParameter("age");
	String role = request.getParameter("role");
	String state = request.getParameter("state");
	
	/* Checks to see if there are spaces in the username*/
	boolean noSpace = true;
	if(name!=null)
	{
		for(int x  = 0; x<name.length(); x++)
		{
			char c = name.charAt(x);
			if(c==' ')
				noSpace = false;
		}
	}
	
	if(name==null || age==null || role==null || state==null)
	{
		%>
		<t:header title='Registration Confirmation'/>
			<t:message type="danger" message="Error: Request Not Valid"/>
		<t:footer />	
		<%
	}
	else
	{
		
		if (name.length()>0 && age.length()>0 && role.length()>0 && state.length()>0 && noSpace) {
			
			Connection conn = null;
			String sql = "";
			PreparedStatement pstmt = null; 
			try {
				// Registering Postgresql JDBC driver with the DriverManager
				Class.forName("org.postgresql.Driver");
	
				// Open a connection to the database using DriverManager
				conn = DriverManager.getConnection(
						"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly

				if (name != null) {
					// Create the statement
					conn.setAutoCommit(false);
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
	
					int count1 = pstmt.executeUpdate();
					System.out.print(count1);
					//out.println("<h1>" + "test" + "</h1>");
					//if no rows have been updated, that is because the name already exists.
					
					sql = "INSERT INTO carts (uid) SELECT uid FROM users WHERE name = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, name);
					int count2 = pstmt.executeUpdate();
					System.out.print(count2);

					if(count1 + count2 == 2)
					{
						conn.commit();
						success = true;
					}
					else
					{
						conn.rollback();
						throw new SQLException("Your signup failed!");
					}

					
					conn.close();
				}
			} catch (SQLException e) {
	            e.printStackTrace();
	            String message = "Failure to Insert Category: " + e.getMessage();
			   	     	%>
						<t:message type="danger" message="<%=message %>"></t:message>
						<%
	            
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
			<t:message type="success" message="You have successfully signed up!" />
			<h3>Thank you for signing up with us!</h3>
			<%
			if(role.equals("Owner")) { %>
				<a class="btn btn-default" href="/CSE135Project/categories.jsp">Go to Categories</a>
			<% }
			if(role.equals("Customer")) { %>
				<a class="btn btn-default" href="/CSE135Project/product_browsing.jsp" >Go to Product Browsing</a>
			<%}%>
			
			<a class="btn btn-default" href="/CSE135Project/login.jsp" >Go to Log In</a>
			
		<% }
		
		else{ %>
			<t:message type="danger" message="Your signup failed!"/>
			<!-- <h3>Unfortunately, someone else is using your username. Please go back and choose another username</h3> -->
			<a class="btn btn-default" href="/CSE135Project/signup.jsp">Go
			Back</a>
		<% } %>
	<t:footer/>
<% } %>