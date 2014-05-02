<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>


<t:header title="Product Order"/>
	<%
			String error = "" + request.getAttribute("error");
			String action = "" + session.getAttribute("action");
			if (error.equals("yes") || ((action.equals("order")) == false && (action.equals("insert")) == false))
			{
				%>
				<h1>Error: Request Is Invalid</h1>
				<%
			}
			else 
			{
				//redirect if not logged in
				String uid = "" + session.getAttribute("uid");
	
				
				if (uid.equals("null"))
					response.sendRedirect("login.jsp");
				
				Connection conn = null;
				PreparedStatement pstmt1 = null;
				PreparedStatement pstmt2 = null;
				PreparedStatement pstmt3 = null;
				PreparedStatement pstmt4 = null;
				ResultSet rs1 = null;
				ResultSet rs2 = null;
				ResultSet rs4 = null;
			
				String product = "" + request.getParameter("product");
				int quantity;
				
				try
				{
					//Collect parameters: need user id and product sku to show user's cart as well as add to it
				
					System.out.println("User: " + uid);
					System.out.println("Product: " + product);
					System.out.println("action: " + action);
					
					if (uid.equals("null") || product.equals("null"))
						throw new IOException();
				
					//Connect to database if parameters exist
					Class.forName("org.postgresql.Driver");
					conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
					
				}
				catch (SQLException e)
				{
					e.printStackTrace();
					if (conn != null)
						conn.close();
					if (pstmt1 != null)
						pstmt1.close();
					if (pstmt2 != null)
						pstmt2.close();
					if (pstmt3 != null)
						pstmt3.close();
					if (pstmt4 != null)
						pstmt4.close();
					if (rs1 != null)
						rs1.close();
					if (rs2 != null)
						rs2.close();
					if (rs4 != null)
						rs4.close();
					response.sendRedirect("productorder.jsp?error=yes");
				}
				
				//Insert data if specified, and redirect back to products.jsp
					if (action.equals("insert"))
					{
						try
						{
							//Add to carts_products
							quantity = Integer.parseInt(request.getParameter("quantity"));
							conn.setAutoCommit(false);
							pstmt3 = conn.prepareStatement("INSERT INTO carts_products VALUES (? , ?)");
							pstmt4 = conn.prepareStatement("SELECT carts.cart_id FROM carts WHERE carts.uid = ?");
							pstmt4.setInt(1, Integer.parseInt(uid));
							rs4 = pstmt4.executeQuery();
							conn.commit();
							rs4.next();
							pstmt3.setInt(1, rs4.getInt("cart_id"));
							pstmt3.setInt(2, Integer.parseInt(product));
							System.out.println("here");
							for (int i = 0; i < quantity; i++)
								pstmt3.executeUpdate();
							conn.commit();
						}
					
						catch (SQLException e)
						{			
							conn.rollback();
							if (conn != null)
								conn.close();
							if (pstmt1 != null)
								pstmt1.close();
							if (pstmt2 != null)
								pstmt2.close();
							if (pstmt3 != null)
								pstmt3.close();
							if (pstmt4 != null)
								pstmt4.close();
							if (rs1 != null)
								rs1.close();
							if (rs2 != null)
								rs2.close();
							if (rs4 != null)
								rs4.close();
							response.sendRedirect("productorder.jsp?error=yes");
						}
						
						finally
						{
							conn.setAutoCommit(true);
							if (conn != null)
								conn.close();
							if (pstmt1 != null)
								pstmt1.close();
							if (pstmt2 != null)
								pstmt2.close();
							if (pstmt3 != null)
								pstmt3.close();
							if (pstmt4 != null)
								pstmt4.close();
							if (rs1 != null)
								rs1.close();
							if (rs2 != null)
								rs2.close();
							if (rs4 != null)
								rs4.close();
						}
						
						response.sendRedirect("http://localhost:8080/CSE135Project/categories.jsp");
					}
				
					//Display cart contents
					else
					{
						try
						{
						//Prepared Statement 1: Get product information and quantities in user's cart
						//Parameters: 1) User ID
						pstmt1 = conn.prepareStatement("SELECT products.product_id, products.sku, products.img_url, products.name, products.price, COUNT (*) \"Quantity\" FROM users, carts, carts_products, products "
							+ "WHERE users.uid = ? "
							+ "AND users.uid = carts.uid "
							+ "AND carts.cart_id = carts_products.cart_id "
							+ "AND carts_products.product_id = products.product_id "
							+ "GROUP BY products.product_id, products.sku, products.img_url, products.name, products.price");
						pstmt1.setInt(1, Integer.parseInt(uid));
						rs1 = pstmt1.executeQuery();
			
						//Prepared Statement 2: Show product information for product desired to add to cart
						//Parameters: 1) Product ID
						pstmt2 = conn.prepareStatement("SELECT * from products WHERE products.product_id = ?");
						pstmt2.setInt(1, Integer.parseInt(product));
						rs2 = pstmt2.executeQuery();
	%>
						<h2>Your Shopping Cart</h2>
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
								<td><%=rs1.getString("img_url")%></td>
								<td><%=rs1.getString("sku")%></td>
								<td><%=rs1.getString("name")%></td>
								<td><%=rs1.getDouble("price")%></td>
								<td><%=rs1.getInt("Quantity") %></td>
								<td><%=rs1.getDouble("price") * rs1.getInt("Quantity")%></td>
							</tr>
	<% 					} 
	%>
						</table>
						<h3>Add to cart?</h3>
						<form action="productorder.jsp" method="POST">
							<input type="hidden" name="action" value="insert">
							<input type="hidden" name="product" value=<%=product%>>
						<table>
	<% 
						pstmt2.setInt(1, Integer.parseInt(product)); 
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
								<td><%=rs2.getString("img_url")%></td>
								<td><%=rs2.getString("sku")%></td>
								<td><%=rs2.getString("name")%></td>
								<td><%=rs2.getDouble("price")%></td>
								<td><input type="text" name="quantity"></td>
								<td><input type="submit" value="Add to cart"></td>
							</tr>
						</table>
					</form>

	<%				}
					
					catch (Exception e)
					{
						e.printStackTrace();
						if (conn != null)
							conn.close();
						if (pstmt1 != null)
							pstmt1.close();
						if (pstmt2 != null)
							pstmt2.close();
						if (pstmt3 != null)
							pstmt3.close();
						if (pstmt4 != null)
							pstmt4.close();
						if (rs1 != null)
							rs1.close();
						if (rs2 != null)
							rs2.close();
						if (rs4 != null)
							rs4.close();
					}
				}
			}
		%>
		
<t:footer />