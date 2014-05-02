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
		
		PreparedStatement pstmtcart = null;
		ResultSet rscart = null;

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
					pstmtcart = conn.prepareStatement("SELECT * FROM carts WHERE uid = ?");
					pstmtcart.setInt(1, rs.getInt("uid"));
					rscart = pstmtcart.executeQuery();
					rscart.next();
					
					session.setAttribute("name", username);
					session.setAttribute("uid", rs.getInt("uid"));
					session.setAttribute("cart_id", rscart.getInt("cart_id"));
					session.setAttribute("role", rs.getObject(rs.findColumn("role")));
					session.setAttribute("state", rs.getObject(rs.findColumn("state")));
					session.setAttribute("age", rs.getObject(rs.findColumn("age")));
					
					/* System.out.print("Log\n name:" + session.getAttribute("name") + "\n");
					System.out.print("Log\n role:" + session.getAttribute("role") + "\n");
					System.out.print("Log\n state:" + session.getAttribute("state") + "\n");
					System.out.print("Log\n age:" + session.getAttribute("age") + "\n"); */
					
					pstmtcart.close();
					rscart.close();
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
            out.println("<h1>" + e.getMessage() + "</h1>");
            
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
		String welcome_message = "<h1>Signed In! Welcome " + username +"!</h1>";
	%>
		<t:message type="success" message="<%=welcome_message %>" />
		<h3>What would you like to do today?</h3>
		<a class="btn btn-default" href="/CSE135Project/index.jsp">Home</a>
		<%
		String role = ""+session.getAttribute("role");
		if(role.equals("Owner")){
		%>
		<a class="btn btn-default" href="/CSE135Project/categories.jsp">Go to Categories</a>
		<%}
		if(role.equals("Customer")) { %>
		<a class="btn btn-default" href="/CSE135Project/product_browsing.jsp" >Go to Product Browsing</a>
		<a class="btn btn-default" href="buycart.jsp?action=view">Go to Shopping Cart</a>
		<%}%>
	<% 
	}
	
	else if(logged_in==2){ 
	%>
		<t:message type="danger" message="<h1>Error: Request Not Valid.</h1>" />
		<%-- <t:message type="danger" message="<h1>You did not provide a username.</h1>
		<h3>Please provide a username and try again.</h3>" /> --%>
		<div class="row">
			<form class="navbar-form navbar-left" role="login" action="login_confirm.jsp" method="POST">
			  <div class="form-group">
			  	<input type="text" class="form-control" placeholder="Username" name="username">
			 	</div>
			  <button type="submit" class="btn btn-default">Log In</button>
			  <a class="btn btn-default" href="/CSE135Project/signup.jsp" >Signup</a>
			</form>
		</div>
		
	<% 
	}
	
	else
	{ 
		String message="<h1>The provided name, " +username+ ", is not known.</h1>" +
				"<h3>Please try again.</h3>";
	%>
		<t:message type="danger" message="<%=message%>" />
		<div class="row">
			<form class="navbar-form navbar-left" role="login" action="login_confirm.jsp" method="POST">
			  <div class="form-group">
			  	<input type="text" class="form-control" placeholder="Username" name="username">
			 	</div>
			  <button type="submit" class="btn btn-default">Log In</button>
			  <a class="btn btn-default" href="/CSE135Project/signup.jsp" >Signup</a>
			</form>
		</div>
	<% 
	}
	%>
<t:footer/>
