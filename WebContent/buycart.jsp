<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<html>
<body>
<t:header title="Shopping Cart"/>
<% 
	String action = request.getParameter("action");
	Connection conn = null;
	PreparedStatement ps1 = null;
	ResultSet rs1 = null;
	
	try
	{
	
	if (action != null && (action.equals("view") || action.equals("purchase")))
	{
		String uid = "" + session.getAttribute("uid");
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
		<% if (action.equals("purchase")) { %>
		<h3>Payment Information</h3>
		<form action="confirmation.jsp">
			<label for="owner">Cardholder's Name</label>
			<input type="text" name="owner">
			<br>
			<label for="card">Card Type</label>
			<select name="card">
  				<option value="visa">Visa</option>
  				<option value="mastercard">Mastercard</option>
  				<option value="discover">Discover</option>
  				<option value="amex">American Express</option>
			</select>
			<br>
			<label for="cardno">Card Number</label>
			<input type="text" name="cardno">
			<label for="csv">Card Security Value</label>
			<input type="text" name="csv">
		</form>
		<h3>Billing Address</h3>
		<form>
			<label for="street">Cardholder's Name</label>
			<input type="text" name="street">
			<br>
			<label for="city">City</label>
			<input type="text" name="city" value="City">
			<label for="state">State</label>
			<select name="state">
					<option>State</option>
					<option>-----</option>
					<option value="AL">Alabama</option>
					<option value="AK">Alaska</option>
					<option value="AZ">Arizona</option>
					<option value="AR">Arkansas</option>
					<option value="CA">California</option>
					<option value="CO">Colorado</option>
					<option value="CT">Connecticut</option>
					<option value="DE">Delaware</option>
					<option value="DC">District Of Columbia</option>
					<option value="FL">Florida</option>
					<option value="GA">Georgia</option>
					<option value="HI">Hawaii</option>
					<option value="ID">Idaho</option>
					<option value="IL">Illinois</option>
					<option value="IN">Indiana</option>
					<option value="IA">Iowa</option>
					<option value="KS">Kansas</option>
					<option value="KY">Kentucky</option>
					<option value="LA">Louisiana</option>
					<option value="ME">Maine</option>
					<option value="MD">Maryland</option>
					<option value="MA">Massachusetts</option>
					<option value="MI">Michigan</option>
					<option value="MN">Minnesota</option>
					<option value="MS">Mississippi</option>
					<option value="MO">Missouri</option>
					<option value="MT">Montana</option>
					<option value="NE">Nebraska</option>
					<option value="NV">Nevada</option>
					<option value="NH">New Hampshire</option>
					<option value="NJ">New Jersey</option>
					<option value="NM">New Mexico</option>
					<option value="NY">New York</option>
					<option value="NC">North Carolina</option>
					<option value="ND">North Dakota</option>
					<option value="OH">Ohio</option>
					<option value="OK">Oklahoma</option>
					<option value="OR">Oregon</option>
					<option value="PA">Pennsylvania</option>
					<option value="RI">Rhode Island</option>
					<option value="SC">South Carolina</option>
					<option value="SD">South Dakota</option>
					<option value="TN">Tennessee</option>
					<option value="TX">Texas</option>
					<option value="UT">Utah</option>
					<option value="VT">Vermont</option>
					<option value="VA">Virginia</option>
					<option value="WA">Washington</option>
					<option value="WV">West Virginia</option>
					<option value="WI">Wisconsin</option>
					<option value="WY">Wyoming</option>
				</select>
				<label for="zip">Zip Code</label>
				<input type="text" value="zip">	
				<br>
				<input type="submit">
		</form>
		
	<%
	}
		else
		{
			%>
			<form action="categories.jsp">
				<input type="submit" value="Back to Browsing">
			</form>
			<form action="buycart.jsp?action=purchase">
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
			conn.close();
			ps1.close();
			rs1.close();
	}
	
	%>
<t:footer />
</body>
</html>