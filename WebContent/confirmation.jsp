<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<html>
<body>
<t:header title="Confirmation of Purchase"/>
<%
	String uid = "" + session.getAttribute("uid");
	String conf = "" + request.getParameter("conf");
	String username = "" + session.getAttribute("name");
	String state = "" + session.getAttribute("state");

	if(uid.equals("null")) //redirect if not logged in
	{
		response.sendRedirect("redirect.jsp");
	}
	
	if (conf.equals("true") == false)
	{
		%>
		<h1>Error: Request Not Valid</h1>
		<%
	}
	else
	{
%>
<h3><%=username%>, your purchase was successful!</h3>
<h4>Summary of Purchase:</h4>
<%	
		Connection conn = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		ResultSet rs1 = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sql = null;
		String sqlpre = null;
		try
		{
		Class.forName("org.postgresql.Driver");
		conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		ps1 = conn.prepareStatement("SELECT products.id AS pidselect, products.cid AS pcid, SKU, products.name AS pname, products.price AS pprice, carts.quantity AS cquantity FROM carts, products "
				+ " WHERE carts.uid = " + uid);
		rs1 = ps1.executeQuery();
		
		ps2 = conn.prepareStatement("INSERT INTO sales (uid, pid, quantity, price) VALUES (?, ?, ?, ?)");
		ps3 = conn.prepareStatement("DELETE FROM carts WHERE uid = " + uid);
		
		%>
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
		
		int pid, price, quantity, total, cid;
		String name, sku;
		
		int grandtotal = 0;
		
		while (rs1.next())
		{
			pid = rs1.getInt("pidselect");
			sku = rs1.getString("SKU");
			price = rs1.getInt("pprice");
			quantity = rs1.getInt("cquantity");
			total = price * quantity;
			grandtotal += total;
			name = rs1.getString("pname");
			cid = rs1.getInt("pcid");
			
			ps2.setInt(1, Integer.parseInt(uid));
			ps2.setInt(2, pid);
			ps2.setInt(3, quantity);
			ps2.setInt(4, price);
			
	%>
		<tr>
			<td><%=sku%></td>
			<td><%=name%></td>
			<td><%=price%></td>
			<td><%=quantity%></td>
			<td><%=total%></td>
		</tr>
	<% 	
			ps2.executeUpdate();
			ps3.executeUpdate();
			
			//users_products_total

			sqlpre =  "SELECT * FROM users_products_total WHERE uid = " + uid;
			rs = stmt.executeQuery(sqlpre);

			if (rs.isBeforeFirst())
				sql = "UPDATE users_products_total SET total = total + " + total + "WHERE uid = " + uid + "AND pid = " + pid;
			else
			 	sql = "INSERT INTO users_products_total VALUES (" + uid + ", " + pid + ", " + total + ")";
				
				stmt.executeUpdate(sql);



			 //users_categories_total


			sqlpre = "SELECT * FROM users_categories_total WHERE uid = " + uid;
			rs = stmt.executeQuery(sqlpre);

			if (rs.isBeforeFirst())
				sql = "UPDATE users_categories_total SET total = total + " + total  + "WHERE  uid = " + uid  + "AND cid = " + cid;
			else
				sql = "INSERT INTO users_categories_total VALUES (" + uid + ", " + cid + ", " + total + ")";

				stmt.executeUpdate(sql);


			//states_products_total

			sqlpre = "SELECT * FROM states_products_total WHERE state = " + state;
			rs = stmt.executeQuery(sqlpre);

			if (rs.isBeforeFirst())
				sql = "UPDATE states_products_total SET total = total + " + total  + "WHERE  state = " + state  + "AND pid = " + pid;
			else
				sql = "INSERT INTO states_products_total VALUES (" + uid + ", " + pid + ", " + total + ")";
				
				stmt.executeUpdate(sql);



			 //states_categories_total

			sqlpre = "SELECT * FROM states_categories_total WHERE state = " + state;
			rs = stmt.executeQuery(sqlpre);

			if (rs.isBeforeFirst())
				sql = "UPDATE states_categories_total SET total = total + " + total  + "WHERE  state = " + state  + "AND cid = " + cid;
			else
				sql = "INSERT INTO states_categories_total VALUES (" + state + ", " + cid + ", " + total + ")";

				stmt.executeUpdate(sql);


			 //products_total

			 sqlpre = "SELECT * FROM products_total WHERE pid = " + pid;
			 rs = stmt.executeQuery(sqlpre);

			 if (rs.isBeforeFirst())
			 	sql = "UPDATE products_total SET total = total + " + total  + "WHERE  pid = " + pid;
			 else
			 	sql = "INSERT INTO prodcuts_total VALUES (" + pid + ", " + total + ")";

				stmt.executeUpdate(sql);
		}
		
		
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
		if (ps2 != null)
			ps2.close();
		if (ps3 != null)
			ps3.close();
		if (conn != null)
			conn.close();
	}
	%>
	</table>
	<form action="products.jsp">
				<input class="btn btn-default" type="submit" value="Back to Browsing">
			</form>
			<% } %>
<t:footer/>
</body>
</html>