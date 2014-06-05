<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>


<t:header title="Product Order" />
<%
			String error = "" + request.getParameter("error");
			String action = "" + request.getParameter("action");
			String uid = "" + session.getAttribute("uid");
			if (error.equals("yes") || ((action.equals("order")) == false && (action.equals("insert")) == false))
			{
				%>
<h1>Error: Request Is Invalid</h1>
<%
			}
			else 
			{
				System.out.println(action.equals("insert"));
				//redirect if not logged in
				if(uid.equals("null"))
					response.sendRedirect("redirect.jsp");
			
			
			
			//indicate error if page is arrived at by accidental refresh, back button, or directly without selecting "add to cart"
		
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
				int price;
				
				try
				{
					//Collect parameters: need user id and product sku to show user's cart as well as add to it
					
					if (product.equals("null"))
						throw new IOException();
				
					//Connect to database if parameters exist
					Class.forName("org.postgresql.Driver");
					conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
					
				}
				catch (SQLException e)
				{
					%><t:message type="danger" message="<%=e.getMessage() %>"/><%
				}
				
				catch (IOException e)
				{
					%>
<t:message type="danger" message="<%=e.getMessage()%>" />
<%
				}
				
				//Insert data if specified, and redirect back to products.jsp
					if (action.equals("insert"))
					{
						try
						{
							//Add to carts
							quantity = Integer.parseInt(request.getParameter("quantity"));
							price = Integer.parseInt(request.getParameter("price"));
							conn.setAutoCommit(false);
							
							pstmt3 = conn.prepareStatement("UPDATE carts SET quantity=quantity+?, price=? WHERE uid=? AND pid=?;"
									+ "INSERT INTO carts (uid, pid, quantity, price)"
								    +  "SELECT ?, ?, ?, ?"
								    +   "WHERE NOT EXISTS (SELECT 1 FROM carts WHERE uid=? AND pid=?);");

							
							pstmt3.setInt(1, quantity);
							pstmt3.setInt(2, price);
							pstmt3.setInt(3, Integer.parseInt(uid));
							pstmt3.setInt(4, Integer.parseInt(product));
							pstmt3.setInt(5, Integer.parseInt(uid));
							pstmt3.setInt(6, Integer.parseInt(product));
							pstmt3.setInt(7, quantity);
							pstmt3.setInt(8, price);
							pstmt3.setInt(9, Integer.parseInt(uid));
							pstmt3.setInt(10, Integer.parseInt(product));
							/*
							pstmt2 = conn.prepareStatement("SELECT * FROM carts WHERE uid = " + uid + " AND pid = " + product);
							rs2 = pstmt2.executeQuery();
							boolean x = rs2.next();
							System.out.println("RS2.NEXT: " + x);
							if (x)
								pstmt3 = conn.prepareStatement("UPDATE carts SET quantity = quantity + " + quantity + ", price = " + price + "WHERE uid = " + uid + " AND pid = product");
							else
								pstmt3 = conn.prepareStatement("INSERT INTO carts VALUES (" + uid + ", " + product + ", " + quantity + ", " + price + ")");
							
							System.out.println("executing update");
							*/
							int result = pstmt3.executeUpdate();
							
							System.out.println("result: " + result);
							if(result > 0)
							{
								%><t:message message="Succcess" type="success"/><%
							}
							else{

								
								%><t:message message="Fail" type="danger"/><%
							}
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
							if (rs1 != null)
								rs1.close();
							if (rs2 != null)
								rs2.close();
							if (rs4 != null)
								rs4.close();
							%><t:message type="danger" message="<%=e.getMessage() %>"/><%
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
						response.sendRedirect("products.jsp");
					}
				
					//Display cart contents
					else
					{
						try
						{
						//Prepared Statement 1: Get product information and quantities in user's cart
						//Parameters: 1) User ID
						pstmt1 = conn.prepareStatement("SELECT products.id AS pidselect, SKU, products.name AS pname, products.price AS pprice, carts.quantity AS cquantity FROM carts, products "
							+ " WHERE carts.uid = " + uid 
							+ " AND carts.pid = products.id");
						rs1 = pstmt1.executeQuery();
			
						//Prepared Statement 2: Show product information for product desired to add to cart
						//Parameters: 1) Product ID
						pstmt2 = conn.prepareStatement("SELECT * from products WHERE products.id = ?");
						pstmt2.setInt(1, Integer.parseInt(product));
						rs2 = pstmt2.executeQuery();
	%>
<h2>Your Shopping Cart</h2>
<table class="table">
	<tr>
		<%-- <th>Image</th> --%>
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
		<%-- <td><%=rs1.getString("img_url")%></td> --%>
		<td><%=rs1.getString("SKU")%></td>
		<td><%=rs1.getString("Pname")%></td>
		<td><%=rs1.getInt("pprice")%></td>
		<td><%=rs1.getInt("cquantity") %></td>
		<td><%=rs1.getInt("pprice") * rs1.getInt("cquantity")%></td>
	</tr>
	<% 					} 
	%>
</table>
<h3>Add to cart?</h3>
<form action="productorder.jsp" method="GET">
	<input type="hidden" name="action" value="insert"> <input
		type="hidden" name="product" value=<%=product%>>
	<table class="table">
		<% 
						pstmt2.setInt(1, Integer.parseInt(product)); 
						rs2 = pstmt2.executeQuery();
						rs2.next(); 
	%>
		<tr>
			<%-- <th>Image</th> --%>
			<th>SKU</th>
			<th>Name</th>
			<th>Price</th>
			<th>Quantity</th>
		</tr>
		<tr>
			<%-- <td><%=rs2.getString("img_url")%></td> --%>
			<td><%=rs2.getString("SKU")%></td>
			<td><%=rs2.getString("name")%></td>
			<td><%=rs2.getInt("price")%>
			<input type="hidden" name="price" value="<%=rs2.getInt("price") %>" /></td>
			<td><input type="text" name="quantity"></td>
			<td><input class="btn btn-primary" type="submit"
				value="Add to cart"></td>
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
						%><t:message type="danger" message="<%=e.getMessage() %>"/><%
					}
						
					finally
					{
							if (conn != null)
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
				}
			}
		%>

<t:footer />