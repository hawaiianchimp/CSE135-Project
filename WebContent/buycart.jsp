<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<html>
<body>
<t:header title="Shopping Cart"/>
<% 
	//redirect if not logged in
	String action = "" + request.getParameter("action");
	String uid = "" + session.getAttribute("uid");
	System.out.println("uid: " + uid);
	if (uid.equals("null"))
	{
		response.sendRedirect("redirect.jsp");
	}
	
	Connection conn = null;
	PreparedStatement ps1 = null;
	ResultSet rs1 = null;
	double price = 0;
	double total = 0;
	int counter = 0;
	
	try
	{
	
	if (((action.equals("null")) == false && (action.equals("view")) || action.equals("purchase")))
	{
		Class.forName("org.postgresql.Driver");
		/* conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); */
				conn = DriverManager.getConnection(
			            "jdbc:postgresql://localhost/CSE135?" +
			            "user=Bonnie");
		ps1 = conn.prepareStatement("SELECT products.id AS pidselect, SKU, products.name AS pname, products.price AS pprice, carts.quantity AS cquantity FROM carts, products "
				+ " WHERE carts.uid = " + uid
				+ " AND carts.pid = products.id ");
		rs1 = ps1.executeQuery();
	
		if (action.equals("purchase"))	
		{
		
		%>
	
	<h2>Purchase Shopping Cart</h2>
	<%} else {
		%>
		
		<h2>View Shopping Cart</h2>
		<% }%>
	
	<table class="table">
			<tr>
				<th>SKU</th>
				<th>Name</th>
				<th>Price</th>
				<th>Quantity</th>
				<th>Total</th>
			</tr>
		<% 
			//Iterate through all tuples to display contents of cart
			while (rs1.next())
			{
				counter++;
		%>
			<tr>
				<td><%=rs1.getString("SKU")%></td>
				<td><%=rs1.getString("pname")%></td>
				<td>$<%=rs1.getDouble("pprice")%></td>
				<td><%=rs1.getInt("cquantity") %></td>
				<%
					price = rs1.getDouble("pprice") * rs1.getInt("cquantity");
					total = total + price;
				%>
				<td><%=price%></td>
			</tr>
		<% 	} 
		%>
		</table>
		<%
			if (counter == 0)
			{
		%>
			<h2>Your cart is empty</h2>
			<%}
		else {%>
		<h2>Total Price: $<%=total%></h2>
		<%} %>
		<% if (action.equals("purchase")) { %>
		<h3>Payment Information</h3>
		<form class="form-horizontal" method="POST" action="confirmation.jsp">
			<input type="hidden" name="conf" value="true">
			<label for="cardno">Card Number</label>
			<input class="form-control" type="text" name="cardno" placeholder="XXXX-XXXX-XXXX-XXXX">
			<input class="btn btn-primary" type="submit" value="Purchase">
		</form>
		
	<%
	}
		else
		{
			%>
			<form method="POST" action="products.jsp">
				<input class="btn btn-default" type="submit" value="Back to Browsing">
			</form>
			<form method="POST" action="buycart.jsp">
				<input type="hidden" name="action" value="purchase">
				<input class="btn btn-success" type="submit" value="Purchase Cart">
			</form>
	<%
		}
	}
	
	else
	{
		%>
		<h1>Error: Request Not Valid</h1>
		<%
	}
	}
	catch (Exception e)
	{
		e.printStackTrace();
	}
	finally
	{
		if (conn != null)
			conn.close();
		if (ps1 != null)
			ps1.close();
		if (rs1 != null)
			rs1.close();
	}
	
	%>
<t:footer />
</body>
</html>