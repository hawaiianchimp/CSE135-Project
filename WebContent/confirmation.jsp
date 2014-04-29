<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<html>
<body>
<t:header title="Confirmation of Purchase"/>
<%
	String username = "" + session.getAttribute("user");
%>
<h3><%=username%>, your purchase was successful!</h3>
<h4>Summary of Purchase:</h4>
<%
		Connection conn = null;
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		String uid = "" + session.getAttribute("uid");
		try
		{
		Class.forName("org.postgresql.Driver");
		conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		ps1 = conn.prepareStatement("SELECT products.product_id, products.sku, products.img_src, products.name, products.price, COUNT (*) \"Quantity\" FROM users, carts, carts_products, products "
				+ "WHERE users.uid = ? "
				+ "AND users.uid = carts.uid "
				+ "AND carts.cart_id = carts_products.cart_id "
				+ "AND carts_products.product_id = products.product_id "
				+ "GROUP BY products.product_id, products.sku, products.img_src, products.name, products.price");
		ps1.setInt(1, Integer.parseInt(uid));
		rs1 = ps1.executeQuery();
		%>
		<table>
		<tr>
			<th>Image</th>
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
	%>
		<tr>
			<td><%=rs1.getString("img_src")%></td>
			<td><%=rs1.getString("sku")%></td>
			<td><%=rs1.getString("name")%></td>
			<td><%=rs1.getDouble("price")%></td>
			<td><%=rs1.getInt("Quantity") %></td>
			<td><%=rs1.getDouble("price") * rs1.getInt("Quantity")%></td>
		</tr>
	<% 	}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	finally
	{
	ps1.close();
	rs1.close();
	conn.close();
	}
	
	%>
	</table>
	<form action="categories.jsp">
				<input type="submit" value="Back to Browsing">
			</form>
<t:footer/>
</body>
</html>