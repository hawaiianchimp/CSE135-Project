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
	String action = request.getParameter("action");
	String uid = "" + session.getAttribute("uid");
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
	
	if (action != null && (action.equals("view") || action.equals("purchase")))
	{
		Class.forName("org.postgresql.Driver");
		conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		ps1 = conn.prepareStatement("SELECT products.product_id, products.sku, products.img_url, products.name, products.price, COUNT (*) \"Quantity\" FROM users, carts, carts_products, products "
				+ "WHERE users.uid = ? "
				+ "AND users.uid = carts.uid "
				+ "AND carts.cart_id = carts_products.cart_id "
				+ "AND carts_products.product_id = products.product_id "
				+ "GROUP BY products.product_id, products.sku, products.img_url, products.name, products.price");
		ps1.setInt(1, Integer.parseInt(uid));
		rs1 = ps1.executeQuery();
	
		if (action.equals("purchase"))	
		{
		
		%>
	
	<h2>Purchase Shopping Cart</h2>
	<%} else {
		%>
		
		<h2>View Shopping Cart</h2>
		<% }%>
	
	<table>
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
				<td><%=rs1.getString("sku")%></td>
				<td><%=rs1.getString("name")%></td>
				<td>$<%=rs1.getDouble("price")%></td>
				<td><%=rs1.getInt("Quantity") %></td>
				<%
					price = rs1.getDouble("price") * rs1.getInt("Quantity");
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
		<form method="POST" action="confirmation.jsp">
			<input type="hidden" name="conf" value="true">
			<label for="cardno">Card Number</label>
			<input type="text" name="cardno">
			<input type="submit" value="Purchase">
		</form>
		
	<%
	}
		else
		{
			%>
			<form method="POST" action="product_browsing.jsp">
				<input type="submit" value="Back to Browsing">
			</form>
			<form method="POST" action="buycart.jsp">
				<input type="hidden" name="action" value="purchase">
				<input type="submit" value="Purchase Cart">
			</form>
	<%
		}
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