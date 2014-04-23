<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>


<html>
<body>
<table>
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try
		{
			String name = request.getParameter("name");
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
			pstmt = conn.prepareStatement("SELECT products.product_id, products.name, products.price, products.sku FROM users, carts, carts_products, products "
					+ "WHERE users.name = 'vineel' "
					+ "AND users.uid = carts.uid "
					+ "AND carts.cart_id = carts_products.cart_id "
					+ "AND carts_products.product_id = products.product_id ");
			//pstmt.setString(1, name);
			rs = pstmt.executeQuery();
	%>
	
<tr>
<th>Product ID</th>
<th>Name</th>
<th>Price</th>
<th>SKU</th>
</tr>
<% while (rs.next()) { %>
<tr>
<td><%=rs.getString("product_id")%></td>
<td><%=rs.getString("name")%></td>
<td><%=rs.getDouble("price")%></td>
<td><%=rs.getString("sku")%></td>
</tr>
<% } %>
</table>
<%
	rs.close();
	pstmt.close();
	conn.close();
	} catch (SQLException e) { e.printStackTrace();} %>
</body>
</html>