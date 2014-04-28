<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
	String role = "" + session.getAttribute("role");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int category_id = Integer.parseInt(request.getParameter("cid"));

	try {
		// Registering Postgresql JDBC driver with the DriverManager
		Class.forName("org.postgresql.Driver");

		// Open a connection to the database using DriverManager
		conn = DriverManager
				.getConnection(
						"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");

		// Create the statement
		Statement statement = conn.createStatement();

		// Use the created statement to SELECT
		// the student attributes FROM the Student table.
		String sql = "SELECT * FROM products_categories INNER JOIN products ON (products_categories.category_id=?) WHERE products_categories.product_id=products.product_id";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, category_id);
		rs = pstmt.executeQuery();
		System.out.println("hello");
%>


<!-- category menu -->
<%
	Connection c_conn = null;
	PreparedStatement c_pstmt = null;
	ResultSet c_rs = null;


		Class.forName("org.postgresql.Driver");

		c_conn = DriverManager
				.getConnection(
						"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		Statement c_statement = c_conn.createStatement();
		c_pstmt = c_conn.prepareStatement("SELECT * FROM categories AS c LEFT JOIN (SELECT p.category_id, COUNT(p.category_id) FROM products_categories AS p GROUP BY p.category_id) AS p ON (c.category_id = p.category_id);");
		c_rs = c_pstmt.executeQuery();
%>

<t:header title="Product Categories" />
	<div class="row">
	<!-- category menu -->
	<div class="col-md-2">
		<ul class="nav nav-stacked navbar-left nav-pills">
		<li class="active"><a href="categories.jsp">Categories</a>
		</li>
		<%
			if (c_rs.isBeforeFirst()) {
					String rsname, rsid, rscount;
					while (c_rs.next()) {
						rsname = c_rs.getString("name");
						rsid = String.valueOf(c_rs.getInt("category_id"));
						session.setAttribute("cid", rsid);
						rscount = String.valueOf(c_rs.getInt("count"));
						//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
					%>
						<li><a href="products.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%> <span class="badge"><%=rscount %></span></a></li>
					<%
					}
			}
			else {
			%>
				<li>No Categories</li>
			<%
			}
		
			/* Close everything  */
			// Close the ResultSet
			c_rs.close();
			//Close the Statement
			c_statement.close();
			// Close the Connection
			c_conn.close();
		%>
		</ul>
	</div>

		<!-- products -->
		<div class="col-md-10">
			<%
				if (rs.isBeforeFirst()) {
					String rsname, rsdescription, rsimg, rssku, rspid, rsprice;
					while (rs.next()) {
						rsname = rs.getString("name");
						rsdescription = rs.getString("description");
						rsimg = rs.getString("img_src");
						rssku = rs.getString("sku");
						rspid = String.valueOf(rs.getInt("product_id"));
						rsprice = String.valueOf(rs.getDouble("price"));

						if (rsimg == null)
							rsimg = "default";
						
						String cid = "" + session.getAttribute("cid");
						%>
						<t:product name="<%=rsname %>" description="<%=rsdescription %>" imgurl="<%=rsimg %>" pid="<%=rspid %>" cid="<%=cid%>" />
					<%}
				} 
				else 
				{
					if (role.equals("Owner")) 
					{%>
						<t:message type="warning" message="No Products in this category, please add a product"></t:message>
					<%} 
					else 
					{%>
						<t:message type="warning" message="No Products in this category"></t:message>
					<%}
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
					out.println("<h1>" + e.getMessage() + "</h1>");
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
					out.println("<h1>org.postgresql.Driver Not Found</h1>");
				}
				if (role.equals("Owner")) {
			%>
			<div class="col-md-4">
				<div class="thumbnail">
					<img style="height: 200px" src="img/categories/plus.png">
					<div class="caption">
						<h3>Add new product</h3>
						<p>Add a new category to the list</p>
						<p>
							<a class="btn btn-success" href="product.jsp?action=add">Add
								Item</a>
						</p>
					</div>
				</div>
			</div>





			<%
				}
			%>
		</div>
	</div>
<t:footer />
