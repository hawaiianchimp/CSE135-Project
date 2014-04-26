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
			//Initialize parameters
			Connection conn = null;
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			ResultSet rs1 = null;
			ResultSet rs2 = null;
		
			try
			{
				//Collect parameters: need user id and product sku to show user's cart as well as add to it
				String user = request.getParameter("user");
				String product = request.getParameter("product");
				if (user == null || product == null)
					throw new IOException();
				
				//Connect to database if parameters exist
				Class.forName("org.postgresql.Driver");
				conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
				
				String action = request.getParameter("action");
				
				if (action != null && action == "insert")
				{
					
				}
			
				//Prepared Statement 1: Get product information and quantities in user's cart
				//Parameters: 1) User ID
				pstmt1 = conn.prepareStatement("SELECT products.img_src, products.sku, products.name, products.price, COUNT (*) 'Quantity' from (" 
						+ "SELECT products.img_src, products.sku, products.name, products.price, FROM users, carts, carts_products, products "
						+ "WHERE users.name = ? "
						+ "AND users.uid = carts.uid "
						+ "AND carts.cart_id = carts_products.cart_id "
						+ "AND carts_products.product_id = products.product_id) "
						+ "GROUP BY products.sku");
				pstmt1.setString(1, user);
				rs1 = pstmt2.executeQuery();
			
				//Prepared Statement 2: Show product information for product desired to add to cart
				//Parameters: 1) Product SKU
				pstmt2 = conn.prepareStatement("SELECT * from products WHERE products.sku = ?");
				pstmt2.setString(1, product);
				rs2 = pstmt2.executeQuery();
		%>
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
		%>
		</table>
		<h3>Add to cart?</h3>
		<form action="browsing.jsp" method="POST">
			<input type="hidden" name="action" value="insert">
			<input type="hidden" name="product" value=<%=product%>>
			<table>
			<% 
				pstmt2.setString(1, product); 
				rs2 = pstmt2.executeQuery();
				rs2.next(); 
			%>
				<tr>
					<th>Image</th>
					<th>SKU</th>
					<th>Name</th>
					<th>Price</th>
					<th>Quantity</th>
				</tr>
				<tr>
					<td><%=rs2.getString("img_src")%></td>
					<td><%=rs2.getString("sku")%></td>
					<td><%=rs2.getString("name")%></td>
					<td><%=rs2.getDouble("price")%></td>
					<td><input type="text" name="quantity"></td>
					<td><input type="submit"></td>
				</tr>
			</table>
		</form>

		<%
			rs1.close();
			rs2.close();
			pstmt1.close();
			pstmt2.close();
			conn.close();
		} 
		
		catch (SQLException e) { e.printStackTrace();}
		catch (IOException e) {e.printStackTrace();}
		%>
	</body>
</html>