<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int category_id = Integer.parseInt(request.getParameter("id"));

	try {
		// Registering Postgresql JDBC driver with the DriverManager
		Class.forName("org.postgresql.Driver");


		// Open a connection to the database using DriverManager
		conn = DriverManager.getConnection(
				"jdbc:postgresql://localhost/bonnie_test", "bonnie",
				"password"); //TODO: Change name of database accordingly

		// Create the statement
		Statement statement = conn.createStatement();

		// Use the created statement to SELECT
		// the student attributes FROM the Student table.
		pstmt = conn
				.prepareStatement("SELECT * FROM products_categories INNER JOIN products ON (products_categories.category_id=?) WHERE products_categories.product_id=products.product_id");
		pstmt.setInt(1, category_id);
		rs = pstmt.executeQuery();
%>

<t:header title="Product Categories" />
<div class="container">
	<div class="row">

		<%
			String rsname, rsdescription, rsimg, rssku, rsid, rsprice;
				while (rs.next()) {
					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsimg = rs.getString("img_src");
					rssku = rs.getString("sku");
					rsid = String.valueOf(rs.getInt("product_id"));
					rsid = String.valueOf(rs.getDouble("price"));

					if (rsimg == null)
						rsimg = "default";
		%>
		<t:product name="<%=rsname %>" description="<%=rsdescription %>"
			imgurl="<%=rsimg %>" />
		<%
			}
				/* Close everything  */
				// Close the ResultSet
				rs.close();
				//Close the Statement
				statement.close();
				// Close the Connection
				conn.close();
			}

			catch (SQLException e) {
				e.printStackTrace();
				out.println("<h1>" + "Shit happened" + "</h1>");
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
				out.println("<h1>org.postgresql.Driver Not Found</h1>");
			}
		%>

	</div>
</div>
<t:footer />
