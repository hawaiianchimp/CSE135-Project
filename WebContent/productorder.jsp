<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@page import="java.sql.*"%>

<html>
<body><table>
	<%
		try
		{
			Class.forName("org.postgresql.Driver");
			Connection conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory?", "qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
			Statement ps = conn.createStatement();
			ResultSet rs = ps.executeQuery("SELECT sku from products");
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

<%
	rs.close();
	ps.close();
	conn.close();
	} catch (SQLException e) {} %>
</table>
</body>
</html>