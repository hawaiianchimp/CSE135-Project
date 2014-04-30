<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<html>
<body>
<t:header title="Confirmation of Purchase"/>
<%
	String username = "" + session.getAttribute("name");
%>
<h3><%=username%>, your purchase was successful!</h3>
<h4>Summary of Purchase:</h4>
<%
		String uid = "" + session.getAttribute("uid");
		String cart_id = "" + session.getAttribute("cart_id");
		if(uid.equals("null")) //redirect if not logged in
		{
			response.sendRedirect("login.jsp");
		}
	
		Connection conn = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs1 = null;
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
		
		ps2 = conn.prepareStatement("DELETE FROM carts_products WHERE cart_id = " + cart_id + " AND product_id = ?");
		
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
			ps2.setInt(1, rs1.getInt("product_id"));
			ps2.executeUpdate();
	%>
		<tr>
			<td><%=rs1.getString("img_url")%></td>
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
		if (ps1 != null)
			ps1.close();
		if (rs1 != null)
			rs1.close();
		if (conn != null)
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