<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>


<t:header title="Product Order"/>
		<%
			//redirect if not logged in
			String uid = "" + session.getAttribute("uid");
			if(uid.equals("null")) 
			{
				response.sendRedirect("login.jsp");
			}
		
			//Initialize parameters
			Connection conn = null;
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			PreparedStatement pstmt3 = null;
			PreparedStatement pstmt4 = null;
			ResultSet rs1 = null;
			ResultSet rs2 = null;
			ResultSet rs4 = null;
			
			String product = "" + request.getParameter("product");
			String action = "" + request.getParameter("action");
		
			try
			{
				//Collect parameters: need user id and product sku to show user's cart as well as add to it
				
				System.out.println("User: " + uid);
				System.out.println("Product: " + product);
				System.out.println("action: " + action);
				
				int quantity;
				if (uid.equals("null") || product.equals("null"))
				{
					%>
					<t:message type="warning" message="Please login first to see your cart"/><%

					throw new IOException();
				}
				
				//Connect to database if parameters exist
				Class.forName("org.postgresql.Driver");
				conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
				
				//Insert data if specified, and redirect back to products.jsp
				System.out.println("Before");
				if (!(action.equals("null")) && action.equals("insert"))
				{
					System.out.println("SUP HOMIE");
					//Add to carts_products
					quantity = Integer.parseInt(request.getParameter("quantity"));
					pstmt3 = conn.prepareStatement("INSERT INTO carts_products VALUES (?,?)");
					pstmt4 = conn.prepareStatement("SELECT carts.cart_id FROM carts WHERE carts.uid = ?");
					pstmt4.setInt(1, Integer.parseInt(uid));
					rs4 = pstmt4.executeQuery();
					System.out.println("successful");
					rs4.next();
					System.out.println("uid: " + uid);
					System.out.println("before p3");
					pstmt3.setInt(1, rs4.getInt("cart_id"));
					System.out.println("before p3");
					pstmt3.setInt(2, Integer.parseInt(product));
					System.out.println("here");
					for (int i = 0; i < quantity; i++)
						pstmt3.executeUpdate();
					response.sendRedirect("http://localhost:8080/CSE135Project/categories.jsp");
				}
				
				//Display cart contents
				else
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
				//Parameters: 1) Product SKU
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
		<% 	} 
		%>
		</table>
		<h3>Add to cart?</h3>
		<form action="productorder.jsp" method="GET">
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

		<%
			} 
		}
		catch (SQLException e) {e.printStackTrace();}
		catch (IOException e) {e.printStackTrace();}
		%>
		
		
		<%
		
		try{

		Class.forName("org.postgresql.Driver");
		conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		String sql = "SELECT * FROM products WHERE product_id = ?";
		pstmt1 = conn.prepareStatement(sql); 
		pstmt1.setInt(1, Integer.parseInt(product));
		ResultSet rs = pstmt1.executeQuery();
		
		if(rs.next())
		{
			String rsname, rsprice, rssku, rsdesc;
			rsname = rs.getString("name");
			rsprice = rs.getString("price");
			rssku = rs.getString("sku");
			rsdesc = rs.getString("description");
			%>
			
			<h1><%=rsname %></h1>
			<h3>$<%=rsprice %></h3>
			<h3>Description: <%=rsdesc %></h3>
			<h3>SKU: <%=rssku %></h3>
			<%
			
		}
		
		
		
		}
		catch(SQLException e){
			e.printStackTrace();
   	     	%>
			<t:message type="danger" message="<%=e.getMessage() %>"></t:message>
			<%
		}
		finally
		{
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
		
		%>
		
<t:footer />