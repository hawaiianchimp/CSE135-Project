<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>


<html>
<body>
<h2>Your Shopping Cart</h2>
<table>
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4 = null;
		
		try
		{
			String user = request.getParameter("user");
			String product = request.getParameter("product");
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
			pstmt = conn.prepareStatement("SELECT products.img_src, products.sku, products.name, products.price, products.sku FROM users, carts, carts_products, products "
					+ "WHERE users.name = ? "
					+ "AND users.uid = carts.uid "
					+ "AND carts.cart_id = carts_products.cart_id "
					+ "AND carts_products.product_id = products.product_id ");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			
			pstmt2 = conn.prepareStatement("SELECT products.sku, COUNT (*) 'Quantity' from (" 
					+ "SELECT products.img_src, products.sku, products.name, products.price, products.sku FROM users, carts, carts_products, products "
					+ "WHERE users.name = ? "
					+ "AND users.uid = carts.uid "
					+ "AND carts.cart_id = carts_products.cart_id "
					+ "AND carts_products.product_id = products.product_id) "
					+ "GROUP BY products.sku");
			pstmt.setString(1, user);
			rs2 = pstmt2.executeQuery();
			
			pstmt3 = conn.prepareStatement("SELECT * from products WHERE products.sku = ?");			
	%>
<tr>
<th>Image</th>
<th>SKU</th>
<th>Name</th>
<th>Price</th>
<th>Quantity</th>
<th>Total</th>
</tr>
<% while (rs2.next())
	{
		pstmt3.setString(1, rs2.getString("products.sku")); %>
<tr>
<td><%=rs3.getString("img_src")%></td>
<td><%=rs3.getString("sku")%></td>
<td><%=rs3.getString("name")%></td>
<td><%=rs3.getDouble("price")%></td>
<td><%=rs2.getInt("Quantity") %></td>
<td><%=rs3.getDouble("price") * rs2.getInt("Quantity")%>
</tr>
<% } %>
</table>
<h3>Add to cart?</h3>
<form action="browsing.jsp" method="POST">
<input type="hidden" name="action" value="insert">
<input type="hidden" name="product" value=<%=product%>>
<table>
<% pstmt3.setString(1, product); 
	rs3 = pstmt3.executeQuery();
	rs3.next(); %>
<tr>
<th>Image</th>
<th>SKU</th>
<th>Name</th>
<th>Price</th>
<th>Quantity</th>
</tr>
<tr>
<td><%=rs3.getString("img_src")%></td>
<td><%=rs3.getString("sku")%></td>
<td><%=rs3.getString("name")%></td>
<td><%=rs3.getDouble("price")%></td>
<td><input type="text" name="quantity"></td>
<td><input type="submit"></td>
</tr>
</table>
</form>

<%
	rs.close();
	rs2.close();
	rs3.close();
	rs4.close();
	pstmt.close();
	pstmt2.close();
	pstmt3.close();
	pstmt4.close();
	conn.close();
		} catch (SQLException e) { e.printStackTrace();} %>
</body>
</html>